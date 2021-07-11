//
//  ReminderRepeatSelectionView.swift
//  PetLog
//
//  Created by Hao Qin on 6/13/21.
//

import SwiftUI

struct ReminderRepeatSelectionView: View {

	@Binding var isShowing: Bool
	@Binding var selectedRepeat: ReminderRepeat
	@Binding var customRepeat: [ReminderCustomRepeat]
	
	@State private var presentCustomRepeatView = false
	
	var body: some View {
		NavigationView {
			VStack {
				Form {
					ForEach(ReminderRepeat.allCases, id: \.self) { reminderRepeat in
						if reminderRepeat != .custom {
							ReminderRepeatButtonRow(isShowing: $isShowing, selectedRepeat: $selectedRepeat, customRepeat: $customRepeat, assignedRepeat: reminderRepeat)
						}
					}
					
					Section(footer: Text(self.selectedRepeat == .custom ? self.getCustomRepeatString() : "").padding(.horizontal)) {
						Button {
							if self.selectedRepeat != .custom {
								self.selectedRepeat = .custom
								self.customRepeat.append(.sunday)
							}
							self.presentCustomRepeatView.toggle()
						} label: {
							HStack {
								Text("Custom")
									.font(.body)
									.foregroundColor(.textGray)
								
								Spacer()
								
								Image(systemName: self.selectedRepeat == .custom ? "checkmark" : "chevron.right")
									.font(.title3)
									.foregroundColor(self.selectedRepeat == .custom ? .pinkyOrange : .iconGray)
							}
						}
					}
				}
				
				NavigationLink(
					destination: ReminderCustomRepeatView(customRepeat: $customRepeat),
					isActive: $presentCustomRepeatView,
					label: {
						EmptyView()
					})
			}
			.navigationTitle("Repeat")
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarBackButtonHidden(true)
			.toolbar(content: {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						self.isShowing.toggle()
					} label: {
						HStack(spacing: 5) {
							Image(systemName: "xmark.circle")
							Text("")
						}
						.font(.title2)
						.foregroundColor(.textGray)
					}
				}
		})
		}
	}
	
	private func getCustomRepeatString() -> LocalizedStringKey {
		let weekDayNumbers: [ReminderCustomRepeat : Int] = [
			.sunday : 0,
			.monday : 1,
			.tuesday : 2,
			.wednesday : 3,
			.thursday : 4,
			.friday : 5,
			.saturday : 6,
		]

		let sorted = self.customRepeat.sorted {
			return (weekDayNumbers[$0] ?? 7) < (weekDayNumbers[$1] ?? 7)
		}

		if sorted.count == 7 {
			return "Reminder will repeat every day."
		} else if !sorted.contains(.sunday) &&
								!sorted.contains(.saturday) &&
								sorted.count == 5 {
			return "Reminder will repeat every weekday."
		} else if sorted.contains(.sunday) &&
								sorted.contains(.saturday) &&
								sorted.count == 2 {
			return "Reminder will repeat every weekend."
		} else {
			var string = ""
			for day in sorted {
				if sorted.count > 1,
					 day == sorted.last {
					string += " and " + day.rawValue + "."
				} else if sorted.count > 1,
									day == sorted.first {
					string += day.rawValue
				} else if sorted.count > 1 {
					string += ", " + day.rawValue
				} else {
					string += day.rawValue + "."
				}
			}
			let final = "Reminder will repeat every week on " + string
			return LocalizedStringKey(final)
		}
	}
}

struct ReminderRepeatSelectionView_Previews: PreviewProvider {
	static var previews: some View {
		ReminderRepeatSelectionView(isShowing: .constant(true) ,selectedRepeat: .constant(.never), customRepeat: .constant([]))
	}
}
