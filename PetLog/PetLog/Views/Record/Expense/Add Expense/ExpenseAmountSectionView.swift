//
//  ExpenseAmountSectionView.swift
//  PetLog
//
//  Created by Hao Qin on 5/25/21.
//

import SwiftUI

struct ExpenseAmountSectionView: View {
	
	@Binding var showNumberPad: Bool
	
	let displayAmount: String
	
	var body: some View {
		VStack {
			HStack {
				Image(systemName: "dollarsign.circle.fill")
					.foregroundColor(.pinkyOrange)
					.font(.title3)
				
				Text("Amount")
					.foregroundColor(.textGray)
					.font(.headline)
				
				Spacer()
			}
			
			ZStack {
				RoundedRectangle(cornerRadius: 10)
					.foregroundColor(.systemWhite)
					.frame(height: 40)
				
				HStack {
					Text("$")
						.font(.title2)
						.bold()
						.foregroundColor(.pinkyOrange)
					
					Spacer()
					
					Text(displayAmount)
						.font(.title2)
						.bold()
						.foregroundColor(.pinkyOrange)
				}
				.padding(.horizontal)
			}
			.onTapGesture {
				self.showNumberPad.toggle()
        UIApplication.shared.hideKeyboard()
			}
		}
	}
}

struct ExpenseAmountSectionView_Previews: PreviewProvider {
	static var previews: some View {
		ExpenseAmountSectionView(showNumberPad: .constant(false), displayAmount: "0.00")
			.previewLayout(.fixed(width: 500, height: 100))
	}
}
