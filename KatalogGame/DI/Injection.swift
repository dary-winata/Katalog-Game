//
//  Injection.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 22/11/24.
//

import Foundation
import RealmSwift

final class Injection : NSObject {
    func provideRepository() -> KatalogGameRepositoryProtocol {
        let realm = try! Realm()
        let remote: NetworkProtocol = AlamofireHelper.shared
        let local: LocalDataSource = RealmHelper.shared(realm)
        
        return KatalogGameRepository(remote: remote, local: local)
    }
    
    func provideKatalogService() -> KatalogUseCase {
        KatalogInteractor(repository: provideRepository())
    }
    
    func provideSearchService() -> SearchUseCase {
        SearchInteractor(repository: provideRepository())
    }
    
    func provideDetailService() -> DetailUseCase {
        DetailInteractor(repository: provideRepository())
    }
    
    func provideFavoriteService() -> FavoriteUseCase {
        FavoriteInteractor(repository: provideRepository())
    }
}
