//
//  JournalView.swift
//  PetLog
//
//  Created by Hao Qin on 5/4/21.
//

import SwiftUI
import CoreData

struct JournalView: View {
	@Environment(\.managedObjectContext) var viewContext
	
	@Binding var fullScreenImagePresented: Bool
	@Binding var imageToPresent: UIImage?
	@Binding var selectedMonth: Date
	@Binding var activityFilter: [String]
	
	@ObservedObject var pet: Pet
	let petPhoto: UIImage?
	
	@State private var addJournalSheetPresented = false
	@State private var journalFilterSheetPresented = false
	@State private var journalToEdit: Journal? = nil
	@State private var actionSheetPresented = false
	@State private var editJournalViewPresented = false
	@State private var deleteJournalAlertPresented = false
	@State private var saveAlertPresented = false
	
	var fetchRequest: FetchRequest<Journal>
	var journals: FetchedResults<Journal> { return fetchRequest.wrappedValue }
	
	private var actionSheet: ActionSheet {
		ActionSheet(title: Text("Please select"),
								buttons: [
									.default(Text("Edit"), action: {
										self.editJournalViewPresented.toggle()
									}),
									.destructive(Text("Delete"), action: {
										self.deleteJournalAlertPresented.toggle()
									}),
									.cancel()
								])
	}
	
	// MARK: - Init
	
	init(fullScreenImagePresented: Binding<Bool>, imageToPresent: Binding<UIImage?>, selectedMonth: Binding<Date>, activityFilter: Binding<[String]>, pet: Pet, petPhoto: UIImage?) {
		_fullScreenImagePresented = fullScreenImagePresented
		_imageToPresent = imageToPresent
		_selectedMonth = selectedMonth
		_activityFilter = activityFilter
		self.pet = pet
		self.petPhoto = petPhoto
		
		let startDate = selectedMonth.wrappedValue.startOfMonth()
		let endDate = selectedMonth.wrappedValue.endOfMonth()
		
		var predicate: NSCompoundPredicate {
			if activityFilter.wrappedValue.isEmpty {
				return NSCompoundPredicate(andPredicateWithSubpredicates: [
					NSPredicate(format: "%K == %@", "pet", pet),
					NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
				])
			} else {
				return NSCompoundPredicate(andPredicateWithSubpredicates: [
					NSPredicate(format: "%K == %@", "pet", pet),
					NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate),
					NSPredicate(format: "activity IN %@", activityFilter.wrappedValue)
				])
			}
		}
		
		self.fetchRequest = FetchRequest<Journal>(
			sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)],
			predicate: predicate
		)
	}
	
	var body: some View {
		ScrollView {
			VStack(spacing: .zero) {
				HomePageHeaderView(fullScreenImagePresented: $fullScreenImagePresented, imageToPresent: $imageToPresent, pet: pet, image: petPhoto)
				
				LazyVStack(spacing: .zero, pinnedViews: [.sectionHeaders]) {
					Section(header: JournalSectionHeaderView(
										selectedMonth: $selectedMonth,
										activityFilter: $activityFilter,
										showAddJournalSheet: $addJournalSheetPresented,
										showJournalFilterSheet: $journalFilterSheetPresented)) {
						if !journals.isEmpty {
							ForEach(journals) { journal in
								JournalDetailView(fullScreenImagePresented: $fullScreenImagePresented, imageToPresent: $imageToPresent, showActionSheet: $actionSheetPresented, journalToEdit: $journalToEdit, journal: journal)
									.padding(.horizontal)
									.padding(.top, 15)
							}
						} else {
							VStack(spacing: 20) {
								Image("Book")
									.resizable()
									.scaledToFit()
									.opacity(0.1)
									.frame(width: UIScreen.main.bounds.width / 2)
								
								Text("Time to write journals for your pet")
									.font(.subheadline)
									.foregroundColor(.textGray)
									.opacity(0.5)
								
								Spacer()
							}
							.padding(.top, UIScreen.main.bounds.height / 6)
						}
					}
				}
				.sheet(isPresented: $addJournalSheetPresented, content: {
					AddJournalView(pet: pet)
        })
				.sheet(isPresented: $journalFilterSheetPresented, content: {
					JournalFilterView(activityFilter: $activityFilter)
				})
				.actionSheet(isPresented: $actionSheetPresented, content: {
					self.actionSheet
				})
				.alert(isPresented: $deleteJournalAlertPresented, content: {
					Alert(title: Text("Delete this journal?"),
											 message: Text("You cannot undo this action."),
											 primaryButton: .cancel(),
											 secondaryButton: .destructive(Text("Delete"), action: {
												deleteJournal(journal: self.journalToEdit!)
											 }))
				})
				
				if let journalToEdit = journalToEdit {
					NavigationLink(
						destination: EditJournalView(journal: journalToEdit),
						isActive: $editJournalViewPresented,
						label: {
							EmptyView()
						})
						.alert(isPresented: $saveAlertPresented, content: {
							Alert(title: Text("Something Went Wrong"),
													 message: Text("Please try again later."),
													 dismissButton: .cancel(Text("OK")))
						})
					
					NavigationLink(
						destination: EmptyView(),
						label: {
							EmptyView()
						})
				}
			}
			.padding(.bottom, 250)
		}
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
	}
	
	private func deleteJournal(journal: Journal) {
		viewContext.delete(journal)
		Persistence.shared.saveContext(with: viewContext) { success in
			guard success else {
				self.saveAlertPresented.toggle()
				return
			}
			self.journalToEdit = nil
		}
	}
}

struct JournalView_Previews: PreviewProvider {
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
		return JournalView(fullScreenImagePresented: .constant(false), imageToPresent: .constant(nil), selectedMonth: .constant(Date()), activityFilter: .constant([]), pet: newPet, petPhoto: nil)
			.environment(\.managedObjectContext, context)
	}
}
