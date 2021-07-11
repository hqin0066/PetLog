//
//  DatePickerView.swift
//  PetLog
//
//  Created by Hao Qin on 5/7/21.
//

import SwiftUI

struct DatePickerView: View {
	
	@Binding var date: Date
	@Binding var didSelectDate: Bool
	@Binding var isShowing: Bool
	@Binding var selectedDate: Date
	
	let shouldShowTime: Bool
	
	var body: some View {
		VStack {
			Spacer()
			
			VStack(spacing: .zero) {
				HStack {
					Button("Cancel") {
						self.isShowing = false
					}
					.foregroundColor(.pinkyOrange)
					
					Spacer()
					
					Button("Save") {
						self.date = selectedDate
						self.didSelectDate = true
						self.isShowing = false
					}
					.foregroundColor(.pinkyOrange)
				}
				.padding(15)
				
				Divider()
				
				if shouldShowTime {
					DatePicker("", selection: $selectedDate)
						.labelsHidden()
						.datePickerStyle(WheelDatePickerStyle())
				} else {
					DatePicker("", selection: $selectedDate, displayedComponents: .date)
						.labelsHidden()
						.datePickerStyle(WheelDatePickerStyle())
				}
			}
			.padding(.bottom)
			.background(Color.systemWhite)
			.clipped()
			.offset(y: isShowing ? 0 : UIScreen.main.bounds.height*1.5)
		}
		.background(isShowing ? Color.black.opacity(0.6) : Color.clear)
		.edgesIgnoringSafeArea(.all)
		.onTapGesture {
			self.isShowing.toggle()
		}
	}
}

struct DatePickerView_Previews: PreviewProvider {
	static var previews: some View {
		DatePickerView(date: .constant(Date()), didSelectDate: .constant(false), isShowing: .constant(true), selectedDate: .constant(Date()), shouldShowTime: true)
	}
}
