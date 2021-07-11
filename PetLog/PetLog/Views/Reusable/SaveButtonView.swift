//
//  SaveButtonView.swift
//  PetLog
//
//  Created by Hao Qin on 5/9/21.
//

import SwiftUI

struct SaveButtonView: View {
	
	let isCompleted: Bool
	
	var body: some View {
		HStack {
			Image(systemName: "person")
				.opacity(0)
			
			ZStack {
				RoundedRectangle(cornerRadius: 10)
					.foregroundColor(.pinkyOrange)
					.overlay(Color.systemWhite.cornerRadius(10).opacity(isCompleted ? 0 : 0.5))
					.frame(width: 55, height: 25)
				
				Text("Save")
					.foregroundColor(.white)
					.font(.body)
					.bold()
			}
		}
	}
}

struct SaveButtonView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			SaveButtonView(isCompleted: false)
				.previewLayout(.fixed(width: 500, height: 100))
			SaveButtonView(isCompleted: false)
				.preferredColorScheme(.dark)
				.previewLayout(.fixed(width: 500, height: 100))
		}
	}
}
