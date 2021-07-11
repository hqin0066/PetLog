//
//  EditUnusualView.swift
//  PetLog
//
//  Created by Hao Qin on 6/9/21.
//

import SwiftUI

struct EditUnusualView: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var viewContext
	
	let unusual: Unusual
	
	@State private var date: Date
	@State private var selectedDate: Date
	@State private var showDatePicker = false
	
	@State private var selectedCategory: UnusualCategory?
	
	@State private var note: String
	
	@State private var showSaveAlert = false
	
	// MARK: - init
	
	init(unusual: Unusual) {
		self.unusual = unusual
		
		guard let date = unusual.date,
					let category = unusual.category?.getUnusualCategory(),
					let note = unusual.note else {
			_date = State(wrappedValue: Date())
			_selectedDate = _date
			_selectedCategory = State(wrappedValue: .sneeze)
			_note = State(wrappedValue: "")
			return
		}
		_date = State(wrappedValue: date)
		_selectedDate = _date
		_selectedCategory = State(wrappedValue: category)
		_note = State(wrappedValue: note)
	}
	
	var body: some View {
		ZStack {
			ScrollView(showsIndicators: false) {
				VStack(spacing: 20) {
					JournalDateSectionView(date: $date, showDatePicker: $showDatePicker)
					
					UnusualCategorySectionView(selectedCategory: $selectedCategory)
					
					ExpenseNoteSectionView(note: $note)
				}
				.padding(.bottom, 100)
			}
			.padding(.top)
			.padding(.horizontal)
			.onTapGesture {
				UIApplication.shared.hideKeyboard()
			}
			.alert(isPresented: $showSaveAlert, content: {
				Alert(title: Text("Something Went Wrong"),
							message: Text("Please try again later."),
							dismissButton: .cancel(Text("OK")))
			})
			
			DatePickerView(date: $date, didSelectDate: .constant(true), isShowing: $showDatePicker, selectedDate: $selectedDate, shouldShowTime: true)
				.animation(.default)
		}
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
		.navigationTitle("Edit Unusual Record")
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
					self.save()
				} label: {
					SaveButtonView(isCompleted: true)
				}
			}
		}
	}
	
	private func save() {
		self.unusual.date = self.date
		self.unusual.category = self.selectedCategory!.rawValue
		self.unusual.note = self.note
		
		Persistence.shared.saveContext(with: self.viewContext) { success in
			guard success else {
				self.showSaveAlert.toggle()
				return
			}
			self.presentationMode.wrappedValue.dismiss()
		}
	}
}

struct EditUnusualView_Previews: PreviewProvider {
	static var previews: some View {
		let context = Persistence.shared.container.viewContext
		let newUnusual = Unusual(context: context)
		newUnusual.date = Date()
		newUnusual.category = "Sneeze"
		
		return EditUnusualView(unusual: newUnusual)
			.environment(\.managedObjectContext, context)
	}
}
