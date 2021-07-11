//
//  HomePageHeaderView.swift
//  PetLog
//
//  Created by Hao Qin on 5/4/21.
//

import SwiftUI

struct HomePageHeaderView: View {
	
	@Binding var fullScreenImagePresented: Bool
	@Binding var imageToPresent: UIImage?
	
	@ObservedObject var pet: Pet
	let image: UIImage?
	
	private var displayAge: LocalizedStringKey {
		guard let date = pet.birthday else {
			return "\(0) Years Old"
		}
		let monthsCount = date.month(to: Date())
		if monthsCount%12 == 0 {
			return "\(monthsCount/12) Years Old"
		} else if monthsCount < 12 {
			return "\(monthsCount) Months Old"
		} else {
			return "\((monthsCount-(monthsCount%12))/12) Years \(monthsCount%12) Months Old"
		}
	}
	
	private var displayArriveDate: LocalizedStringKey {
		guard let date = pet.arriveDate else {
			return "Shared \(0) days with you"
		}
		return "Shared \(date.day(to: Date())) days with you"
	}
	
	private var isGirl: Bool {
		if let gender = pet.gender {
			return gender == "Girl"
		}
		return true
	}
	
	var body: some View {
		ZStack {
			GeometryReader { geometry in
				Rectangle()
					.fill(LinearGradient(
									gradient: .init(colors: [Color("GradientStart"), Color("GradientEnd")]),
									startPoint: .init(x: 0, y: 0.6),
									endPoint: .init(x: 0, y: 1)))
					.frame(height: geometry.getHeightForHeaderImage())
					.offset(y: geometry.getOffsetForHeaderImage())
			}
			
			HStack(alignment: .center, spacing: 15) {
				if let image = image {
					Image(uiImage: image)
						.resizable()
						.scaledToFill()
						.frame(width: 60, height: 60)
						.cornerRadius(30)
						.shadow(radius: 4)
						.onTapGesture {
							self.imageToPresent = image
							withAnimation {
								self.fullScreenImagePresented.toggle()
							}
						}
				} else {
					Image(systemName: "person.circle.fill")
						.resizable()
						.scaledToFit()
						.frame(width: 60, height: 60)
						.shadow(radius: 4)
						.foregroundColor(.white)
				}
				
				VStack(alignment: .leading, spacing: 2) {
					HStack {
						Text(LocalizedStringKey(pet.breed ?? "Other Breed"))
							.foregroundColor(.white)
							.font(.headline)
							.bold()
							.shadow(radius: 4)
						
						Image(isGirl ? "GirlIconWhite" : "BoyIconWhite")
							.resizable()
							.scaledToFill()
							.frame(width: 15, height: 15)
					}
					
					Text(displayAge)
						.foregroundColor(.white)
						.font(.subheadline)
						.fontWeight(.light)
						.shadow(radius: 4)
					
					Text(displayArriveDate)
						.foregroundColor(.white)
						.font(.subheadline)
						.fontWeight(.light)
						.shadow(radius: 4)
				}
				
				Spacer()
			}
			.padding(.horizontal)
			.padding(.vertical, 10)
		}
	}
}


struct HeaderView_Previews: PreviewProvider {
	static var previews: some View {
		let context = Persistence.shared.container.viewContext
		let newPet = Pet(context: context)
		newPet.name = "Da Da"
		newPet.image = nil
		newPet.type = "dog"
		newPet.breed = "Maltese"
		newPet.gender = "Boy"
		newPet.isSelected = true
		newPet.birthday = Date()
		newPet.arriveDate = Date()
		return Group {
			HomePageHeaderView(fullScreenImagePresented: .constant(false), imageToPresent: .constant(nil), pet: newPet, image: nil)
				.environment(\.managedObjectContext, context)
				.previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 80))
			HomePageHeaderView(fullScreenImagePresented: .constant(false), imageToPresent: .constant(nil), pet: newPet, image: nil)
				.environment(\.managedObjectContext, context)
				.environment(\.locale, .init(identifier: "zh"))
				.previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 80))
		}
	}
}
