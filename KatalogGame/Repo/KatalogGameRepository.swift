//
//  LocaleRepository.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 22/11/24.
//

import RxSwift

protocol KatalogGameRepositoryProtocol: AnyObject {
    // Remote
    func getKatalog(page: Int) -> Observable<[KatalogGameModel]>
    func getSearchedKatalog(page: Int, keyword: String) -> Observable<[KatalogGameModel]>
    func getDetailKatalog(with id: Int) -> Observable<DetailGameModel>
    
    // Local
    func saveFavoriteGame(with game: DetailGameModel) -> Observable<Bool>
    func deleteFavoriteGame(with id: Int) -> Observable<Bool>
    func fetchAllFavorite() -> Observable<[KatalogGameModel]>
}

final class KatalogGameRepository: KatalogGameRepositoryProtocol {
    fileprivate let remote: NetworkProtocol
    fileprivate let local: LocalDataSource
    
    init(remote: NetworkProtocol, local: LocalDataSource) {
        self.remote = remote
        self.local = local
    }
    
    func getKatalog(page: Int) -> Observable<[KatalogGameModel]> {
        remote.fetchAllGamesWithPagination(page)
            .map { listGame in
                VariableMapper.mapListGameIntoKatalogGame(with: listGame)
            }
    }
    
    func getSearchedKatalog(page: Int, keyword: String) -> Observable<[KatalogGameModel]> {
        remote.fetchAllSearchedGame(page, searchedText: keyword)
            .map { listGame in
                VariableMapper.mapListGameIntoKatalogGame(with: listGame)
            }
    }
    
    func getDetailKatalog(with id: Int) -> Observable<DetailGameModel> {
        local.getRealmDataById(id: id)
            .flatMap { favorite in
                if favorite != nil {
                    return self.local.getRealmDataById(id: id)
                        .map { favorite in
                            VariableMapper.detailGameEntityIntoDetailGame(with: favorite!)
                        }
                } else {
                    return self.remote.fetchGameDetails(id)
                        .map { gameDetail in
                            VariableMapper.mapGameIntoDetailGame(with: gameDetail)
                        }
                }
            }
    }
    
    func saveFavoriteGame(with game: DetailGameModel) -> Observable<Bool> {
        let realmData = VariableMapper.detailGameIntoEntity(with: game)
        return local.saveToRealm(realmData)
    }
    
    func deleteFavoriteGame(with id: Int) -> Observable<Bool> {
        local.deleteDataById(id)
    }
    
    func fetchAllFavorite() -> Observable<[KatalogGameModel]> {
        local.fetchAllFavorite()
            .map { favorites in
                VariableMapper.mapListEntityIntoKatalogGameModel(listFavorite: favorites)
            }
    }
}
