//
//  JournalFilterView.swift
//  PetLog
//
//  Created by Hao Qin on 5/21/21.
//

import SwiftUI

struct JournalFilterView: View {
	@Environment(\.presentationMode) var presentationMode
	
	@Binding var activityFilter: [String]
	
	var body: some View {
		VStack {
			ZStack {
				Text("Filters")
					.foregroundColor(.textGray)
					.font(.title3)
					.bold()
				
				HStack {
					Spacer()
					
					Button {
						self.presentationMode.wrappedValue.dismiss()
					} label: {
						Image(systemName: "checkmark.circle.fill")
							.font(.title)
							.foregroundColor(.pinkyOrange)
					}
				}
			}
			.padding(.vertical)
			
			JournalFilterActivitySectionView(activityFilter: $activityFilter)
			
			Spacer()
		}
		.padding(.horizontal)
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
	}
}

struct JournalFilterView_Previews: PreviewProvider {
	static var previews: some View {
		JournalFilterView(activityFilter: .constant([]))
	}
}

// MARK: - JournalFilterActivitySectionView

struct JournalFilterActivitySectionView: View {
	
	@Binding var activityFilter: [String]
	
	var items: [GridItem] {
		Array(repeating: .init(.fixed(UIScreen.main.bounds.width/5-15)), count: 5)
	}
	
	var body: some View {
		LazyVGrid(columns: items, spacing: 5) {
			ForEach(Activity.allCases, id: \.self) { activity in
				JournalFilterActivityCellView(activityFilter: $activityFilter, activity: activity)
			}
		}
		.padding(.top)
		.background(
			RoundedRectangle(cornerRadius: 15)
				.stroke(lineWidth: 0.5)
				.foregroundColor(.iconGray)
		)
	}
}

// MARK: - JournalFilterActivityCellView

struct JournalFilterActivityCellView: View {
	
	@Binding var activityFilter: [String]
	
	let activity: Activity
	
	var isSelected: Bool {
		activityFilter.contains(activity.rawValue)
	}
	
	var body: some View {
		VStack {
			ZStack {
				Circle()
					.stroke()
					.frame(width: 50, height: 50)
					.foregroundColor(isSelected ? .clear : .iconGray)
				
				Circle()
					.frame(width: 50, height: 50)
					.foregroundColor(isSelected ? .pinkyOrange : .systemWhite)
				
				if isSelected {
					Image(activity.whiteImageName)
						.resizable()
						.scaledToFit()
						.frame(width: 35, height: 35)
						.foregroundColor(isSelected ? .white : .pinkyOrange)
				} else {
					Image(activity.pinkyOrangeImageName)
						.resizable()
						.scaledToFit()
						.frame(width: 35, height: 35)
						.foregroundColor(isSelected ? .white : .pinkyOrange)
				}
			}
			.animation(.easeIn(duration: 0.2))
			
			Text(LocalizedStringKey(activity.rawValue))
				.font(.system(size: 12))
				.foregroundColor(.textGray)
				.lineLimit(nil)
				.multilineTextAlignment(.center)
			
			Spacer()
		}
		.frame(height: 100)
		.onTapGesture {
			if !isSelected {
				self.activityFilter.append(activity.rawValue)
			} else {
				if let index = self.activityFilter.firstIndex(of: activity.rawValue) {
					self.activityFilter.remove(at: index)
				}
			}
		}
	}
}
