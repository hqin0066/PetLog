//
//  PetGenderSelectionSectionView.swift
//  PetLog
//
//  Created by Hao Qin on 5/8/21.
//

import SwiftUI

struct PetGenderSelectionSectionView: View {
	
	@Binding var gender: PetGender
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Pet Gender")
				.font(.headline)
				.foregroundColor(.textGray)
			
			HStack(spacing: 30) {
				Button {
					self.gender = .girl
				} label: {
					PetGenderButtonView(petGender: $gender, petGenderString: "Girl")
				}
				
				Button {
					self.gender = .boy
				} label: {
					PetGenderButtonView(petGender: $gender, petGenderString: "Boy")
				}
			}
		}
	}
}

struct PetGenderSelectionSectionView_Previews: PreviewProvider {
	static var previews: some View {
		PetGenderSelectionSectionView(gender: .constant(.girl))
	}
}
