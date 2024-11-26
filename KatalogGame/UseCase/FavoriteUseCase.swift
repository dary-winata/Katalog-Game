//
//  FavoriteUseCase.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 22/11/24.
//

import RxSwift

protocol FavoriteUseCase {
    func getAllFavorite() -> Observable<[KatalogGameModel]>
    func deleteFavoriteGame(with id: Int) -> Observable<Bool>
}

class FavoriteInteractor: FavoriteUseCase {
    private let repository: KatalogGameRepositoryProtocol
    
    init(repository: KatalogGameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getAllFavorite() -> Observable<[KatalogGameModel]> {
        self.repository.fetchAllFavorite()
    }
    
    func deleteFavoriteGame(with id: Int) -> Observable<Bool> {
        repository.deleteFavoriteGame(with: id)
    }
}
