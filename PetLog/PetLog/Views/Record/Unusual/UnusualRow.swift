//
//  UnusualRow.swift
//  PetLog
//
//  Created by Hao Qin on 6/8/21.
//

import SwiftUI

struct UnusualRow: View {
	
	@Binding var unusualToEdit: Unusual?
	@Binding var showActionSheet: Bool
	
	@ObservedObject var unusual: Unusual
	
	var displayDate: LocalizedStringKey {
		guard let unusualDate = unusual.date else { return "" }
		let dateString = unusualDate.getDateWithoutYearString()
		let date = Calendar.current.dateComponents([.day, .month, .year], from: self.unusual.date!)
		let todaysDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
		let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
		let yesterdaysDate = Calendar.current.dateComponents([.day, .month, .year], from: yesterday!)
		if date == todaysDate {
			return "Today, \(dateString)"
		} else if date == yesterdaysDate {
			return "Yesterday, \(dateString)"
		}
		return "\(unusualDate.getDateWithWeekdayString())"
	}
	
	var imageName: String {
		if let category = unusual.category?.getUnusualCategory() {
			return category.pinkyOrangeImageName
		}
		return "DatePinkyOrange"
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Text(displayDate)
					.font(.subheadline)
					.foregroundColor(.textGray)
				
				Spacer()
			}
			
			HStack(alignment: .center) {
				Image(imageName)
					.resizable()
					.scaledToFit()
					.frame(width: 30, height: 30)
				
				HStack(alignment: .lastTextBaseline, spacing: 5) {
					Text(LocalizedStringKey(unusual.category ?? ""))
						.font(.title2)
						.bold()
						.foregroundColor(Color.pinkyOrange)
					
					if let date = unusual.date {
						Text(date.getTimeString())
							.font(.subheadline)
							.foregroundColor(.textGray)
					}
				}
			}
			
			if let note = unusual.note,
				 !note.isEmpty {
				Text(note)
					.font(.body)
					.foregroundColor(.textGray)
					.lineLimit(nil)
			}
		}
		.padding()
		.background(Color.systemWhite.cornerRadius(10).shadow(radius: 4))
		.onTapGesture {
			self.unusualToEdit = self.unusual
			self.showActionSheet.toggle()
		}
	}
}

struct UnusualRow_Previews: PreviewProvider {
	static var previews: some View {
		let context = Persistence.shared.container.viewContext
		let newUnusual = Unusual(context: context)
		newUnusual.date = Date()
		newUnusual.category = "Other"
		
		return UnusualRow(unusualToEdit: .constant(nil), showActionSheet: .constant(false), unusual: newUnusual)
			.environment(\.managedObjectContext, context)
			.previewLayout(.fixed(width: 500, height: 300))
	}
}
