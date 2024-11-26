//
//  AlamofireHelper.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 04/11/24.
//

import Alamofire
import RxSwift

protocol NetworkProtocol: AnyObject {
    func fetchAllGamesWithPagination(_ page: Int) -> Observable<[ListGame]>
    func fetchGameDetails(_ id: Int) -> Observable<GameDetailModel>
    func fetchAllSearchedGame(_ page: Int, searchedText: String) -> Observable<[ListGame]>
}

class AlamofireHelper: NetworkProtocol {
    static var shared = AlamofireHelper()

    func fetchAllGamesWithPagination(_ page: Int) -> Observable<[ListGame]> {
        let url = URLBASE + "/games"
        let parameters = [
            "key": API_KEY,
            "page_size": "10",
            "page": String(page)
        ]
        
        return Observable<[ListGame]>.create { observer in
            AF.request(url, parameters: parameters)
                .responseDecodable(of: GameModel.self) { respons in
                    switch respons.result {
                    case .success(let result):
                        observer.onNext(result.results ?? [])
                        observer.onCompleted()
                    case .failure(let err):
                        observer.onError(err)
                    }
                }
            return Disposables.create()
        }
    }

    func fetchGameDetails(_ id: Int) -> Observable<GameDetailModel> {
        let url = URLBASE + "/games/\(id)"
        let parameters = [
            "key": API_KEY
        ]
        
        return Observable<GameDetailModel>.create { observer in
            AF.request(url, parameters: parameters)
                .responseDecodable(of: GameDetailModel.self) { response in
                    switch response.result {
                    case .success(let detail):
                        observer.onNext(detail)
                        observer.onCompleted()
                    case .failure(let err):
                        observer.onError(err)
                    }
                }
            return Disposables.create()
        }
    }
    
    func fetchAllSearchedGame(_ page: Int, searchedText: String) -> Observable<[ListGame]> {
        let url = URLBASE + "/games"
        let parameters = [
            "key": API_KEY,
            "page_size": "10",
            "page": String(page),
            "search": searchedText
        ]
        
        return Observable<[ListGame]>.create { observer in
            AF.request(url, parameters: parameters)
                .responseDecodable(of: GameModel.self) { respons in
                    switch respons.result {
                    case .success(let result):
                        observer.onNext(result.results ?? [])
                        observer.onCompleted()
                    case .failure(let err):
                        observer.onError(err)
                    }
                }
            return Disposables.create()
        }
        
    }
}
