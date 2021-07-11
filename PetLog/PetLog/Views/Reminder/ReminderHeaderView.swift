//
//  ReminderHeaderView.swift
//  PetLog
//
//  Created by Hao Qin on 6/10/21.
//

import SwiftUI

struct ReminderHeaderView: View {
	
	@Binding var addReminderSheetPresented: Bool
	
	var body: some View {
		ZStack {
			HStack {
				Spacer()
				
				Button{
					self.addReminderSheetPresented.toggle()
				} label: {
					Image(systemName: "plus.circle.fill")
						.font(.title2)
						.foregroundColor(Color.pinkyOrange)
				}
			}
			
			Text("Reminder")
				.font(.headline)
				.foregroundColor(.textGray)
		}
		.padding(.horizontal)
		.frame(height: 40)
		.background(Color.systemWhite)
	}
}


struct ReminderHeaderView_Previews: PreviewProvider {
	static var previews: some View {
		ReminderHeaderView(addReminderSheetPresented: .constant(false))
			.previewLayout(.fixed(width: 500, height: 100))
	}
}
