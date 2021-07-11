//
//  AddWeightView.swift
//  PetLog
//
//  Created by Hao Qin on 6/2/21.
//

import SwiftUI

struct AddWeightView: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var viewContext
	
	let pet: Pet
	let inPound: Bool
	
	@State private var date = Date()
	@State private var selectedDate = Date()
	@State private var showDatePicker = false
	
	@State private var weight: String = ""
	
	@State private var showDuplicateDateAlert = false
	@State private var showConvertWeightAlert = false
	@State private var showSaveAlert = false
	
	@FetchRequest(sortDescriptors: []) var weights: FetchedResults<Weight>
	
	private var isCompleted: Bool {
		return !weight.isEmpty
	}
	
	var body: some View {
		ZStack {
			VStack {
				HStack {
					Button {
						self.presentationMode.wrappedValue.dismiss()
					} label: {
						Image(systemName: "xmark.circle")
							.font(.title)
							.foregroundColor(.iconGray)
					}
					
					Spacer()
					
					Button {
						if isCompleted {
							self.save()
						}
					} label: {
						Image(systemName: "checkmark.circle.fill")
							.font(.title)
							.foregroundColor(isCompleted ? .pinkyOrange : .iconGray)
					}
					.alert(isPresented: $showSaveAlert, content: {
						Alert(title: Text("Something Went Wrong"),
									message: Text("Please try again later."),
									dismissButton: .cancel(Text("OK")))
					})
				}
				.padding(.vertical)
				
				ScrollView(showsIndicators: false) {
					VStack(spacing: 20) {
						ExpenseDateSectionView(date: $date, showDatePicker: $showDatePicker, showNumberPad: .constant(false))
							.alert(isPresented: $showDuplicateDateAlert, content: {
								Alert(title: Text("You have already recorded weight for \(self.pet.name!) this day."),
											dismissButton: .cancel(Text("OK")))
							})
						
						WeightSectionView(weight: $weight, inPound: inPound)
							.alert(isPresented: $showConvertWeightAlert, content: {
								Alert(title: Text("\(pet.name!) is too light to record weight."),
											dismissButton: .cancel(Text("OK")))
							})
					}
				}
				.onTapGesture {
					UIApplication.shared.hideKeyboard()
				}
			}
			.padding(.horizontal)
			
			DatePickerView(date: $date, didSelectDate: .constant(true), isShowing: $showDatePicker, selectedDate: $selectedDate, shouldShowTime: false)
				.animation(.default)
		}
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
	}
	
	private func convertWeight(from string: String) -> Double {
		if let weight = Double(string) {
			if self.inPound {
				let weightInKg = weight/2.205
				return Double(round(weightInKg*100)/100)
			} else {
				return Double(round(weight*100)/100)
			}
		}
		return 0
	}
	
	private func save() {
		let recordedDate = weights.compactMap { $0.date?.startOfDay() }
		let dateToRecord = self.date.startOfDay()
		guard !recordedDate.contains(dateToRecord) else {
			self.showDuplicateDateAlert.toggle()
			return
		}
		
		let weight = convertWeight(from: self.weight)
		guard weight > 0 else {
			self.showConvertWeightAlert.toggle()
			return
		}
		
		Persistence.shared.createWeightWith(
			date: self.date,
			value: weight,
			for: self.pet,
			using: self.viewContext) { success in
			guard success else {
				self.showSaveAlert.toggle()
				return
			}
			self.presentationMode.wrappedValue.dismiss()
		}
	}
}

struct AddWeightView_Previews: PreviewProvider {
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
		return AddWeightView(pet: newPet, inPound: true)
			.environment(\.managedObjectContext, context)
	}
}
