//
//  MainTabView.swift
//  PetLog
//
//  Created by Hao Qin on 5/3/21.
//

import SwiftUI

struct MainTabView: View {
	
	@Binding var currentPage: Int
	@Binding var addButtonsPresented: Bool
	
	let width = UIScreen.main.bounds.width / 5.5
	let height = UIScreen.main.bounds.height / 36
	
	var body: some View {
		HStack {
			TabBarItem(currentPage: $currentPage, assignedTab: 0, width: width, height: height, iconName: "house", tabName: "HOME")
			TabBarItem(currentPage: $currentPage, assignedTab: 1, width: width, height: height, iconName: "chart.pie", tabName: "RECORD")
			
			Rectangle()
				.opacity(0)
				.frame(width: UIScreen.main.bounds.width / 8)
			
			TabBarItem(currentPage: $currentPage, assignedTab: 2, width: width, height: height, iconName: "bell", tabName: "REMINDER")
			TabBarItem(currentPage: $currentPage, assignedTab: 3, width: width, height: height, iconName: "person", tabName: "MY PET")
		}
		.padding(.top, 15)
		.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 9)
		.background(Color.backgroundColor.shadow(radius: 4))
	}
}

struct MainTabView_Previews: PreviewProvider {
	static var previews: some View {
		MainTabView(currentPage: .constant(0), addButtonsPresented: .constant(false))
			.previewLayout(.fixed(width: 500, height: 500))
	}
}
