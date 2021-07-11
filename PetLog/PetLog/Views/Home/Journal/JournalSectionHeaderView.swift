//
//  JournalSectionHeaderView.swift
//  PetLog
//
//  Created by Hao Qin on 5/4/21.
//

import SwiftUI

struct JournalSectionHeaderView: View {
	
	@Binding var selectedMonth: Date
	@Binding var activityFilter: [String]
	@Binding var showAddJournalSheet: Bool
	@Binding var showJournalFilterSheet: Bool
	
	var body: some View {
		ZStack {
			VStack(spacing: -20) {
				Rectangle()
					.fill(Color.systemWhite)
					.cornerRadius(20)
					.frame(height: 40)
							
				Rectangle()
					.fill(Color.systemWhite)
					.frame(height: 30)
			}
			.background(Color("GradientEnd"))
			
			HStack {
				Button{
					self.showJournalFilterSheet.toggle()
				} label: {
					Image(self.activityFilter.isEmpty ? "FilterPinkyOrange" : "FilterPinkyOrangeFill")
						.resizable()
						.scaledToFit()
						.frame(width: 20, height: 20)
				}
				
				Spacer()
				
				Button{
					self.selectedMonth = selectedMonth.backOneMonth()
				} label: {
					Image(systemName: "chevron.backward")
						.font(.body)
						.foregroundColor(Color.pinkyOrange)
				}
				
				Text(selectedMonth.getMonthString())
					.font(.title3)
					.bold()
					.foregroundColor(Color.textGray)
					.padding(.horizontal)
					.frame(minWidth: 140)
				
				Button{
					self.selectedMonth = selectedMonth.forwardOneMonth()
				} label: {
					Image(systemName: "chevron.forward")
						.font(.body)
						.foregroundColor(Color.pinkyOrange)
				}
				
				Spacer()
				
				Button{
					self.showAddJournalSheet.toggle()
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
}

struct JournalSectionHeaderView_Previews: PreviewProvider {
	static var previews: some View {
		JournalSectionHeaderView(selectedMonth: .constant(Date()), activityFilter: .constant([]), showAddJournalSheet: .constant(false), showJournalFilterSheet: .constant(false))
			.previewLayout(.fixed(width: 500, height: 200))
	}
}
