//
//  ActivityCellView.swift
//  PetLog
//
//  Created by Hao Qin on 5/18/21.
//

import SwiftUI

struct ActivityCellView: View {
	
	@Binding var selectedActivity: Activity?
	
	let activity: Activity
	
	var isSelected: Bool {
		activity == selectedActivity
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
				} else {
					Image(activity.pinkyOrangeImageName)
						.resizable()
						.scaledToFit()
						.frame(width: 35, height: 35)
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
			selectedActivity = activity
		}
	}
}

struct ActivityCellView_Previews: PreviewProvider {
	static var previews: some View {
		ActivityCellView(selectedActivity: .constant(.date), activity: .date)
			.previewLayout(.fixed(width: 100, height: 150))
	}
}
