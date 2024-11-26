//
//  DetailGameViewModel.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 10/11/24.
//

import RxSwift

protocol DetailGameViewModelDelegate: AnyObject {
    func setupView()
    func updateFavoriteNavigationBar(isFavorite: Bool)
    func updateView(game: DetailGameModel)
    func addLoadingView()
    func stopLoadingView()
}

protocol DetailGameViewModelProtocol: AnyObject {
    var delegate: DetailGameViewModelDelegate? { get set }

    func viewDidLoad()
    func onFavoriteButtonDidTapped()
}

class DetailGameViewModel: DetailGameViewModelProtocol {
    weak var delegate: DetailGameViewModelDelegate?
    
    private let detailUseCase: DetailUseCase
    private let disposableBag: DisposeBag = DisposeBag()
    private let id: Int
    private var isFavorite: Bool = false
    private var gameData: DetailGameModel = DetailGameModel(id: 0,
                                                            image: nil,
                                                            name: nil,
                                                            released: nil,
                                                            rating: nil,
                                                            description: nil,
                                                            isFavorite: nil)

    init(useCase: DetailUseCase, id: Int) {
        self.detailUseCase = useCase
        self.id = id
    }

    func viewDidLoad() {
        delegate?.setupView()
        self.delegate?.addLoadingView()
        fetchDetailData()
    }
    
    func fetchDetailData() {
        detailUseCase.getDetailed(with: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { detailGame in
                self.gameData = detailGame
                self.delegate?.stopLoadingView()
                self.delegate?.updateView(game: self.gameData)
                self.isFavorite = detailGame.isFavorite ?? true
                self.delegate?.updateFavoriteNavigationBar(isFavorite: detailGame.isFavorite ?? true)
            })
            .disposed(by: disposableBag)
    }
    
    func onFavoriteButtonDidTapped() {
        if isFavorite == false {
            detailUseCase.saveFavoriteGame(with: gameData)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { isSaved in
                    if isSaved {
                        self.isFavorite = true
                        self.delegate?.updateFavoriteNavigationBar(isFavorite: true)
                    }
                })
                .disposed(by: disposableBag)
        } else {
            detailUseCase.deleteFavoriteGame(with: id)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { isDeleted in
                    if isDeleted {
                        self.isFavorite = false
                        self.delegate?.updateFavoriteNavigationBar(isFavorite: false)
                    }
                }, onError: { err in
                    print(err.localizedDescription)
                })
                .disposed(by: disposableBag)
        }
    }
}
