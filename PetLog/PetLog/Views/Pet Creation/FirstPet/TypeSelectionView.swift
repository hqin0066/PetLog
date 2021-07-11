//
//  FirstPetTypeSelectionView.swift
//  PetLog
//
//  Created by Hao Qin on 5/5/21.
//

import SwiftUI

struct TypeSelectionView: View {
	
	@Binding var selectedType: PetType
	
	var body: some View {
		ZStack {
			Color.backgroundColor
				.edgesIgnoringSafeArea(.all)
			
			VStack {
				Text("What type of pet do you have?")
					.font(.title)
					.bold()
					.foregroundColor(.textGray)
					.padding()
				
				VStack(spacing: 40) {
					Button {
						self.selectedType = .dog
					} label: {
						PetTypeRow(selectedType: $selectedType, petTypeString: "Dog")
					}
					
					Button {
						self.selectedType = .cat
					} label: {
						PetTypeRow(selectedType: $selectedType, petTypeString: "Cat")
					}
					
					Button {
						self.selectedType = .other
					} label: {
						PetTypeRow(selectedType: $selectedType, petTypeString: "Other")
					}
				}
			}
		}
	}
}

struct TypeSelectionView_Previews: PreviewProvider {
	static var previews: some View {
		TypeSelectionView(selectedType: .constant(.dog))
	}
}
