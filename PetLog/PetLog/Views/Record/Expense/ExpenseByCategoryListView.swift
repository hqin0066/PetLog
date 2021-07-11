//
//  ExpenseByCategoryListView.swift
//  PetLog
//
//  Created by Hao Qin on 5/27/21.
//

import SwiftUI

struct ExpenseByCategoryListView: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var viewContext
	
	let category: ExpenseCategory
	let date: Date
  let pet: Pet
	
	var fetchRequest: FetchRequest<Expense>
	var expenses: FetchedResults<Expense> { return fetchRequest.wrappedValue }
	
	@State private var expenseToEdit: Expense?
	@State private var actionSheetPresented = false
	@State private var editExpenseViewPresented = false
	@State private var deleteExpenseAlertPresented = false
	@State private var saveAlertPresented = false
	
	private var actionSheet: ActionSheet {
		ActionSheet(title: Text("Please select"),
								buttons: [
									.default(Text("Edit"), action: {
										self.editExpenseViewPresented.toggle()
									}),
									.destructive(Text("Delete"), action: {
										self.deleteExpenseAlertPresented.toggle()
									}),
									.cancel()
								])
	}
	
	// MARK: - init
	
  init(category: ExpenseCategory, date: Date, pet: Pet) {
		self.category = category
		self.date = date
    self.pet = pet
		
		let startDate = date.startOfYear()
		let endDate = date.endOfYear()
		
		self.fetchRequest = FetchRequest<Expense>(
			sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)],
			predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
				NSPredicate(format: "%K == %@", "category", category.rawValue),
				NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate),
        NSPredicate(format: "%K == %@", "pet", pet)
			])
		)
	}
	
	var body: some View {
		ScrollView {
			VStack {
				ForEach(expenses, id: \.self) { expense in
					ExpenseByCategoryListRow(expenseToEdit: $expenseToEdit, showActionSheet: $actionSheetPresented, expense: expense, category: self.category)
						.padding(.horizontal)
						.padding(.top, 15)
				}
				.actionSheet(isPresented: $actionSheetPresented, content: {
					self.actionSheet
				})
				.alert(isPresented: $deleteExpenseAlertPresented, content: {
					Alert(title: Text("Delete this expense?"),
											 message: Text("You cannot undo this action."),
											 primaryButton: .cancel(),
											 secondaryButton: .destructive(Text("Delete"), action: {
												deleteExpense(expense: self.expenseToEdit!)
											 }))
				})
				
				if let expense = self.expenseToEdit {
					NavigationLink(
						destination: EditExpenseView(expense: expense),
						isActive: $editExpenseViewPresented,
						label: {
							EmptyView()
						})
						.alert(isPresented: $saveAlertPresented, content: {
							Alert(title: Text("Something Went Wrong"),
													 message: Text("Please try again later."),
													 dismissButton: .cancel(Text("OK")))
						})
				}
			}
			.padding(.top)
		}
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.navigationViewStyle(StackNavigationViewStyle())
		.toolbar(content: {
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
			
			ToolbarItem(placement: .principal) {
				HStack(spacing: .zero) {
					Text(LocalizedStringKey(category.rawValue))
					Text(" Expense")
				}
			}
		})
	}
	
	private func deleteExpense(expense: Expense) {
		viewContext.delete(expense)
		Persistence.shared.saveContext(with: viewContext) { success in
			guard success else {
				self.saveAlertPresented.toggle()
				return
			}
			self.expenseToEdit = nil
		}
	}
}

struct ExpenseByCategoryListView_Previews: PreviewProvider {
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
    
		return ExpenseByCategoryListView(category: .food, date: Date(), pet: newPet)
      .environment(\.managedObjectContext, context)
	}
}
