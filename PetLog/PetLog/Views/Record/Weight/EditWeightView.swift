//
//  EditWeightView.swift
//  PetLog
//
//  Created by Hao Qin on 6/3/21.
//

import SwiftUI

struct EditWeightView: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var viewContext
	
	let pet: Pet
	let weight: Weight
	let inPound: Bool
	
	@State private var date: Date
	@State private var selectedDate: Date
	@State private var showDatePicker = false
	
	@State private var weightString: String
	
	@State private var showDuplicateDateAlert = false
	@State private var showConvertWeightAlert = false
	@State private var showSaveAlert = false
	
	@FetchRequest(sortDescriptors: []) var weights: FetchedResults<Weight>
	
	private var isCompleted: Bool {
		return !weightString.isEmpty
	}
	
	// MARK: - init
	
	init(pet: Pet, weight: Weight, inPound: Bool) {
		self.pet = pet
		self.weight = weight
		self.inPound = inPound
		
		guard let date = weight.date else {
			_date = State(wrappedValue: Date())
			_selectedDate = _date
			_weightString = State(wrappedValue: "")
			return
		}
		_date = State(wrappedValue: date)
		_selectedDate = _date
		if inPound {
			let weightInPound = weight.weight*2.205
			let rounded = Double(round(weightInPound*10)/10)
			_weightString = State(wrappedValue: String(rounded))
		} else {
			_weightString = State(wrappedValue: String(weight.weight))
		}
	}
	
	var body: some View {
		ZStack {
			VStack {
				ScrollView(showsIndicators: false) {
					VStack(spacing: 20) {
						ExpenseDateSectionView(date: $date, showDatePicker: $showDatePicker, showNumberPad: .constant(false))
							.alert(isPresented: $showDuplicateDateAlert, content: {
								Alert(title: Text("You have already recorded weight for \(self.pet.name!) this day."),
											dismissButton: .cancel(Text("OK")))
							})
						
						WeightSectionView(weight: $weightString, inPound: inPound)
							.alert(isPresented: $showConvertWeightAlert, content: {
								Alert(title: Text("\(pet.name!) is too light to record weight."),
											dismissButton: .cancel(Text("OK")))
							})
					}
				}
				.padding(.top)
				.onTapGesture {
					UIApplication.shared.hideKeyboard()
				}
			}
			.padding(.horizontal)
			
			DatePickerView(date: $date, didSelectDate: .constant(true), isShowing: $showDatePicker, selectedDate: $selectedDate, shouldShowTime: false)
				.animation(.default)
				.alert(isPresented: $showSaveAlert, content: {
					Alert(title: Text("Something Went Wrong"),
								message: Text("Please try again later."),
								dismissButton: .cancel(Text("OK")))
				})
		}
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
		.navigationTitle("Edit Weight")
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Button {
					self.presentationMode.wrappedValue.dismiss()
				} label: {
					HStack(spacing: 5) {
						Image(systemName: "chevron.backward")
						Text("")
					}
					.font(.title3)
					.foregroundColor(.textGray)
				}
			}
			
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					self.save()
				} label: {
					SaveButtonView(isCompleted: true)
				}
			}
		}
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
		guard let savedDate = self.weight.date?.startOfDay(),
					dateToRecord == savedDate ||
					!recordedDate.contains(dateToRecord) else {
			self.showDuplicateDateAlert.toggle()
			return
		}
		
		let weight = convertWeight(from: self.weightString)
		guard weight > 0 else {
			self.showConvertWeightAlert.toggle()
			return
		}
		
		self.weight.date = self.date
		self.weight.weight = weight
		Persistence.shared.saveContext(with: viewContext) { success in
			guard success else {
				self.showSaveAlert.toggle()
				return
			}
			self.presentationMode.wrappedValue.dismiss()
		}
	}
}

struct EditWeightView_Previews: PreviewProvider {
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
		
		let newWeight = Weight(context: context)
		newWeight.date = Date()
		newWeight.weight = 0
		return EditWeightView(pet: newPet, weight: newWeight, inPound: false)
			.environment(\.managedObjectContext, context)
	}
}
