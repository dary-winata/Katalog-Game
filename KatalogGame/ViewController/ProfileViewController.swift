//
//  ProfileViewController.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 05/11/24.
//

import UIKit

class ProfileViewController: UIViewController {
    private lazy var profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.contentMode = .scaleAspectFit
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageDidTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var nameLabel: UITextField = {
        let label: UITextField = UITextField(frame: .zero)
        label.borderStyle = .roundedRect
        label.placeholder = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.delegate = self

        return label
    }()

    private lazy var githubBtn: UIButton = {
        let button: UIButton = UIButton(type: .roundedRect)
        button.setTitle("My Github", for: .normal)
        button.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(dicodingLabelTapped))
        button.addGestureRecognizer(tap)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var linkedinBtn: UIButton = {
        let button: UIButton = UIButton(type: .roundedRect)
        button.setTitle("My Linkedin", for: .normal)
        button.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkedinBtnTapped))
        button.addGestureRecognizer(tap)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.mediaTypes = ["public.image"]
        
        return picker
    }()
    
    private lazy var saveButton: UIButton = {
        let btn = UIButton(type: .roundedRect)
        btn.setTitle("Save Data", for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(onSavedButtonDidTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()

    let viewModel: ProfileViewModelProtocol

    init(viewModel: ProfileViewModelProtocol) {
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

extension ProfileViewController: ProfileViewModelDelegate {
    func setupView() {
        self.title = "Profile"
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(profileImageView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(githubBtn)
        self.view.addSubview(linkedinBtn)
        self.view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            githubBtn.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            githubBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            linkedinBtn.topAnchor.constraint(equalTo: githubBtn.bottomAnchor, constant: 4),
            linkedinBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveButton.topAnchor.constraint(equalTo: linkedinBtn.bottomAnchor, constant: 16),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func navigateToLinked(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func setupData(username: String) {
        nameLabel.text = username
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.profileImageView.image = image
        }
        dismiss(animated: true)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
}

private extension ProfileViewController {
    @objc
    func linkedinBtnTapped() {
        let url = "https://www.linkedin.com/in/dary-winata-992537170/"
        viewModel.onLabelLinkedTapped(link: url)
    }

    @objc
    func dicodingLabelTapped() {
        let url = "https://github.com/dary-winata"
        viewModel.onLabelLinkedTapped(link: url)
    }
    
    @objc
    func imageDidTapped() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc
    func onSavedButtonDidTapped() {
        viewModel.onSaveDidTapped(username: nameLabel.text)
        nameLabel.endEditing(true)
    }
}
