//
//  TabBarViewModel.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 05/11/24.
//

protocol TabBarViewModelProtocol: AnyObject {
    var delegate: TabBarViewModelDelegate? { get set }
    func onViewWillAppear()
}

protocol TabBarViewModelDelegate: AnyObject {
    func setupView()
}

class TabBarViewModel: TabBarViewModelProtocol {
    weak var delegate: TabBarViewModelDelegate?

    func onViewWillAppear() {
        delegate?.setupView()
    }
}
