//
//  NoteDetailView.swift
//  List&Notes
//
//  Created by Yoan on 20/04/2021.
//

import SwiftUI

struct NoteDetailView: View {
    let coreDM: CoreDataManger
    let note :Note
    @State private var noteTitle = String()
    @State private var noteDetail = String()
    @Binding var needsRefresh: Bool

    var body: some View {
        VStack(alignment: .leading){
            TextField(note.title ?? "", text: $noteTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
               TextEditor(text: $noteDetail)
                .padding(.bottom)
                .font(.body)
                .background(Color.white)
                .shadow(radius: 5)
                .cornerRadius(8)
        }
        Button("Update") {
            if !noteTitle.isEmpty && !noteDetail.isEmpty {
                note.title = noteTitle
                note.dataNote = noteDetail
                note.date = Date()
                coreDM.updateNote()
                needsRefresh.toggle()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 40.0 )
        .background(Color.yellow)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .cornerRadius(10)
        
        .onAppear() {
            noteDetail = note.dataNote ?? ""
            noteTitle = note.title ?? ""
        }
    }
    
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let note = Note()
        let coreDM = CoreDataManger()
        
        NoteDetailView(coreDM: CoreDataManger(), note: note, needsRefresh: .constant(false))
    }
}
