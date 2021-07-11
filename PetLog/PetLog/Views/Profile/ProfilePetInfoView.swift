//
//  ProfilePetInfoView.swift
//  PetLog
//
//  Created by Hao Qin on 6/15/21.
//

import SwiftUI

struct ProfilePetInfoView: View {
	
	@Binding var fullScreenImagePresented: Bool
	@Binding var imageToPresent: UIImage?
	
	@ObservedObject var pet: Pet
	let image: UIImage?
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack(alignment: .top) {
				if let image = image {
					Image(uiImage: image)
						.resizable()
						.scaledToFill()
						.frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
						.cornerRadius(10)
						.clipped()
						.onTapGesture {
							self.imageToPresent = self.image
							withAnimation {
								self.fullScreenImagePresented.toggle()
							}
						}
				} else {
					Rectangle()
						.frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
						.cornerRadius(10)
						.foregroundColor(.iconGray)
						.clipped()
				}
				
				VStack(alignment: .leading, spacing: 8) {
					HStack(alignment: .firstTextBaseline, spacing: .zero) {
						Text("Name: ")
							.font(.subheadline)
							.foregroundColor(.textGray)
						Text(pet.name ?? "Pet Name")
							.font(.title3)
							.bold()
							.foregroundColor(.pinkyOrange)
					}
					
					HStack(alignment: .firstTextBaseline, spacing: .zero) {
						Text("Breed: ")
							.font(.subheadline)
							.foregroundColor(.textGray)
						Text(LocalizedStringKey(pet.breed ?? "Breed"))
							.font(.subheadline)
							.bold()
							.foregroundColor(.textGray)
					}
					
					HStack(alignment: .firstTextBaseline, spacing: .zero) {
						Text("Sex: ")
							.font(.subheadline)
							.foregroundColor(.textGray)
						Text(LocalizedStringKey(pet.gender ?? "Girl"))
							.font(.subheadline)
							.bold()
							.foregroundColor(.textGray)
					}
				}
				
				Spacer()
			}
			
			HStack(alignment: .firstTextBaseline, spacing: .zero) {
				Text("DOB: ")
					.font(.subheadline)
					.foregroundColor(.textGray)
				Text(pet.birthday?.getDateString() ?? "00/00/0000")
					.font(.headline)
					.foregroundColor(.pinkyOrange)
			}
			
			HStack(alignment: .firstTextBaseline, spacing: .zero) {
				Text("Home Since: ")
					.font(.subheadline)
					.foregroundColor(.textGray)
				Text(pet.arriveDate?.getDateString() ?? "00/00/0000")
					.font(.headline)
					.foregroundColor(.textGray)
			}
		}
		.padding()
		.background(Color.systemWhite.cornerRadius(10).shadow(radius: 4))
	}
}

struct ProfilePetInfoView_Previews: PreviewProvider {
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
		return ProfilePetInfoView(fullScreenImagePresented: .constant(false), imageToPresent: .constant(nil), pet: newPet, image: nil)
			.environment(\.managedObjectContext, context)
			.previewLayout(.fixed(width: 500, height: 300))
	}
}
