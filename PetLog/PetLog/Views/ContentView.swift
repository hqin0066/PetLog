//
//  ContentView.swift
//  PetLog
//
//  Created by Hao Qin on 5/3/21.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var pet: Pet
  
  @State private var currentPage = 0
  @State private var addButtonsPresented = false
  
  @State private var imageToPresent: UIImage? = nil
  @State private var fullScreenImagePresented = false
  
  var petPhoto: UIImage? {
    if let data = pet.image?.image {
      return UIImage(data: data)
    }
    return nil
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        TabView(selection: $currentPage) {
          HomePageView(fullScreenImagePresented: $fullScreenImagePresented, imageToPresent: $imageToPresent, pet: pet, petPhoto: petPhoto)
            .tag(0)
            .contentShape(Rectangle())
            .simultaneousGesture(DragGesture())
          
          RecordPageView(pet: pet)
            .tag(1)
            .contentShape(Rectangle())
            .simultaneousGesture(DragGesture())
          
          ReminderPageView(pet: pet)
            .tag(2)
            .contentShape(Rectangle())
            .simultaneousGesture(DragGesture())
          
          ProfilePageView(fullScreenImagePresented: $fullScreenImagePresented, imageToPresent: $imageToPresent, pet: pet, petPhoto: petPhoto)
            .tag(3)
            .contentShape(Rectangle())
            .simultaneousGesture(DragGesture())
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .background(currentPage == 0 ? Color("GradientStart") : Color.systemWhite)
        .edgesIgnoringSafeArea(.all)
        
        MainTabView(currentPage: $currentPage, addButtonsPresented: $addButtonsPresented)
          .edgesIgnoringSafeArea(.bottom)
        
        TabBarButtonsView(addButtonsPresented: $addButtonsPresented, pet: pet)
          .ignoresSafeArea(.keyboard, edges: .bottom)
        
        FullScreenImageView(isShowing: $fullScreenImagePresented, image: $imageToPresent)
          .edgesIgnoringSafeArea(.all)
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarHidden(true)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let context = Persistence.shared.container.viewContext
    let newPet = Pet(context: context)
    newPet.name = "Da Da"
    newPet.image = nil
    newPet.type = "dog"
    newPet.breed = "Maltese"
    newPet.isSelected = true
    newPet.birthday = Date()
    newPet.arriveDate = Date()
    return Group {
      ContentView(pet: newPet)
        .environment(\.managedObjectContext, context)
      ContentView(pet: newPet)
        .preferredColorScheme(.dark)
        .environment(\.managedObjectContext, context)
    }
  }
}
