//
//  ReminderRepeatSectionView.swift
//  PetLog
//
//  Created by Hao Qin on 6/13/21.
//

import SwiftUI

struct ReminderRepeatSectionView: View {
	
	@Binding var showSheet: Bool
	@Binding var selectedRepeat: ReminderRepeat
	@Binding var customRepeat: [ReminderCustomRepeat]
	
	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Image(systemName: "repeat")
					.foregroundColor(.pinkyOrange)
					.font(.title3)
				
				Text("Repeat")
					.font(.headline)
					.foregroundColor(.textGray)
				
				Spacer()
			}
			
			Button {
				self.showSheet.toggle()
				UIApplication.shared.hideKeyboard()
			} label: {
				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.foregroundColor(.systemWhite)
					
					HStack {
						Text(LocalizedStringKey(selectedRepeat.rawValue))
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

struct ReminderRepeatSectionView_Previews: PreviewProvider {
	static var previews: some View {
		ReminderRepeatSectionView(showSheet: .constant(false), selectedRepeat: .constant(.never), customRepeat: .constant([]))
			.previewLayout(.fixed(width: 500, height: 100))
	}
}
