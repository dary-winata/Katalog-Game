//
//  TabBarViewController.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 05/11/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    let viewModel: TabBarViewModelProtocol

    init(viewModel: TabBarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }
}

extension TabBarViewController: TabBarViewModelDelegate {
    func setupView() {
        let katalogTabBar = UITabBarItem(title: "List Game",
                                         image: UIImage(systemName: "list.bullet.rectangle"),
                                         tag: 0)
        let searchTabBar = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        let profileTabBar = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)
        let favoriteTabBar = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart"), tag: 3)

        let katalogUseCase = Injection().provideKatalogService()
        let katalogVM = KatalogViewModel(katalogUseCase: katalogUseCase)
        let katalogVC = KatalogViewController(viewModel: katalogVM)
        katalogVC.tabBarItem = katalogTabBar

        let searchUseCase = Injection().provideSearchService()
        let searchVM = SearchViewModel(searchUseCase: searchUseCase)
        let searchVC = SearchViewController(viewModel: searchVM)
        searchVC.tabBarItem = searchTabBar
        
        let favoriteUseCase = Injection().provideFavoriteService()
        let favoriteVM = FavoriteViewModel(useCase: favoriteUseCase)
        let favoriteVC = FavoriteViewController(viewModel: favoriteVM)
        favoriteVC.tabBarItem = favoriteTabBar

        let profileVM = ProfileViewModel()
        let profileVC = ProfileViewController(viewModel: profileVM)
        profileVC.tabBarItem = profileTabBar

        viewControllers = [katalogVC, searchVC, favoriteVC, profileVC]
    }
}
