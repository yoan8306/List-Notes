//
//  File.swift
//  List&Notes
//
//  Created by Yoan on 26/04/2021.
//

import Foundation
enum AlertType: Identifiable {
    var id: UUID {
        return UUID()
    }
    case success
    case error
    
    var title: String {
        switch self {
        case .success:
            return "Success !"
        case .error:
            return "Error !"
        }
    }
    
    var message: String {
        switch self {
        case .success:
            return "Insert with success !"
        case .error:
            return "Can you retry or check all is not empty."
        }
    }
}
