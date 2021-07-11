//
//  UnusualCategoryCellView.swift
//  PetLog
//
//  Created by Hao Qin on 6/8/21.
//

import SwiftUI

struct UnusualCategoryCellView: View {
	
	@Binding var selectedCategory: UnusualCategory?
	
	let category: UnusualCategory
	
	var isSelected: Bool {
		category == selectedCategory
	}
	
	var body: some View {
		VStack {
			ZStack {
				Circle()
					.stroke()
					.frame(width: 50, height: 50)
					.foregroundColor(isSelected ? .clear : .iconGray)
				
				Circle()
					.frame(width: 50, height: 50)
					.foregroundColor(isSelected ? .pinkyOrange : .systemWhite)
				
        if isSelected {
          Image(category.whiteImageName)
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
        } else {
          Image(category.pinkyOrangeImageName)
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
        }
			}
			.animation(.easeIn(duration: 0.2))
			
			Text(LocalizedStringKey(category.rawValue))
				.font(.footnote)
				.foregroundColor(.textGray)
				.lineLimit(nil)
				.multilineTextAlignment(.center)
			
			Spacer()
		}
		.frame(height: 100)
		.onTapGesture {
			self.selectedCategory = self.category
		}
	}
}

struct UnusualCategoryCellView_Previews: PreviewProvider {
	static var previews: some View {
		UnusualCategoryCellView(selectedCategory: .constant(.other), category: .sneeze)
			.previewLayout(.fixed(width: 100, height: 120))
	}
}
