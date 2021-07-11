//
//  ReminderCustomRepeatButtonRow.swift
//  PetLog
//
//  Created by Hao Qin on 6/13/21.
//

import SwiftUI

struct ReminderCustomRepeatButtonRow: View {
	
	@Binding var customRepeat: [ReminderCustomRepeat]
	
	let assignedCustomRepeat: ReminderCustomRepeat
	
	private var isSelected: Bool {
		return self.customRepeat.contains(self.assignedCustomRepeat)
	}
	
	var body: some View {
		HStack {
			Button {
				if self.isSelected,
					 self.customRepeat.count > 1,
					 let index = self.customRepeat.firstIndex(of: self.assignedCustomRepeat) {
					self.customRepeat.remove(at: index)
				} else if !self.isSelected {
					self.customRepeat.append(self.assignedCustomRepeat)
				}
			} label: {
				Text(LocalizedStringKey(assignedCustomRepeat.rawValue))
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

struct ReminderCustomRepeatButtonRow_Previews: PreviewProvider {
	static var previews: some View {
		ReminderCustomRepeatButtonRow(customRepeat: .constant([.sunday]), assignedCustomRepeat: .sunday)
	}
}
