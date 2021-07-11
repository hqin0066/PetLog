//
//  ProfilePageView.swift
//  PetLog
//
//  Created by Hao Qin on 5/3/21.
//

import SwiftUI

struct ProfilePageView: View {
	
	@Binding var fullScreenImagePresented: Bool
	@Binding var imageToPresent: UIImage?
	
	@ObservedObject var pet: Pet
	let petPhoto: UIImage?
	
	@State private var editPetViewPresented = false
	@State private var managePetViewPresented = false
	
	var body: some View {
		VStack(spacing: .zero) {
			ProfileHeaderView()
			
			VStack(spacing: 15) {
				ProfilePetInfoView(fullScreenImagePresented: $fullScreenImagePresented, imageToPresent: $imageToPresent, pet: pet, image: petPhoto)
				
				Button {
					self.editPetViewPresented.toggle()
				} label: {
					HStack {
						Image(systemName: "square.and.pencil")
							.font(.body)
							.foregroundColor(.pinkyOrange)
						Text("Edit Profile")
							.font(.body)
							.foregroundColor(.textGray)
						
						Spacer()
					}
					.padding(.horizontal)
					.padding(.vertical, 10)
					.background(Color.systemWhite.cornerRadius(10).shadow(radius: 4))
				}
				
				Button {
					self.managePetViewPresented.toggle()
				} label: {
					HStack {
						Image(systemName: "list.dash")
							.font(.body)
							.foregroundColor(.pinkyOrange)
						Text("Manage Pets")
							.font(.body)
							.foregroundColor(.textGray)
						
						Spacer()
					}
					.padding(.horizontal)
					.padding(.vertical, 10)
					.background(Color.systemWhite.cornerRadius(10).shadow(radius: 4))
				}
				
//				Button {
//					
//				} label: {
//					HStack {
//						Image(systemName: "star.fill")
//							.font(.body)
//							.foregroundColor(.pinkyOrange)
//						Text("Rate Our App")
//							.font(.body)
//							.foregroundColor(.textGray)
//						
//						Spacer()
//					}
//					.padding(.horizontal)
//					.padding(.vertical, 10)
//					.background(Color.systemWhite.cornerRadius(10).shadow(radius: 4))
//				}
				
				Spacer()
			}
			.padding()
			
			NavigationLink(
				destination: EditPetView(pet: self.pet),
				isActive: $editPetViewPresented,
				label: {
					EmptyView()
				})
			
			NavigationLink(
				destination: ManagePetView(pet: self.pet),
				isActive: $managePetViewPresented,
				label: {
					EmptyView()
				})
			
			NavigationLink(
				destination: EmptyView(),
				label: {
					EmptyView()
				})
		}
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.bottom))
	}
}

struct ProfilePageView_Previews: PreviewProvider {
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
		return ProfilePageView(fullScreenImagePresented: .constant(false), imageToPresent: .constant(nil), pet: newPet, petPhoto: nil)
			.environment(\.managedObjectContext, context)
	}
}
