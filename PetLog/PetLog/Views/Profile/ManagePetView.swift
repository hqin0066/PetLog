//
//  ManagePetView.swift
//  PetLog
//
//  Created by Hao Qin on 5/10/21.
//

import SwiftUI

enum ActiveAlert {
	case deleteConfirmation, cannotDelete, saveError
}

struct ManagePetView: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var viewContext
	
	@ObservedObject var pet: Pet
	
	@State private var showAddNewPetSheet = false
	@State private var petToEdit: Pet? = nil
	@State private var editPetViewPresented = false
	@State private var showAlert = false
	@State private var activeAlert: ActiveAlert = .saveError
	
	@FetchRequest(sortDescriptors: [])
	var pets: FetchedResults<Pet>
	
	var body: some View {
		ScrollView {
			ForEach(pets, id: \.self) { pet in
				ManagePetRow(
					petToEdit: $petToEdit, showEditPetView: $editPetViewPresented,
					activeAlert: $activeAlert,
					showAlert: $showAlert,
					pet: pet,
					pets: pets)
					.onTapGesture {
						for pet in pets {
							pet.isSelected = false
						}
						pet.isSelected = true
						Persistence.shared.saveContext(with: viewContext) { success in
							guard success else {
								self.activeAlert = .saveError
								self.showAlert = true
								return
							}
						}
					}
			}
			.alert(isPresented: $showAlert, content: {
				switch activeAlert {
				case .deleteConfirmation:
					return Alert(title: Text("Delete this pet?"),
											 message: Text("You cannot undo this action."),
											 primaryButton: .cancel(),
											 secondaryButton: .destructive(Text("Delete"), action: {
												deletePet(pet: petToEdit!)
											 }))
				case .cannotDelete:
					return Alert(title: Text("You only have one pet."),
											 dismissButton: .cancel(Text("OK")))
				case .saveError:
					return Alert(title: Text("Something Went Wrong"),
											 message: Text("Please try again later."),
											 dismissButton: .cancel(Text("OK")))
				}
			})
			.sheet(isPresented: $showAddNewPetSheet, content: {
				AddNewPetView(pet: self.pet)
			})
			
			if let pet = self.petToEdit {
				NavigationLink(
					destination: EditPetView(pet: pet),
					isActive: $editPetViewPresented,
					label: {
						EmptyView()
					})
			}
		}
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Manage Pets")
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
					self.showAddNewPetSheet.toggle()
				} label: {
					HStack {
						Text("")
						Image(systemName: "plus.circle")
							.font(.title2)
							.foregroundColor(.pinkyOrange)
					}
				}
			}
		}
	}
	
	private func deletePet(pet: Pet) {
		if !pet.isSelected {
			viewContext.delete(pet)
			Persistence.shared.saveContext(with: viewContext) { success in
				guard success else {
					self.activeAlert = .saveError
					self.showAlert = true
					return
				}
				self.petToEdit = nil
			}
		} else {
			viewContext.delete(pet)
			Persistence.shared.saveContext(with: viewContext) { success in
				guard success else {
					self.activeAlert = .saveError
					self.showAlert = true
					return
				}
				pets.first?.isSelected = true
				Persistence.shared.saveContext(with: viewContext) { success in
					guard success else {
						self.activeAlert = .saveError
						self.showAlert = true
						return
					}
					self.petToEdit = nil
				}
			}
		}
	}
}

struct ManagePetView_Previews: PreviewProvider {
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
		
		return ManagePetView(pet: newPet)
			.environment(\.managedObjectContext, context)
	}
}

struct ManagePetRow: View {
	
	@Binding var petToEdit: Pet?
	@Binding var showEditPetView: Bool
	@Binding var activeAlert: ActiveAlert
	@Binding var showAlert: Bool
	
	@ObservedObject var pet: Pet
	let pets: FetchedResults<Pet>
	
	var uiImage: UIImage? {
		if let data = self.pet.image?.image {
			return UIImage(data: data)
		}
		return nil
	}
	
	var displayAge: LocalizedStringKey {
		guard let date = pet.birthday else {
			return "\(0) Years Old"
		}
		let monthsCount = date.month(to: Date())
		if monthsCount%12 == 0 {
			return "\(monthsCount/12) Years Old"
		} else if monthsCount < 12 {
			return "\(monthsCount) Months Old"
		} else {
			return "\((monthsCount-(monthsCount%12))/12) Years \(monthsCount%12) Months Old"
		}
	}
	
	var body: some View {
		VStack {
			HStack(spacing: 15) {
				ZStack(alignment: .bottomTrailing) {
					if let uiImage = self.uiImage {
						Image(uiImage: uiImage)
							.resizable()
							.scaledToFill()
							.frame(width: 50, height: 50)
							.cornerRadius(25)
					} else {
						Image(systemName: "person.crop.circle.fill")
							.resizable()
							.scaledToFill()
							.frame(width: 50, height: 50)
							.foregroundColor(.iconGray)
					}
					
					if self.pet.isSelected {
						Image(systemName: "checkmark.circle.fill")
							.resizable()
							.scaledToFill()
							.frame(width: 20, height: 20)
							.foregroundColor(.pinkyOrange)
							.offset(x: 5, y: 5)
					}
				}
				
				VStack(alignment: .leading, spacing: 2) {
					Text(pet.name ?? "Name")
						.font(.headline)
						.foregroundColor(.textGray)
					
					Text(displayAge)
						.font(.subheadline)
						.foregroundColor(.textGray)
				}
				
				Spacer()
			}
			
			HStack(spacing: 30) {
				Spacer()
				
				Button {
					self.petToEdit = self.pet
					self.showEditPetView.toggle()
				} label: {
					HStack {
						Image(systemName: "square.and.pencil")
							.foregroundColor(.iconGray)
							.font(.body)
						
						Text("Edit")
							.foregroundColor(.textGray)
							.font(.body)
					}
				}
				
				Button {
					if pets.count > 1 {
						self.petToEdit = self.pet
						self.activeAlert = .deleteConfirmation
						self.showAlert = true
					} else {
						self.activeAlert = .cannotDelete
						self.showAlert = true
					}
				} label: {
					HStack {
						Image(systemName: "trash")
							.foregroundColor(.iconGray)
							.font(.body)
						
						Text("Delete")
							.foregroundColor(.textGray)
							.font(.body)
					}
				}
			}
		}
		.padding()
		.background(Color.systemWhite)
	}
}
