//
//  DetailUseCase.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 22/11/24.
//

import RxSwift

protocol DetailUseCase {
    func getDetailed(with id: Int) -> Observable<DetailGameModel>
    func saveFavoriteGame(with model: DetailGameModel) -> Observable<Bool>
    func deleteFavoriteGame(with id: Int) -> Observable<Bool>
}

class DetailInteractor: DetailUseCase {
    private let repository: KatalogGameRepositoryProtocol
    
    init(repository: KatalogGameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getDetailed(with id: Int) -> Observable<DetailGameModel> {
        repository.getDetailKatalog(with: id)
    }
    
    func saveFavoriteGame(with model: DetailGameModel) -> Observable<Bool> {
        repository.saveFavoriteGame(with: model)
    }
    
    func deleteFavoriteGame(with id: Int) -> Observable<Bool> {
        repository.deleteFavoriteGame(with: id)
    }
}
