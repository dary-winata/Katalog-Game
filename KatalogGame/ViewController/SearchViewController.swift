//
//  SearchViewController.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 07/11/24.
//

import UIKit
import Foundation

class SearchViewController: UIViewController {
    let viewModel: SearchViewModelProtocol
    private var searchDisplayWork: DispatchWorkItem?

    private lazy var searchTextField: UISearchTextField = {
        let textField: UISearchTextField = UISearchTextField(frame: .zero)
        textField.placeholder = "Search Game"
        textField.addTarget(self, action: #selector(textFieldValueDidChanged), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()

    private lazy var katalogGameTable: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(KatalogCell.self, forCellReuseIdentifier: "katalog_cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)

        return indicator
    }()

    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
        self.katalogGameTable.setNeedsLayout()
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func setupView() {
        self.title = "Search"
        self.view.backgroundColor = .systemBackground
        navigationItem.hidesSearchBarWhenScrolling = false
        view.addSubview(searchTextField)
        view.addSubview(katalogGameTable)

        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            katalogGameTable.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            katalogGameTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            katalogGameTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            katalogGameTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    func reloadTable() {
        katalogGameTable.reloadData()
        hideLoading()
    }

    func hideLoading() {
        katalogGameTable.tableFooterView?.isHidden = true
    }

    func addLoadingView() {
        loadingIndicator.startAnimating()
        self.katalogGameTable.tableFooterView = loadingIndicator
        self.katalogGameTable.tableFooterView?.isHidden = false
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getSearchedValue().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "katalog_cell") as? KatalogCell
        else {
            return UITableViewCell()
        }

        cell.editDataView(game: viewModel.getSearchedValue()[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 >= (10 * viewModel.getCurrentpage()) {
            addLoadingView()
            viewModel.updateMoreData()
        }
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailGameVM: DetailGameViewModel = DetailGameViewModel(game: viewModel.getSearchedValue()[indexPath.row])
//        let vc: DetailGameViewController = DetailGameViewController(viewModel: detailGameVM)
//        navigationController?.pushViewController(vc, animated: true)
//    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchDisplayWork?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            self?.viewModel.fetchSearchedValue(searchController.searchBar.text ?? "")
        }

        searchDisplayWork = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
    }
}

private extension SearchViewController {
    func setupLoadingView() {
        loadingIndicator.frame = CGRect(x: CGFloat(0),
                                        y: CGFloat(0),
                                        width: katalogGameTable.bounds.width,
                                        height: CGFloat(44))
    }
    
    @objc
    func textFieldValueDidChanged() {
        searchDisplayWork?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            guard let self else {return}
            self.viewModel.fetchSearchedValue(self.searchTextField.text ?? "")
        }

        searchDisplayWork = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
    }
}
