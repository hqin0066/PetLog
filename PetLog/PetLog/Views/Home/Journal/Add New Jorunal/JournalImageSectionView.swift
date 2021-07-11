//
//  JournalImageSectionView.swift
//  PetLog
//
//  Created by Hao Qin on 5/19/21.
//

import SwiftUI

struct JournalImageSectionView: View {

	@Binding var imageData: Data?
	@Binding var showImagePickerActionSheet: Bool
	@Binding var showDeleteImageAlert: Bool
	
	var displayImage: UIImage? {
		if let data = imageData {
			return UIImage(data: data)
		}
		return nil
	}
	
	var body: some View {
		VStack {
			HStack {
				Image(systemName: "camera.fill")
					.foregroundColor(.pinkyOrange)
					.font(.title3)
				
				Text("Photo")
					.foregroundColor(.textGray)
					.font(.headline)
				
				Spacer()
				
				if imageData != nil {
					Button {
						self.showDeleteImageAlert.toggle()
            UIApplication.shared.hideKeyboard()
					} label: {
						Image(systemName: "xmark.circle")
							.rotationEffect(Angle(degrees: 90))
							.font(.title)
							.foregroundColor(.red)
					}
				}
			}
			
			if let uiImage = displayImage {
				Image(uiImage: uiImage)
					.resizable()
					.scaledToFill()
					.frame(maxHeight: UIScreen.main.bounds.width-60)
					.cornerRadius(10)
					.contentShape(Rectangle())
			} else {
				Button {
					self.showImagePickerActionSheet.toggle()
          UIApplication.shared.hideKeyboard()
				} label: {
					ZStack {
						RoundedRectangle(cornerRadius: 10)
							.stroke(lineWidth: 0.5)
							.frame(height: 40)
							.foregroundColor(.iconGray)
						
						Text("Select photo...")
							.font(.body)
							.foregroundColor(.textGray)
					}
				}
				.padding(.horizontal, 3)
			}
		}
	}
}

struct JournalImageSectionView_Previews: PreviewProvider {
	static var previews: some View {
		JournalImageSectionView(imageData: .constant(nil), showImagePickerActionSheet: .constant(false), showDeleteImageAlert: .constant(false))
			.previewLayout(.fixed(width: 500, height: 100))
	}
}
