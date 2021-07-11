//
//  ActivitySectionView.swift
//  PetLog
//
//  Created by Hao Qin on 5/5/21.
//

import SwiftUI

struct ActivitySectionView: View {
	
	@Binding var selectedActivity: Activity?
	
	var items: [GridItem] {
		Array(repeating: .init(.fixed(UIScreen.main.bounds.width/5-15)), count: 5)
	}
	
	var body: some View {
		LazyVGrid(columns: items, spacing: 5) {
			ForEach(Activity.allCases, id: \.self) { activity in
				ActivityCellView(selectedActivity: $selectedActivity, activity: activity)
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

struct ActivitySectionView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ActivitySectionView(selectedActivity: .constant(.date))
				.previewLayout(.fixed(width: 400, height: 450))
			ActivitySectionView(selectedActivity: .constant(.date))
				.preferredColorScheme(.dark)
				.previewLayout(.fixed(width: 400, height: 450))
		}
	}
}
