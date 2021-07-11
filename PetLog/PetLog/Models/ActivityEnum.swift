//
//  ActivityEnum.swift
//  PetLog
//
//  Created by Hao Qin on 5/18/21.
//

import Foundation

enum Activity: String, CaseIterable {
	case meetFriends = "Meet Friends"
	case date = "Date"
	case outdoors = "Outdoors"
	case relax = "Relax"
	case bath = "Bath"
	case training = "Training"
	case toy = "Toy"
	case newDress = "New Dress"
	case food = "Food"
	case birthday = "Birthday"
	case backHome = "Back Home"
	case clinic = "Clinic"
	case parting = "Parting"
	case sad = "Sad"
	case other = "Other"
	
	var pinkyOrangeImageName: String {
		switch self {
		case .meetFriends:
			return "MeetFriendsPinkyOrange"
		case .date:
			return "DatePinkyOrange"
		case .outdoors:
			return "OutdoorsPinkyOrange"
		case .bath:
			return "BathPinkyOrange"
		case .newDress:
			return "NewDressPinkyOrange"
		case .training:
			return "TrainingPinkyOrange"
		case .toy:
			return "ToyPinkyOrange"
		case .food:
			return "FoodPinkyOrange"
		case .parting:
			return "PartingPinkyOrange"
		case .birthday:
			return "BirthdayPinkyOrange"
		case .backHome:
			return "BackHomePinkyOrange"
		case .clinic:
			return "ClinicPinkyOrange"
		case .relax:
			return "RelaxPinkyOrange"
		case .sad:
			return "SadPinkyOrange"
		case .other:
			return "OtherPinkyOrange"
		}
	}
	
	var whiteImageName: String {
		switch self {
		case .meetFriends:
			return "MeetFriendsWhite"
		case .date:
			return "DateWhite"
		case .outdoors:
			return "OutdoorsWhite"
		case .bath:
			return "BathWhite"
		case .newDress:
			return "NewDressWhite"
		case .training:
			return "TrainingWhite"
		case .toy:
			return "ToyWhite"
		case .food:
			return "FoodWhite"
		case .parting:
			return "PartingWhite"
		case .birthday:
			return "BirthdayWhite"
		case .backHome:
			return "BackHomeWhite"
		case .clinic:
			return "ClinicWhite"
		case .relax:
			return "RelaxWhite"
		case .sad:
			return "SadWhite"
		case .other:
			return "OtherWhite"
		}
	}
}
