//
//  ProfileViewModel.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 11/11/24.
//

import Foundation

protocol ProfileViewModelDelegate: AnyObject {
    func setupView()
    func navigateToLinked(url: URL)
    func setupData(username: String)
}

protocol ProfileViewModelProtocol: AnyObject {
    var delegate: ProfileViewModelDelegate? { get set }

    func onViewDidLoad()
    func onLabelLinkedTapped(link: String)
    func onSaveDidTapped(username: String?)
}

class ProfileViewModel: ProfileViewModelProtocol {
    weak var delegate: ProfileViewModelDelegate?
    var currentUsername: String = "Dary Winata Nugraha Djati"

    func onViewDidLoad() {
        delegate?.setupView()
        setupData()
        delegate?.setupData(username: currentUsername)
    }

    func onLabelLinkedTapped(link: String) {
        if let url = URL(string: link) {
            delegate?.navigateToLinked(url: url)
        }
    }
    
    func onSaveDidTapped(username: String?) {
        LocalDeviceRepo.savingUsername(username: username ?? "Dary Winata Nugraha Djati")
        currentUsername = username ?? "Dary Winata Nugraha Djati"
    }
}

private extension ProfileViewModel {
    func setupData() {
        self.currentUsername = LocalDeviceRepo.getUsername() ?? "Dary Winata Nugraha Djati"
    }
}
