//
//  SearchBar.swift
//  PetLog
//
//  Created by Hao Qin on 5/6/21.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
	
	@Binding var text: String
	
	let placeholderText: String
	
	class Coordinator: NSObject, UISearchBarDelegate {
		
		@Binding var text: String
		
		init(text: Binding<String>) {
			_text = text
		}
		
		func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
			text = searchText
		}
		
		func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
			searchBar.resignFirstResponder()
		}
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(text: $text)
	}
	
	func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
		let searchBar = UISearchBar(frame: .zero)
		searchBar.delegate = context.coordinator
		searchBar.placeholder = placeholderText
		
		return searchBar
	}
	
	func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
		uiView.text = text
	}
}

struct SearchBar_Previews: PreviewProvider {
	static var previews: some View {
		SearchBar(text: .constant(""), placeholderText: "Search...")
			.previewLayout(.fixed(width: 500, height: 100))
	}
}
