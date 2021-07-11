//
//  PetNameTextField.swift
//  PetLog
//
//  Created by Hao Qin on 5/8/21.
//

import SwiftUI

struct PetNameTextField: View {
	
	@Binding var name: String
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Pet Name")
				.font(.headline)
				.foregroundColor(.textGray)
			
			ZStack {
				Rectangle()
					.frame(height: 40)
					.foregroundColor(.systemWhite)
					.cornerRadius(10)
				        
				TextField("Add your pet's name", text: $name)
					.textFieldStyle(PlainTextFieldStyle())
					.font(.body)
					.padding(.horizontal)
			}
		}
	}
}

struct PetNameTextField_Previews: PreviewProvider {
	static var previews: some View {
		PetNameTextField(name: .constant(""))
			.previewLayout(.fixed(width: 400, height: 100))
      .environment(\.locale, .init(identifier: "zh"))
	}
}
