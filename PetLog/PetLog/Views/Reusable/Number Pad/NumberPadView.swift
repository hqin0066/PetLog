//
//  NumberPadView.swift
//  PetLog
//
//  Created by Hao Qin on 5/26/21.
//

import SwiftUI

struct NumberPadView: View {
	
	@Binding var isShowing: Bool
	@Binding var amount: Double
	@Binding var enteredValue: Int
	
	private var items: [GridItem] {
		Array(repeating: .init(.fixed((UIScreen.main.bounds.width-4*15)/3)), count: 3)
	}
	
	var body: some View {
		VStack {
			Spacer()
			
			VStack {
				HStack {
					Spacer()
					
					Button("Complete") {
						self.isShowing.toggle()
					}
					.foregroundColor(.pinkyOrange)
				}
				
				Divider()
				
				LazyVGrid(columns: items, spacing: 15) {
					ForEach(NumberPadButton.allCases, id: \.self) { button in
						Button {
							onTap(button: button)
						} label: {
							NumberPadCellView(button: button)
						}
					}
				}
			}
			.padding()
			.padding(.bottom)
			.background(Color.systemWhite)
			.clipped()
			.offset(y: isShowing ? 0 : UIScreen.main.bounds.height)
		}
		.edgesIgnoringSafeArea(.all)
	}
	
	private func onTap(button: NumberPadButton) {
		switch button {
		case .space:
			break
		case .delete:
			amount = (amount*10).rounded(.down)/100
			enteredValue = enteredValue/10
		default:
			let input = Int(button.rawValue) ?? 0
			self.enteredValue = enteredValue*10 + input
			self.amount = Double(enteredValue/100) + Double(enteredValue%100)/100
		}
	}
}

struct NumberPadView_Previews: PreviewProvider {
	static var previews: some View {
		NumberPadView(isShowing: .constant(true), amount: .constant(0), enteredValue: .constant(0))
	}
}
