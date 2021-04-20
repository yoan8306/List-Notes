//
//  List_NotesApp.swift
//  List&Notes
//
//  Created by Yoan on 18/04/2021.
//

import SwiftUI

@main
struct List_NotesApp: App {
    var body: some Scene {
        WindowGroup {
            TabView{
                NavigationView{
                    ListView(coreDM: CoreDataManger())
                }
                .tabItem { Image(systemName: "list.bullet.rectangle")
                    Text("List")
                }
                NavigationView{
                    NewNoteView(coreDM: CoreDataManger())
                }
                .tabItem { Image(systemName: "note.text.badge.plus")
                    Text("Create new note")
                }
                NavigationView{
                    NewCategoryView(coreDM: CoreDataManger())
                }
                .tabItem { Image(systemName: "folder.fill.badge.plus")
                    Text("Create new category")
                }
            }
        }
    }
}
