//
//  NoteSectionView.swift
//  PetLog
//
//  Created by Hao Qin on 5/19/21.
//

import SwiftUI

struct NoteSectionView: View {
	
	@Binding var note: String
	@Binding var title: String
	@Binding var showFullEditor: Bool
	
	private var displayFullNote: Bool {
		if note.contains("\n") || !title.isEmpty {
			return true
		}
		return false
	}
	
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
				
				Button {
					self.showFullEditor.toggle()
				} label: {
					Image(systemName: "arrow.up.left.and.arrow.down.right.circle")
						.rotationEffect(Angle(degrees: 90))
						.font(.title)
						.foregroundColor(.pinkyOrange)
				}
			}
    
			if !displayFullNote {
				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.foregroundColor(.systemWhite)
						.frame(height: 40)
					
					TextField("Add annotation", text: $note)
            .textFieldStyle(PlainTextFieldStyle())
						.font(.body)
						.padding(.horizontal)
				}
			} else {
				HStack {
					VStack(alignment: .leading, spacing: 8) {
						if !title.isEmpty {
							Text(title)
								.font(.title2)
						}
						if !note.isEmpty {
							Text(note)
								.font(.body)
								.fixedSize(horizontal: false, vertical: true)
						}
					}
					.padding(.vertical, 1)
					.onTapGesture {
						self.showFullEditor.toggle()
					}
					
					Spacer()
				}
			}
		}
	}
}

struct NoteSectionView_Previews: PreviewProvider {
	static var previews: some View {
		NoteSectionView(note: .constant(""), title: .constant(""), showFullEditor: .constant(false))
      .previewLayout(.sizeThatFits)
	}
}
