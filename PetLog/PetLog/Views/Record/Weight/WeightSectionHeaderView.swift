//
//  WeightSectionHeaderView.swift
//  PetLog
//
//  Created by Hao Qin on 6/2/21.
//

import SwiftUI

struct WeightSectionHeaderView: View {
	@Environment(\.managedObjectContext) var viewContext
	
	@Binding var showAddWeightSheet: Bool
	
	let weightUnit: WeightUnit?
	
	@State private var inPound: Bool
	
	init(showAddWeightSheet: Binding<Bool>, weightUnit: WeightUnit?) {
		_showAddWeightSheet = showAddWeightSheet
		self.weightUnit = weightUnit
		
		if let weightUnit = weightUnit {
			_inPound = State(wrappedValue: weightUnit.inPound)
		} else {
			inPound = false
		}
	}
	
	var body: some View {
		ZStack {
			VStack(spacing: -20) {
				Rectangle()
					.fill(Color.backgroundColor)
					.cornerRadius(20)
					.frame(height: 40)
				
				Rectangle()
					.fill(Color.backgroundColor)
					.frame(height: 30)
			}
			.background(Color.systemWhite)
			
			HStack {
				HStack(spacing: .zero) {
					Text("kg")
						.font(.footnote)
						.fontWeight(inPound ? .regular : .bold)
						.foregroundColor(inPound ? .pinkyOrange : .white)
						.frame(width: 40, height: 20)
						.background(Color.pinkyOrange.cornerRadius(10).opacity(inPound ? 0 : 1))
						.onTapGesture {
							self.changeToKg()
						}
					
					Text("lb")
						.font(.footnote)
						.fontWeight(inPound ? .bold : .regular)
						.foregroundColor(inPound ? .white : .pinkyOrange)
						.frame(width: 40, height: 20)
						.background(Color.pinkyOrange.cornerRadius(10).opacity(inPound ? 1 : 0))
						.onTapGesture {
							self.changeToLb()
						}
				}
				.background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1.5).foregroundColor(.pinkyOrange))
				
				Spacer()
				
				Button{
					self.showAddWeightSheet.toggle()
				} label: {
					Image(systemName: "plus.circle.fill")
						.font(.title2)
						.foregroundColor(Color.pinkyOrange)
				}
			}
			.padding(.horizontal)
		}
		.frame(height: 50)
	}
	
	private func changeToKg() {
		if let weightUnit = self.weightUnit {
			weightUnit.inPound = false
			Persistence.shared.saveContext(with: viewContext) { _ in
				withAnimation {
					self.inPound = false
				}
			}
		} else {
			Persistence.shared.createWeightUnitWith(
				inPound: false,
				using: viewContext,
				completion: { _ in
				withAnimation {
					self.inPound = false
				}
			})
		}
	}
	
	func changeToLb() {
		if let weightUnit = self.weightUnit {
			weightUnit.inPound = true
			Persistence.shared.saveContext(with: viewContext) { _ in
				withAnimation {
					self.inPound = true
				}
			}
		} else {
			Persistence.shared.createWeightUnitWith(
				inPound: true,
				using: viewContext,
				completion: { _ in
				withAnimation {
					self.inPound = true
				}
			})
		}
	}
}

struct WeightSectionHeaderView_Previews: PreviewProvider {
	static var previews: some View {
		WeightSectionHeaderView(showAddWeightSheet: .constant(false), weightUnit: nil)
	}
}
