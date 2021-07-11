//
//  ReminderCategoryEnum.swift
//  PetLog
//
//  Created by Hao Qin on 6/13/21.
//

import SwiftUI

enum ReminderCategory: String, CaseIterable {
	case feed = "Feed"
	case walk = "Walk"
	case bath = "Bath"
	case train = "Train"
	case clean = "Clean"
	case birthday = "Birthday"
	case vaccine = "Vaccine"
	case deworm = "Deworm"
	case physical = "Physical"
	case other = "Other"
	
	var pinkyOrangeImageName: String {
		switch self {
		case .feed:
			return "FoodPinkyOrange"
		case .walk:
			return "WalkPinkyOrange"
		case .bath:
			return "BathPinkyOrange"
		case .train:
			return "TrainingPinkyOrange"
		case .clean:
			return "CleanPinkyOrange"
		case .birthday:
			return "BirthdayPinkyOrange"
		case .vaccine:
			return "VaccinePinkyOrange"
		case .deworm:
			return "DewormPinkyOrange"
		case .physical:
			return "PhysicalPinkyOrange"
		case .other:
			return "OtherPinkyOrange"
		}
	}
  
  var whiteImageName: String {
    switch self {
    case .feed:
      return "FoodWhite"
    case .walk:
      return "WalkWhite"
    case .bath:
      return "BathWhite"
    case .train:
      return "TrainingWhite"
    case .clean:
      return "CleanWhite"
    case .birthday:
      return "BirthdayWhite"
    case .vaccine:
      return "VaccineWhite"
    case .deworm:
      return "DewormWhite"
    case .physical:
      return "PhysicalWhite"
    case .other:
      return "OtherWhite"
    }
  }
	
	func getDisplayString(petName: String) -> LocalizedStringKey {
		switch self {
		case .feed:
			return "Feed \(petName)"
		case .walk:
			return "Walk \(petName)"
		case .bath:
			return "Give \(petName) a bath"
		case .train:
			return "Train \(petName)"
		case .clean:
			return "Clean \(petName)"
		case .birthday:
			return "\(petName)'s birthday"
		case .vaccine:
			return "Vaccinate \(petName)"
		case .deworm:
			return "Deworm \(petName)"
		case .physical:
			return "Give \(petName) a physical exam"
		case .other:
			return "Other"
		}
	}
}
