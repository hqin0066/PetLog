//
//  RecordWeightView.swift
//  PetLog
//
//  Created by Hao Qin on 5/24/21.
//

import SwiftUI

struct RecordWeightView: View {
	@Environment(\.managedObjectContext) var viewContext
	
	@Binding var animateWeightGraph: Bool
	
	let pet: Pet
	
	@State private var showAddWeightSheet = false
	
	@State private var weightToEdit: Weight? = nil
	@State private var actionSheetPresented = false
	@State private var editWeightViewPresented = false
	@State private var deleteWeightAlertPresented = false
	@State private var saveAlertPresented = false
	
	var fetchRequest: FetchRequest<Weight>
	var weights: FetchedResults<Weight> { return fetchRequest.wrappedValue }
	
	@FetchRequest(sortDescriptors: []) var weightUnits: FetchedResults<WeightUnit>
	
	private var weightUnit: WeightUnit? {
		return weightUnits.first
	}
	
	private var inPound: Bool {
		if let weightUnit = self.weightUnit {
			return weightUnit.inPound
		}
		return false
	}
	
	private var weightData: [WeightData] {
		var data: [WeightData] = []
		for weight in self.weights {
			if let date = weight.date {
				data.append(WeightData(date: date, weight: weight.weight))
			}
		}
		
		return data.sorted { $0.date < $1.date }
	}
	
	private var actionSheet: ActionSheet {
		ActionSheet(title: Text("Please select"),
								buttons: [
									.default(Text("Edit"), action: {
										self.editWeightViewPresented.toggle()
									}),
									.destructive(Text("Delete"), action: {
										self.deleteWeightAlertPresented.toggle()
									}),
									.cancel()
								])
	}
	
	// MARK: - Init
	
	init(animateWeightGraph: Binding<Bool>, pet: Pet) {
		_animateWeightGraph = animateWeightGraph
		self.pet = pet
	
		self.fetchRequest = FetchRequest<Weight>(
			sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)],
			predicate: NSPredicate(format: "%K == %@", "pet", pet))
	}
	
	var body: some View {
		ScrollView {
			VStack(spacing: .zero) {
				ZStack {
					GeometryReader { geometry in
						Color.systemWhite
							.frame(height: geometry.getHeightForHeaderImage())
							.offset(y: geometry.getOffsetForHeaderImage())
					}
					
					WeightGraphView(animateChart: $animateWeightGraph, weightData: self.weightData, inPound: self.inPound)
					
				}
				
				LazyVStack(spacing: .zero, pinnedViews: [.sectionHeaders]) {
					Section(header: WeightSectionHeaderView(
										showAddWeightSheet: $showAddWeightSheet,
										weightUnit: self.weightUnit)) {
						if !weights.isEmpty {
							ForEach(weights, id: \.self) { weight in
								WeightRow(weightToEdit: $weightToEdit,
													showActionSheet: $actionSheetPresented,
													weight: weight,
													pet: self.pet,
													inPound: inPound)
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
								
								Text("Try to record the first weight for your pet")
									.font(.subheadline)
									.foregroundColor(.textGray)
									.opacity(0.5)
								
								Spacer()
							}
							.padding(.top, UIScreen.main.bounds.height / 11)
						}
					}
				}
				.sheet(isPresented: $showAddWeightSheet, content: {
					AddWeightView(pet: pet, inPound: inPound)
						.environment(\.managedObjectContext, viewContext)
				})
				.actionSheet(isPresented: $actionSheetPresented, content: {
					self.actionSheet
				})
				.alert(isPresented: $deleteWeightAlertPresented, content: {
					Alert(title: Text("Delete this weight?"),
											 message: Text("You cannot undo this action."),
											 primaryButton: .cancel(),
											 secondaryButton: .destructive(Text("Delete"), action: {
												deleteWeight(weight: self.weightToEdit!)
											 }))
				})
				
				if let weight = weightToEdit {
					NavigationLink(
						destination: EditWeightView(pet: pet, weight: weight, inPound:  inPound),
						isActive: $editWeightViewPresented,
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
			.padding(.bottom, 250)
		}
		.background(Color.backgroundColor)
		.edgesIgnoringSafeArea(.bottom)
	}
	
	private func deleteWeight(weight: Weight) {
		self.viewContext.delete(weight)
		Persistence.shared.saveContext(with: viewContext) { success in
			guard success else {
				self.saveAlertPresented.toggle()
				return
			}
			self.weightToEdit = nil
		}
	}
}

struct RecordWeightView_Previews: PreviewProvider {
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
		return RecordWeightView(animateWeightGraph: .constant(true), pet: newPet)
			.environment(\.managedObjectContext, context)
	}
}
