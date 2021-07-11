//
//  AddJournalView.swift
//  PetLog
//
//  Created by Hao Qin on 5/15/21.
//

import SwiftUI
import PhotosUI

struct AddJournalView: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var viewContext
	
	let pet: Pet
	
	@State private var date = Date()
	@State private var selectedDate = Date()
	@State private var showDatePicker = false
	
	@State private var selectedActivity: Activity? = nil
	
	@State private var note = ""
	@State private var title = ""
	@State private var showFullEditor = false
	
	@State private var imageData: Data? = nil
	@State private var showImagePickerActionSheet = false
	@State private var showCameraView = false
	@State private var showImagePicker = false
	@State private var showDeleteImageAlert = false
	
	@State private var showSaveAlert = false
	
	private var actionSheet: ActionSheet {
		ActionSheet(
			title: Text("Please select"),
			buttons: [
				.default(Text("Take Photo"), action: {
					self.showCameraView.toggle()
				}),
				.default(Text("Select Photo"), action: {
					self.showImagePicker.toggle()
				}),
				.cancel()
			])
	}
	
	private var deleteImageAlert: Alert {
		Alert(title: Text("Delete this photo?"),
					primaryButton: .destructive(Text("Delete"), action: {
						self.imageData = nil
					}),
					secondaryButton: .cancel())
	}
	
	var body: some View {
		ZStack {
			VStack {
				HStack {
					Button {
						self.presentationMode.wrappedValue.dismiss()
					} label: {
						Image(systemName: "xmark.circle")
							.font(.title)
							.foregroundColor(.iconGray)
					}
					
					Spacer()
					
					Button {
						if let activity = self.selectedActivity {
							Persistence.shared.createJournalWith(
								date: self.date,
								activity: activity,
								note: self.note,
								title: self.title,
								imageData: self.imageData,
								for: self.pet,
								using: self.viewContext) { success in
								guard success else {
									self.showSaveAlert.toggle()
									return
								}
								self.presentationMode.wrappedValue.dismiss()
							}
						}
					} label: {
						Image(systemName: "checkmark.circle.fill")
							.font(.title)
							.foregroundColor(self.selectedActivity == nil ? .iconGray : .pinkyOrange)
					}
					.alert(isPresented: $showSaveAlert, content: {
						Alert(title: Text("Something Went Wrong"),
									message: Text("Please try again later."),
									dismissButton: .cancel(Text("OK")))
					})
				}
				.padding(.vertical)
				
				ScrollView(showsIndicators: false) {
					VStack(spacing: 20) {
						Text("What did \(self.pet.name!) do at this moment?")
							.font(.title2)
							.bold()
							.foregroundColor(.textGray)
						
						JournalDateSectionView(date: $date, showDatePicker: $showDatePicker)
						
						ActivitySectionView(selectedActivity: $selectedActivity)
						
						NoteSectionView(note: $note, title: $title, showFullEditor: $showFullEditor)
							.sheet(isPresented: $showFullEditor, content: {
								FullEditorView(title: $title, note: $note)
							})
						
						JournalImageSectionView(imageData: $imageData, showImagePickerActionSheet: $showImagePickerActionSheet, showDeleteImageAlert: $showDeleteImageAlert)
							.actionSheet(isPresented: $showImagePickerActionSheet, content: {
								self.actionSheet
							})
							.sheet(isPresented: $showImagePicker, content: {
								PHPickerViewController.View(imageData: $imageData)
							})
							.fullScreenCover(isPresented: $showCameraView, content: {
								UIImagePickerView(imageData: $imageData)
									.edgesIgnoringSafeArea(.all)
							})
							.alert(isPresented: $showDeleteImageAlert, content: {
								self.deleteImageAlert
							})
					}
					.padding(.bottom, 100)
				}
			}
			.padding(.horizontal)
			
			DatePickerView(date: $date, didSelectDate: .constant(true), isShowing: $showDatePicker, selectedDate: $selectedDate, shouldShowTime: true)
				.animation(.default)
		}
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
    .onTapGesture {
      UIApplication.shared.hideKeyboard()
    }
	}
}

struct AddJournalView_Previews: PreviewProvider {
	static var previews: some View {
		let context = Persistence.shared.container.viewContext
		let newPet = Pet(context: context)
		newPet.name = "Da Da"
		newPet.image = nil
		newPet.type = "dog"
		newPet.breed = "Maltese"
		newPet.isSelected = true
		newPet.birthday = Date()
		newPet.arriveDate = Date()
		return Group {
			AddJournalView(pet: newPet)
				.environment(\.managedObjectContext, context)
        .environment(\.locale, .init(identifier: "zh"))
			AddJournalView(pet: newPet)
				.preferredColorScheme(.dark)
				.environment(\.managedObjectContext, context)
		}
	}
}
