//
//  SearchUseCase.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 22/11/24.
//

import RxSwift

protocol SearchUseCase {
    func getSearchedKatalog(page: Int, with keyword: String) -> Observable<[KatalogGameModel]>
}

class SearchInteractor: SearchUseCase {
    private let repository: KatalogGameRepositoryProtocol
    
    init(repository: KatalogGameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getSearchedKatalog(page: Int, with keyword: String) -> Observable<[KatalogGameModel]> {
        repository.getSearchedKatalog(page: page, keyword: keyword)
    }
}
