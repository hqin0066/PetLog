//
//  RecordUnusualView.swift
//  PetLog
//
//  Created by Hao Qin on 5/24/21.
//

import SwiftUI

struct RecordUnusualView: View {
	@Environment(\.managedObjectContext) var viewContext
	
	@Binding var selectedYear: Date
	@Binding var unusualCategoryFilter: [String]
	
	let pet: Pet
	
	@State private var showAddUnusualSheet = false
	@State private var showUnusualFilterSheet = false
	
	@State private var unusualToEdit: Unusual? = nil
	@State private var actionSheetPresented = false
	@State private var editUnusualViewPresented = false
	@State private var deleteUnusualAlertPresented = false
	@State private var saveAlertPresented = false
	
	var fetchRequest: FetchRequest<Unusual>
	var unusuals: FetchedResults<Unusual> { return fetchRequest.wrappedValue }
	
	private var actionSheet: ActionSheet {
		ActionSheet(title: Text("Please select"),
								buttons: [
									.default(Text("Edit"), action: {
										self.editUnusualViewPresented.toggle()
									}),
									.destructive(Text("Delete"), action: {
										self.deleteUnusualAlertPresented.toggle()
									}),
									.cancel()
								])
	}
	
	// MARK: - init
	
	init(selectedYear: Binding<Date>, unusualCategoryFilter: Binding<[String]>, pet: Pet) {
		_selectedYear = selectedYear
		_unusualCategoryFilter = unusualCategoryFilter
		self.pet = pet
		
		let startDate = selectedYear.wrappedValue.startOfYear()
		let endDate = selectedYear.wrappedValue.endOfYear()
		
		var predicate: NSCompoundPredicate {
			if unusualCategoryFilter.wrappedValue.isEmpty {
				return NSCompoundPredicate(andPredicateWithSubpredicates: [
					NSPredicate(format: "%K == %@", "pet", pet),
					NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
				])
			} else {
				return NSCompoundPredicate(andPredicateWithSubpredicates: [
					NSPredicate(format: "%K == %@", "pet", pet),
					NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate),
					NSPredicate(format: "category IN %@", unusualCategoryFilter.wrappedValue)
				])
			}
		}
		
		self.fetchRequest = FetchRequest<Unusual>(
			sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)],
			predicate: predicate
		)
	}
	
	var body: some View {
		VStack(spacing: .zero) {
			UnusualPageTopButtonsView(selectedYear: $selectedYear,
																showAddUnusualSheet: $showAddUnusualSheet,
																showUnusualFilterSheet: $showUnusualFilterSheet,
																unusualCategoryFilter: $unusualCategoryFilter)
				.sheet(isPresented: $showAddUnusualSheet, content: {
					AddUnusualView(pet: pet)
				})
				.sheet(isPresented: $showUnusualFilterSheet, content: {
					UnusualFilterView(unusualFilter: $unusualCategoryFilter)
				})
			
			ScrollView {
				if !unusuals.isEmpty {
					LazyVStack {
						ForEach(unusuals, id: \.self) { unusual in
							UnusualRow(unusualToEdit: $unusualToEdit, showActionSheet: $actionSheetPresented, unusual: unusual)
								.padding(.horizontal)
								.padding(.top, 15)
						}
					}
					.padding(.bottom, 250)
				} else {
					VStack(spacing: 20) {
						Image("Book")
							.resizable()
							.scaledToFit()
							.opacity(0.1)
							.frame(width: UIScreen.main.bounds.width / 2)
						
						Text("Try to record any unusual activities of your pet")
							.font(.subheadline)
							.foregroundColor(.textGray)
							.opacity(0.5)
						
						Spacer()
					}
					.padding(.top, UIScreen.main.bounds.height / 5)
				}
			}
			.actionSheet(isPresented: $actionSheetPresented, content: {
				self.actionSheet
			})
			.alert(isPresented: $deleteUnusualAlertPresented, content: {
				Alert(title: Text("Delete this unusual record?"),
										 message: Text("You cannot undo this action."),
										 primaryButton: .cancel(),
										 secondaryButton: .destructive(Text("Delete"), action: {
											deleteUnusual(unusual: self.unusualToEdit!)
										 }))
			})
			
			if let unusual = self.unusualToEdit {
				NavigationLink(
					destination: EditUnusualView(unusual: unusual),
					isActive: $editUnusualViewPresented,
					label: {
						EmptyView()
					})
					.alert(isPresented: $saveAlertPresented, content: {
						Alert(title: Text("Something Went Wrong"),
												 message: Text("Please try again later."),
												 dismissButton: .cancel(Text("OK")))
					})
			}
		}
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
	}
	
	private func deleteUnusual(unusual: Unusual) {
		self.viewContext.delete(unusual)
		Persistence.shared.saveContext(with: viewContext) { success in
			guard success else {
				self.saveAlertPresented.toggle()
				return
			}
			self.unusualToEdit = nil
		}
	}
}

struct RecordUnusualView_Previews: PreviewProvider {
	static var previews: some View {
		let context = Persistence.shared.container.viewContext
		let newPet = Pet(context: context)
		newPet.name = "Da Da"
		newPet.image = nil
		newPet.type = "dog"
		newPet.breed = "Maltese"
		newPet.isSelected = true
		newPet.birthday = Date()
		newPet.arriveDate = Date()
		return RecordUnusualView(selectedYear: .constant(Date()), unusualCategoryFilter: .constant([]), pet: newPet)
			.environment(\.managedObjectContext, context)
	}
}
