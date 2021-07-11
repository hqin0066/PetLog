//
//  PHPickerView.swift
//  PetLog
//
//  Created by Hao Qin on 5/6/21.
//

import SwiftUI
import PhotosUI

extension PHPickerViewController {
	struct View {
		@Binding var imageData: Data?
	}
}

// MARK: - UIViewControllerRepresentable
extension PHPickerViewController.View: UIViewControllerRepresentable {
	func makeCoordinator() -> some PHPickerViewControllerDelegate {
		PHPickerViewController.Delegate(imageData: $imageData)
	}
	
	func makeUIViewController(context: Context) -> PHPickerViewController {
		var config = PHPickerConfiguration()
		config.selectionLimit = 1
		config.filter = .images
		config.preferredAssetRepresentationMode = .current
		
		let picker = PHPickerViewController(configuration: config)
		picker.delegate = context.coordinator
		return picker
	}
	
	func updateUIViewController(_: UIViewControllerType, context _: Context) { }
}

// MARK: - PHPickerViewControllerDelegate
extension PHPickerViewController.Delegate: PHPickerViewControllerDelegate {
	func picker(
		_ picker: PHPickerViewController,
		didFinishPicking results: [PHPickerResult]
	) {
		if let itemProvider = results.first?.itemProvider,
			 itemProvider.canLoadObject(ofClass: UIImage.self) {
			itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
				guard let self = self, let image = image as? UIImage else { return }
				DispatchQueue.main.async {
					self.imageData = image.png()
				}
			}
		}
		
		picker.dismiss(animated: true)
	}
}

// MARK: - private
private extension PHPickerViewController {
	final class Delegate {
		init(imageData: Binding<Data?>) {
			_imageData = imageData
		}
		
		@Binding var imageData: Data?
	}
}

struct PHPickerView_Previews: PreviewProvider {
	static var previews: some View {
		PHPickerViewController.View(imageData: .constant(nil))
	}
}
