//
//  FavoriteViewController.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 14/11/24.
//

import UIKit

class FavoriteViewController: UIViewController {
    private lazy var noFavoriteLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tidak ada game favorit"
        
        return label
    }()
    
    private lazy var katalogTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(KatalogCell.self, forCellReuseIdentifier: "katalog_cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()
    
    let viewModel: FavoriteViewModelProtocol
    
    init(viewModel: FavoriteViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }
}

extension FavoriteViewController: FavoriteViewModelDelegate {
    func setupView() {
        self.view.backgroundColor = .systemBackground
        
        view.addSubview(katalogTableView)
        view.addSubview(noFavoriteLabel)
        NSLayoutConstraint.activate([
            noFavoriteLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noFavoriteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            katalogTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            katalogTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            katalogTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            katalogTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func reloadData() {
        if viewModel.getGameData().isEmpty {
            katalogTableView.isHidden = true
            noFavoriteLabel.isHidden = false
        } else {
            katalogTableView.isHidden = false
            noFavoriteLabel.isHidden = true
        }
        katalogTableView.reloadData()
    }
    
    func updateDeletedData(at indexPath: IndexPath) {
        katalogTableView.deleteRows(at: [indexPath], with: .fade)
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getGameData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "katalog_cell") as? KatalogCell else {
            return UITableViewCell()
        }
        
        cell.editDataView(game: viewModel.getGameData()[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailUseCase = Injection().provideDetailService()
        let detailVM = DetailGameViewModel(useCase: detailUseCase,
                                           id: viewModel.getGameData()[indexPath.row].id)
        let detailVC = DetailGameViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteData(at: indexPath)
        }
    }
}
