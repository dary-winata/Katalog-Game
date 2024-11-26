//
//  GameDBModel.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 14/11/24.
//

import RealmSwift

class FavoriteGameRealmModelEntity: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var released: String = ""
    @objc dynamic var backgroundImage: String = ""
    @objc dynamic var rating: Double = 0.0
    @objc dynamic var desc: String = ""
    
    override class func primaryKey() -> String? {
        "id"
    }
}

extension FavoriteGameRealmModelEntity {
    static func setupData(_ game: ListGame) -> FavoriteGameRealmModelEntity {
        let localFavorite = FavoriteGameRealmModelEntity()
        localFavorite.id = game.id
        localFavorite.backgroundImage = game.backgroundImage ?? ""
        localFavorite.name = game.name ?? ""
        localFavorite.rating = game.rating ?? 0.0
        localFavorite.released = game.released ?? ""
        
        return localFavorite
    }
}
