//
//  UnusualFilterView.swift
//  PetLog
//
//  Created by Hao Qin on 6/9/21.
//

import SwiftUI

struct UnusualFilterView: View {
	@Environment(\.presentationMode) var presentationMode
	
	@Binding var unusualFilter: [String]
	
	var body: some View {
		VStack {
			ZStack {
				Text("Filters")
					.foregroundColor(.textGray)
					.font(.title3)
					.bold()
				
				HStack {
					Spacer()
					
					Button {
						self.presentationMode.wrappedValue.dismiss()
					} label: {
						Image(systemName: "checkmark.circle.fill")
							.font(.title)
							.foregroundColor(.pinkyOrange)
					}
				}
			}
			.padding(.vertical)
			
			UnusualFilterActivitySectionView(unusualFilter: $unusualFilter)
			
			Spacer()
		}
		.padding(.horizontal)
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
	}
}

struct UnusualFilterView_Previews: PreviewProvider {
	static var previews: some View {
		UnusualFilterView(unusualFilter: .constant([]))
	}
}

// MARK: - UnusualFilterActivitySectionView

struct UnusualFilterActivitySectionView: View {
	
	@Binding var unusualFilter: [String]
	
	var items: [GridItem] {
		Array(repeating: .init(.fixed(UIScreen.main.bounds.width/5 - 15)), count: 5)
	}
	
	var body: some View {
		LazyVGrid(columns: items, spacing: 5) {
			ForEach(UnusualCategory.allCases, id: \.self) { category in
				UnusualFilterCategoryCellView(unusualFilter: $unusualFilter, category: category)
			}
		}
		.padding(.top)
		.background(
			RoundedRectangle(cornerRadius: 15)
				.stroke(lineWidth: 0.5)
				.foregroundColor(.iconGray)
		)
	}
}

// MARK: - UnusualFilterActivityCellView

struct UnusualFilterCategoryCellView: View {
	
	@Binding var unusualFilter: [String]
	
	let category: UnusualCategory
	
	var isSelected: Bool {
		unusualFilter.contains(category.rawValue)
	}
	
	var body: some View {
		VStack {
			ZStack {
				Circle()
					.stroke()
					.frame(width: 50, height: 50)
					.foregroundColor(isSelected ? .clear : .iconGray)
				
				Circle()
					.frame(width: 50, height: 50)
					.foregroundColor(isSelected ? .pinkyOrange : .systemWhite)
				
        if isSelected {
          Image(category.whiteImageName)
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
        } else {
          Image(category.pinkyOrangeImageName)
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)  
        }
			}
			.animation(.easeIn(duration: 0.2))
			
			Text(LocalizedStringKey(category.rawValue))
				.font(.system(size: 11))
				.foregroundColor(.textGray)
				.lineLimit(nil)
				.multilineTextAlignment(.center)
			
			Spacer()
		}
		.frame(height: 100)
		.onTapGesture {
			if !isSelected {
				self.unusualFilter.append(category.rawValue)
			} else {
				if let index = self.unusualFilter.firstIndex(of: category.rawValue) {
					self.unusualFilter.remove(at: index)
				}
			}
		}
	}
}

