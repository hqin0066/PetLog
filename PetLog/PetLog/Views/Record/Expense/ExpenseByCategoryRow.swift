//
//  ExpenseByCategoryRow.swift
//  PetLog
//
//  Created by Hao Qin on 5/25/21.
//

import SwiftUI

struct ExpenseByCategoryRow: View {
	
	@Binding var categorySelected: ExpenseCategory
	@Binding var expenseByCategoryListPresented: Bool
	
	let category: ExpenseCategory
	let total: Double
	let percent: Double
	
	var displayTotal: String {
		return NumberFormatter.currencyFormatter.string(from: NSNumber(value: total)) ?? "0.00"
	}
	
	var displayPercentage: String {
		let percent = self.percent*100
		return (NumberFormatter.decimalFormatter.string(from: NSNumber(value: percent)) ?? "0.00") + "%"
	}
	
	var rectWidth: CGFloat {
		return CGFloat(Double((UIScreen.main.bounds.width/1.5))*percent)
	}
	
	var body: some View {
		HStack(spacing: 15) {
      Image(category.pinkyOrangeImageName)
				.resizable()
				.scaledToFit()
				.frame(width: 30, height: 30)
			
			VStack(alignment: .leading, spacing: 5) {
				HStack(spacing: 5) {
					Text(LocalizedStringKey(category.rawValue))
						.font(.headline)
						.foregroundColor(.textGray)
					
					Text(displayPercentage)
						.font(.headline)
						.foregroundColor(.textGray)
					
					Spacer()
					
					HStack(spacing: 1) {
						Text("$")
							.font(.headline)
							.foregroundColor(.pinkyOrange)
						
						Text(displayTotal)
							.font(.headline)
							.foregroundColor(.pinkyOrange)
					}
				}
				
				RoundedRectangle(cornerRadius: 3)
					.frame(width: rectWidth, height: 6)
					.foregroundColor(category.color)
			}
		}
		.padding()
		.background(Color.systemWhite.cornerRadius(10).shadow(radius: 4))
		.onTapGesture {
			self.categorySelected = self.category
			self.expenseByCategoryListPresented.toggle()
		}
	}
}

struct ExpenseByCategoryRow_Previews: PreviewProvider {
	static var previews: some View {
    ExpenseByCategoryRow(categorySelected: .constant(.food), expenseByCategoryListPresented: .constant(false), category: .food, total: 500, percent: 1)
      .previewLayout(.sizeThatFits)
	}
}
