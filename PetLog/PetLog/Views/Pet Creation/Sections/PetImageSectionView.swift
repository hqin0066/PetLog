//
//  PetImageSectionView.swift
//  PetLog
//
//  Created by Hao Qin on 5/7/21.
//

import SwiftUI
import PhotosUI

struct PetImageSectionView: View {
	
	@Binding var imageData: Data?
	@Binding var imagePickerIsShowing: Bool
	
	var image: UIImage? {
		if let data = imageData {
			return UIImage(data: data)
		}
		return nil
	}
	
	var body: some View {
		VStack(spacing: 0) {
			ZStack {
				if let image = image.map(Image.init) {
					image
						.resizable()
						.scaledToFill()
						.frame(width: 100, height: 100)
						.cornerRadius(60)
					
					Button {
						self.imagePickerIsShowing.toggle()
            UIApplication.shared.hideKeyboard()
					} label: {
						ImageOverlay()
					}
				} else {
					Image(systemName: "person.crop.circle.fill")
						.resizable()
						.scaledToFit()
						.frame(width: 100, height: 100)
						.foregroundColor(.iconGray)
					
					Button {
						self.imagePickerIsShowing.toggle()
            UIApplication.shared.hideKeyboard()
					} label: {
						ImageOverlay()
					}
				}
			}
			
			Text("Change photo")
				.font(.subheadline)
				.foregroundColor(.textGray)
				.onTapGesture {
					self.imagePickerIsShowing.toggle()
          UIApplication.shared.hideKeyboard()
				}
		}
		.sheet(isPresented: $imagePickerIsShowing) {
			PHPickerViewController.View(imageData: $imageData)
		}
	}
}

struct PetImageSectionView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			PetImageSectionView(imageData: .constant(nil), imagePickerIsShowing: .constant(false))
				.previewLayout(.fixed(width: 200, height: 200))
			PetImageSectionView(imageData: .constant(nil), imagePickerIsShowing: .constant(false))
				.preferredColorScheme(.dark)
				.previewLayout(.fixed(width: 200, height: 200))
		}
	}
}

struct ImageOverlay: View {
	var body: some View {
		ZStack {
			Circle()
				.foregroundColor(.systemWhite)
				.opacity(0.2)
				.frame(width: 100, height: 100)
			
			Image(systemName: "camera")
				.resizable()
				.scaledToFit()
				.frame(width: 30, height: 30)
				.foregroundColor(.secondary)
		}
	}
}

