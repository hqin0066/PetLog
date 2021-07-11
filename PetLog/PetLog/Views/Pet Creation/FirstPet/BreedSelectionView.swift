//
//  BreedSelectionView.swift
//  PetLog
//
//  Created by Hao Qin on 5/5/21.
//

import SwiftUI

struct BreedSelectionView: View {
	
	@Binding var petType: PetType
	@Binding var breed: String
	@Binding var breedListSheetIsShowing: Bool
	
	var body: some View {
		ZStack {
			Color.backgroundColor
				.edgesIgnoringSafeArea(.all)
			
			VStack(spacing: 10) {
				Text("What's the breed of your pet?")
					.font(.title)
					.bold()
					.foregroundColor(.textGray)
					.padding()
				
				Button {
					breedListSheetIsShowing.toggle()
				} label: {
					HStack {
						Text(breed.isEmpty ? "Select" : "\(breed)")
							.font(.body)
							.bold()
							.foregroundColor(.pinkyOrange)
							.lineLimit(1)
						
						Spacer()
						
						Image(systemName: "chevron.down.circle")
							.font(.title3)
							.foregroundColor(.pinkyOrange)
					}
					.padding(.horizontal, 20)
					.frame(width: UIScreen.main.bounds.width - 60, height: 40)
					.background(Color.systemWhite)
					.cornerRadius(10)
				}
				.shadow(radius: 4)
				.sheet(isPresented: $breedListSheetIsShowing) {
					BreedListView(petType: $petType, breed: $breed)
				}
			}
		}
	}
}

struct BreedSelectionView_Previews: PreviewProvider {
	static var previews: some View {
		BreedSelectionView(petType: .constant(.dog), breed: .constant(""), breedListSheetIsShowing: .constant(false))
	}
}
