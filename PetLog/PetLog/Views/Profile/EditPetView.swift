//
//  EditPetView.swift
//  PetLog
//
//  Created by Hao Qin on 5/10/21.
//

import SwiftUI

struct EditPetView: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var viewContext
	
	let pet: Pet
	
	@State private var imageData: Data?
	@State private var imagePickerIsShowing: Bool = false
	
	@State private var name: String
	
	@State private var gender: PetGender
	
	@State private var selectedType: PetType
	@State private var typeActionSheetIsShowing = false
	
	@State private var breed: String
	@State private var breedListSheetIsShowing = false
	@State private var breedAlertPresented = false
	
	@State private var birthday: Date
	@State private var arriveDate: Date
	@State private var didSelectBirthday: Bool = true
	@State private var didSelectArriveDate: Bool = true
	@State private var showBirthdayDatePicker: Bool = false
	@State private var showArrivalDateDatePicker: Bool = false
	@State private var selectedDate: Date = Date()
	
	@State private var saveAlertPresented = false
	
	private var isCompleted: Bool {
		!self.breed.isEmpty
	}
	
	private var actionSheet: ActionSheet {
		ActionSheet(
			title: Text("Please select"),
			buttons: [
				.default(Text("Dog"), action: {
					if self.selectedType != .dog {
						self.selectedType = .dog
						self.breed = ""
					}
				}),
				.default(Text("Cat"), action: {
					if self.selectedType != .cat {
						self.selectedType = .cat
						self.breed = ""
					}
				}),
				.default(Text("Other"), action: {
					if self.selectedType != .other {
						self.selectedType = .other
						self.breed = ""
					}
				}),
				.cancel()
			])
	}
	
	// MARK: - Init
	
	init(pet: Pet) {
		self.pet = pet
		
		var petGender: PetGender {
			switch pet.gender {
			case "Girl":
				return .girl
			case "Boy":
				return .boy
			default:
				return .girl
			}
		}
		
		var petType: PetType {
			switch pet.type {
			case "dog":
				return .dog
			case "cat":
				return .cat
			case "other":
				return .other
			default:
				return .none
			}
		}
		
		_imageData = State(wrappedValue: pet.image?.image)
		_name = State(wrappedValue: pet.name ?? "")
		_gender = State(wrappedValue: petGender)
		_selectedType = State(wrappedValue: petType)
		_breed = State(wrappedValue: pet.breed ?? "")
		_birthday = State(wrappedValue: pet.birthday ?? Date())
		_arriveDate = State(wrappedValue: pet.arriveDate ?? Date())
	}
	
	var body: some View {
		ZStack {
			Color.backgroundColor
				.edgesIgnoringSafeArea(.all)
			
			ScrollView {
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
				.padding(.top)
				.padding(.horizontal)
        .padding(.bottom, 100)
			}
			
			DatePickerView(date: $birthday, didSelectDate: $didSelectBirthday, isShowing: $showBirthdayDatePicker, selectedDate: $selectedDate, shouldShowTime: false)
				.animation(.default)
			
			DatePickerView(date: $arriveDate, didSelectDate: $didSelectArriveDate, isShowing: $showArrivalDateDatePicker, selectedDate: $selectedDate, shouldShowTime: false)
				.animation(.default)
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.navigationTitle("Edit Profile")
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
					if isCompleted {
						self.pet.image!.image = self.imageData
						self.pet.name = self.name
						self.pet.gender = self.gender.rawValue
						self.pet.type = self.selectedType.rawValue
						self.pet.breed = self.breed
						self.pet.birthday = self.birthday
						self.pet.arriveDate = self.arriveDate
						Persistence.shared.saveContext(with: viewContext) { success in
							guard success else {
								self.saveAlertPresented.toggle()
								return
							}
							self.presentationMode.wrappedValue.dismiss()
						}
					}
				} label: {
					SaveButtonView(isCompleted: self.isCompleted)
				}
			}
		}
	}
}

struct EditPetView_Previews: PreviewProvider {
	static var previews: some View {
		let context = Persistence.shared.container.viewContext
		let newPet = Pet(context: context)
		let petImage = PetImage(context: context)
		newPet.name = "Da Da"
		newPet.image = petImage
		newPet.type = "dog"
		newPet.breed = "Maltese"
		newPet.isSelected = true
		newPet.birthday = Date()
		newPet.arriveDate = Date()
		
		return EditPetView(pet: newPet)
			.environment(\.managedObjectContext, context)
	}
}
