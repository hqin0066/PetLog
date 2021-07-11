//
//  PetLogApp.swift
//  PetLog
//
//  Created by Hao Qin on 5/3/21.
//

import SwiftUI
import CoreData
import UserNotifications

@main
struct PetLogApp: App {
	
	@StateObject var notificationDelegate = NotificationDelegate()
	
	let viewContext = Persistence.shared.container.viewContext
	
	var body: some Scene {
		WindowGroup {
			MotherView()
				.environment(\.managedObjectContext, viewContext)
				.onAppear {
					UNUserNotificationCenter.current().delegate = notificationDelegate
				}
		}
	}
}
