//
//  CoreDataManger.swift
//  List&Notes
//
//  Created by Yoan on 18/04/2021.
//

import Foundation
import CoreData

class CoreDataManger {
    let persistentContainer: NSPersistentContainer
    init() {
        persistentContainer = NSPersistentContainer(name: "Category&Notes")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
    }
    
    func sortNoteByCategory() -> [[Note]] {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        guard let note = try? persistentContainer.viewContext.fetch(fetchRequest) else {
            return []
        }
        return note.convertedToArrayofArray
    }
    
    func getAllNotes() -> [Note] {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
    
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    
    }
    
    func getAllCategory() ->[Category] {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func saveNote(noteData: String, noteTitle: String, noteDate: Date, noteCategory: Category ) {
        let note = Note(context: persistentContainer.viewContext)
        
        note.date = noteDate
        note.dataNote = noteData
        note.title = noteTitle
        note.category = noteCategory
        
        do {
            try persistentContainer.viewContext.save()
        } catch  {
            print("failed to save note \(error)")
        }
        
    }
    
    func saveCategory (title: String) {
        let category = Category(context: persistentContainer.viewContext)
        
        category.title = title
        
        do {
            try persistentContainer.viewContext.save()
        } catch  {
            print("Failed save category \(error)")
        }
        
    }
    
    func updateNote () {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context after update note \(error)")
        }
    }
    
    
    func deleteNote(note: Note) {
        persistentContainer.viewContext.delete(note)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context after delete note \(error)")
        }
    }
    
    func deleteCategory(category: Category) {
        persistentContainer.viewContext.delete(category)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context after delete category \(error)")
        }
    }
    
}

extension Array where Element == Note {
    var convertedToArrayofArray: [[Note]] {
        var dict = [Category: [Note]]()
        for notes in self where notes.category != nil {
            dict[notes.category!,default: []].append(notes)
        }
        var result = [[Note]] ()
        for (_, data) in dict {
            result.append(data)
        }
        return result
    }
}
