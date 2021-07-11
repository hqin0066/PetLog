//
//  ExpenseByDateRow.swift
//  PetLog
//
//  Created by Hao Qin on 5/25/21.
//

import SwiftUI

struct ExpenseByDateRow: View {
	
	@Binding var expenseToEdit: Expense?
	@Binding var showActionSheet: Bool
	
	let date: Date
  let pet: Pet
	
	var fetchRequest: FetchRequest<Expense>
	var expenses: FetchedResults<Expense> { return fetchRequest.wrappedValue }
	
	var displayDate: LocalizedStringKey {
		let dateString = self.date.getDateWithoutYearString()
		let date = Calendar.current.dateComponents([.day, .month, .year], from: self.date)
		let todaysDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
		let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
		let yesterdaysDate = Calendar.current.dateComponents([.day, .month, .year], from: yesterday!)
		if date == todaysDate {
			return "Today, \(dateString)"
		} else if date == yesterdaysDate {
			return "Yesterday, \(dateString)"
		}
		return "\(self.date.getDateWithWeekdayString())"
	}
	
	var totalAmount: String {
		var total: Double = 0
		for expense in expenses {
			total += expense.amount
		}
		return NumberFormatter.currencyFormatter.string(from: NSNumber(value: total)) ?? "0.00"
	}
	
	// MARK: - Init
	
  init(expenseToEdit: Binding<Expense?>, showActionSheet: Binding<Bool> ,date: Date, pet: Pet) {
		_expenseToEdit = expenseToEdit
		_showActionSheet = showActionSheet
		self.date = date
    self.pet = pet
		
		let startDate = date.startOfDay()
		let endDate = date.endOfDay()
		
		self.fetchRequest = FetchRequest<Expense>(
			sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)],
			predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
        NSPredicate(format: "%K == %@", "pet", pet),
        NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
      ])
    )
	}
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text(displayDate)
					.font(.subheadline)
					.foregroundColor(.textGray)
				
				Spacer()
				
				HStack(spacing: 1) {
					Text("$")
						.font(.subheadline)
						.foregroundColor(.textGray)
					
					Text(totalAmount)
						.font(.subheadline)
						.foregroundColor(.textGray)
				}
			}
			
			Divider()
			
			ForEach(expenses, id: \.self) { expense in
				ExpenseByDateDetailRow(expense: expense)
					.onTapGesture {
						self.expenseToEdit = expense
						self.showActionSheet.toggle()
					}
			}
		}
		.padding()
		.background(Color.systemWhite.cornerRadius(10).shadow(radius: 4))
	}
}

struct ExpenseByDateRow_Previews: PreviewProvider {
	static var previews: some View {
    let context = Persistence.shared.container.viewContext
    let newPet = Pet(context: context)
    newPet.name = "Pet Name"
    newPet.image = nil
    newPet.type = "dog"
    newPet.breed = "Maltese"
    newPet.isSelected = true
    newPet.birthday = Date()
    newPet.arriveDate = Date()
    
    return ExpenseByDateRow(expenseToEdit: .constant(nil), showActionSheet: .constant(false), date: Date(), pet: newPet)
			.previewLayout(.fixed(width: 500, height: 150))
      .environment(\.managedObjectContext, context)
	}
}

struct ExpenseByDateDetailRow: View {
	
	@ObservedObject var expense: Expense
	
	var amount: String {
		return NumberFormatter.currencyFormatter.string(from: NSNumber(value: expense.amount)) ?? "0.00"
	}
	
	var body: some View {
		HStack(spacing: 15) {
			Circle()
				.frame(width: 15, height: 15)
				.foregroundColor(expense.category?.getExpenseCategory().color)
			
			HStack {
				VStack(alignment: .leading, spacing: 5) {
					Text(LocalizedStringKey(expense.category ?? ""))
						.font(.headline)
						.foregroundColor(.textGray)
					
					if let note = expense.note,
						 !note.isEmpty {
						Text(note)
							.font(.subheadline)
							.foregroundColor(.textGray)
					}
				}
				
				Spacer()
				
				HStack(spacing: 1) {
					Text("$")
						.font(.headline)
						.foregroundColor(.pinkyOrange)
					
					Text(amount)
						.font(.headline)
						.foregroundColor(.pinkyOrange)
				}
			}
		}
		.padding(.vertical, 8)
	}
}
