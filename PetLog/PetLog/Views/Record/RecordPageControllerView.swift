//
//  RecordPageControllerView.swift
//  PetLog
//
//  Created by Hao Qin on 5/24/21.
//

import SwiftUI

struct RecordPageControllerView: View {
	
	@Binding var currentPage: Int
	
	var body: some View {
		HStack(alignment: .bottom, spacing: 18) {
			Text("Expenses")
				.foregroundColor(self.currentPage == 0 ? .pinkyOrange : .textGray)
				.bold()
				.font(.subheadline)
				.scaleEffect(self.currentPage == 0 ? 1.2 : 1, anchor: .center)
				.padding(.leading, 5)
				.onTapGesture {
					self.currentPage = 0
				}
			
			
			Text("Weight")
				.foregroundColor(self.currentPage == 1 ? .pinkyOrange : .textGray)
				.bold()
				.font(.subheadline)
				.scaleEffect(self.currentPage == 1 ? 1.2 : 1, anchor: .center)
				.onTapGesture {
					self.currentPage = 1
				}
			
			Text("Unusual")
				.foregroundColor(self.currentPage == 2 ? .pinkyOrange : .textGray)
				.bold()
				.font(.subheadline)
				.scaleEffect(self.currentPage == 2 ? 1.2 : 1, anchor: .center)
				.onTapGesture {
					self.currentPage = 2
				}
			
			Spacer()
			
			//				Text("Medical")
			//					.foregroundColor(self.currentPage == 3 ? .pinkyOrange : .textGray)
			//					.bold()
			//					.font(.subheadline)
			//					.lineLimit(1)
			//					.scaleEffect(self.currentPage == 3 ? 1.2 : 1, anchor: .center)
			//					.onTapGesture {
			//						self.currentPage = 3
			//					}
		}
		.padding(.horizontal)
		.padding(.top)
		.animation(.linear(duration: 0.08))
	}
}

struct RecordPageControllerView_Previews: PreviewProvider {
	static var previews: some View {
		RecordPageControllerView(currentPage: .constant(0))
			.previewLayout(.fixed(width: 500, height: 50))
	}
}
