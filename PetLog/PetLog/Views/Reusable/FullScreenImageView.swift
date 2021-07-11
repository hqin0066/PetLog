//
//  FullScreenImageView.swift
//  PetLog
//
//  Created by Hao Qin on 5/20/21.
//

import SwiftUI

struct FullScreenImageView: View {
	
	@Binding var isShowing: Bool
	@Binding var image: UIImage?
	
	
	var body: some View {
		ZStack {
			Color.black
				.edgesIgnoringSafeArea(.all)
			
			if let image = self.image {
					Image(uiImage: image)
						.resizable()
						.scaledToFit()
						.edgesIgnoringSafeArea(.all)
			}
		}
		.edgesIgnoringSafeArea(.all)
		.statusBar(hidden: true)
		.opacity(isShowing ? 1 : 0)
		.gesture(DragGesture().onEnded { _ in
			withAnimation {
				self.isShowing.toggle()
			}
		})
		.onTapGesture {
			withAnimation {
				self.isShowing.toggle()
			}
		}
	}
}

struct FullScreenImageView_Previews: PreviewProvider {
	static var previews: some View {
		FullScreenImageView(isShowing: .constant(true), image: .constant(nil))
	}
}
