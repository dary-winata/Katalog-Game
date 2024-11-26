//
//  SearchViewModel.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 07/11/24.
//

import RxSwift

protocol SearchViewModelDelegate: AnyObject {
    func setupView()
    func reloadTable()
    func hideLoading()
    func addLoadingView()
}

protocol SearchViewModelProtocol: AnyObject {
    var delegate: SearchViewModelDelegate? { get set }
    
    func onViewDidLoad()
    func getSearchedValue() -> [KatalogGameModel]
    func fetchSearchedValue(_ searchedValue: String)
    func updateMoreData()
    func getCurrentpage() -> Int
}

class SearchViewModel: SearchViewModelProtocol {
    weak var delegate: (any SearchViewModelDelegate)?
    let searchUseCase: SearchUseCase
    private let disposableBag: DisposeBag = DisposeBag()
    private var searchedValue: [KatalogGameModel] = []
    private var page: Int = 1
    private var currentSearchedValue = ""
    
    init(searchUseCase: SearchUseCase) {
        self.searchUseCase = searchUseCase
    }
    
    func onViewDidLoad() {
        delegate?.setupView()
    }
    
    func fetchSearchedValue(_ searchedValue: String) {
        if searchedValue != currentSearchedValue {
            reloadData()
            currentSearchedValue = searchedValue
            self.delegate?.reloadTable()
        }
        
        if currentSearchedValue != "" {
            self.delegate?.addLoadingView()
            searchUseCase.getSearchedKatalog(page: page, with: currentSearchedValue)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { listGame in
                    self.searchedValue += listGame
                    self.delegate?.reloadTable()
                }, onError: { err in
                    print(err.localizedDescription)
                })
                .disposed(by: disposableBag)
        } else {
            reloadData()
            self.delegate?.reloadTable()
        }
    }
    
    func getSearchedValue() -> [KatalogGameModel] {
        return searchedValue
    }
    
    func updateMoreData() {
        page += 1
        fetchSearchedValue(currentSearchedValue)
    }
    
    func getCurrentpage() -> Int {
        page
    }
}

private extension SearchViewModel {
    func reloadData() {
        page = 1
        self.searchedValue = []
    }
}
