//
//  Constant.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 04/11/24.
//

import Foundation

public var URLBASE = "https://api.rawg.io/api"
public var API_KEY: String = {
    guard let filePath = Bundle.main.path(forResource: "Rawrg-Info", ofType: "plist") else {
        fatalError("Couldn't find file 'TMDB-Info.plist'.")
    }
    
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
        fatalError("Couldn't find key 'API_KEY' in 'TMDB-Info.plist'.")
    }
    
    return value
}()
