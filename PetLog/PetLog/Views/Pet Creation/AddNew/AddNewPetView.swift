//
//  AddNewPetView.swift
//  PetLog
//
//  Created by Hao Qin on 5/8/21.
//

import SwiftUI

struct AddNewPetView: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var viewContext
	
	let pet: Pet
	
	@State private var imageData: Data? = nil
	@State private var imagePickerIsShowing: Bool = false
	
	@State private var name: String = ""
	
	@State private var gender: PetGender = .girl
	
	@State private var selectedType: PetType = .none
	@State private var typeActionSheetIsShowing = false
	
	@State private var breed: String = ""
	@State private var breedListSheetIsShowing = false
	@State private var breedAlertPresented = false
	
	@State private var birthday: Date = Date()
	@State private var arriveDate: Date = Date()
	@State private var didSelectBirthday: Bool = false
	@State private var didSelectArriveDate: Bool = false
	@State private var showBirthdayDatePicker: Bool = false
	@State private var showArrivalDateDatePicker: Bool = false
	@State private var selectedDate: Date = Date()
	
	@State private var saveAlertPresented = false
	
	private var isCompleted: Bool {
		return (imageData != nil && !name.isEmpty && selectedType != .none && !breed.isEmpty && didSelectBirthday && didSelectArriveDate)
	}
	
	private var actionSheet: ActionSheet {
		ActionSheet(
			title: Text("Please select"),
			buttons: [
				.default(Text("Dog"), action: {
					self.selectedType = .dog
					self.breed = ""
				}),
				.default(Text("Cat"), action: {
					self.selectedType = .cat
					self.breed = ""
				}),
				.default(Text("Other"), action: {
					self.selectedType = .other
					self.breed = ""
				}),
				.cancel()
			])
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
							self.pet.isSelected = false
							Persistence.shared.createPetWith(
								type: self.selectedType,
								breed: self.breed,
								imageData: self.imageData!,
								name: self.name,
								gender: self.gender,
								birthday: self.birthday,
								arriveDate: self.arriveDate,
								using: self.viewContext) { success in
								guard success else {
									self.saveAlertPresented.toggle()
									self.pet.isSelected = true
									return
								}
								self.presentationMode.wrappedValue.dismiss()
							}
						}
					} label: {
						Image(systemName: "checkmark.circle.fill")
							.font(.title)
							.foregroundColor(isCompleted ? .pinkyOrange : .iconGray)
					}
				}
				.padding(.vertical)
				
				ScrollView(showsIndicators: false) {
					VStack(alignment: .leading, spacing: 18) {
						HStack {
							Spacer()
							
							PetImageSectionView(imageData: $imageData, imagePickerIsShowing: $imagePickerIsShowing)
							
							Spacer()
						}
						
						PetNameTextField(name: $name)
						
						PetGenderSelectionSectionView(gender: $gender)
						
						TypeSelectionSectionView(selectedType: $selectedType, showActionSheet: $typeActionSheetIsShowing)
							.actionSheet(isPresented: $typeActionSheetIsShowing, content: {
								self.actionSheet
							})
						
						BreedSelectionSectionView(petType: $selectedType, breed: $breed, breedListSheetIsShowing: $breedListSheetIsShowing, alertIsShowing: $breedAlertPresented)
							.sheet(isPresented: $breedListSheetIsShowing) {
								BreedListView(petType: $selectedType, breed: $breed)
							}
							.alert(isPresented: $breedAlertPresented, content: {
								Alert(
									title: Text("Please Select Pet Type First"),
									dismissButton: .cancel(Text("OK")))
							})
						
						DateSelectionSectionView(showDatePicker: $showBirthdayDatePicker, didSelectDate: $didSelectBirthday, date: $birthday, selectedDate: $selectedDate, title: "Birthday")
						
						DateSelectionSectionView(showDatePicker: $showArrivalDateDatePicker, didSelectDate: $didSelectArriveDate, date: $arriveDate, selectedDate: $selectedDate, title: "Arrive Date")
							.alert(isPresented: $saveAlertPresented, content: {
								Alert(title: Text("Something Went Wrong"),
											message: Text("Please try again later."),
											dismissButton: .cancel(Text("OK")))
							})
					}
          .padding(.bottom, 100)
				}
			}
			.padding(.horizontal)
			
			DatePickerView(date: $birthday, didSelectDate: $didSelectBirthday, isShowing: $showBirthdayDatePicker, selectedDate: $selectedDate, shouldShowTime: false)
				.animation(.default)
			
			DatePickerView(date: $arriveDate, didSelectDate: $didSelectArriveDate, isShowing: $showArrivalDateDatePicker, selectedDate: $selectedDate, shouldShowTime: false)
				.animation(.default)
		}
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
		.onTapGesture {
			UIApplication.shared.hideKeyboard()
		}
	}
}

struct AddNewPetView_Previews: PreviewProvider {
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
		
		return Group {
			AddNewPetView(pet: newPet)
				.environment(\.managedObjectContext, context)
			AddNewPetView(pet: newPet)
				.preferredColorScheme(.dark)
				.environment(\.managedObjectContext, context)
				.environment(\.locale, .init(identifier: "zh"))
		}
	}
}
