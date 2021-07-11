//
//  ReminderCustomRepeatView.swift
//  PetLog
//
//  Created by Hao Qin on 6/13/21.
//

import SwiftUI

struct ReminderCustomRepeatView: View {
	@Environment(\.presentationMode) var presentationMode
	
	@Binding var customRepeat: [ReminderCustomRepeat]
	
	var body: some View {
		Form {
			ForEach(ReminderCustomRepeat.allCases, id: \.self) { customRepeat in
				ReminderCustomRepeatButtonRow(customRepeat: $customRepeat, assignedCustomRepeat: customRepeat)
			}
		}
		.navigationTitle("Custom")
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.toolbar(content: {
			ToolbarItem(placement: .navigationBarLeading) {
				Button {
					self.presentationMode.wrappedValue.dismiss()
				} label: {
					HStack(spacing: 5) {
						Image(systemName: "chevron.backward")
						Text("")
					}
					.font(.title3)
					.foregroundColor(.textGray)
				}
			}
		})
	}
}

struct ReminderCustomRepeatView_Previews: PreviewProvider {
	static var previews: some View {
		ReminderCustomRepeatView(customRepeat: .constant([.sunday]))
	}
}
