//
//  ExpensesSectionHeaderView.swift
//  PetLog
//
//  Created by Hao Qin on 5/24/21.
//

import SwiftUI

struct ExpensesSectionHeaderView: View {
	
	@Binding var selectedYear: Date
	@Binding var showExpensesByCategory: Bool
	@Binding var showAddExpenseSheet: Bool
	
	var body: some View {
		ZStack {
			VStack(spacing: -20) {
				Rectangle()
					.fill(Color.backgroundColor)
					.cornerRadius(20)
					.frame(height: 40)
				
				Rectangle()
					.fill(Color.backgroundColor)
					.frame(height: 30)
			}
			.background(Color.systemWhite)
			
			HStack {
				Button{
					self.showExpensesByCategory.toggle()
				} label: {
					Image(self.showExpensesByCategory ? "SortByCategory" : "SortByDate")
						.resizable()
						.scaledToFit()
						.frame(width: 25, height: 25)
				}
				
				Spacer()
				
				Button{
					self.selectedYear = self.selectedYear.backOneYear()
				} label: {
					Image(systemName: "chevron.backward")
						.font(.body)
						.foregroundColor(Color.pinkyOrange)
				}
				
				Text(self.selectedYear.getYearString())
					.font(.title3)
					.bold()
					.foregroundColor(Color.textGray)
					.padding(.horizontal)
					.frame(minWidth: 110)
				
				Button{
					self.selectedYear = self.selectedYear.forwardOneYear()
				} label: {
					Image(systemName: "chevron.forward")
						.font(.body)
						.foregroundColor(Color.pinkyOrange)
				}
				
				Spacer()
				
				Button{
					self.showAddExpenseSheet.toggle()
				} label: {
					Image(systemName: "plus.circle.fill")
						.font(.title2)
						.foregroundColor(Color.pinkyOrange)
				}
			}
			.padding(.horizontal)
		}
		.frame(height: 50)
	}
}

struct ExpensesSectionHeaderView_Previews: PreviewProvider {
	static var previews: some View {
		ExpensesSectionHeaderView(selectedYear: .constant(Date()), showExpensesByCategory: .constant(true), showAddExpenseSheet: .constant(false))
			.previewLayout(.fixed(width: 500, height: 50))
	}
}
