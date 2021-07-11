//
//  HomeTabPage.swift
//  PetLog
//
//  Created by Hao Qin on 5/3/21.
//

import SwiftUI

struct HomePageView: View {
	
	@Binding var fullScreenImagePresented: Bool
	@Binding var imageToPresent: UIImage?
	
	@ObservedObject var pet: Pet
	let petPhoto: UIImage?
	
	@State private var managePetViewPresented = false
	@State private var saveAlertPresented = false
	@State private var selectedMonth = Date()
	@State private var activityFilter: [String] = []
	
	var body: some View {
		VStack(spacing: .zero) {
			
			HomeNavigationView(showManagePetView: $managePetViewPresented, pet: pet)
			
			JournalView(fullScreenImagePresented: $fullScreenImagePresented,
									imageToPresent: $imageToPresent,
									selectedMonth: $selectedMonth,
									activityFilter: $activityFilter,
									pet: pet,
									petPhoto: petPhoto)
			
			NavigationLink(
				destination: ManagePetView(pet: pet),
				isActive: $managePetViewPresented,
				label: {
					EmptyView()
				})
		}
		.background(Color.backgroundColor)
	}
}


struct HomePageView_Previews: PreviewProvider {
	static var previews: some View {
		let context = Persistence.shared.container.viewContext
		let newPet = Pet(context: context)
		newPet.name = "Da Da"
		newPet.image = nil
		newPet.type = "dog"
		newPet.breed = "Maltese"
		newPet.isSelected = true
		newPet.birthday = Date()
		newPet.arriveDate = Date()
		return HomePageView(fullScreenImagePresented: .constant(false), imageToPresent: .constant(nil), pet: newPet, petPhoto: nil)
			.environment(\.managedObjectContext, context)
	}
}
