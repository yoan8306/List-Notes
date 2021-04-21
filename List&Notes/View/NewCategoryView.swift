//
//  NewCategoryView.swift
//  List&Notes
//
//  Created by Yoan on 18/04/2021.
//



import SwiftUI


struct NewCategoryView: View {
    let coreDM: CoreDataManger
    @State var categoryField = String()
    @State private var category: [Category] = [Category]()
    @State private var presentAlert = false
    @State private var SaveSuccess = false
    
    private func checkDoubleCategory() -> Bool{
        var find = true
        for check in category {
            if check.title == categoryField {
                print("this category exist")
                find = false
            }
        }
        return find
    }
    
    private func updateCategoryList() {
        category = coreDM.getAllCategory()
    }
    
    var body: some View {
        VStack{
            HStack{
                TextField("Enter new category", text: $categoryField)
                    .autocapitalization(.sentences)
                Button("Insert category") {
                    if checkDoubleCategory() {
                    coreDM.saveCategory(title: categoryField)
                    category = coreDM.getAllCategory()
                    categoryField = ""
                       SaveSuccess = true
                    } else {
                        presentAlert = true
                    }
                }
            }
            .padding()
            
            List {
                ForEach(category, id: \.self) { categorize in
                    Text(categorize.title ?? "no value")
                }.onDelete(perform: { indexSet in
                    indexSet.forEach { index in
                        let categorize = category[index]
                        coreDM.deleteCategory(category: categorize)
                        updateCategoryList()
                    }
                })
            }
        }
        
        .navigationTitle("New Category")
        .onAppear(perform: {
            updateCategoryList()
        })
        .alert(isPresented: $presentAlert) {
            Alert( //Exemple
                title: Text("Error !"), message: Text("This category already exist !!"),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $SaveSuccess) {
            Alert( //Exemple
                title: Text("Success !"), message: Text("Insert with success !"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct NewCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            NewCategoryView(coreDM: CoreDataManger())
        }
    }
}
