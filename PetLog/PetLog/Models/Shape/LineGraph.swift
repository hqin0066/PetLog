//
//  LineGraph.swift
//  PetLog
//
//  Created by Hao Qin on 6/4/21.
//

import SwiftUI

struct WeightData {
	let date: Date
	let weight: Double
}

struct LineGraph: Shape {
	var dataPoint: [CGFloat]
	
	func path(in rect: CGRect) -> Path {
		func point(at index: Int) -> CGPoint {
			let point = dataPoint[index]
			let x = UIScreen.main.bounds.width / 8 * CGFloat(index)
			let y = (1 - point) * rect.height
			
			return CGPoint(x: x, y: y)
		}
		
		func control1(at index: Int) -> CGPoint {
			let point = dataPoint[index]
			let previewsPoint = dataPoint[index - 1]
			let midY = (point - previewsPoint) * rect.height
			let x = UIScreen.main.bounds.width / 8 * CGFloat(index) - (UIScreen.main.bounds.width / 8)/2
			let y = (1 - point) * rect.height + midY
			
			return CGPoint(x: x, y: y)
		}
		
		func control2(at index: Int) -> CGPoint {
			let point = dataPoint[index]
			let x = UIScreen.main.bounds.width / 8 * CGFloat(index) - (UIScreen.main.bounds.width / 8)/2
			let y = (1 - point) * rect.height
			
			return CGPoint(x: x, y: y)
		}
		
		var path = Path()
		
		guard dataPoint.count > 1 else { return Path()}
		let startPoint = dataPoint[0]
		path.move(to: CGPoint(x: 0, y: (1 - startPoint) * rect.height))
		
		for index in dataPoint.indices.dropFirst() {
			path.addCurve(to: point(at: index), control1: control1(at: index), control2: control2(at: index))
		}
		
		return path
	}
}

struct LineGraphPoint: Shape {
	var dataPoint: [CGFloat]
	
	func path(in rect: CGRect) -> Path {
		func point(at index: Int) -> CGPoint {
			let point = dataPoint[index]
			let x = UIScreen.main.bounds.width / 8 * CGFloat(index)
			let y = (1 - point) * rect.height
			return CGPoint(x: x, y: y)
		}
		
		var path = Path()
		
		guard dataPoint.count > 0 else { return Path()}

		for index in dataPoint.indices {
			path.move(to: point(at: index))
			path.addArc(center: point(at: index),
									radius: 4.5,
									startAngle: Angle(degrees: 0),
									endAngle: Angle(degrees: 360),
									clockwise: false)
		}
		
		return path
	}
}

struct LineGraphPointStroke: Shape {
	var dataPoint: [CGFloat]
	
	func path(in rect: CGRect) -> Path {
		func point(at index: Int) -> CGPoint {
			let point = dataPoint[index]
			let x = UIScreen.main.bounds.width / 8 * CGFloat(index)
			let y = (1 - point) * rect.height
			return CGPoint(x: x, y: y)
		}
		
		var path = Path()
		
		guard dataPoint.count > 0 else { return Path()}

		for index in dataPoint.indices {
			path.move(to: point(at: index))
			path.addArc(center: point(at: index),
									radius: 7,
									startAngle: Angle(degrees: 0),
									endAngle: Angle(degrees: 360),
									clockwise: false)
		}
		
		return path
	}
}

struct Line: Shape {
	var count: Int
	
	func path(in rect: CGRect) -> Path {
		var path = Path()
		
		for i in 0..<count {
			path.move(to: CGPoint(x: 0, y: rect.height/CGFloat(count-1) * CGFloat(i)))
			path.addLine(to: CGPoint(x: rect.width, y: rect.height/CGFloat(count-1) * CGFloat(i)))
		}
		
		return path
	}
}
