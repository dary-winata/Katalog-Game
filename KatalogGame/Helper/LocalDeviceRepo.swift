//
//  LocalDeviceRepo.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 14/11/24.
//

import Foundation

class LocalDeviceRepo {
    static func savingUsername(username: String) {
        UserDefaults.standard.set(username, forKey: "username")
    }
    
    static func getUsername() -> String? {
        return UserDefaults.standard.string(forKey: "username")
    }
}
