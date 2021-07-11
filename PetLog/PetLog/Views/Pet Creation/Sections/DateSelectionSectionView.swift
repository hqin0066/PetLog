//
//  DateSelectionSectionView.swift
//  PetLog
//
//  Created by Hao Qin on 5/7/21.
//

import SwiftUI

struct DateSelectionSectionView: View {
	
	@Binding var showDatePicker: Bool
	@Binding var didSelectDate: Bool
	@Binding var date: Date
	@Binding var selectedDate: Date
	
	let title: String
	
	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			Text(LocalizedStringKey(title))
				.font(.headline)
				.foregroundColor(.textGray)
			
			Button {
				if didSelectDate {
					self.selectedDate = date
				} else {
					self.selectedDate = Date()
				}
				self.showDatePicker.toggle()
				UIApplication.shared.hideKeyboard()
			} label: {
				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.foregroundColor(.systemWhite)
					
					HStack {
						Text(didSelectDate ? "\(date.getDateString())" : "Select")
							.font(.body)
							.foregroundColor(.textGray)
						
						Spacer()
						
						Image(systemName: "chevron.down.circle")
							.font(.title3)
							.foregroundColor(.pinkyOrange)
					}
					.padding(.horizontal)
				}
				.frame(height: 40)
			}
		}
	}
}


struct DateSelectionSectionView_Previews: PreviewProvider {
    static var previews: some View {
			Group {
				DateSelectionSectionView(showDatePicker: .constant(false), didSelectDate: .constant(true), date: .constant(Date()), selectedDate: .constant(Date()), title: "Birthday")
				DateSelectionSectionView(showDatePicker: .constant(false), didSelectDate: .constant(true), date: .constant(Date()), selectedDate: .constant(Date()), title: "Birthday")
					.environment(\.locale, .init(identifier: "zh"))
			}
    }
}
