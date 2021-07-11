//
//  Wedge.swift
//  PetLog
//
//  Created by Hao Qin on 5/27/21.
//

import SwiftUI

struct WedgeShape: Shape {
	var startAngle: Angle
	var endAngle: Angle
	
	func path(in rect: CGRect) -> Path {
		var path = Path()
		
		path.move(to: CGPoint(x: rect.size.width/2, y: rect.size.width/2))
		path.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/2),
								radius: rect.size.width/2,
								startAngle: startAngle,
								endAngle: endAngle,
								clockwise: false)
		path.closeSubpath()
		return path
	}
}

struct CategoryWedge {
	let category: ExpenseCategory
	let percent: Double
	let color: Color
}
