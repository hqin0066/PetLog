//
//  PetInfoDetailView.swift
//  PetLog
//
//  Created by Hao Qin on 5/6/21.
//

import SwiftUI

struct PetInfoDetailView: View {
	@Binding var imageData: Data?
	@Binding var imagePickerIsShowing: Bool
	@Binding var name: String
	@Binding var gender: PetGender
	@Binding var birthday: Date
	@Binding var arriveDate: Date
	@Binding var didSelectBirthday: Bool
	@Binding var didSelectArriveDate: Bool
	@Binding var showBirthdayDatePicker: Bool
	@Binding var showArrivalDateDatePicker: Bool
	@Binding var selectedDate: Date
	
	var body: some View {
		ZStack {
			Color.backgroundColor
				.edgesIgnoringSafeArea(.all)
			
			VStack(alignment: .leading, spacing: 18) {
				HStack {
					Spacer()
					
					PetImageSectionView(imageData: $imageData, imagePickerIsShowing: $imagePickerIsShowing)
					
					Spacer()
				}
				
				PetNameTextField(name: $name)
				
				PetGenderSelectionSectionView(gender: $gender)
				
				DateSelectionSectionView(showDatePicker: $showBirthdayDatePicker, didSelectDate: $didSelectBirthday, date: $birthday, selectedDate: $selectedDate, title: "Birthday")
				
				DateSelectionSectionView(showDatePicker: $showArrivalDateDatePicker, didSelectDate: $didSelectArriveDate, date: $arriveDate, selectedDate: $selectedDate, title: "Arrive Date")
				
				Spacer()
			}
			.padding(.top)
			.padding(.horizontal, 20)
		}
		.onTapGesture {
			UIApplication.shared.hideKeyboard()
		}
	}
}

struct PetInfoDetailView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			PetInfoDetailView(imageData: .constant(nil),
												imagePickerIsShowing: .constant(false),
												name: .constant(""),
												gender: .constant(.girl),
												birthday: .constant(Date()),
												arriveDate: .constant(Date()),
												didSelectBirthday: .constant(false),
												didSelectArriveDate: .constant(false),
												showBirthdayDatePicker: .constant(false),
												showArrivalDateDatePicker: .constant(false),
												selectedDate: .constant(Date())
			)
			PetInfoDetailView(imageData: .constant(nil),
												imagePickerIsShowing: .constant(false),
												name: .constant(""),
												gender: .constant(.girl),
												birthday: .constant(Date()),
												arriveDate: .constant(Date()),
												didSelectBirthday: .constant(false),
												didSelectArriveDate: .constant(false),
												showBirthdayDatePicker: .constant(false),
												showArrivalDateDatePicker: .constant(false),
												selectedDate: .constant(Date())
			)
			.environment(\.locale, .init(identifier: "zh"))
		}
	}
}

