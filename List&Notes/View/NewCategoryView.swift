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
    
    private func updateCategoryList() {
        category = coreDM.getAllCategory()
    }
    
    var body: some View {
        VStack{
            HStack{
                TextField("Enter new category", text: $categoryField)
                    .autocapitalization(.sentences)
                Button("Insert category") {
                    coreDM.saveCategory(title: categoryField)
                    category = coreDM.getAllCategory()
                    categoryField = ""
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
    }
}

struct NewCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            NewCategoryView(coreDM: CoreDataManger())
        }
    }
}
