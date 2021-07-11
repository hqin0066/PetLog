//
//  FirstWelcomePageView.swift
//  PetLog
//
//  Created by Hao Qin on 5/5/21.
//

import SwiftUI

struct InfoPageView: View {
  var body: some View {
    NavigationView {
      VStack(alignment: .center, spacing: 20) {
        Text("PetLog")
          .font(.title)
          .bold()
          .foregroundColor(.pinkyOrange)
          .padding(.top, UIScreen.main.bounds.height / 12)
        
        Text("Record any memorable moment of your loved one, or ones. Or record something important and see them in charts, like weight, spent, etc.")
          .font(.body)
          .multilineTextAlignment(.center)
          .foregroundColor(Color("TextGrayStatic"))
          .padding(.horizontal, 40)
        
        Spacer()
        
        NavigationLink(destination: PetCreationView()) {
          Text("Continue")
            .foregroundColor(Color.pinkyOrange)
            .bold()
            .font(.title3)
            .frame(width: UIScreen.main.bounds.width - 60, height: 50)
            .background(Color.white)
            .cornerRadius(30)
            .shadow(radius: 8)
        }
      }
      .padding()
      .background(
        Image("InfoPageBackground")
          .resizable()
          .scaledToFill()
          .frame(width: UIScreen.main.bounds.width)
          .edgesIgnoringSafeArea(.all)
      )
      .navigationBarHidden(true)
    }
  }
}

struct InfoPageView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      InfoPageView()
      InfoPageView()
        .environment(\.locale, .init(identifier: "zh"))
    }
  }
}
