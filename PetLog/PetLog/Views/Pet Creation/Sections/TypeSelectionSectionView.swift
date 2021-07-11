//
//  TypeSelectionSectionView.swift
//  PetLog
//
//  Created by Hao Qin on 5/8/21.
//

import SwiftUI

struct TypeSelectionSectionView: View {
	
	@Binding var selectedType: PetType
	@Binding var showActionSheet: Bool
	
	var displayTypeName: LocalizedStringKey {
		switch selectedType {
		case .dog:
			return "Dog"
		case .cat:
			return "Cat"
		case .other:
			return "Other"
		case .none:
			return "Select"
		}
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			Text("Pet Type")
				.font(.headline)
				.foregroundColor(.textGray)
			
			Button {
				self.showActionSheet.toggle()
				UIApplication.shared.hideKeyboard()
			} label: {
				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.foregroundColor(.systemWhite)
					
					HStack {
						Text(displayTypeName)
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

struct TypeSelectionSectionView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			TypeSelectionSectionView(selectedType: .constant(.none), showActionSheet: .constant(false))
			TypeSelectionSectionView(selectedType: .constant(.none), showActionSheet: .constant(false))
				.environment(\.locale, .init(identifier: "zh"))
		}
		.previewLayout(.fixed(width: 500, height: 100))
	}
}
