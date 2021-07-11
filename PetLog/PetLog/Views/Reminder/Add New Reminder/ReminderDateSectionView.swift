//
//  ReminderDateSectionView.swift
//  PetLog
//
//  Created by Hao Qin on 6/13/21.
//

import SwiftUI

struct ReminderDateSectionView: View {
	@Binding var date: Date
	@Binding var showDatePicker: Bool
	
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
					Text(self.date.getFullDateString())
						.font(.body)
						.foregroundColor(.pinkyOrange)
						.underline()
				}
			}
		}
	}
}

struct ReminderDateSectionView_Previews: PreviewProvider {
	static var previews: some View {
		ReminderDateSectionView(date: .constant(Date()), showDatePicker: .constant(false))
			.previewLayout(.fixed(width: 500, height: 100))
	}
}
