//
//  TabBarButtonsView.swift
//  PetLog
//
//  Created by Hao Qin on 6/16/21.
//

import SwiftUI

struct TabBarButtonsView: View {
	@Environment(\.managedObjectContext) var viewContext
	
	@Binding var addButtonsPresented: Bool
	
	@ObservedObject var pet: Pet
	
	@State private var addJournalSheetPresented = false
	@State private var addExpenseSheetPresented = false
	@State private var addWeightSheetPresented = false
	@State private var addUnusualSheetPresented = false
	
	@FetchRequest(sortDescriptors: []) var weightUnits: FetchedResults<WeightUnit>
	
	private var weightUnit: WeightUnit? {
		return weightUnits.first
	}
	
	private var inPound: Bool {
		if let weightUnit = self.weightUnit {
			return weightUnit.inPound
		}
		return false
	}
  
  private let size = UIScreen.main.bounds.width / 8
	
	var body: some View {
    GeometryReader { proxy in
      ZStack {
        Color.black
          .edgesIgnoringSafeArea(.all)
          .opacity(self.addButtonsPresented ? 0.6 : 0)
          .onTapGesture {
            self.addButtonsPresented.toggle()
          }
        
        VStack {
          Spacer()
          
          ZStack {
            TabBarAddButtonView(addButtonsPresented: $addButtonsPresented, size: size)
            
            Button {
              self.addButtonsPresented.toggle()
              self.addJournalSheetPresented.toggle()
            } label: {
              TabBarSubButtonView(imageName: "note.text", text: "Write Journal")
            }
            .opacity(self.addButtonsPresented ? 1 : 0)
            .offset(x: self.addButtonsPresented ? -120 : 0,
                    y: self.addButtonsPresented ? -70 : 20)
            .sheet(isPresented: $addJournalSheetPresented, content: {
              AddJournalView(pet: pet)
            })
            
            Button {
              self.addButtonsPresented.toggle()
              self.addExpenseSheetPresented.toggle()
            } label: {
              TabBarSubButtonView(imageName: "dollarsign.circle", text: "Record Expense")
            }
            .opacity(self.addButtonsPresented ? 1 : 0)
            .offset(x: self.addButtonsPresented ? -40: 0,
                    y: self.addButtonsPresented ? -110 : 20)
            .sheet(isPresented: $addExpenseSheetPresented, content: {
              AddExpenseView(pet: pet)
            })
            
            Button {
              self.addButtonsPresented.toggle()
              self.addWeightSheetPresented.toggle()
            } label: {
              TabBarSubButtonView(imageName: "scalemass", text: "Record Weight")
            }
            .opacity(self.addButtonsPresented ? 1 : 0)
            .offset(x: self.addButtonsPresented ? 40 : 0,
                    y: self.addButtonsPresented ? -110: 20)
            .sheet(isPresented: $addWeightSheetPresented, content: {
              AddWeightView(pet: pet, inPound: inPound)
                .environment(\.managedObjectContext, viewContext)
            })
            
            Button {
              self.addButtonsPresented.toggle()
              self.addUnusualSheetPresented.toggle()
            } label: {
              TabBarSubButtonView(imageName: "exclamationmark.circle", text: "Record Unusual")
            }
            .opacity(self.addButtonsPresented ? 1 : 0)
            .offset(x: self.addButtonsPresented ? 120 : 0,
                    y: self.addButtonsPresented ? -70: 20)
            .sheet(isPresented: $addUnusualSheetPresented, content: {
              AddUnusualView(pet: pet)
            })
          }
          .padding(.bottom, UIScreen.main.bounds.width / 16)
        }
      }
      
    }
	}
}


struct TabBarButtonsView_Previews: PreviewProvider {
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
      TabBarButtonsView(addButtonsPresented: .constant(true), pet: newPet)
        .environment(\.managedObjectContext, context)
      TabBarButtonsView(addButtonsPresented: .constant(true), pet: newPet)
        .environment(\.managedObjectContext, context)
        .environment(\.locale, .init(identifier: "zh"))
    }
	}
}
