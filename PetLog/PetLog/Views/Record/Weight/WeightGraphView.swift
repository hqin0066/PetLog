//
//  WeightGraphView.swift
//  PetLog
//
//  Created by Hao Qin on 6/1/21.
//

import SwiftUI

struct WeightGraphView: View {
	
	@Binding var animateChart: Bool
	
	let weightData: [WeightData]
	let inPound: Bool
	
	private var weights: [Double] {
		if inPound {
			return weightData.map { $0.weight * 2.205 }
		} else {
			return weightData.map { $0.weight }
		}
	}
  
  private var dataPoints: [CGFloat] {
    if let min = self.weights.min(),
       let max = self.weights.max(),
       min != max {
      return self.weights.map {
        CGFloat(($0 - min) / (max - min) * 0.8)
      }
    } else if let min = self.weights.min(),
              let max = self.weights.max(),
              min == max {
      return self.weights.map { CGFloat($0 * 0) }
    }
    return []
	}
	
	private var yValues: [String] {
		var strings: [String] = []
		if let min = self.weights.min(),
			 let max = self.weights.max() {
			for i in 0..<6 {
				let maxValue = max + (max - min) / 4
				let value = maxValue - Double(i) * ((max - min) / 4)
				if self.inPound {
					strings.append(NumberFormatter.oneDecimalFormatter.string(from: NSNumber(value: value)) ?? "0.0")
				} else {
					strings.append(NumberFormatter.decimalFormatter.string(from: NSNumber(value: value)) ?? "0.00")
				}
			}
			return strings
		}
		return []
	}
	
	private var pointValueOffset: CGFloat {
		return -UIScreen.main.bounds.width / 15.6
	}
	
	private var xValueOffset: CGFloat {
		return -UIScreen.main.bounds.width / 16.5
	}
	
	private var xValue: [String] {
		var strings: [String] = []
		let dates = weightData.compactMap { $0.date }
		for date in dates {
			strings.append(date.getShortDateWithoutYearString())
		}
		return strings
	}
	
	var body: some View {
		HStack(alignment: .center, spacing: 10) {
			VStack(alignment: .trailing, spacing: .zero) {
				ForEach(yValues, id: \.self) { value in
					HStack(spacing: .zero) {
						Text(value)
							.font(.caption)
							.foregroundColor(.textGray)
						
						Text(inPound ? "lb" : "kg")
							.font(.caption)
							.foregroundColor(.textGray)
					}
					.frame(height: UIScreen.main.bounds.width / 13, alignment: .top)
					
				}
			}
			
			ScrollViewReader { scrollView in
				ScrollView(.horizontal, showsIndicators: false) {
					VStack(alignment: .leading) {
						ZStack(alignment: .topLeading) {
							Line(count: 6)
								.stroke(Color.iconGray ,style: StrokeStyle(lineWidth: 1, dash: [5]))
								.frame(minWidth: UIScreen.main.bounds.width / 1.4)
							
							LineGraph(dataPoint: dataPoints)
								.trim(to: self.animateChart ? 1 : 0)
								.stroke(Color.pinkyOrange, lineWidth: 3)
							
							LineGraphPointStroke(dataPoint: dataPoints)
								.fill(Color.pinkyOrange)
							
							LineGraphPoint(dataPoint: dataPoints)
								.fill(Color.systemWhite)
							
							HStack(spacing: .zero) {
								ForEach(weights, id: \.self) { weight in
									Text(self.getDisplayWeight(value: weight))
										.bold()
										.font(.footnote)
										.foregroundColor(.textGray)
										.frame(width: UIScreen.main.bounds.width / 8, alignment: .center)
										.offset(x: self.pointValueOffset, y: self.getPointValueOffset(value: weight))
								}
							}
						}
						.frame(height: UIScreen.main.bounds.width / 2.6)
						.padding(.top, 15)
						
						HStack(spacing: .zero) {
							ForEach(xValue, id: \.self) { value in
								Text(value)
									.font(.caption)
									.foregroundColor(.textGray)
									.frame(width: UIScreen.main.bounds.width / 8, alignment: .center)
									.id(value)
									.offset(x: self.xValueOffset)
							}
						}
						.padding(.top, 5)
					}
					.padding(.leading, 20)
				}
				.onAppear(perform: {
					scrollView.scrollTo(xValue.last)
				})
			}
		}
		.frame(height: UIScreen.main.bounds.width / 2)
		.padding(.leading)
		.padding(.vertical)
	}
	
	private func getDisplayWeight(value: Double) -> String {
		if self.inPound {
			return NumberFormatter.oneDecimalFormatter.string(from: NSNumber(value: value)) ?? "0.0"
		} else {
			return NumberFormatter.decimalFormatter.string(from: NSNumber(value: value)) ?? "0.00"
		}
	}
	
	private func getPointValueOffset(value: Double) -> CGFloat {
		var normalizedValue: CGFloat {
			if let min = self.weights.min(),
				 let max = self.weights.max(),
         min != max {
				return CGFloat((value - min) / (max - min) * 0.8 + 0.15)
			}
			return 0.15
		}
    
		return (1 - normalizedValue) * (UIScreen.main.bounds.width / 2.6)
	}
}

struct WeightGraphView_Previews: PreviewProvider {
	static var previews: some View {
    WeightGraphView(animateChart: .constant(true), weightData: [], inPound: false)
      .previewLayout(.sizeThatFits)
	}
}
