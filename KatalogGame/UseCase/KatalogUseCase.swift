//
//  KatalogUseCase.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 22/11/24.
//

import RxSwift

protocol KatalogUseCase {
    func getKatalog(page: Int) -> Observable<[KatalogGameModel]>
}

class KatalogInteractor: KatalogUseCase {
    private let repository: KatalogGameRepositoryProtocol
    
    init(repository: KatalogGameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getKatalog(page: Int) -> Observable<[KatalogGameModel]> {
        repository.getKatalog(page: page)
    }
}
