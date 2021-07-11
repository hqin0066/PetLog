//
//  SwiftUIView.swift
//  PetLog
//
//  Created by Hao Qin on 5/5/21.
//

import SwiftUI

struct PetTypeRow: View {
	
	@Binding var selectedType: PetType
	
	let petTypeString: String
	
	var isSelected: Bool {
		petTypeString.lowercased() == selectedType.rawValue
	}
	
	var body: some View {
		
		ZStack {
			RoundedRectangle(cornerRadius: 10)
				.foregroundColor(.systemWhite)
			
			RoundedRectangle(cornerRadius: 10)
				.stroke(lineWidth: 5)
				.foregroundColor(isSelected ? .pinkyOrange : .systemWhite)
			
			HStack {
				Image(systemName: "person.crop.circle")
					.resizable()
					.scaledToFit()
					.frame(width: 60, height: 60)
					.foregroundColor(.textGray)
					.padding(.horizontal)
				
				Text(LocalizedStringKey(petTypeString))
					.font(.title3)
					.bold()
					.foregroundColor(isSelected ? .pinkyOrange : .textGray)
				
				Spacer()
			}
			.frame(width: UIScreen.main.bounds.width-80)
		}
		.frame(width: UIScreen.main.bounds.width-60, height: 90)
		.compositingGroup()
		.shadow(radius: 4)
	}
}

struct PetTypeRow_Previews: PreviewProvider {
	static var previews: some View {
		PetTypeRow(selectedType: .constant(.dog), petTypeString: "Dog")
			.previewLayout(.fixed(width: 500, height: 300))
	}
}
