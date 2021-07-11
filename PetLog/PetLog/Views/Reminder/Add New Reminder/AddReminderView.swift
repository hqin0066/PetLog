//
//  AddReminderView.swift
//  PetLog
//
//  Created by Hao Qin on 6/13/21.
//

import SwiftUI
import UserNotifications

struct AddReminderView: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var viewContext
	
	let pet: Pet
	
	@State private var date = Date()
	@State private var selectedDate = Date()
	@State private var showDatePicker = false
	
	@State private var showRepeatSelectionSheet = false
	@State private var selectedRepeat: ReminderRepeat = .never
	@State private var customRepeat: [ReminderCustomRepeat] = []
	
	@State private var selectedCategory: ReminderCategory? = nil
	
	@State private var note = ""
	
	@State private var showSaveAlert = false
	@State private var showAuthorizationAlert = false
	
	var body: some View {
		NavigationView {
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
						.alert(isPresented: $showAuthorizationAlert) {
							Alert(title: Text("Notification is Turned Off for PetLog"),
										message: Text("You can turn on notification for PetLog in Settings."),
										primaryButton: .cancel(Text("OK")),
										secondaryButton: .default(Text("Settings"), action: {
											if let bundleIdentifier = Bundle.main.bundleIdentifier,
												 let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
												UIApplication.shared.open(appSettings)
											}
										}))
						}
						
						Spacer()
						
						Button {
							self.save()
						} label: {
							Image(systemName: "checkmark.circle.fill")
								.font(.title)
								.foregroundColor(self.selectedCategory != nil ? .pinkyOrange : .iconGray)
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
							ReminderDateSectionView(date: $date, showDatePicker: $showDatePicker)
							
							ReminderRepeatSectionView(showSheet: $showRepeatSelectionSheet, selectedRepeat: $selectedRepeat, customRepeat: $customRepeat)
								.sheet(isPresented: $showRepeatSelectionSheet, content: {
									ReminderRepeatSelectionView(isShowing: $showRepeatSelectionSheet, selectedRepeat: $selectedRepeat, customRepeat: $customRepeat)
							})
							
							ReminderCategorySectionView(selectedCategory: $selectedCategory)
							
							ExpenseNoteSectionView(note: $note)
						}
						.padding(.bottom, 100)
					}
				}
				.padding(.horizontal)
				.onTapGesture {
					UIApplication.shared.hideKeyboard()
				}
				
				DatePickerView(date: $date, didSelectDate: .constant(true), isShowing: $showDatePicker, selectedDate: $selectedDate, shouldShowTime: true)
					.animation(.default)
			}
			.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
			.navigationBarHidden(true)
		}
	}
	
	private func save() {
		let current = UNUserNotificationCenter.current()
		current.getNotificationSettings { permisson in
			guard permisson.authorizationStatus != .notDetermined else {
				LocalNotification.shared.requestNotifyAuthorization()
				return
			}
			
			guard permisson.authorizationStatus != .denied else {
				self.showAuthorizationAlert.toggle()
				return
			}
			
			DispatchQueue.main.async {
				if let category = self.selectedCategory {
					let id = UUID().uuidString
					
					self.saveToCoreData(category: category, id: id)
					
					if self.selectedRepeat != .custom {
						LocalNotification.shared.scheduleNotification(category: category, body: self.note, date: self.date, repeating: self.selectedRepeat, id: id)
					} else {
						LocalNotification.shared.scheduleCustomRepeatNotification(category: category, body: self.note, date: self.date, customRepeating: self.customRepeat, id: id)
					}
					
					self.presentationMode.wrappedValue.dismiss()
				}
			}
		}
	}
	
	private func saveToCoreData(category: ReminderCategory, id: String) {
		Persistence.shared.createReminderWith(
			date: self.date,
			repeating: self.selectedRepeat,
			customRepeat: self.customRepeat,
			category: category,
			note: self.note,
			id: id,
			for: self.pet,
			using: self.viewContext) { success in
			guard success else {
				self.showSaveAlert.toggle()
				return
			}
		}
	}
}

struct AddReminderView_Previews: PreviewProvider {
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
		
		return AddReminderView(pet: newPet)
			.environment(\.managedObjectContext, context)
	}
}
