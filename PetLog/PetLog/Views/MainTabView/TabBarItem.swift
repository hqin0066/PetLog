//
//  TabBarItem.swift
//  PetLog
//
//  Created by Hao Qin on 5/3/21.
//

import SwiftUI

struct TabBarItem: View {
	
	@Binding var currentPage: Int
	
	let assignedTab: Int
	let width, height: CGFloat
	let iconName: String
	let tabName: String
	
	var body: some View {
		VStack {
			Image(systemName: "\(iconName)")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: width, height: height)
				.foregroundColor(self.currentPage == assignedTab ? Color("PinkyOrange") : Color("Gray"))
			
			Text(LocalizedStringKey(tabName))
				.font(.caption2)
				.foregroundColor(self.currentPage == assignedTab ? Color.pinkyOrange : Color.textGray)
			
			Spacer()
		}
		.onTapGesture {
			self.currentPage = self.assignedTab
		}
	}
}

struct TabBarItem_Previews: PreviewProvider {
	static var previews: some View {
		let width = UIScreen.main.bounds.width / 5.5
		let height = UIScreen.main.bounds.height / 34
		
		TabBarItem(currentPage: .constant(0), assignedTab: 0, width: width, height: height, iconName: "house", tabName: "HOME")
			.previewLayout(.fixed(width: 100, height: 100))
	}
}
