//
//  ReminderRepeatEnum.swift
//  PetLog
//
//  Created by Hao Qin on 6/13/21.
//

import Foundation

enum ReminderRepeat: String, CaseIterable {
	case never = "Never"
	case everyDay = "Every Day"
	case everyWeek = "Every Week"
	case everyMonth = "Every Month"
	case everyYear = "Every Year"
	case custom = "Custom"
}

enum ReminderCustomRepeat: String, CaseIterable {
	case sunday = "Sunday"
	case monday = "Monday"
	case tuesday = "Tuesday"
	case wednesday = "Wednesday"
	case thursday = "Thursday"
	case friday = "Friday"
	case saturday = "Saturday"
}
