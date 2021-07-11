//
//  Extension.swift
//  PetLog
//
//  Created by Hao Qin on 5/4/21.
//

import SwiftUI

extension Color {
	static let backgroundColor = Color("BackgroundColor")
	static let pinkyOrange = Color("PinkyOrange")
	static let textGray = Color("TextGray")
	static let iconGray = Color("Gray")
	static let systemWhite = Color("White")
}

extension Date {
	func getDateString() -> String {
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.setLocalizedDateFormatFromTemplate("dd MMMM yyyy")
		return formatter.string(from: self)
	}
	
	func getShortDateString() -> String {
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
		return formatter.string(from: self)
	}
	
	func getShortDateWithoutYearString() -> String {
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.setLocalizedDateFormatFromTemplate("MM-dd")
		return formatter.string(from: self)
	}
	
	func getDateWithoutYearString() -> String {
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.setLocalizedDateFormatFromTemplate("dd MMMM")
		return formatter.string(from: self)
	}
	
	func getDateWithWeekdayString() -> String {
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.setLocalizedDateFormatFromTemplate("EEE dd MMMM")
		return formatter.string(from: self)
	}
	
	func getMonthString() -> String {
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.setLocalizedDateFormatFromTemplate("MMM yyyy")
		return formatter.string(from: self)
	}
	
	func getYearString() -> String {
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.setLocalizedDateFormatFromTemplate("yyyy")
		return formatter.string(from: self)
	}
	
	func getDateAndTimeString() -> String {
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.setLocalizedDateFormatFromTemplate("dd MMMM h:mm a")
		return formatter.string(from: self)
	}
	
	func getTimeString() -> String {
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.setLocalizedDateFormatFromTemplate("h:mm a")
		return formatter.string(from: self)
	}
	
	func getFullDateString() -> String {
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.setLocalizedDateFormatFromTemplate("EEE dd MMMM yyyy h:mm a")
		return formatter.string(from: self)
	}
	
	func month(to date: Date) -> Int {
		Calendar.current.dateComponents([.month], from: self, to: date).month ?? 0
	}
	
	func day(to date: Date) -> Int {
		Calendar.current.dateComponents([.day], from: self, to: date).day ?? 0
	}
	
	func forwardOneMonth() -> Date {
		let newDate = Calendar.current.date(byAdding: .month, value: 1, to: self)
		if let newDate = newDate {
			return newDate
		}
		return self
	}
	
	func backOneMonth() -> Date {
		let newDate = Calendar.current.date(byAdding: .month, value: -1, to: self)
		if let newDate = newDate {
			return newDate
		}
		return self
	}
	
	func forwardOneYear() -> Date {
		let newDate = Calendar.current.date(byAdding: .year, value: 1, to: self)
		if let newDate = newDate {
			return newDate
		}
		return self
	}
	
	func backOneYear() -> Date {
		let newDate = Calendar.current.date(byAdding: .year, value: -1, to: self)
		if let newDate = newDate {
			return newDate
		}
		return self
	}
	
	func startOfDay() -> Date {
		let calendar = Calendar.current
		let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: self)
		let startOfDay = calendar.date(from: currentDateComponents)!
		
		return startOfDay
	}
	
	func endOfDay() -> Date {
		let calendar = Calendar.current
		let plusOneDayDate = calendar.date(byAdding: .day, value: 1, to: self)
		let plusOneDayDateComponents = calendar.dateComponents([.year, .month, .day], from: plusOneDayDate!)
		let endOfDay = calendar.date(from: plusOneDayDateComponents)!.addingTimeInterval(-1)
		
		return endOfDay
	}
	
	func startOfMonth() -> Date {
		let calendar = Calendar.current
		let currentDateComponents = calendar.dateComponents([.year, .month], from: self)
		let startOfMonth = calendar.date(from: currentDateComponents)!
		
		return startOfMonth
	}
	
	func dateByAddingMonths(_ monthsToAdd: Int) -> Date? {
		let calendar = NSCalendar.current
		var months = DateComponents()
		months.month = monthsToAdd

		return calendar.date(byAdding: months, to: self)
	}
	
	func endOfMonth() -> Date {
		let calendar = Calendar.current
		let plusOneMonthDate = dateByAddingMonths(1)!
		let plusOneMonthDateComponents = calendar.dateComponents([.year, .month], from: plusOneMonthDate)
		let endOfMonth = calendar.date(from: plusOneMonthDateComponents)!.addingTimeInterval(-1)
		
		return endOfMonth
	}
	
	func startOfYear() -> Date {
		let calendar = Calendar.current
		let currentDateComponents = calendar.dateComponents([.year], from: self)
		let startOfYear = calendar.date(from: currentDateComponents)!
		
		return startOfYear
	}
	
	func dateByAddingYears(_ yearsToAdd: Int) -> Date? {
		let calendar = NSCalendar.current
		var years = DateComponents()
		years.year = yearsToAdd

		return calendar.date(byAdding: years, to: self)
	}
	
	func endOfYear() -> Date {
		let calendar = Calendar.current
		let plusOneYearDate = dateByAddingYears(1)!
		let plusOneYearDateComponents = calendar.dateComponents([.year], from: plusOneYearDate)
		let endOfYear = calendar.date(from: plusOneYearDateComponents)!.addingTimeInterval(-1)
		
		return endOfYear
	}
}

extension UIImage {
	func png(isOpaque: Bool = true) -> Data? { flattened(isOpaque: isOpaque).pngData() }
	func flattened(isOpaque: Bool = true) -> UIImage {
		if imageOrientation == .up { return self }
		let format = imageRendererFormat
		format.opaque = isOpaque
		return UIGraphicsImageRenderer(size: size, format: format).image { _ in draw(at: .zero) }
	}
}

extension UIApplication {
	func hideKeyboard() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}

extension String {
	func getActivity() -> Activity {
		if self == Activity.meetFriends.rawValue {
			return .meetFriends
		} else if self == Activity.date.rawValue {
			return .date
		} else if self == Activity.outdoors.rawValue {
			return .outdoors
		} else if self == Activity.bath.rawValue {
			return .bath
		} else if self == Activity.newDress.rawValue {
			return .newDress
		} else if self == Activity.training.rawValue {
			return .training
		} else if self == Activity.toy.rawValue {
			return .toy
		} else if self == Activity.food.rawValue {
			return .food
		} else if self == Activity.parting.rawValue {
			return .parting
		} else if self == Activity.birthday.rawValue {
			return .birthday
		} else if self == Activity.backHome.rawValue {
			return .backHome
		} else if self == Activity.clinic.rawValue {
			return .clinic
		} else if self == Activity.relax.rawValue {
			return .relax
		} else if self == Activity.other.rawValue {
			return .other
		} else {
			return .other
		}
	}
	
	func getExpenseCategory() -> ExpenseCategory {
		if self == ExpenseCategory.food.rawValue {
			return .food
		} else if self == ExpenseCategory.toys.rawValue {
			return .toys
		} else if self == ExpenseCategory.clothes.rawValue {
			return .clothes
		} else if self == ExpenseCategory.accessories.rawValue {
			return .accessories
		} else if self == ExpenseCategory.petPurchase.rawValue {
			return .petPurchase
		} else if self == ExpenseCategory.bath.rawValue {
			return .bath
		} else if self == ExpenseCategory.insurance.rawValue {
			return .insurance
		} else if self == ExpenseCategory.clinic.rawValue {
			return .clinic
		} else if self == ExpenseCategory.travel.rawValue {
			return .travel
		} else if self == ExpenseCategory.training.rawValue {
			return .travel
		} else if self == ExpenseCategory.petCare.rawValue {
			return .petCare
		} else if self == ExpenseCategory.other.rawValue {
			return .other
		} else {
			return .other
		}
	}
	
	func getUnusualCategory() -> UnusualCategory {
		if self == UnusualCategory.sneeze.rawValue {
			return .sneeze
		} else if self == UnusualCategory.runningNose.rawValue {
			return .runningNose
		} else if self == UnusualCategory.cough.rawValue {
			return .cough
		} else if self == UnusualCategory.drool.rawValue {
			return .drool
		} else if self == UnusualCategory.vomit.rawValue {
			return .vomit
		} else if self == UnusualCategory.diarrhea.rawValue {
			return .diarrhea
		} else if self == UnusualCategory.softFeces.rawValue {
			return .softFeces
		} else if self == UnusualCategory.eatByMistake.rawValue {
			return .eatByMistake
		} else if self == UnusualCategory.notEating.rawValue {
			return .notEating
		} else if self == UnusualCategory.fever.rawValue {
			return .fever
		} else if self == UnusualCategory.sleepy.rawValue {
			return .sleepy
		} else if self == UnusualCategory.seizures.rawValue {
			return .seizures
		} else if self == UnusualCategory.abnormalBreathing.rawValue {
			return .abnormalBreathing
		} else if self == UnusualCategory.shedding.rawValue {
			return .shedding
		} else if self == UnusualCategory.hotSpot.rawValue {
			return .hotSpot
		} else if self == UnusualCategory.heat.rawValue {
			return .heat
		} else if self == UnusualCategory.scratching.rawValue {
			return .scratching
		} else if self == UnusualCategory.aggressive.rawValue {
			return .aggressive
		} else if self == UnusualCategory.other.rawValue {
			return .other
		} else {
			return .other
		}
	}
	
	func getReminderCategory() -> ReminderCategory {
		if self == ReminderCategory.feed.rawValue {
			return .feed
		} else if self == ReminderCategory.walk.rawValue {
			return .walk
		} else if self == ReminderCategory.bath.rawValue {
			return .bath
		} else if self == ReminderCategory.train.rawValue {
			return .train
		} else if self == ReminderCategory.clean.rawValue {
			return .clean
		} else if self == ReminderCategory.birthday.rawValue {
			return .birthday
		} else if self == ReminderCategory.vaccine.rawValue {
			return .vaccine
		} else if self == ReminderCategory.deworm.rawValue {
			return .deworm
		} else if self == ReminderCategory.physical.rawValue {
			return .physical
		} else if self == ReminderCategory.other.rawValue {
			return .other
		} else {
			return .other
		}
	}
	
	func getReminderRepeat() -> ReminderRepeat {
		if self == ReminderRepeat.never.rawValue {
			return .never
		} else if self == ReminderRepeat.everyDay.rawValue {
			return .everyDay
		} else if self == ReminderRepeat.everyWeek.rawValue {
			return .everyWeek
		} else if self == ReminderRepeat.everyMonth.rawValue {
			return .everyMonth
		} else if self == ReminderRepeat.everyYear.rawValue {
			return .everyYear
		} else if self == ReminderRepeat.custom.rawValue {
			return .custom
		} else {
			return .never
		}
	}
	
	func getReminderCustomRepeat() -> ReminderCustomRepeat {
		if self == ReminderCustomRepeat.sunday.rawValue {
			return .sunday
		} else if self == ReminderCustomRepeat.monday.rawValue {
			return .monday
		} else if self == ReminderCustomRepeat.tuesday.rawValue {
			return .tuesday
		} else if self == ReminderCustomRepeat.wednesday.rawValue {
			return .wednesday
		} else if self == ReminderCustomRepeat.thursday.rawValue {
			return .thursday
		} else if self == ReminderCustomRepeat.friday.rawValue {
			return .friday
		} else if self == ReminderCustomRepeat.saturday.rawValue {
			return .saturday
		} else {
			return .sunday
		}
	}
}

extension GeometryProxy {
	func getScrollOffset() -> CGFloat {
		self.frame(in: .global).minY
	}
	
	func getOffsetForHeaderImage() -> CGFloat {
		let offset = self.getScrollOffset()
		
		if offset > 0 {
			return -offset
		}
		return 0
	}
	
	func getHeightForHeaderImage() -> CGFloat {
		let offset = self.getScrollOffset()
		let imageHeight = self.size.height
		
		if offset > 0 {
			return imageHeight + offset
		}
		
		return imageHeight
	}
}

extension NumberFormatter {
	static var currencyFormatter: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.currencySymbol = ""
		return formatter
	}
	
	static var decimalFormatter: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.roundingMode = .halfUp
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
		return formatter
	}
	
	static var oneDecimalFormatter: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.roundingMode = .halfUp
		formatter.minimumFractionDigits = 1
		formatter.maximumFractionDigits = 1
		return formatter
	}
}

extension UINavigationController: UIGestureRecognizerDelegate {
	override open func viewDidLoad() {
		super.viewDidLoad()
		interactivePopGestureRecognizer?.delegate = self
	}
	
	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return viewControllers.count > 1
	}
}
