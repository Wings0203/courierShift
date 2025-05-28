//
//  ProfileVC.swift
//  courierShift
//
//  Created by Татьяна Федотова on 13.05.2025.
//

import UIKit

class ProfileVC: UIViewController {
    
    private let build = ProfileView.shared
    var userInfoModel: UserInfoModel?
    
    private var nameLabel = UILabel()
    private var phoneLabel = UILabel()
    private var emailLabel = UILabel()
    private var completedShiftsLabel = UILabel()
    
    private let avatarContainerView = UIView()
    private var noProfileIcon = UIImageView()
    private var editIcon = UIButton()
    
    private let credentialsStack = UIStackView()
    private let phoneStack = UIStackView()
    private let emailStack = UIStackView()
    private let completedShiftsStack = UIStackView()
    
    private let mainStack = UIStackView()
    
    private let deleteProfileButton = UIButton()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserInfo()
        setupAvatarContainerView()
        setupMainStack()
        setupDeleteProfileButton()
    }
    
    private func setupAvatarContainerView() {
        noProfileIcon = build.noProfieIcon
        editIcon = build.editIcon
        
        avatarContainerView.addSubview(noProfileIcon)
        avatarContainerView.addSubview(editIcon)
        
        avatarContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarContainerView)
        
        NSLayoutConstraint.activate([
            avatarContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            avatarContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            avatarContainerView.heightAnchor.constraint(equalTo: noProfileIcon.widthAnchor),
            
            noProfileIcon.topAnchor.constraint(equalTo: avatarContainerView.topAnchor),
            noProfileIcon.leadingAnchor.constraint(equalTo: avatarContainerView.leadingAnchor),
            noProfileIcon.trailingAnchor.constraint(equalTo: avatarContainerView.trailingAnchor),
            noProfileIcon.bottomAnchor.constraint(equalTo: avatarContainerView.bottomAnchor),

            editIcon.trailingAnchor.constraint(equalTo: noProfileIcon.trailingAnchor, constant: -30),
            editIcon.bottomAnchor.constraint(equalTo: noProfileIcon.bottomAnchor, constant: -10)
        ])
        
        editIcon.addTarget(self, action: #selector(editProfileButton), for: .touchUpInside)
        editIcon.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        editIcon.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        editIcon.addTarget(self, action: #selector(buttonTouchDragExit), for: .touchDragExit)
    }
    
    @objc private func editProfileButton() {
        guard let userInfoModel = userInfoModel else { return }
        let vc = EditProfileVC(model: userInfoModel)
        
        vc.onDismiss = { [weak self] in
            self?.getUserInfo()
            self?.setupMainStack()
            print("1")
        }
        present(vc, animated: true)
    }
    
    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.editIcon.alpha = 0.5
        }
    }

    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.editIcon.alpha = 1.0
        }
    }
    
    @objc private func buttonTouchDragExit() {
        UIView.animate(withDuration: 0.1) {
            self.editIcon.alpha = 1.0
        }
    
    }
    
    private func setupMainStack() {
        configureStacks()
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainStack.axis = .vertical
        mainStack.spacing = 10
        mainStack.alignment = .leading
        
        mainStack.addArrangedSubview(credentialsStack)
        mainStack.addArrangedSubview(phoneStack)
        mainStack.addArrangedSubview(emailStack)
        mainStack.addArrangedSubview(completedShiftsStack)
        
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.topAnchor.constraint(equalTo: noProfileIcon.bottomAnchor, constant: 60)
        ])
    }
    
    private func setupDeleteProfileButton() {
        let deleteProfileButton = build.deleteProfileButton
        view.addSubview(deleteProfileButton)
        
        NSLayoutConstraint.activate([
            deleteProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteProfileButton.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 60),
            deleteProfileButton.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 0.6),
            deleteProfileButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        deleteProfileButton.addTarget(self, action: #selector(deleteProfileButtonAction), for: .touchUpInside)
    }
    
    @objc private func deleteProfileButtonAction() {
        showConfirmMessage()
    }
    
    private func showConfirmMessage() {
        let alert = UIAlertController(title: "Вы уверены?", message: "Ваш аккаунт будет удален навсегда", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive))
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { _ in
            self.deleteAccount()
        }))
        present(alert, animated: true)
    }
    
    private func deleteAccount() {
        guard let accessToken = KeychainTokens.standart.read(service: "accessToken", account: "rodionn39@gmail.com", type: String.self) else { return }
        
        UserService().deleteUser(token: accessToken, email: "rodionn39@gmail.com") { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.logout()
                case .failure(let error):
                    print(error)
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func logout() {
        UserDefaults.standard.setValue(false, forKey: "isAuthorized")
        KeychainTokens.standart.delete(service: "accessToken", account: "rodionn39@gmail.com")
        KeychainTokens.standart.delete(service: "refreshToken", account: "rodionn39@gmail.com")
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let vc = LoginViewController(authService: AuthService())
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.tintColor = .black
            sceneDelegate.window?.rootViewController = navController
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    private func configureStacks() {
        configureCredentialsStack()
        configurePhoneStack()
        configureEmailStack()
        configureCompletedShiftsStack()
    }
    
    private func configureCredentialsStack() {
        let credentialsIcon = build.credentialsIcon
        nameLabel = build.nameLabel
        
        credentialsStack.axis = .horizontal
        credentialsStack.spacing = 6
        credentialsStack.alignment = .leading
        
        credentialsStack.addArrangedSubview(credentialsIcon)
        credentialsStack.addArrangedSubview(nameLabel)
        
        credentialsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(credentialsStack)
    }
    
    private func configurePhoneStack() {
        let phoneIcon = build.phoneIcon
        phoneLabel = build.phoneLabel
        
        phoneStack.axis = .horizontal
        phoneStack.spacing = 6
        phoneStack.alignment = .leading
        
        phoneStack.addArrangedSubview(phoneIcon)
        phoneStack.addArrangedSubview(phoneLabel)
        
        phoneStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneStack)
    }
    
    private func configureEmailStack() {
        let emailIcon = build.emailIcon
        emailLabel = build.emailLabel
        
        emailStack.axis = .horizontal
        emailStack.spacing = 6
        emailStack.alignment = .leading
        
        emailStack.addArrangedSubview(emailIcon)
        emailStack.addArrangedSubview(emailLabel)
        
        emailStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailStack)
    }
    
    private func configureCompletedShiftsStack() {
        let completedShiftsIcon = build.completedShiftsIcon
        completedShiftsLabel = build.completedShiftsLabel
        
        completedShiftsStack.axis = .horizontal
        completedShiftsStack.spacing = 6
        completedShiftsStack.alignment = .leading
        
        completedShiftsStack.addArrangedSubview(completedShiftsIcon)
        completedShiftsStack.addArrangedSubview(completedShiftsLabel)
        
        completedShiftsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(completedShiftsStack)
    }
    
    private func getUserInfo() {
        guard let accessToken = KeychainTokens.standart.read(service: "accessToken", account: "londxz@yandex.ru", type: String.self) else { return }
        
        UserService().getUserInfo(token: accessToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userInfo):
                    self.fetchUserInfo(userInfoModel: userInfo)
                    self.userInfoModel = userInfo
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func getCompletedShiftsCount() {
        guard let accessToken = KeychainTokens.standart.read(service: "accessToken", account: "londxz@yandex.ru", type: String.self) else { return }
        
        ShiftService().getCompletedShiftsCountInfo(token: accessToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let count):
                    self.completedShiftsLabel.text = "\(count)"
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func fetchUserInfo(userInfoModel: UserInfoModel) {
        getCompletedShiftsCount()
        nameLabel.text = "\(userInfoModel.firstName) \(userInfoModel.middleName) \(userInfoModel.surname)"
        phoneLabel.text = userInfoModel.phone
        emailLabel.text = userInfoModel.email
    }
}
