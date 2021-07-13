//
//  ExpenseGraphView.swift
//  PetLog
//
//  Created by Hao Qin on 5/27/21.
//

import SwiftUI

struct ExpenseGraphView: View {
	
	@Binding var animateChart: Bool
	
	let wedges: [CategoryWedge]
	let displayTotal: String
	
	var font: Font {
		let count = self.displayTotal.count
		if count < 9 {
			return .system(size: 20)
		} else {
      return .system(size: 15)
		}
	}
	
	var body: some View {
		ZStack {
			if wedges.count > 0 {
				ZStack {
					ForEach(0..<wedges.count, id: \.self) { index in
						let wedge = wedges[index]
						let lastDegree = wedges.prefix(index).map { $0.percent }.reduce(0, +)*360-90
						let currentEndDegree = wedge.percent*360
						WedgeShape(startAngle: Angle(degrees: lastDegree), endAngle: Angle(degrees: lastDegree+currentEndDegree))
							.fill(wedge.color)
					}
					
					Circle()
						.trim(from: self.animateChart ? 1 : 0)
						.stroke(Color.systemWhite, lineWidth: 100)
						.rotationEffect(Angle(degrees: -90))
				}
				.frame(width: UIScreen.main.bounds.width/2,
							 height: UIScreen.main.bounds.width/2)
			} else {
				Circle()
					.foregroundColor(.pinkyOrange)
					.frame(width: UIScreen.main.bounds.width/2,
								 height: UIScreen.main.bounds.width/2)
			}
			
			Circle()
				.frame(width: UIScreen.main.bounds.width/3,
							 height: UIScreen.main.bounds.width/3)
				.foregroundColor(.systemWhite)
			
			HStack(spacing: 1) {
				Text("$")
					.font(font)
					.bold()
					.foregroundColor(.pinkyOrange)
				
				Text(displayTotal)
					.font(font)
					.bold()
					.foregroundColor(.pinkyOrange)
			}
			.frame(maxWidth: UIScreen.main.bounds.width/3.5)
		}
		.padding()
	}
}

struct ExpenseGraphView_Previews: PreviewProvider {
    static var previews: some View {
			ExpenseGraphView(animateChart: .constant(false), wedges: [], displayTotal: "5,000.00")
				.previewLayout(.fixed(width: 300, height: 300))
    }
}
