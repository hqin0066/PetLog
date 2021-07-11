//
//  JournalView.swift
//  PetLog
//
//  Created by Hao Qin on 5/4/21.
//

import SwiftUI

struct JournalDetailView: View {
	
	@Binding var fullScreenImagePresented: Bool
	@Binding var imageToPresent: UIImage?
	@Binding var showActionSheet: Bool
	@Binding var journalToEdit: Journal?
	
	@ObservedObject var journal: Journal
	
	var displayDate: LocalizedStringKey {
		guard let journalDate = journal.date else { return "" }
		let dateString = journalDate.getDateWithoutYearString()
		let date = Calendar.current.dateComponents([.day, .month, .year], from: self.journal.date!)
		let todaysDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
		let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
		let yesterdaysDate = Calendar.current.dateComponents([.day, .month, .year], from: yesterday!)
		if date == todaysDate {
			return "Today, \(dateString)"
		} else if date == yesterdaysDate {
			return "Yesterday, \(dateString)"
		}
		return "\(journalDate.getDateWithWeekdayString())"
	}
	
	var imageName: String {
		if let activity = journal.activity?.getActivity() {
			return activity.pinkyOrangeImageName
		}
		return "DatePinkyOrange"
	}
	
	var displayImage: UIImage? {
		if let data = journal.image?.image {
			return UIImage(data: data)
		}
		return nil
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 5) {
			HStack {
				Text(displayDate)
					.font(.subheadline)
					.foregroundColor(.textGray)
				
				Spacer()
				
				Button {
					self.journalToEdit = self.journal
					self.showActionSheet.toggle()
				} label: {
					Image(systemName: "chevron.down.circle")
						.font(.title2)
						.foregroundColor(.iconGray)
				}
			}
			
			HStack(alignment: .center) {					
				Image(imageName)
					.resizable()
					.scaledToFit()
					.foregroundColor(.pinkyOrange)
					.frame(width: 30, height: 30)
				
				HStack(alignment: .lastTextBaseline, spacing: 5) {
					Text(LocalizedStringKey(journal.activity ?? ""))
						.font(.title2)
						.bold()
						.foregroundColor(Color.pinkyOrange)
					
					if let journalDate = journal.date {
						Text(journalDate.getTimeString())
							.font(.subheadline)
							.foregroundColor(.textGray)
					}
				}
			}
			
			if let title = journal.title,
				!title.isEmpty {
				Text(title)
					.font(.title3)
					.bold()
					.foregroundColor(.textGray)
					.padding(.vertical, 3)
			}
			
			if let note = journal.note,
				!note.isEmpty {
				Text(note)
					.font(.body)
					.foregroundColor(.textGray)
					.lineLimit(nil)
			}
			
			if let uiImage = displayImage {
				Image(uiImage: uiImage)
					.resizable()
					.scaledToFill()
					.frame(maxHeight: UIScreen.main.bounds.width - 60)
					.cornerRadius(10)
					.padding(.top, 15)
					.contentShape(Rectangle())
					.onTapGesture {
						self.imageToPresent = uiImage
						withAnimation {
							self.fullScreenImagePresented.toggle()
						}
					}
			}
			
		}
		.padding()
		.background(Color.systemWhite.cornerRadius(10).shadow(radius: 4))
	}
}

struct JournalDetailView_Previews: PreviewProvider {
	static var previews: some View {
		let context = Persistence.shared.container.viewContext
		let newJournal = Journal(context: context)
		newJournal.date = Date()
		newJournal.activity = "Meet Friends"
		newJournal.note = "This is note text."
		newJournal.title = "Title"
		return JournalDetailView(fullScreenImagePresented: .constant(false), imageToPresent: .constant(nil), showActionSheet: .constant(false), journalToEdit: .constant(nil), journal: newJournal)
			.environment(\.managedObjectContext, context)
			.previewLayout(.fixed(width: 500, height: 300))
	}
}
