//
//  RemindersPage.swift
//  PetLog
//
//  Created by Hao Qin on 5/3/21.
//

import SwiftUI
import UserNotifications

struct ReminderPageView: View {
	@Environment(\.managedObjectContext) var viewContext
	
	let pet: Pet
	
	@State private var addReminderSheetPresented = false
	@State private var reminderToDelete: Reminder? = nil
	@State private var showDeleteAlert = false
	@State private var showSaveAlert = false
	
	var fetchRequest: FetchRequest<Reminder>
	var reminders: FetchedResults<Reminder> { return fetchRequest.wrappedValue }
	
	// MARK: - Init
	
	init(pet: Pet) {
		self.pet = pet
		self.fetchRequest = FetchRequest<Reminder>(
			sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)],
			predicate: NSPredicate(format: "%K == %@", "pet", pet))
	}
	
	var body: some View {
		VStack(spacing: .zero) {
			ReminderHeaderView(addReminderSheetPresented: $addReminderSheetPresented)
				.sheet(isPresented: $addReminderSheetPresented, content: {
					AddReminderView(pet: pet)
				})
				.alert(isPresented: $showSaveAlert, content: {
					Alert(title: Text("Something Went Wrong"),
											 message: Text("Please try again later."),
											 dismissButton: .cancel(Text("OK")))
				})
			
			ScrollView {
				if !reminders.isEmpty {
					LazyVStack(spacing: .zero) {
						ForEach(reminders, id: \.self) { reminder in
							ReminderRow(reminderToDelete: $reminderToDelete, showDeleteAlert: $showDeleteAlert, reminder: reminder)
								.padding(.horizontal)
								.padding(.top, 15)
						}
					}
					.padding(.bottom, 250)
				} else {
					VStack(spacing: 20) {
						Image("Book")
							.resizable()
							.scaledToFit()
							.opacity(0.1)
							.frame(width: UIScreen.main.bounds.width / 2)
						
						Text("Try to set a reminder for your pet")
							.font(.subheadline)
							.foregroundColor(.textGray)
							.opacity(0.5)
						
						Spacer()
					}
					.padding(.top, UIScreen.main.bounds.height / 4)
				}
			}
			.alert(isPresented: $showDeleteAlert, content: {
				Alert(title: Text("Mark this reminder as completed?"),
							primaryButton: .cancel(),
							secondaryButton: .destructive(Text("Confirm"), action: {
								self.delete(reminder: self.reminderToDelete!)
							}))
			})
		}
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.bottom))
	}
	
	private func delete(reminder: Reminder) {
		if let repeating = reminder.repeating?.getReminderRepeat(),
			 let id = reminder.id {
			if repeating != .custom {
				LocalNotification.shared.removeNotification(id: id)
			} else {
				LocalNotification.shared.removeCustomRepeatNotification(id: id)
			}
		}
		
		self.viewContext.delete(reminder)
		Persistence.shared.saveContext(with: viewContext) { success in
			guard success else {
				self.showSaveAlert.toggle()
				return
			}
			self.reminderToDelete = nil
		}
	}
}

struct ReminderPageView_Previews: PreviewProvider {
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
		
		return ReminderPageView(pet: newPet)
			.environment(\.managedObjectContext, context)
	}
}

