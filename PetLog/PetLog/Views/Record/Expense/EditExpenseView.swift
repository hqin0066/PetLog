//
//  EditExpenseView.swift
//  PetLog
//
//  Created by Hao Qin on 5/27/21.
//

import SwiftUI

struct EditExpenseView: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var viewContext
	
	let expense: Expense
	
	@State private var date: Date
	@State private var selectedDate: Date
	@State private var showDatePicker = false
	
	@State private var selectedCategory: ExpenseCategory?
	
	@State private var amount: Double
	@State private var enteredValue: Int
	@State private var showNumberPad = false
	
	@State private var note: String
	
	@State private var showSaveAlert = false
	
	private var displayAmount: String {
		return NumberFormatter.currencyFormatter.string(from: NSNumber(value: amount)) ?? "0.00"
	}
	
	private var isCompleted: Bool {
		return self.amount > 0 && self.selectedCategory != nil
	}
	
	// MARK: - Init
	
	init(expense: Expense) {
		self.expense = expense
		
		guard let date = expense.date,
					let category = expense.category?.getExpenseCategory(),
					let note = expense.note else {
			_date = State(wrappedValue: Date())
			_selectedDate = _date
			_amount = State(wrappedValue: expense.amount)
			_enteredValue = State(wrappedValue: Int(expense.amount*100))
			_selectedCategory = State(wrappedValue: .food)
			_note = State(wrappedValue: "")
			return
		}
		_date = State(wrappedValue: date)
		_selectedDate = _date
		_amount = State(wrappedValue: expense.amount)
		_enteredValue = State(wrappedValue: Int(expense.amount*100))
		_selectedCategory = State(wrappedValue: category)
		_note = State(wrappedValue: note)
	}
	
	var body: some View {
		ZStack {
			ScrollView(showsIndicators: false) {
				VStack(spacing: 20) {
					ExpenseDateSectionView(date: $date, showDatePicker: $showDatePicker, showNumberPad: $showNumberPad)
						.padding(.top)
						.alert(isPresented: $showSaveAlert, content: {
							Alert(title: Text("Something Went Wrong"),
										message: Text("Please try again later."),
										dismissButton: .cancel(Text("OK")))
						})
					
					ExpenseAmountSectionView(showNumberPad: $showNumberPad, displayAmount: displayAmount)
					
					ExpenseCategorySectionView(selectedCategory: $selectedCategory)
					
					ExpenseNoteSectionView(note: $note)
				}
				.padding(.bottom, 100)
			}
			.padding(.horizontal)
			.ignoresSafeArea(.container, edges: .bottom)
			.onTapGesture {
				UIApplication.shared.hideKeyboard()
				self.showNumberPad = false
			}
			
			DatePickerView(date: $date, didSelectDate: .constant(true), isShowing: $showDatePicker, selectedDate: $selectedDate, shouldShowTime: false)
				.animation(.default)
			
			NumberPadView(isShowing: $showNumberPad, amount: $amount, enteredValue: $enteredValue)
				.animation(.default)
		}
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
		.navigationTitle("Edit Expense")
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Button {
					self.presentationMode.wrappedValue.dismiss()
				} label: {
					HStack(spacing: 5) {
						Image(systemName: "chevron.backward")
						Text("")
					}
					.font(.title3)
					.foregroundColor(.textGray)
				}
			}
			
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					if self.amount > 0 {
						self.expense.date = self.date
						self.expense.amount = self.amount
						self.expense.category = self.selectedCategory!.rawValue
						self.expense.note = self.note
						Persistence.shared.saveContext(with: viewContext) { success in
							guard success else {
								self.showSaveAlert.toggle()
								return
							}
							self.presentationMode.wrappedValue.dismiss()
						}
					}
				} label: {
					SaveButtonView(isCompleted: self.amount > 0)
				}
			}
		}
	}
}

struct EditExpenseView_Previews: PreviewProvider {
	static var previews: some View {
		let context = Persistence.shared.container.viewContext
		let newExpense = Expense(context: context)
		newExpense.date = Date()
		newExpense.amount = 100
		newExpense.category = "Food"
		return EditExpenseView(expense: newExpense)
			.environment(\.managedObjectContext, context)
	}
}
