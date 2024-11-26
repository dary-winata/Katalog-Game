//
//  RealmHelper.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 14/11/24.
//

import RealmSwift
import RxSwift

protocol LocalDataSource: AnyObject {
    func saveToRealm<T: Object>(_ object: T) -> Observable<Bool>
    func getRealmDataById(id: Int) -> Observable<FavoriteGameRealmModelEntity?>
    func fetchAllFavorite() -> Observable<[FavoriteGameRealmModelEntity]>
    func deleteDataById(_ id: Int) -> Observable<Bool>
}

class RealmHelper: LocalDataSource {
    static let shared: (Realm) -> RealmHelper = { realmDatabase in
        return RealmHelper(realm: realmDatabase)
    }
    private let realm: Realm
    private let disposeBag = DisposeBag()
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func saveToRealm<T: Object>(_ object: T) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            do {
                try self.realm.write({
                    self.realm.add(object, update: .all)
                    observer.onNext(true)
                    observer.onCompleted()
                })
            } catch {
                observer.onNext(false)
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func getRealmDataById(id: Int) -> Observable<FavoriteGameRealmModelEntity?> {
        return Observable<FavoriteGameRealmModelEntity?>.create { observer in
            let realmData = self.realm.objects(FavoriteGameRealmModelEntity.self).filter("id == \(id)")
            observer.onNext(realmData.first)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func fetchAllFavorite() -> Observable<[FavoriteGameRealmModelEntity]> {
        Observable<[FavoriteGameRealmModelEntity]>.create { observer in
            observer.onNext(Array(self.realm.objects(FavoriteGameRealmModelEntity.self)))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func deleteDataById(_ id: Int) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let data = self.getRealmDataById(id: id)
            data.observe(on: MainScheduler.instance)
                .subscribe(onNext: { result in
                    do {
                        try self.realm.write {
                            self.realm.delete(result!)
                            observer.onNext(true)
                            observer.onCompleted()
                        }
                    } catch {
                        observer.onNext(false)
                        observer.onError(error)
                    }
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
