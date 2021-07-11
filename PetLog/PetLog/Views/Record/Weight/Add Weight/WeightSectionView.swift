//
//  WeightSectionView.swift
//  PetLog
//
//  Created by Hao Qin on 6/3/21.
//

import SwiftUI

struct WeightSectionView: View {
	
	@Binding var weight: String
	
	let inPound: Bool
	
	var placeHolder: LocalizedStringKey {
		if inPound {
			return "0.0"
		}
		return "0.00"
	}
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Image(systemName: "scalemass.fill")
					.foregroundColor(.pinkyOrange)
					.font(.title3)
				
				Text("Weight")
					.foregroundColor(.textGray)
					.font(.headline)
			}
			
			ZStack {
				RoundedRectangle(cornerRadius: 10)
					.foregroundColor(.systemWhite)
					.frame(height: 40)
				
				HStack {
					TextField(placeHolder, text: $weight)
						.font(.title2.bold())
						.foregroundColor(.pinkyOrange)
						.keyboardType(.decimalPad)
					
					Text(inPound ? "lb" : "kg")
						.font(.title2)
						.bold()
						.foregroundColor(.pinkyOrange)
				}
				.padding(.horizontal)
			}
		}
	}
}

struct WeightSectionView_Previews: PreviewProvider {
	static var previews: some View {
		WeightSectionView(weight: .constant(""), inPound: true)
			.previewLayout(.fixed(width: 500, height: 100))
	}
}
