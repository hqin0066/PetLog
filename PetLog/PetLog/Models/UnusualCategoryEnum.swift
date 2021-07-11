//
//  UnusualCategoryEnum.swift
//  PetLog
//
//  Created by Hao Qin on 6/8/21.
//

import Foundation

enum UnusualCategory: String, CaseIterable {
	case sneeze = "Sneeze"
	case runningNose = "Running Nose"
	case cough = "Cough"
	case drool = "Drool"
	case vomit = "Vomit"
	case diarrhea = "Diarrhea"
	case softFeces = "Soft Feces"
	case eatByMistake = "Eat By Mistake"
	case notEating = "Not Eating"
	case fever = "Fever"
	case sleepy = "Sleepy"
	case seizures = "Seizures"
	case abnormalBreathing = "Abnormal Breathing"
	case shedding = "Shedding"
	case hotSpot = "Hot Spot"
	case heat = "Heat"
	case scratching = "Scratching"
	case aggressive = "Aggressive"
	case other = "Other"
	
	var pinkyOrangeImageName: String {
		switch self {
		case .sneeze:
			return "SneezePinkyOrange"
		case .runningNose:
			return "RunningNosePinkyOrange"
		case .cough:
			return "SneezePinkyOrange"
		case .drool:
			return "DroolPinkyOrange"
		case .vomit:
			return "VomitPinkyOrange"
		case .diarrhea:
			return "DiarrheaPinkyOrange"
		case .softFeces:
			return "SoftFecesPinkyOrange"
		case .eatByMistake:
			return "EatByMistakePinkyOrange"
		case .notEating:
			return "NotEatingPinkyOrange"
		case .fever:
			return "FeverPinkyOrange"
		case .sleepy:
			return "RelaxPinkyOrange"
		case .seizures:
			return "SeizuresPinkyOrange"
		case .abnormalBreathing:
			return "AbnormalBreathingPinkyOrange"
		case .shedding:
			return "SheddingPinkyOrange"
		case .hotSpot:
			return "HotSpotPinkyOrange"
		case .heat:
			return "HeatPinkyOrange"
		case .scratching:
			return "ScratchingPinkyOrange"
		case .aggressive:
			return "AggressivePinkyOrange"
		case .other:
			return "OtherPinkyOrange"
		}
	}
  
  var whiteImageName: String {
    switch self {
    case .sneeze:
      return "SneezeWhite"
    case .runningNose:
      return "RunningNoseWhite"
    case .cough:
      return "SneezeWhite"
    case .drool:
      return "DroolWhite"
    case .vomit:
      return "VomitWhite"
    case .diarrhea:
      return "DiarrheaWhite"
    case .softFeces:
      return "SoftFecesWhite"
    case .eatByMistake:
      return "EatByMistakeWhite"
    case .notEating:
      return "NotEatingWhite"
    case .fever:
      return "FeverWhite"
    case .sleepy:
      return "RelaxWhite"
    case .seizures:
      return "SeizuresWhite"
    case .abnormalBreathing:
      return "AbnormalBreathingWhite"
    case .shedding:
      return "SheddingWhite"
    case .hotSpot:
      return "HotSpotWhite"
    case .heat:
      return "HeatWhite"
    case .scratching:
      return "ScratchingWhite"
    case .aggressive:
      return "AggressiveWhite"
    case .other:
      return "OtherWhite"
    }
  }
}
