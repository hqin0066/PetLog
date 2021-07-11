//
//  AddExpenseView.swift
//  PetLog
//
//  Created by Hao Qin on 5/25/21.
//

import SwiftUI

struct AddExpenseView: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var viewContext
	
	let pet: Pet
	
	@State private var date = Date()
	@State private var selectedDate = Date()
	@State private var showDatePicker = false
	
	@State private var selectedCategory: ExpenseCategory? = nil
	
	@State private var amount: Double = 0
	@State private var enteredValue = 0
	@State private var showNumberPad = false
	
	@State private var note = ""
	
	@State private var showSaveAlert = false
	
	private var displayAmount: String {
		return NumberFormatter.currencyFormatter.string(from: NSNumber(value: amount)) ?? "0.00"
	}
	
	private var isCompleted: Bool {
		return self.amount > 0 && self.selectedCategory != nil
	}
	
	var body: some View {
		ZStack {
			VStack {
				HStack {
					Button {
						self.presentationMode.wrappedValue.dismiss()
					} label: {
						Image(systemName: "xmark.circle")
							.font(.title)
							.foregroundColor(.iconGray)
					}
					
					Spacer()
					
					Button {
						if isCompleted {
							Persistence.shared.createExpenseWith(
								date: self.date,
								amount: self.amount,
								note: self.note,
								category: self.selectedCategory!,
								for: self.pet,
								using: self.viewContext) { success in
								guard success else {
									self.showSaveAlert.toggle()
									return
								}
								self.presentationMode.wrappedValue.dismiss()
							}
						}
					} label: {
						Image(systemName: "checkmark.circle.fill")
							.font(.title)
							.foregroundColor(isCompleted ? .pinkyOrange : .iconGray)
					}
					.alert(isPresented: $showSaveAlert, content: {
						Alert(title: Text("Something Went Wrong"),
									message: Text("Please try again later."),
									dismissButton: .cancel(Text("OK")))
					})
				}
				.padding(.vertical)
				
				ScrollView(showsIndicators: false) {
					VStack(spacing: 20) {
						ExpenseDateSectionView(date: $date, showDatePicker: $showDatePicker, showNumberPad: $showNumberPad)
						
						ExpenseAmountSectionView(showNumberPad: $showNumberPad, displayAmount: displayAmount)
						
						ExpenseCategorySectionView(selectedCategory: $selectedCategory)
						
						ExpenseNoteSectionView(note: $note)
					}
					.padding(.bottom, 100)
				}
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
	}
}

struct AddExpenseView_Previews: PreviewProvider {
	static var previews: some View {
		let context = Persistence.shared.container.viewContext
		let newPet = Pet(context: context)
		newPet.name = "Da Da"
		newPet.image = nil
		newPet.type = "dog"
		newPet.breed = "Maltese"
		newPet.isSelected = true
		newPet.birthday = Date()
		newPet.arriveDate = Date()
		return AddExpenseView(pet: newPet)
			.environment(\.managedObjectContext, context)
	}
}
