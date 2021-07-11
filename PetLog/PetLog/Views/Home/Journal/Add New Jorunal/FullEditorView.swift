//
//  FullEditorView.swift
//  PetLog
//
//  Created by Hao Qin on 5/19/21.
//

import SwiftUI

struct FullEditorView: View {
	@Environment(\.presentationMode) var presentationMode
	
	@Binding var title: String
	@Binding var note: String
	
	var body: some View {
		UITextView.appearance().backgroundColor = .clear
		
		return VStack {
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
			.padding(.bottom)
			
			VStack(spacing: 15) {
				TextField("Enter title", text: $title)
					.font(.title)
				
				TextEditor(text: $note)
					.font(.body)
					.padding(10)
					.background(Color.systemWhite.cornerRadius(10))
			}
			.padding()
		}
		.padding()
		.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
		.onTapGesture {
			UIApplication.shared.hideKeyboard()
		}
	}
}

struct FullEditorView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			FullEditorView(title: .constant(""), note: .constant("Test Text"))
			FullEditorView(title: .constant(""), note: .constant("Test Text"))
				.preferredColorScheme(.dark)
		}
	}
}
