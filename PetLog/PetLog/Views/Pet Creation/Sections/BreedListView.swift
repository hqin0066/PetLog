//
//  BreedListView.swift
//  PetLog
//
//  Created by Hao Qin on 5/5/21.
//

import SwiftUI

struct BreedListView: View {
	
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	
	@Binding var petType: PetType
	@Binding var breed: String
	
	@State private var searchQuery = ""
	
	var allBreeds: [String] {
		switch petType {
		case .dog:
			return Dog().allBreeds.map { NSLocalizedString($0, comment: "") }
		case .cat:
			return Cat().allBreeds.map { NSLocalizedString($0, comment: "") }
		case .other:
			return OtherType().allbreeds.map { NSLocalizedString($0, comment: "") }
		case .none:
			return []
		}
	}
	
	var sortedList: [String] {
		let sortedList = allBreeds.sorted {
			$0.localizedStandardCompare($1) == .orderedAscending
		}
		switch petType {
		case .dog, .cat:
			var array = [NSLocalizedString("Mixed Breed", comment: "")]
			array.append(contentsOf: sortedList)
			return array
		case .other:
			var array = sortedList
			array.append(NSLocalizedString("Other", comment: ""))
			return array
		case .none:
			return []
		}
	}
	
	var filterdAndSortedList: [String] {
		return sortedList.filter {
			self.searchQuery.isEmpty ?
				true : $0.lowercased().contains(self.searchQuery.lowercased())
		}
	}
	
	var body: some View {
		VStack {
			SearchBar(text: $searchQuery, placeholderText: NSLocalizedString("Search By Breed", comment: ""))
				.padding(.horizontal)
			
			List {
				ForEach(filterdAndSortedList, id: \.self) { breed in
					Button {
						self.breed = breed
						presentationMode.wrappedValue.dismiss()
					} label: {
						Text(breed)
							.font(.title3)
							.foregroundColor(.textGray)
					}
				}
			}
		}
	}
}

struct BreedListView_Previews: PreviewProvider {
	static var previews: some View {
		BreedListView(petType: .constant(.dog), breed: .constant(""))
			.environment(\.locale, .init(identifier: "zh"))
		BreedListView(petType: .constant(.cat), breed: .constant(""))
		BreedListView(petType: .constant(.other), breed: .constant(""))
	}
}
