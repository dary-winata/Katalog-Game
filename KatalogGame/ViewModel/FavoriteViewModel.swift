//
//  FavoriteViewModel.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 14/11/24.
//

import Foundation
import RxSwift

protocol FavoriteViewModelDelegate: AnyObject {
    func setupView()
    func reloadData()
    func updateDeletedData(at indexPath: IndexPath)
}

protocol FavoriteViewModelProtocol: AnyObject {
    var delegate: FavoriteViewModelDelegate? { get set }
    
    func onViewDidLoad()
    func getGameData() -> [KatalogGameModel]
    func deleteData(at indexPath: IndexPath)
}

class FavoriteViewModel: FavoriteViewModelProtocol {
    weak var delegate: FavoriteViewModelDelegate?
    var gameData: [KatalogGameModel] = []
    private let useCase: FavoriteUseCase
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(useCase: FavoriteUseCase) {
        self.useCase = useCase
    }
    
    func onViewDidLoad() {
        delegate?.setupView()
        fetchDataFromRealm()
    }
    
    func fetchDataFromRealm() {
        useCase.getAllFavorite()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self else {return}
                self.gameData = result
                self.delegate?.reloadData()
            }, onError: { err in
                print(err.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func getGameData() -> [KatalogGameModel] {
        gameData
    }
    
    func deleteData(at indexPath: IndexPath) {
        useCase.deleteFavoriteGame(with: gameData[indexPath.row].id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isDeleted in
                if isDeleted {
                    self.gameData.remove(at: indexPath.row)
                    self.delegate?.updateDeletedData(at: indexPath)
                }
            }).disposed(by: disposeBag)
    }
}
