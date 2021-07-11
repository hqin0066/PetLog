//
//  AddUnusualView.swift
//  PetLog
//
//  Created by Hao Qin on 6/8/21.
//

import SwiftUI

struct AddUnusualView: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var viewContext
	
	let pet: Pet
	
	@State private var date = Date()
	@State private var selectedDate = Date()
	@State private var showDatePicker = false
	
	@State private var selectedCategory: UnusualCategory? = nil
	
	@State private var note = ""
	
	@State private var showSaveAlert = false
	
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
						if let category = self.selectedCategory {
							Persistence.shared.createUnusualWith(
								date: self.date,
								category: category,
								note: self.note,
								for: self.pet,
								using: viewContext) { success in
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
							.foregroundColor(self.selectedCategory == nil ? .iconGray : .pinkyOrange)
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
						JournalDateSectionView(date: $date, showDatePicker: $showDatePicker)
						
						UnusualCategorySectionView(selectedCategory: $selectedCategory)
						
						ExpenseNoteSectionView(note: $note)
					}
					.padding(.bottom, 100)
				}
				.onTapGesture {
					UIApplication.shared.hideKeyboard()
				}
			}
			.padding(.horizontal)
			
			DatePickerView(date: $date, didSelectDate: .constant(true), isShowing: $showDatePicker, selectedDate: $selectedDate, shouldShowTime: true)
				.animation(.default)
		}
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
	}
}

struct AddUnusualView_Previews: PreviewProvider {
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
		return AddUnusualView(pet: newPet)
			.environment(\.managedObjectContext, context)
	}
}
