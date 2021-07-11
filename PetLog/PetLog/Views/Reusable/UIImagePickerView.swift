//
//  UIImagePickerView.swift
//  PetLog
//
//  Created by Hao Qin on 5/19/21.
//

import SwiftUI

struct UIImagePickerView: UIViewControllerRepresentable {
	@Binding var imageData: Data?
	
	class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
		@Binding var imageData: Data?
		
		init(_ imageData: Binding<Data?>) {
			_imageData = imageData
		}
		
		func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
			guard let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
				return
			}
			DispatchQueue.main.async { [weak self] in
				self?.imageData = uiImage.png()
			}
			picker.dismiss(animated: true)
		}
		
		func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
			picker.dismiss(animated: true)
		}
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator($imageData)
	}
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<UIImagePickerView>) -> UIImagePickerController {
		let picker = UIImagePickerController()
		picker.delegate = context.coordinator
		picker.sourceType = .camera
		return picker
	}
	
	func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<UIImagePickerView>) {
		
	}
}

struct UIImagePickerView_Previews: PreviewProvider {
	static var previews: some View {
		UIImagePickerView(imageData: .constant(nil))
	}
}
