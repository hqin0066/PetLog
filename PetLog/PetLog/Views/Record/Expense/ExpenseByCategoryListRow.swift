//
//  ExpenseByCategoryListRow.swift
//  PetLog
//
//  Created by Hao Qin on 5/27/21.
//

import SwiftUI

struct ExpenseByCategoryListRow: View {
	
	@Binding var expenseToEdit: Expense?
	@Binding var showActionSheet: Bool
	
	@ObservedObject var expense: Expense
	let category: ExpenseCategory
	
	var displayAmount: String {
		return NumberFormatter.currencyFormatter.string(from: NSNumber(value: expense.amount)) ?? "0.00"
	}
	
	var body: some View {
		HStack {
			Image(category.pinkyOrangeImageName)
				.resizable()
				.scaledToFit()
				.frame(width: 25, height: 25)
			
			VStack(alignment: .leading, spacing: 5) {
				if let date = expense.date {
					Text(date.getDateString())
						.font(.subheadline)
						.foregroundColor(.textGray)
				}
				
				if let note = expense.note,
					 !note.isEmpty {
					Text(note)
						.font(.body)
						.foregroundColor(.textGray)
				}
			}
			
			Spacer()
			
			HStack(spacing: 1) {
				Text("$")
					.font(.headline)
					.foregroundColor(.pinkyOrange)
				
				Text(displayAmount)
					.font(.headline)
					.foregroundColor(.pinkyOrange)
			}
		}
		.padding()
		.background(Color.systemWhite.cornerRadius(10).shadow(radius: 4))
		.onTapGesture {
			self.expenseToEdit = self.expense
			self.showActionSheet.toggle()
		}
	}
}


struct ExpenseByCategoryListRow_Previews: PreviewProvider {
	static var previews: some View {
		let context = Persistence.shared.container.viewContext
		let newExpense = Expense(context: context)
		newExpense.date = Date()
		newExpense.amount = 100
		newExpense.category = "Food"
		newExpense.note = "Text Text"
		return ExpenseByCategoryListRow(expenseToEdit: .constant(nil), showActionSheet: .constant(false), expense: newExpense, category: .food)
			.environment(\.managedObjectContext, context)
	}
}
