//
//  WeightRow.swift
//  PetLog
//
//  Created by Hao Qin on 6/2/21.
//

import SwiftUI

struct WeightRow: View {
	
	@Binding var weightToEdit: Weight?
	@Binding var showActionSheet: Bool
	
	@ObservedObject var weight: Weight
	
	let pet: Pet
	let inPound: Bool
	
	var displayWeight: String {
		if inPound {
			let weightInPound = weight.weight*2.205
			let rounded = Double(round(weightInPound*10)/10)
			return NumberFormatter.oneDecimalFormatter.string(from: NSNumber(value: rounded)) ?? "0.0"
		}
		return NumberFormatter.decimalFormatter.string(from: NSNumber(value: weight.weight)) ?? "0.00"
	}
	
	var displayDate: String {
		guard let date = weight.date else { return "" }
		return date.getShortDateString()
	}
	
	var displayAge: LocalizedStringKey {
		guard let date = weight.date,
					let birthday = pet.birthday else {
			return "\(0) Years"
		}
		let monthsCount = birthday.month(to: date)
		if monthsCount%12 == 0 {
			return "\(monthsCount/12) Years"
		} else if monthsCount < 12 {
			return "\(monthsCount) Months"
		} else {
			return "\((monthsCount-(monthsCount%12))/12) Years \(monthsCount%12) Months"
		}
	}
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack(spacing: .zero) {
				Text(displayWeight)
					.font(.title3)
					.bold()
					.foregroundColor(.textGray)
				
				Text(inPound ? " lb" : " kg")
					.font(.title3)
					.bold()
					.foregroundColor(.textGray)
				
				Spacer()
				
				Text(displayAge)
					.font(.subheadline)
					.foregroundColor(.white)
					.padding(.vertical, 2)
					.padding(.horizontal, 10)
					.background(Color.pinkyOrange.cornerRadius(15))
			}
			
			Text(displayDate)
				.font(.subheadline)
				.foregroundColor(.textGray)
				.padding(.vertical, 2)
				.padding(.horizontal, 10)
				.background(Color.backgroundColor.cornerRadius(15))
		}
		.padding()
		.background(Color.systemWhite.cornerRadius(10).shadow(radius: 4))
		.onTapGesture {
			self.weightToEdit = self.weight
			self.showActionSheet.toggle()
		}
	}
}

struct WeightRow_Previews: PreviewProvider {
	static var previews: some View {
		let context = Persistence.shared.container.viewContext
		let newWeight = Weight(context: context)
		newWeight.date = Date()
		newWeight.weight = 8
		
		let newPet = Pet(context: context)
		newPet.name = "Da Da"
		newPet.image = nil
		newPet.type = "dog"
		newPet.breed = "Maltese"
		newPet.isSelected = true
		newPet.birthday = Date()
		newPet.arriveDate = Date()
		return WeightRow(weightToEdit: .constant(nil), showActionSheet: .constant(false), weight: newWeight, pet: newPet, inPound: false)
			.environment(\.managedObjectContext, context)
			.previewLayout(.fixed(width: 500, height: 200))
	}
}
