//
//  WelcomePageControllerView.swift
//  PetLog
//
//  Created by Hao Qin on 5/5/21.
//

import SwiftUI

struct WelcomePageControllerView: View {
	@Environment(\.managedObjectContext) var viewContext
	
	@Binding var currentPage: Int
	@Binding var showHomeView: Bool
	@Binding var selectedType: PetType
	@Binding var breed: String
	@Binding var imageData: Data?
	@Binding var name: String
	@Binding var gender: PetGender
	@Binding var birthday: Date
	@Binding var arriveDate: Date
	@Binding var didSelectBirthday: Bool
	@Binding var didSelectArriveDate: Bool
	@Binding var showAlert: Bool
		
	var DetailIsCompleted: Bool {
		return (imageData != nil && !name.isEmpty && didSelectBirthday && didSelectArriveDate)
	}
	
	var body: some View {
		ZStack {
			HStack {
				if currentPage != 0{
					HStack {
						Image(systemName: "chevron.backward")
							.font(.body)
							.foregroundColor(.textGray)
						
						Button {
							switch currentPage {
							case 1:
								currentPage = 0
							case 2:
								currentPage = 1
							default:
								break
							}
						} label: {
							Text("Back")
								.font(.body)
								.foregroundColor(.textGray)
						}
					}
				}
				
				Spacer()
				
				Button {
					switch currentPage {
					case 0:
						currentPage = 1
					case 1:
						if !breed.isEmpty {
							currentPage = 2
						}
					case 2:
						if DetailIsCompleted {
							Persistence.shared.createPetWith(
								type: selectedType,
								breed: breed,
								imageData: imageData!,
								name: name,
								gender: gender,
								birthday: birthday,
								arriveDate: arriveDate,
								using: viewContext) { success in
								guard success else {
									self.showAlert.toggle()
									return
								}
								self.showHomeView.toggle()
							}
						}
					default:
						break
					}
				} label: {
					if currentPage == 0 {
						Image(systemName: "chevron.forward.circle.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 50, height: 50)
							.foregroundColor(.pinkyOrange)
							.shadow(radius: 2)
					} else if currentPage == 1 {
						Image(systemName: "chevron.forward.circle.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 50, height: 50)
							.foregroundColor(!breed.isEmpty ? .pinkyOrange : .iconGray)
							.shadow(radius: 2)
					}	else {
						Image(systemName: "checkmark.circle.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 50, height: 50)
							.foregroundColor(DetailIsCompleted ? .pinkyOrange : .iconGray)
							.shadow(radius: 2)
					}
				}
			}
			.padding(.horizontal, 40)
			
			HStack {
				let defaultSize: CGFloat = 13
				let selectedSize: CGFloat = 15
				
				Circle()
					.frame(width: currentPage == 0 ? selectedSize : defaultSize,
								 height: currentPage == 0 ? selectedSize : defaultSize)
					.foregroundColor(currentPage == 0 ? .pinkyOrange : .iconGray)
				Circle()
					.frame(width: currentPage == 1 ? selectedSize : defaultSize,
								 height: currentPage == 1 ? selectedSize : defaultSize)
					.foregroundColor(currentPage == 1 ? .pinkyOrange : .iconGray)
				Circle()
					.frame(width: currentPage == 2 ? selectedSize : defaultSize,
								 height: currentPage == 2 ? selectedSize : defaultSize)
					.foregroundColor(currentPage == 2 ? .pinkyOrange : .iconGray)
			}
		}
	}
}


struct WelcomePageControllerView_Previews: PreviewProvider {
    static var previews: some View {
			WelcomePageControllerView(currentPage: .constant(1),
												 showHomeView: .constant(false),
												 selectedType: .constant(.dog),
												 breed: .constant("Maltese"),
												 imageData: .constant(nil),
												 name: .constant("Name"),
												 gender: .constant(.girl),
												 birthday: .constant(Date()),
												 arriveDate: .constant(Date()),
												 didSelectBirthday: .constant(true),
												 didSelectArriveDate: .constant(true),
												 showAlert: .constant(false))
				.previewLayout(.fixed(width: 500, height: 100))
    }
}
