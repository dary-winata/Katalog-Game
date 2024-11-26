//
//  KatalogViewModel.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 03/11/24.
//

import Foundation
import RxSwift

protocol KatalogViewModelDelegate: AnyObject {
    func setupView()
    func reloadData()
    func hideLoading()
    func addLoadingView()
}

protocol KatalogViewModelProtocol: AnyObject {
    var delegate: KatalogViewModelDelegate? { get set }
    func onViewDidLoad()
    func getCurrentGame() -> [KatalogGameModel]
    func updateMoreGame()
    func getCurrentPage() -> Int
}

class KatalogViewModel: KatalogViewModelProtocol {
    weak var delegate: KatalogViewModelDelegate?
    let katalogUseCase: KatalogUseCase
    private var currentGame: [KatalogGameModel] = []
    private var currentPage: Int = 1
    private let disposableBag: DisposeBag = DisposeBag()
    
    init(katalogUseCase: KatalogUseCase) {
        self.katalogUseCase = katalogUseCase
    }
    
    func onViewDidLoad() {
        delegate?.addLoadingView()
        fetchData()
        delegate?.setupView()
    }
    
    func fetchData() {
        katalogUseCase.getKatalog(page: currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { katalogGameModel in
                self.currentGame += katalogGameModel
                self.delegate?.reloadData()
            }, onError: { err in
                print(err.localizedDescription)
            })
            .disposed(by: disposableBag)
    }
    
    func getCurrentGame() -> [KatalogGameModel] {
        return currentGame
    }
    
    func updateMoreGame() {
        currentPage += 1
        fetchData()
    }
    
    func getCurrentPage() -> Int {
        currentPage
    }
}
