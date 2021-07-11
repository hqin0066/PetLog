//
//  PetGenderButtonView.swift
//  PetLog
//
//  Created by Hao Qin on 5/7/21.
//

import SwiftUI

struct PetGenderButtonView: View {
	
	@Binding var petGender: PetGender
	
	let petGenderString: String
	
	var isSelected: Bool {
		petGenderString == petGender.rawValue
	}
	
	var body: some View {
		VStack(spacing: 3) {
			ZStack {
				Circle()
					.stroke()
					.frame(width: 35, height: 35)
					.foregroundColor(isSelected ? .clear : .iconGray)
				
				Circle()
					.frame(width: 35, height: 35)
					.foregroundColor(isSelected ? .pinkyOrange : .systemWhite)
				
				if petGenderString == "Girl" {
					Image(isSelected ? "GirlIconWhite" : "GirlIconPinkyOrange")
						.resizable()
						.scaledToFit()
						.frame(width: 20, height: 20)
						.foregroundColor(isSelected ? .white : .pinkyOrange)
				} else {
					Image(isSelected ? "BoyIconWhite" : "BoyIconPinkyOrange")
						.resizable()
						.scaledToFit()
						.frame(width: 20, height: 20)
						.foregroundColor(isSelected ? .white : .pinkyOrange)
				}
			}
			
			Text(LocalizedStringKey(petGenderString))
				.font(.body)
				.foregroundColor(.textGray)
		}
	}
}

struct PetGenderButtonView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			PetGenderButtonView(petGender: .constant(.boy), petGenderString: "Girl")
				.previewLayout(.fixed(width: 100, height: 100))
			PetGenderButtonView(petGender: .constant(.girl), petGenderString: "Girl")
				.preferredColorScheme(.dark)
				.previewLayout(.fixed(width: 100, height: 100))
		}
	}
}
