   //
//  MotherView.swift
//  PetLog
//
//  Created by Hao Qin on 5/7/21.
//

import SwiftUI
import CoreData

struct MotherView: View {
	@FetchRequest(
		sortDescriptors: [],
		predicate: NSPredicate(format: "%K == %@", "isSelected", NSNumber(value: true)))
	var pets: FetchedResults<Pet>
	
	private var pet: Pet {
		guard let pet = pets.first else {
			fatalError("Core Data Fetch Error")
		}
		return pet
	}
	
	var body: some View {
		if pets.count == 0 {
			InfoPageView()
		} else {
			ContentView(pet: pet)
		}
	}
}

struct MotherView_Previews: PreviewProvider {
	static var previews: some View {
		MotherView()
	}
}
