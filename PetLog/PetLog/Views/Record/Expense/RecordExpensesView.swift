//
//  RecordExpensesView.swift
//  PetLog
//
//  Created by Hao Qin on 5/24/21.
//

import SwiftUI

struct RecordExpensesView: View {
	@Environment(\.managedObjectContext) var viewContext
	
	@Binding var animateExpenseGraph: Bool
	@Binding var selectedYear: Date
	
	let pet: Pet
	
	@State private var showExpensesByCategory = true
	@State private var showAddExpenseSheet = false
	
	@State private var categorySelected: ExpenseCategory = .food
	@State private var expenseByCategoryListPresented = false
	
	@State private var expenseToEdit: Expense? = nil
	@State private var actionSheetPresented = false
	@State private var editExpenseViewPresented = false
	@State private var deleteExpenseAlertPresented = false
	@State private var saveAlertPresented = false
	
	var fetchRequest: FetchRequest<Expense>
	var expenses: FetchedResults<Expense> { return fetchRequest.wrappedValue }
	
	private var total: Double {
		var total: Double = 0
		for expense in expenses {
			total += expense.amount
		}
		return total
	}
	
	private var displayTotal: String {
		return NumberFormatter.currencyFormatter.string(from: NSNumber(value: self.total)) ?? "0.00"
	}
	
	private var combinedDates: [Date] {
		let allDates = expenses.compactMap { $0.date?.startOfDay() }
		return Array(Set(allDates)).sorted { $0 > $1 }
	}
	
	private var sortedCategories: [ExpenseCategory] {
		return ExpenseCategory.allCases
			.filter {
				self.getCategoryTotal(category: $0) > 0
			}
			.sorted {
				self.getCategoryTotal(category: $0) > self.getCategoryTotal(category: $1)
			}
	}
	
	private var wedges: [CategoryWedge] {
		var wedges: [CategoryWedge] = []
		for category in self.sortedCategories {
			let percent = self.getCategoryPercentage(category: category)
			wedges.append(CategoryWedge(category: category, percent: percent, color: category.color))
		}

		return wedges
	}
	
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
	
	// MARK: - Init
	
	init(animateExpenseGraph: Binding<Bool> ,selectedYear: Binding<Date>, pet: Pet) {
		_animateExpenseGraph = animateExpenseGraph
		_selectedYear = selectedYear
		self.pet = pet
		
		let startDate = selectedYear.wrappedValue.startOfYear()
		let endDate = selectedYear.wrappedValue.endOfYear()
		
		self.fetchRequest = FetchRequest<Expense>(
			sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)],
			predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
				NSPredicate(format: "%K == %@", "pet", pet),
				NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
			])
		)
	}
	
	var body: some View {
		ScrollView {
			VStack(spacing: .zero) {
				ZStack {
					GeometryReader { geometry in
						Color.systemWhite
							.frame(height: geometry.getHeightForHeaderImage())
							.offset(y: geometry.getOffsetForHeaderImage())
					}
					
					ExpenseGraphView(animateChart: $animateExpenseGraph, wedges: wedges, displayTotal: displayTotal)
					
				}
				
				LazyVStack(spacing: .zero, pinnedViews: [.sectionHeaders]) {
					Section(header: ExpensesSectionHeaderView(
										selectedYear: $selectedYear,
										showExpensesByCategory: $showExpensesByCategory,
										showAddExpenseSheet: $showAddExpenseSheet)) {
						if !expenses.isEmpty {
							if showExpensesByCategory {
								ForEach(sortedCategories, id: \.self) { category in
									let categoryTotal = self.getCategoryTotal(category: category)
									let percent = self.getCategoryPercentage(category: category)
									ExpenseByCategoryRow(
										categorySelected: $categorySelected,
										expenseByCategoryListPresented: $expenseByCategoryListPresented,
										category: category,
										total: categoryTotal,
										percent: percent)
										.padding(.horizontal)
										.padding(.top, 15)
								}
							} else {
								ForEach(combinedDates, id: \.self) { date in
                  ExpenseByDateRow(expenseToEdit: $expenseToEdit, showActionSheet: $actionSheetPresented, date: date, pet: pet)
										.padding(.horizontal)
										.padding(.top, 15)
								}
							}
						} else {
							VStack(spacing: 20) {
								Image("Book")
									.resizable()
									.scaledToFit()
									.opacity(0.1)
									.frame(width: UIScreen.main.bounds.width / 2)
								
								Text("Try to record an expense for your pet")
									.font(.subheadline)
									.foregroundColor(.textGray)
									.opacity(0.5)
								
								Spacer()
							}
							.padding(.top, UIScreen.main.bounds.height / 11)
						}
					}
				}
				.sheet(isPresented: $showAddExpenseSheet, content: {
					AddExpenseView(pet: pet)
				})
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
				
				if let expense = expenseToEdit {
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
					
					NavigationLink(
						destination: EmptyView(),
						label: {
							EmptyView()
						})
				}
				
				NavigationLink(
					destination: ExpenseByCategoryListView(category: categorySelected, date: selectedYear, pet: pet),
					isActive: $expenseByCategoryListPresented,
					label: {
						EmptyView()
					})
			}
			.padding(.bottom, 250)
		}
		.background(Color.backgroundColor)
		.edgesIgnoringSafeArea(.bottom)
	}
	
	private func getCategoryTotal(category: ExpenseCategory) -> Double {
		var foodTotal: Double = 0
		var toysTotal: Double = 0
		var clothesTotal: Double = 0
		var accessoriesTotal: Double = 0
		var petPurchaseTotal: Double = 0
		var bathTotal: Double = 0
		var insuranceTotal: Double = 0
		var clinicTotal: Double = 0
		var travelTotal: Double = 0
		var trainingTotal: Double = 0
		var petCareTotal: Double = 0
		var otherTotal: Double = 0
		
		for expense in expenses {
			switch expense.category!.getExpenseCategory() {
			case .food:
				foodTotal += expense.amount
			case .toys:
				toysTotal += expense.amount
			case .clothes:
				clothesTotal += expense.amount
			case .accessories:
				accessoriesTotal += expense.amount
			case .petPurchase:
				petPurchaseTotal += expense.amount
			case .bath:
				bathTotal += expense.amount
			case .insurance:
				insuranceTotal += expense.amount
			case .clinic:
				clinicTotal += expense.amount
			case .travel:
				travelTotal += expense.amount
			case .training:
				trainingTotal += expense.amount
			case .petCare:
				petCareTotal += expense.amount
			case .other:
				otherTotal += expense.amount
			}
		}
		switch category {
		case.food:
			return foodTotal
		case .toys:
			return toysTotal
		case .clothes:
			return clothesTotal
		case .accessories:
			return accessoriesTotal
		case .petPurchase:
			return petPurchaseTotal
		case .bath:
			return bathTotal
		case .insurance:
			return insuranceTotal
		case .clinic:
			return clinicTotal
		case .travel:
			return travelTotal
		case .training:
			return trainingTotal
		case .petCare:
			return petCareTotal
		case .other:
			return otherTotal
		}
	}
	
	private func getCategoryPercentage(category: ExpenseCategory) -> Double {
		return self.getCategoryTotal(category: category)/self.total
	}
	
	private func deleteExpense(expense: Expense) {
		self.viewContext.delete(expense)
		Persistence.shared.saveContext(with: viewContext) { success in
			guard success else {
				self.saveAlertPresented.toggle()
				return
			}
			self.expenseToEdit = nil
		}
	}
}

struct RecordExpensesView_Previews: PreviewProvider {
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
		return RecordExpensesView(animateExpenseGraph: .constant(true), selectedYear: .constant(Date()), pet: newPet)
			.environment(\.managedObjectContext, context)
	}
}
