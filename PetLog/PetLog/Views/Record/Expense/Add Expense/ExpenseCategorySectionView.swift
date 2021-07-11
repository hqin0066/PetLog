//
//  ExpenseCategorySectionView.swift
//  PetLog
//
//  Created by Hao Qin on 5/25/21.
//

import SwiftUI

struct ExpenseCategorySectionView: View {
	
	@Binding var selectedCategory: ExpenseCategory?
	
	private var items: [GridItem] {
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
				ForEach(ExpenseCategory.allCases, id: \.self) { expense in
					ExpenseCategoryCellView(selectedCategory: $selectedCategory, category: expense)
				}
			}
			.padding(.vertical)
			.background(
				RoundedRectangle(cornerRadius: 15)
					.stroke(lineWidth: 0.5)
					.foregroundColor(.iconGray)
			)
		}
	}
}

struct ExpenseCategorySectionView_Previews: PreviewProvider {
	static var previews: some View {
		ExpenseCategorySectionView(selectedCategory: .constant(.food))
			.previewLayout(.fixed(width: 400, height: 450))
	}
}
