//
//  UnusualPageTopButtonsView.swift
//  PetLog
//
//  Created by Hao Qin on 6/8/21.
//

import SwiftUI

struct UnusualPageTopButtonsView: View {
	
	@Binding var selectedYear: Date
	@Binding var showAddUnusualSheet: Bool
	@Binding var showUnusualFilterSheet: Bool
	@Binding var unusualCategoryFilter: [String]
	
	var body: some View {
		HStack {
			Button {
				self.showUnusualFilterSheet.toggle()
			} label: {
        Image(self.unusualCategoryFilter.isEmpty ? "FilterPinkyOrange" : "FilterPinkyOrangeFill")
          .resizable()
          .scaledToFit()
          .frame(width: 20, height: 20)
			}
			
			Spacer()
			
			Button{
				self.selectedYear = self.selectedYear.backOneYear()
			} label: {
				Image(systemName: "chevron.backward")
					.font(.body)
					.foregroundColor(Color.pinkyOrange)
			}
			
			Text(selectedYear.getYearString())
				.font(.title3)
				.bold()
				.foregroundColor(Color.textGray)
				.padding(.horizontal)
				.frame(minWidth: 110)
			
			Button{
				self.selectedYear = self.selectedYear.forwardOneYear()
			} label: {
				Image(systemName: "chevron.forward")
					.font(.body)
					.foregroundColor(Color.pinkyOrange)
			}
			
			Spacer()
			
			Button {
				self.showAddUnusualSheet.toggle()
			} label: {
				Image(systemName: "plus.circle.fill")
					.font(.title2)
					.foregroundColor(.pinkyOrange)
			}
		}
		.padding(.horizontal)
		.frame(height: 50)
	}
}

struct UnusualPageTopButtonsView_Previews: PreviewProvider {
	static var previews: some View {
		UnusualPageTopButtonsView(selectedYear: .constant(Date()), showAddUnusualSheet: .constant(false), showUnusualFilterSheet: .constant(false), unusualCategoryFilter: .constant([]))
      .previewLayout(.sizeThatFits)
	}
}
