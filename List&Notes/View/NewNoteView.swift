//
//  NewNoteView.swift
//  List&Notes
//
//  Created by Yoan on 18/04/2021.
//

import SwiftUI

    struct NewNoteView: View {
        let coreDM: CoreDataManger
        
        @State var category: [Category] = [Category]()
        @State private var categorySelected : Category? = nil
        @State private var categoryField = String()
        @State private var noteField: String = "Your note here"
        @State private var noteTitleField = String()
        @State private var showButton = false
        @State private var selection = Category()
        @State private var alertType: AlertType?
        
        private func emptyField() {
            categoryField = ""
            noteField = ""
            noteTitleField = ""
        }
        private func checkNoteIsOk() -> Bool{
            if !noteTitleField.isEmpty && !noteField.isEmpty && categorySelected != nil {
              return true
            } else {
                return false
            }
        }
        
          var body: some View {
          
            VStack{
                Form {
                    Picker("Select your category", selection: $categorySelected ) {
                            ForEach(category, id: \.self) { categorize in
                                Text(categorize.title ?? "no value").tag((categorize as Category?))
                            }
                        }
                    TextField("titleNote", text: $noteTitleField)
                        .font(.title2)
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 5)
                    
                        TextEditor(text: $noteField)
                          .font(.body)
                          .background(Color.white)
                          .shadow(radius: 5)
                          .cornerRadius(8)
                            .padding(.bottom)
                    }
                if checkNoteIsOk() {
                    Button(action: {
                        if checkNoteIsOk() {
                        coreDM.saveNote(noteData: noteField, noteTitle: noteTitleField,
                                          noteDate: Date(), noteCategory: categorySelected!)
                        emptyField()
                            alertType = AlertType.success
                        } else {
                            alertType = AlertType.error
                        }
                        
                    },
                            label: {
                              Text("Save")
                            }
                    )
                        .frame(maxWidth: .infinity, maxHeight: 40.0 )
                        .background(Color.yellow)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Create new note")
            .onAppear(perform: {category = coreDM.getAllCategory()})
            
            .alert(item: $alertType, content: { (type) -> Alert in
               Alert (title: Text(type.title), message: Text(type.message), dismissButton: .default(Text("OK")))
                
            })
            
    }
}

struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            NewNoteView(coreDM: CoreDataManger())
        }
    }
}
