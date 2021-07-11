//
//  TabBarAddButtonView.swift
//  PetLog
//
//  Created by Hao Qin on 6/16/21.
//

import SwiftUI

struct TabBarAddButtonView: View {
	
	@Binding var addButtonsPresented: Bool
	
	var body: some View {
		ZStack {
			Circle()
				.foregroundColor(.backgroundColor)
				.shadow(radius: 4)
			
			Image(systemName: "plus.circle.fill")
				.resizable()
				.scaledToFit()
				.foregroundColor(Color.pinkyOrange)
				.rotationEffect(.degrees(self.addButtonsPresented ? 45 : 0))
				.onTapGesture {
					withAnimation(.easeOut(duration: 0.2)) {
						self.addButtonsPresented.toggle()
					}
				}
		}
		.frame(width: UIScreen.main.bounds.width / 8,
					 height: UIScreen.main.bounds.width / 8)
	}
}

struct TabBarAddButtonView_Previews: PreviewProvider {
	static var previews: some View {
		TabBarAddButtonView(addButtonsPresented: .constant(false))
			.previewLayout(.fixed(width: 150, height: 150))
	}
}
