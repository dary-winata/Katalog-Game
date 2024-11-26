//
//  HomeViewController.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 03/11/24.
//

import UIKit

class KatalogViewController: UIViewController {
    let viewModel: KatalogViewModelProtocol

    private lazy var katalogTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(KatalogCell.self, forCellReuseIdentifier: "katalog_cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    private lazy var spinnerLoading: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)

        return spinner
    }()

    init(viewModel: KatalogViewModelProtocol) {
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
    }
}

extension KatalogViewController: KatalogViewModelDelegate {
    func setupView() {
        self.title = "Katalog Game"
        self.setupLoadingView()
        self.view.backgroundColor = .white

        view.addSubview(katalogTableView)
        NSLayoutConstraint.activate([
            katalogTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            katalogTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            katalogTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            katalogTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func reloadData() {
        katalogTableView.reloadData()
        hideLoading()
    }

    func hideLoading() {
        katalogTableView.tableFooterView?.isHidden = true
    }

    func addLoadingView() {
        spinnerLoading.startAnimating()
        self.katalogTableView.tableFooterView = spinnerLoading
        self.katalogTableView.tableFooterView?.isHidden = false
    }
}

extension KatalogViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getCurrentGame().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "katalog_cell") as? KatalogCell else {
            return UITableViewCell()
        }

        cell.editDataView(game: viewModel.getCurrentGame()[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 >= (10 * viewModel.getCurrentPage()) {
            addLoadingView()
            viewModel.updateMoreGame()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        KatalogCell.getSizeDataView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailUseCase: DetailUseCase = Injection().provideDetailService()
        let detailGameVM = DetailGameViewModel(useCase: detailUseCase,
                                               id: self.viewModel.getCurrentGame()[indexPath.row].id)
        let vc: DetailGameViewController = DetailGameViewController(viewModel: detailGameVM)
        navigationController?.pushViewController(vc, animated: true)
    }
}

private extension KatalogViewController {
    func setupLoadingView() {
        spinnerLoading.frame = CGRect(x: CGFloat(0),
                                      y: CGFloat(0),
                                      width: katalogTableView.bounds.width,
                                      height: CGFloat(44))
    }
}
