//
//  File.swift
//  PetLog
//
//  Created by Hao Qin on 5/3/21.
//

import CoreData
import SwiftUI

struct Persistence {
	static let shared = Persistence()
	
	let container: NSPersistentContainer
	
	private init() {
		container = NSPersistentContainer(name: "PetLog")
		
		container.loadPersistentStores { storeDescription, error in
			if let nsError = error as NSError? {
				fatalError("Unsolved error: \(nsError), \(nsError.userInfo)")
			}
		}
	}
	
	// MARK: - Pet Creation
	func createPetWith(
		type: PetType,
		breed: String,
		imageData: Data,
		name: String,
		gender: PetGender,
		birthday: Date,
		arriveDate: Date,
		using context: NSManagedObjectContext,
		completion: (Bool) -> Void) {
		let pet = Pet(context: context)
		let petImage = PetImage(context: context)
		pet.type = type.rawValue
		pet.breed = breed
		pet.name = name
		pet.gender = gender.rawValue
		pet.birthday = birthday
		pet.arriveDate = arriveDate
		pet.isSelected = true
		petImage.image = imageData
		petImage.pet = pet
		
		do {
			try context.save()
			completion(true)
		} catch {
			let nserror = error as NSError
			print("CoreDate Error: \(nserror), \(nserror.userInfo)")
			completion(false)
		}
	}
	
	// MARK: - Journal Creation
	func createJournalWith(
		date: Date,
		activity: Activity,
		note: String,
		title: String,
		imageData: Data?,
		for pet: Pet,
		using context: NSManagedObjectContext,
		completion: (Bool) -> Void) {
		let journal = Journal(context: context)
		journal.date = date
		journal.activity = activity.rawValue
		journal.note = note
		journal.title = title
		journal.pet = pet
		
		if let data = imageData {
			let jornalImage = JournalImage(context: context)
			jornalImage.image = data
			jornalImage.journal = journal
		}
		
		do {
			try context.save()
			completion(true)
		} catch {
			let nserror = error as NSError
			print("CoreDate Error: \(nserror), \(nserror.userInfo)")
			completion(false)
		}
	}
	
	// MARK: - Expense Creation
	func createExpenseWith(
		date: Date,
		amount: Double,
		note: String,
		category: ExpenseCategory,
		for pet: Pet,
		using context: NSManagedObjectContext,
		completion: (Bool) -> Void) {
		let expense = Expense(context: context)
		expense.date = date
		expense.amount = amount
		expense.note = note
		expense.category = category.rawValue
		expense.pet = pet
		
		do {
			try context.save()
			completion(true)
		} catch {
			let nserror = error as NSError
			print("CoreDate Error: \(nserror), \(nserror.userInfo)")
			completion(false)
		}
	}
	
	// MARK: - Weight Creation
	func createWeightWith(
		date: Date,
		value: Double,
		for pet: Pet,
		using context: NSManagedObjectContext,
		completion: (Bool) -> Void) {
		let weight = Weight(context: context)
		weight.date = date
		weight.weight = value
		weight.pet = pet
		
		do {
			try context.save()
			completion(true)
		} catch {
			let nserror = error as NSError
			print("CoreDate Error: \(nserror), \(nserror.userInfo)")
			completion(false)
		}
	}
	
	// MARK: - Unit Creation
	func createWeightUnitWith(
		inPound: Bool,
		using context: NSManagedObjectContext,
		completion: (Bool) -> Void) {
		let unit = WeightUnit(context: context)
		unit.inPound = inPound
		
		do {
			try context.save()
			completion(true)
		} catch {
			let nserror = error as NSError
			print("CoreDate Error: \(nserror), \(nserror.userInfo)")
			completion(false)
		}
	}
	
	// Unusual Creation
	func createUnusualWith(
		date: Date,
		category: UnusualCategory,
		note: String,
		for pet: Pet,
		using context: NSManagedObjectContext,
		completion: (Bool) -> Void) {
		let unusual = Unusual(context: context)
		unusual.date = date
		unusual.category = category.rawValue
		unusual.note = note
		unusual.pet = pet
		
		do {
			try context.save()
			completion(true)
		} catch {
			let nserror = error as NSError
			print("CoreDate Error: \(nserror), \(nserror.userInfo)")
			completion(false)
		}
	}
	
	// MARK: - Reminder Creation
	func createReminderWith(
		date: Date,
		repeating: ReminderRepeat,
		customRepeat: [ReminderCustomRepeat],
		category: ReminderCategory,
		note: String,
		id: String,
		for pet: Pet,
		using context: NSManagedObjectContext,
		completion: (Bool) -> Void) {
		let reminder = Reminder(context: context)

		let weekDayNumbers: [ReminderCustomRepeat : Int] = [
			.sunday : 0,
			.monday : 1,
			.tuesday : 2,
			.wednesday : 3,
			.thursday : 4,
			.friday : 5,
			.saturday : 6,
		]

		let sorted = customRepeat.sorted {
			return (weekDayNumbers[$0] ?? 7) < (weekDayNumbers[$1] ?? 7)
		}
		
		var customRepeatString = ""

		if sorted.count == 7 {
			customRepeatString = "Every Day"
		} else if !sorted.contains(.sunday) &&
								!sorted.contains(.saturday) &&
								sorted.count == 5 {
			customRepeatString = "Every Weekday"
		} else if sorted.contains(.sunday) &&
								sorted.contains(.saturday) &&
								sorted.count == 2 {
			customRepeatString = "Every Weekend"
		} else {
			for day in sorted {
				customRepeatString += day.rawValue + " "
			}
		}
		
		reminder.date = date
		reminder.repeating = repeating.rawValue
		reminder.customRepeat = customRepeatString
		reminder.category = category.rawValue
		reminder.note = note
		reminder.id = id
		reminder.pet = pet
		
		do {
			try context.save()
			completion(true)
		} catch {
			let nserror = error as NSError
			print("CoreDate Error: \(nserror), \(nserror.userInfo)")
			completion(false)
		}
	}
	
	// MARK: - Save
	func saveContext(with context: NSManagedObjectContext, completion: (Bool) -> Void) {
		do {
			try context.save()
			completion(true)
		} catch {
			let nserror = error as NSError
			print("CoreDate Error: \(nserror), \(nserror.userInfo)")
			completion(false)
		}
	}
}
