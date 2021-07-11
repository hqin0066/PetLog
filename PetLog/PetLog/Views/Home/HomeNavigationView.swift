//
//  HomeNavigationView.swift
//  PetLog
//
//  Created by Hao Qin on 5/4/21.
//

import SwiftUI

struct HomeNavigationView: View {
	
	@Binding var showManagePetView: Bool
	
	@ObservedObject var pet: Pet
	
	var body: some View {
		ZStack {
			Text(pet.name ?? "Pet Name")
				.foregroundColor(.white)
				.font(.headline)
				.bold()
				.shadow(radius: 4)
			
			HStack {
				Spacer()
				
				Button {
					self.showManagePetView.toggle()
				} label: {
					ZStack {
						Text("Switch Pet")
							.font(.footnote)
							.foregroundColor(.white)
              .padding(.vertical, 2)
              .padding(.horizontal, 10)
							.background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).foregroundColor(.white))
					}
				}
			}
		}
		.padding(.horizontal)
		.frame(height: 40)
		.background(Color("GradientStart"))
	}
}


struct HomeNavigationView_Previews: PreviewProvider {
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
		return HomeNavigationView(showManagePetView: .constant(false), pet: newPet)
			.environment(\.managedObjectContext, context)
			.previewLayout(.fixed(width: 500, height: 100))
	}
}
