//
//  LocalNotification.swift
//  PetLog
//
//  Created by Hao Qin on 6/15/21.
//

import SwiftUI
import UserNotifications

struct LocalNotification {
	static let shared = LocalNotification()
	
	private init() { }
	
	func requestNotifyAuthorization() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
			
		}
	}
	
	func scheduleNotification(category: ReminderCategory, body: String, date: Date, repeating: ReminderRepeat, id: String) {
		let center = UNUserNotificationCenter.current()
		
		let content = UNMutableNotificationContent()
		let title = self.getNotificationTitle(for: category)
		content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
		content.body = body
		content.sound = .default
		
		let dateComponents = self.getDateComponents(date: date, repeating: repeating)
		
		let trigger = self.createTrigger(date: dateComponents, repeating: repeating)
		
		let request = self.createRequest(content: content, trigger: trigger, id: id)
		
		center.add(request) { error in
			if let error = error {
				print(error.localizedDescription)
			}
		}
	}
	
	func scheduleCustomRepeatNotification(category: ReminderCategory, body: String, date: Date, customRepeating: [ReminderCustomRepeat], id: String) {
		let center = UNUserNotificationCenter.current()
		
		let content = UNMutableNotificationContent()
		let title = self.getNotificationTitle(for: category)
		content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
		content.body = body
		content.sound = .default
		
		var dateComponents = self.getDateComponents(date: date, repeating: .custom)
		
		let weekDayNumbers: [ReminderCustomRepeat : Int] = [
			.sunday : 1,
			.monday : 2,
			.tuesday : 3,
			.wednesday : 4,
			.thursday : 5,
			.friday : 6,
			.saturday : 7,
		]
		
		for weekday in customRepeating {
			dateComponents.weekday = weekDayNumbers[weekday]
			
			let trigger = self.createTrigger(date: dateComponents, repeating: .custom)
			
			let IndividualId = id + weekday.rawValue
			
			let request = self.createRequest(content: content, trigger: trigger, id: IndividualId)
			
			center.add(request) { error in
				if let error = error {
					print(error.localizedDescription)
				}
			}
		}
	}
	
	func removeNotification(id: String) {
		let center = UNUserNotificationCenter.current()
		center.removeDeliveredNotifications(withIdentifiers: [id])
		center.removePendingNotificationRequests(withIdentifiers: [id])
	}
	
	func removeCustomRepeatNotification(id: String) {
		let center = UNUserNotificationCenter.current()
		var ids: [String] = []
		for weekday in ReminderCustomRepeat.allCases {
			let individualId = id + weekday.rawValue
			ids.append(individualId)
		}
		center.removeDeliveredNotifications(withIdentifiers: ids)
		center.removePendingNotificationRequests(withIdentifiers: ids)
	}
	
	private func getNotificationTitle(for category: ReminderCategory) -> String {
		switch category {
		case .feed:
			return "It's time to feed your pet!"
		case .walk:
			return "It's time to walk your pet!"
		case .bath:
			return "Time to give your pet a bath!"
		case .train:
			return "It's time to train your pet!"
		case .clean:
			return "It's time to clean your pet!"
		case .birthday:
			return "Today is your pet's birthday!"
		case .vaccine:
			return "It's time to vaccinate your pet!"
		case .deworm:
			return "It's time to deworm your pet!"
		case .physical:
			return "Time to give your pet a physical exam!"
		case .other:
			return "You have a reminder set at this time!"
		}
	}
	
	private func getDateComponents(date: Date, repeating: ReminderRepeat) -> DateComponents {
		let calendar = Calendar.current
		switch repeating {
		case .never:
			return calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
		case .everyDay:
			return calendar.dateComponents([.hour, .minute], from: date)
		case .everyWeek:
			return calendar.dateComponents([.weekday, .hour, .minute], from: date)
		case .everyMonth:
			return calendar.dateComponents([.day, .hour, .minute], from: date)
		case .everyYear:
			return calendar.dateComponents([.month, .day, .hour, .minute], from: date)
		case .custom:
			return calendar.dateComponents([.hour, .minute], from: date)
		}
	}
	
	private func createTrigger(date: DateComponents, repeating: ReminderRepeat) -> UNCalendarNotificationTrigger {
		switch repeating {
		case .never:
			return UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
		default:
			return UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
		}
	}
	
	private func createRequest(content: UNMutableNotificationContent, trigger: UNCalendarNotificationTrigger, id: String) -> UNNotificationRequest {
		return UNNotificationRequest(identifier: id, content: content, trigger: trigger)
	}
}

class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.banner, .sound])
	}
}
