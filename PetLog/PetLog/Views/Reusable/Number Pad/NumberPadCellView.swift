//
//  NumberPadCellView.swift
//  PetLog
//
//  Created by Hao Qin on 5/26/21.
//

import SwiftUI

struct NumberPadCellView: View {
	
	let button: NumberPadButton
	
	var body: some View {
		switch button {
		case .space:
			RoundedRectangle(cornerRadius: 10)
				.frame(width: (UIScreen.main.bounds.width-4*15)/3,
							 height: 50)
				.opacity(0)
		case .delete:
			VStack {
				Image(systemName: "delete.left")
					.resizable()
					.scaledToFit()
					.foregroundColor(.pinkyOrange)
					.frame(width: 30, height: 30)
			}
			.frame(width: (UIScreen.main.bounds.width-4*15)/3,
						 height: 50)
			
		default:
			Text(button.rawValue)
				.font(.title)
				.bold()
				.foregroundColor(.textGray)
				.frame(width: (UIScreen.main.bounds.width-4*15)/3,
							 height: 50)
				.background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.iconGray))
		}
	}
}

struct NumberPadCellView_Previews: PreviewProvider {
	static var previews: some View {
		NumberPadCellView(button: .one)
	}
}
