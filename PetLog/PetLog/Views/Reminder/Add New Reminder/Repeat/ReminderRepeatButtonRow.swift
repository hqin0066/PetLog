//
//  ReminderRepeatButtonRow.swift
//  PetLog
//
//  Created by Hao Qin on 6/13/21.
//

import SwiftUI

struct ReminderRepeatButtonRow: View {

	@Binding var isShowing: Bool
	@Binding var selectedRepeat: ReminderRepeat
	@Binding var customRepeat: [ReminderCustomRepeat]
	
	let assignedRepeat: ReminderRepeat
	
	private var isSelected: Bool {
		return self.selectedRepeat == self.assignedRepeat
	}
	
	var body: some View {
		HStack {
			Button {
				self.customRepeat.removeAll()
				self.selectedRepeat = self.assignedRepeat
				self.isShowing.toggle()
			} label: {
				Text(LocalizedStringKey(assignedRepeat.rawValue))
					.font(.body)
					.foregroundColor(.textGray)
			}
			
			Spacer()
			
			Image(systemName: "checkmark")
				.font(.title3)
				.foregroundColor(.pinkyOrange)
				.opacity(isSelected ? 1 : 0)
		}
	}
}

struct ReminderRepeatButtonRow_Previews: PreviewProvider {
	static var previews: some View {
		ReminderRepeatButtonRow(isShowing: .constant(true), selectedRepeat: .constant(.never), customRepeat: .constant([]), assignedRepeat: .never)
			.previewLayout(.fixed(width: 500, height: 50))
	}
}
