//
//  JournalDateSectionView.swift
//  PetLog
//
//  Created by Hao Qin on 5/16/21.
//

import SwiftUI

struct JournalDateSectionView: View {
	@Binding var date: Date
	@Binding var showDatePicker: Bool
	
	var displayDate: LocalizedStringKey {
		let dateString = self.date.getDateAndTimeString()
		let date = Calendar.current.dateComponents([.day, .month, .year], from: self.date)
		let todaysDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
		let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
		let yesterdaysDate = Calendar.current.dateComponents([.day, .month, .year], from: yesterday!)
		if date == todaysDate {
			return "Today, \(dateString)"
		} else if date == yesterdaysDate {
			return "Yesterday, \(dateString)"
		}
		return "\(dateString)"
	}
	
	var body: some View {
		Button {
			self.showDatePicker.toggle()
      UIApplication.shared.hideKeyboard()
		} label: {
			HStack {
				Image(systemName: "calendar")
					.font(.title3)
					.foregroundColor(.pinkyOrange)
				
				VStack(spacing: 2) {
					Text(displayDate)
						.font(.body)
						.foregroundColor(.pinkyOrange)
						.underline()
				}
			}
		}
	}
}

struct JournalDateSectionView_Previews: PreviewProvider {
	static var previews: some View {
		JournalDateSectionView(date: .constant(Date()), showDatePicker: .constant(false))
			.previewLayout(.fixed(width: 500, height: 50))
	}
}
