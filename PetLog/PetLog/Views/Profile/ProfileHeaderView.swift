//
//  ProfileHeaderView.swift
//  PetLog
//
//  Created by Hao Qin on 6/15/21.
//

import SwiftUI

struct ProfileHeaderView: View {
	var body: some View {
		HStack {
			Spacer()
			
			Text("My Pet")
				.font(.headline)
				.foregroundColor(.textGray)
			
			Spacer()
		}
		.padding(.horizontal)
		.frame(height: 40)
		.background(Color.systemWhite)
	}
}

struct ProfileHeaderView_Previews: PreviewProvider {
	static var previews: some View {
		ProfileHeaderView()
			.previewLayout(.fixed(width: 500, height: 50))
	}
}
