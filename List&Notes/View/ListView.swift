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
    @State var searchField = String()
    @State var noteByCategory = [[Note]]()
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    private func updateListNote() {
        notes = coreDM.getAllNotes()
//        noteByCategory = coreDM.sortNoteByCategory()
    }
    var body: some View {
    VStack{
        HStack{
            TextField("search", text: $searchText, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    print("onCommit")
                }).foregroundColor(.primary)
                        Button(action: {
                           self.searchText = ""
                           }) {
                               Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                           }
                        }
                       .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                       .foregroundColor(.secondary)
                       .background(Color(.secondarySystemBackground))
                       .cornerRadius(10.0)

        
        List {
            ForEach(notes, id: \.self) { notes in
                NavigationLink(
                    destination: NoteDetailView(coreDM: coreDM, note: notes, needsRefresh: $needsRefresh),
                    label: { HStack{
                                VStack(alignment: .leading){
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
                    }
                )
            }
            .onDelete(perform: { indexSet in
                indexSet.forEach { index in
                    let note = notes[index]
                    coreDM.deleteNote(note: note)
                    updateListNote()
                    }
            })
        }
        .listStyle(InsetGroupedListStyle())
        .accentColor(needsRefresh ? .red: .blue)
        .onAppear(perform: {
            updateListNote()
        })
    }
            .navigationTitle("Your notes")
    }
    
}



struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ListView(coreDM: CoreDataManger())
        }
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
