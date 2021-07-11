//
//  ExpenseNoteSectionView.swift
//  PetLog
//
//  Created by Hao Qin on 5/26/21.
//

import SwiftUI

struct ExpenseNoteSectionView: View {
	
	@Binding var note: String
	
	var body: some View {
		VStack {
			HStack {
				Image(systemName: "note.text")
					.foregroundColor(.pinkyOrange)
					.font(.title3)
				
				Text("Note")
					.foregroundColor(.textGray)
					.font(.headline)
				
				Spacer()
			}
			
			ZStack {
				RoundedRectangle(cornerRadius: 10)
					.foregroundColor(.systemWhite)
					.frame(height: 40)
				
				TextField("Add annotation", text: $note)
					.textFieldStyle(PlainTextFieldStyle())
					.font(.body)
					.padding(.horizontal)
			}
		}
	}
}

struct ExpenseNoteSectionView_Previews: PreviewProvider {
	static var previews: some View {
		ExpenseNoteSectionView(note: .constant(""))
	}
}
