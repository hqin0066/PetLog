//
//  ExpensesCategoryEnum.swift
//  PetLog
//
//  Created by Hao Qin on 5/25/21.
//

import SwiftUI

enum ExpenseCategory: String, CaseIterable {
  case food = "Food"
  case toys = "Toys"
  case clothes = "Clothes"
  case accessories = "Accessories"
  case petPurchase = "Pet Purchase"
  case bath = "Bath"
  case insurance = "Insurance"
  case clinic = "Clinic"
  case travel = "Travel"
  case training = "Training"
  case petCare = "Pet Care"
  case other = "Other"
  
  var pinkyOrangeImageName: String {
    switch self {
    case .food:
      return "FoodPinkyOrange"
    case .toys:
      return "ToyPinkyOrange"
    case .clothes:
      return "NewDressPinkyOrange"
    case .accessories:
      return "AccessoriesPinkyOrange"
    case .petPurchase:
      return "PetPurchasePinkyOrange"
    case .bath:
      return "BathPinkyOrange"
    case .insurance:
      return "InsurancePinkyOrange"
    case .clinic:
      return "ClinicPinkyOrange"
    case .travel:
      return "TravelPinkyOrange"
    case .training:
      return "TrainingPinkyOrange"
    case .petCare:
      return "BackHomePinkyOrange"
    case .other:
      return "OtherPinkyOrange"
    }
  }
  
  var whiteImageName: String {
    switch self {
    case .food:
      return "FoodWhite"
    case .toys:
      return "ToyWhite"
    case .clothes:
      return "NewDressWhite"
    case .accessories:
      return "AccessoriesWhite"
    case .petPurchase:
      return "PetPurchaseWhite"
    case .bath:
      return "BathWhite"
    case .insurance:
      return "InsuranceWhite"
    case .clinic:
      return "ClinicWhite"
    case .travel:
      return "TravelWhite"
    case .training:
      return "TrainingWhite"
    case .petCare:
      return "BackHomeWhite"
    case .other:
      return "OtherWhite"
    }
  }
  
  var color: Color {
    switch self {
    case .food:
      return Color("Food")
    case .toys:
      return Color("Toys")
    case .clothes:
      return Color("Clothes")
    case .accessories:
      return Color("Accessories")
    case .petPurchase:
      return Color("PetPurchase")
    case .bath:
      return Color("Bath")
    case .insurance:
      return Color("Insurance")
    case .clinic:
      return Color("Clinic")
    case .travel:
      return Color("Travel")
    case .training:
      return Color("Training")
    case .petCare:
      return Color("PetCare")
    case .other:
      return Color("Other")
    }
  }
}
