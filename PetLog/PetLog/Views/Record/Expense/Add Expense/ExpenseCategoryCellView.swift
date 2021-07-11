//
//  ExpenseCategoryCellView.swift
//  PetLog
//
//  Created by Hao Qin on 5/25/21.
//

import SwiftUI

struct ExpenseCategoryCellView: View {
  
  @Binding var selectedCategory: ExpenseCategory?
  
  let category: ExpenseCategory
  
  var isSelected: Bool {
    category == selectedCategory
  }
  
  var body: some View {
    VStack {
      ZStack {
        Circle()
          .stroke()
          .frame(width: 50, height: 50)
          .foregroundColor(isSelected ? .clear : .iconGray)
        
        Circle()
          .frame(width: 50, height: 50)
          .foregroundColor(isSelected ? .pinkyOrange : .systemWhite)
        
        if isSelected {
          Image(category.whiteImageName)
            .resizable()
            .scaledToFit()
            .frame(width: 35, height: 35)
        } else {
          Image(category.pinkyOrangeImageName)
            .resizable()
            .scaledToFit()
            .frame(width: 35, height: 35)
        }
      }
      .animation(.easeIn(duration: 0.2))
      
      Text(LocalizedStringKey(category.rawValue))
        .font(.footnote)
        .foregroundColor(.textGray)
        .multilineTextAlignment(.center)
      
      Spacer()
    }
    .frame(height: 100)
    .onTapGesture {
      self.selectedCategory = self.category
    }
  }
}

struct ExpenseCategoryCellView_Previews: PreviewProvider {
  static var previews: some View {
    ExpenseCategoryCellView(selectedCategory: .constant(.accessories), category: .accessories)
      .previewLayout(.fixed(width: 100, height: 120))
  }
}
