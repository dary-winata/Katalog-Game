//
//  CategoryMapper.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 22/11/24.
//

final class VariableMapper {
    static func mapListGameIntoKatalogGame(with listGame: [ListGame]) -> [KatalogGameModel] {
        listGame.map { game in
            let katalogGame = KatalogGameModel(id: game.id,
                                               image: game.backgroundImage,
                                               name: game.name,
                                               released: game.released,
                                               rating: game.rating ?? 0.0)
            return katalogGame
        }
    }
    
    static func mapGameIntoDetailGame(with game: GameDetailModel) -> DetailGameModel {
        return DetailGameModel(id: game.id,
                               image: game.backgroundImage,
                               name: game.name,
                               released: game.released,
                               rating: game.rating,
                               description: game.descriptionRaw,
                               isFavorite: false)
    }
    
    static func detailGameEntityIntoDetailGame(with game: FavoriteGameRealmModelEntity) -> DetailGameModel {
        return DetailGameModel(id: game.id,
                               image: game.backgroundImage,
                               name: game.name,
                               released: game.released,
                               rating: game.rating,
                               description: game.desc,
                               isFavorite: true)
    }
    
    static func detailGameIntoEntity(with game: DetailGameModel) -> FavoriteGameRealmModelEntity {
        let favorite = FavoriteGameRealmModelEntity()
        favorite.id = game.id
        favorite.backgroundImage = game.image ?? ""
        favorite.desc = game.description ?? ""
        favorite.name = game.name ?? "No Game Name"
        favorite.rating = game.rating ?? 0.0
        favorite.released = game.released ?? "TBA"
        
        return favorite
    }
    
    static func mapListEntityIntoKatalogGameModel(listFavorite: [FavoriteGameRealmModelEntity]) -> [KatalogGameModel] {
        listFavorite.map { favorite in
            let katalogGame = KatalogGameModel(id: favorite.id,
                                               image: favorite.backgroundImage,
                                               name: favorite.name,
                                               released: favorite.released,
                                               rating: favorite.rating)
            return katalogGame
        }
    }
}
