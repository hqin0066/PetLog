//
//  BreedSelectionSectionView.swift
//  PetLog
//
//  Created by Hao Qin on 5/8/21.
//

import SwiftUI

struct BreedSelectionSectionView: View {
	
	@Binding var petType: PetType
	@Binding var breed: String
	@Binding var breedListSheetIsShowing: Bool
	@Binding var alertIsShowing: Bool
	
	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			Text("Pet Breed")
				.font(.headline)
				.foregroundColor(.textGray)
			
			Button {
				if petType == .none {
					self.alertIsShowing.toggle()
				} else {
					breedListSheetIsShowing.toggle()	
				}
				UIApplication.shared.hideKeyboard()
			} label: {
				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.foregroundColor(.systemWhite)
					
					HStack {
						Text(breed.isEmpty ? "Select" : "\(breed)")
							.font(.body)
							.foregroundColor(.textGray)
						
						Spacer()
						
						Image(systemName: "chevron.down.circle")
							.font(.title3)
							.foregroundColor(.pinkyOrange)
					}
					.padding(.horizontal)
				}
				.frame(height: 40)
			}
		}
	}
}

struct BreedSelectionSectionView_Previews: PreviewProvider {
	static var previews: some View {
		BreedSelectionSectionView(petType: .constant(.none), breed: .constant(""), breedListSheetIsShowing: .constant(false), alertIsShowing: .constant(false))
	}
}
