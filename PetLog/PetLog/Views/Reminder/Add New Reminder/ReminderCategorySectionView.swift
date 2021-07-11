//
//  ReminderCategorySectionView.swift
//  PetLog
//
//  Created by Hao Qin on 6/13/21.
//

import SwiftUI

struct ReminderCategorySectionView: View {
	
	@Binding var selectedCategory: ReminderCategory?
	
	var items: [GridItem] {
		Array(repeating: .init(.fixed(UIScreen.main.bounds.width/5-15)), count: 5)
	}
	
	var body: some View {
		VStack {
			HStack {
				Image(systemName: "tag.fill")
					.foregroundColor(.pinkyOrange)
					.font(.title3)
				
				Text("Category")
					.foregroundColor(.textGray)
					.font(.headline)
				
				Spacer()
			}
			
			LazyVGrid(columns: items) {
				ForEach(ReminderCategory.allCases, id: \.self) { category in
					ReminderCategoryCellView(selectedCategory: $selectedCategory, category: category)
				}
			}
			.padding(.top)
			.background(
				RoundedRectangle(cornerRadius: 15)
					.stroke(lineWidth: 0.5)
					.foregroundColor(.iconGray)
		)
		}
	}
}

struct ReminderCategorySectionView_Previews: PreviewProvider {
	static var previews: some View {
		ReminderCategorySectionView(selectedCategory: .constant(.feed))
			.previewLayout(.fixed(width: 400, height: 450))
	}
}
