//
//  EditJournalView.swift
//  PetLog
//
//  Created by Hao Qin on 5/23/21.
//

import SwiftUI
import PhotosUI

struct EditJournalView: View {
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var viewContext
	
	let journal: Journal
	
	@State private var date: Date
	@State private var showDatePicker = false
	@State private var selectedDate: Date
	
	@State private var selectedActivity: Activity?
	
	@State private var note: String
	@State private var title: String
	@State private var showFullEditor = false
	
	@State private var imageData: Data?
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
	
	// MARK: - Init
	
	init(journal: Journal) {
		self.journal = journal
		
		guard let date = journal.date,
					let selectedActivity = journal.activity?.getActivity(),
					let title = journal.title,
					let note = journal.note else {
			_date = State(wrappedValue: Date())
			_selectedDate = _date
			_selectedActivity = State(wrappedValue: .meetFriends)
			_title = State(wrappedValue: "")
			_note = State(wrappedValue: "")
			return
		}
		
		_date = State(wrappedValue: date)
		_selectedDate = _date
		_selectedActivity = State(wrappedValue: selectedActivity)
		_title = State(wrappedValue: title)
		_note = State(wrappedValue: note)
		_imageData = State(wrappedValue: journal.image?.image)
	}
	
	var body: some View {
		ZStack {
			ScrollView(showsIndicators: false) {
				VStack(spacing: 20) {
					JournalDateSectionView(date: $date, showDatePicker: $showDatePicker)
						.padding(.top)
						.alert(isPresented: $showSaveAlert, content: {
							Alert(title: Text("Something Went Wrong"),
										message: Text("Please try again later."),
										dismissButton: .cancel(Text("OK")))
						})
					
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
			.padding(.horizontal)
			.ignoresSafeArea(.container, edges: .bottom)
			.onTapGesture {
				UIApplication.shared.hideKeyboard()
			}
			
			DatePickerView(date: $date, didSelectDate: .constant(true), isShowing: $showDatePicker, selectedDate: $selectedDate, shouldShowTime: true)
				.animation(.default)
		}
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Edit Journal")
		.navigationBarBackButtonHidden(true)
		.toolbar {
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
			
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					self.save()
				} label: {
					SaveButtonView(isCompleted: true)
				}
			}
		}
	}
	
	private func save() {
		self.journal.date = self.date
		self.journal.activity = self.selectedActivity!.rawValue
		self.journal.title = self.title
		self.journal.note = self.note
		
		if let data = self.imageData {
			if let storedImage = self.journal.image {
				storedImage.image = data
			} else {
				let journalImage = JournalImage(context: self.viewContext)
				journalImage.image = data
				journalImage.journal = self.journal
			}
		} else {
			if let storedImage = self.journal.image {
				self.viewContext.delete(storedImage)
			}
		}
		
		Persistence.shared.saveContext(with: viewContext) { success in
			guard success else {
				self.showSaveAlert.toggle()
				return
			}
			self.presentationMode.wrappedValue.dismiss()
		}
	}
}

struct EditJournalView_Previews: PreviewProvider {
	static var previews: some View {
		let context = Persistence.shared.container.viewContext
		let newJournal = Journal(context: context)
		newJournal.date = Date()
		newJournal.activity = "Meet Friends"
		newJournal.note = "This is note text."
		newJournal.title = "Title"
		return EditJournalView(journal: newJournal)
			.environment(\.managedObjectContext, context)
	}
}
