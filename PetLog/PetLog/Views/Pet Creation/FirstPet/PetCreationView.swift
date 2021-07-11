//
//  PetCreationView.swift
//  PetLog
//
//  Created by Hao Qin on 5/5/21.
//

import SwiftUI

struct PetCreationView: View {
	@State private var currentPage = 0
	
	// TypeSelectionView State
	@State var selectedType: PetType = .dog
	
	// BreedSelectionView State
	@State private var breed: String = ""
	@State private var breedListSheetIsShowing = false
	
	// DetailView State
	@State private var imageData: Data? = nil
	@State private var imagePickerIsShowing = false
	@State private var name: String = ""
	@State private var gender: PetGender = .girl
	@State private var birthday: Date = Date()
	@State private var arriveDate: Date = Date()
	@State private var didSelectBirthday = false
	@State private var didSelectArriveDate = false
	@State private var showBirthdayDatePicker = false
	@State private var showArrivalDateDatePicker = false
	@State private var selectedDate = Date()
	@State private var showAlert = false
	@State private var showHomeView = false
	
	
	var body: some View {
		ZStack {
			Color.backgroundColor
				.edgesIgnoringSafeArea(.all)
			
			VStack {	
				TabView(selection: $currentPage) {
					
					TypeSelectionView(selectedType: $selectedType)
						.tag(0)
						.contentShape(Rectangle())
						.simultaneousGesture(DragGesture())
					
					BreedSelectionView(petType: $selectedType, breed: $breed, breedListSheetIsShowing: $breedListSheetIsShowing)
						.tag(1)
						.contentShape(Rectangle())
						.simultaneousGesture(DragGesture())
					
					
					PetInfoDetailView(
						imageData: $imageData,
						imagePickerIsShowing: $imagePickerIsShowing,
						name: $name,
						gender: $gender,
						birthday: $birthday,
						arriveDate: $arriveDate,
						didSelectBirthday: $didSelectBirthday,
						didSelectArriveDate: $didSelectArriveDate,
						showBirthdayDatePicker: $showBirthdayDatePicker,
						showArrivalDateDatePicker: $showArrivalDateDatePicker,
						selectedDate: $selectedDate
					)
						.tag(2)
						.contentShape(Rectangle())
						.simultaneousGesture(DragGesture())
				}
				.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
				
				
				Spacer()
				
				WelcomePageControllerView(
					currentPage: $currentPage,
					showHomeView: $showHomeView,
					selectedType: $selectedType,
					breed: $breed,
					imageData: $imageData,
					name: $name,
					gender: $gender,
					birthday: $birthday,
					arriveDate: $arriveDate,
					didSelectBirthday: $didSelectArriveDate,
					didSelectArriveDate: $didSelectArriveDate,
					showAlert: $showAlert
				)
				.fullScreenCover(isPresented: $showHomeView, content: {
					MotherView()
				})
				.alert(isPresented: $showAlert, content: {
					Alert(title: Text("Something Went Wrong"),
								message: Text("Please try again later."),
								dismissButton: .cancel(Text("OK")))
				})
			}
			.padding(.bottom)
			.ignoresSafeArea(.keyboard)
			
			DatePickerView(date: $birthday, didSelectDate: $didSelectBirthday, isShowing: $showBirthdayDatePicker, selectedDate: $selectedDate, shouldShowTime: false)
			
			DatePickerView(date: $arriveDate, didSelectDate: $didSelectArriveDate, isShowing: $showArrivalDateDatePicker, selectedDate: $selectedDate, shouldShowTime: false)
			
		}
		.navigationBarHidden(true)
		.animation(.default)
	}
}

struct PetCreationView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			PetCreationView()
			PetCreationView()
				.preferredColorScheme(.dark)
				.environment(\.locale, .init(identifier: "zh"))
		}
	}
}
