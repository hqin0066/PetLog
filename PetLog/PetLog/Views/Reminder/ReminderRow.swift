//
//  ReminderRow.swift
//  PetLog
//
//  Created by Hao Qin on 6/10/21.
//

import SwiftUI

struct ReminderRow: View {
	
	@Binding var reminderToDelete: Reminder?
	@Binding var showDeleteAlert: Bool
	
	@ObservedObject var reminder: Reminder
	
	private var imageName: String {
		if let category = reminder.category?.getReminderCategory() {
			return category.pinkyOrangeImageName
		}
		return "DatePinkyOrange"
	}
	
	private var displayCategory: LocalizedStringKey {
		if let category = reminder.category?.getReminderCategory(),
			 let petName = reminder.pet?.name {
			return category.getDisplayString(petName: petName)
		}
		return "Other"
	}
	
	private var displayTime: String {
		if let date = reminder.date {
			return date.getTimeString()
		}
		return "00:00"
	}
	
	private var displayDate: String {
		if let date = reminder.date {
			return date.getShortDateString()
		}
		return "00/00/0000"
	}
	
	private var repeating: String {
		if let repeating = reminder.repeating?.getReminderRepeat(),
			 let customRepeat = reminder.customRepeat {
			if repeating != .custom {
				return repeating.rawValue
			} else {
				return customRepeat
			}
		}
		return ""
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 5) {
			HStack {
				Image(imageName)
					.resizable()
					.scaledToFit()
					.frame(width: 30, height: 30)
					.foregroundColor(.pinkyOrange)
					
				
				VStack(alignment: .leading) {
					Text(displayCategory)
						.font(.headline)
						.foregroundColor(.textGray)
					
					if let note = reminder.note,
						 !note.isEmpty {
						Text(note)
							.font(.subheadline)
							.foregroundColor(.textGray)
					}
				}
				
				Spacer()
				
				Button {
					self.reminderToDelete = self.reminder
					self.showDeleteAlert.toggle()
				} label: {
					Text("Mark Complete")
						.font(.subheadline)
						.bold()
						.foregroundColor(.white)
						.padding(.vertical, 5)
						.padding(.horizontal, 10)
						.background(Color.pinkyOrange.cornerRadius(15))
				}
			}
			
			Text(displayTime)
				.font(.largeTitle)
				.bold()
				.foregroundColor(.textGray)
			
			HStack {
				Text(displayDate)
					.font(.subheadline)
					.foregroundColor(.textGray)
					.padding(.vertical, 2)
					.padding(.horizontal, 10)
					.background(Color.backgroundColor.cornerRadius(15))
				
				Text(LocalizedStringKey(repeating))
					.font(.subheadline)
					.foregroundColor(.textGray)
			}
		}
		.padding()
		.background(Color.systemWhite.cornerRadius(10).shadow(radius: 4))
	}
}

struct ReminderRow_Previews: PreviewProvider {
	static var previews: some View {
		let context = Persistence.shared.container.viewContext
		let newReminder = Reminder(context: context)
		newReminder.date = Date()
		newReminder.repeating = "Never"
		newReminder.customRepeat = ""
		newReminder.category = "Feed"
		newReminder.note = ""
		newReminder.id = UUID().uuidString
		
		return ReminderRow(reminderToDelete: .constant(nil), showDeleteAlert: .constant(false), reminder: newReminder)
			.previewLayout(.fixed(width: 500, height: 200))
			.environment(\.managedObjectContext, context)
	}
}
