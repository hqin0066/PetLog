//
//  TabBarSubButtonView.swift
//  PetLog
//
//  Created by Hao Qin on 6/16/21.
//

import SwiftUI

struct TabBarSubButtonView: View {
	
	let imageName: String
	let text: LocalizedStringKey
	
	var body: some View {
		VStack {
			ZStack {
				Circle()
					.foregroundColor(.pinkyOrange)
					.frame(width: UIScreen.main.bounds.width / 10,
								 height: UIScreen.main.bounds.width / 10)
					.shadow(radius: 4)
				Image(systemName: imageName)
					.resizable()
					.scaledToFit()
					.foregroundColor(.white)
					.frame(width: UIScreen.main.bounds.width / 18,
								 height: UIScreen.main.bounds.width / 18)
			}
			
			Text(text)
				.font(.system(size: 13))
				.bold()
				.multilineTextAlignment(.center)
				.foregroundColor(.white)
				.frame(width: UIScreen.main.bounds.width / 6)
		}
	}
}

struct TabBarSubButtonView_Previews: PreviewProvider {
	static var previews: some View {
		TabBarSubButtonView(imageName: "note.text", text: "Write Journal")
			.background(Color.black.opacity(0.4))
			.previewLayout(.fixed(width: 100, height: 100))
	}
}
