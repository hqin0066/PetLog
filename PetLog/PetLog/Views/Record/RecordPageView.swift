//
//  RecordPage.swift
//  PetLog
//
//  Created by Hao Qin on 5/3/21.
//

import SwiftUI

struct RecordPageView: View {
	
	let pet: Pet
	
	@State private var currentPage = 0
	
	@State private var animateExpenseGraph = false
	@State private var selectedYearForExpense = Date()
	
	@State private var animateWeightGraph = false
	
	@State private var selectedYearForUnusual = Date()
	@State private var unusualCategoryFilter: [String] = []
	
	var body: some View {
		VStack {
			RecordPageControllerView(currentPage: $currentPage)
	
			TabView(selection: $currentPage) {
				RecordExpensesView(animateExpenseGraph: $animateExpenseGraph ,selectedYear: $selectedYearForExpense, pet: pet)
					.tag(0)
					.onAppear(perform: {
						withAnimation(.easeOut(duration: 1)) {
							self.animateExpenseGraph = true
						}
					})
					.onDisappear(perform: {
						self.animateExpenseGraph = false
					})

				RecordWeightView(animateWeightGraph: $animateWeightGraph, pet: pet)
					.tag(1)
					.onAppear(perform: {
						withAnimation(.easeOut(duration: 1)) {
							self.animateWeightGraph = true
						}
					})
					.onDisappear(perform: {
						self.animateWeightGraph = false
					})

				RecordUnusualView(selectedYear: $selectedYearForUnusual, unusualCategoryFilter: $unusualCategoryFilter ,pet: pet)
					.tag(2)

//				RecordMedicalView()
//					.tag(3)
			}
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
			
		}
		.background(Color.systemWhite.edgesIgnoringSafeArea(.all))
		.edgesIgnoringSafeArea(.bottom)
	}
}

struct RecordPageView_Previews: PreviewProvider {
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
		return RecordPageView(pet: newPet)
			.environment(\.managedObjectContext, context)
	}
}
