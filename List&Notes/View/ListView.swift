//
//  ListView.swift
//  List&Notes
//
//  Created by Yoan on 18/04/2021.
//

import SwiftUI

struct ListView: View {
    let coreDM: CoreDataManger
    @State var notes: [Note] = [Note]()
    @State var needsRefresh: Bool = false
    @State var category: [Category] = [Category]()
    
    
    private func updateListNote() {
        notes = coreDM.getAllNotes()
        category = coreDM.getAllCategory()
    }
    var body: some View {
        
        List {
                        ForEach(notes, id: \.self) { notes in
                        NavigationLink(
                            destination: NoteDetailView(coreDM: coreDM, note: notes, needsRefresh: $needsRefresh),
                            label: {
                                HStack{
                                    VStack{
                                        Text(notes.title ?? "no value")
                                            .font(.title2)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                        Text(notes.dataNote ?? "No description")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(2)
                                    }
                                    Spacer()
                                    VStack{
                                        Text(notes.date!, style: .date)
                                        Text(notes.date!, style: .time)
                                    }
                                   
                                }
                            })
                        }
                        .onDelete(perform: { indexSet in
                            indexSet.forEach { index in
                                let note = notes[index]
                                coreDM.deleteNote(note: note)
                                updateListNote()
                                }
                        })
        }
        .listStyle(PlainListStyle())
        .accentColor(needsRefresh ? .red: .blue)
        
        .navigationTitle("Your notes")
        .onAppear(perform: {
            updateListNote()
        })
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(coreDM: CoreDataManger())
    }
}
