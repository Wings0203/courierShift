//
//  MainScreenViewController.swift
//  courierShift
//
//  Created by Татьяна Федотова on 04.03.2025.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    private let build = MainView.shared
    private var segments = [UIViewController]()
    private var currentVC: UIViewController?

    private var segmentControl = CustomSegmentControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNavigationBar()
        initSegments()
        setUpSegmentControl()
        switchToSegment(index: 0)
        segmentControl.selectedSegmentIndex = 0
    }
    
    private func setUpNavigationBar() {
        title = "Мои смены"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill.badge.xmark"), style: .plain, target: self, action: #selector(logout))
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        navigationItem.backBarButtonItem = backButton
    }
    
    private func initSegments() {
        let myShifts = MyShiftsVC()
        let choseShift = ChoseShiftVC()
        let profile = ProfileVC()
        segments = [myShifts, choseShift, profile]
    }
    
    private func setUpSegmentControl() {
        segmentControl = build.segmentControl
        segmentControl.commaSeparatedButtonTitles = "Мои смены, Выбрать смену, Профиль"
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        view.addSubview(segmentControl)
        
        NSLayoutConstraint.activate([
            segmentControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }
    
    private func switchToSegment(index: Int) {
        if let current = currentVC {
            current.willMove(toParent: nil)
            current.view.removeFromSuperview()
            current.removeFromParent()
        }
        
        let selectedSegment = segments[index]
        addChild(selectedSegment)
        view.addSubview(selectedSegment.view)
        selectedSegment.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectedSegment.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectedSegment.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectedSegment.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectedSegment.view.bottomAnchor.constraint(equalTo: segmentControl.topAnchor)
        ])
        
        selectedSegment.didMove(toParent: self)
        currentVC = selectedSegment
    }
    
    @objc private func segmentChanged(_ sender: CustomSegmentControl) {
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            title = "Мои смены"
        case 1:
            title = "Выбрать смену"
        case 2:
            title = "Профиль"
        default:
            title = ""
        }
        switchToSegment(index: index)
    }
    
    @objc private func logout() {
        UserDefaults.standard.setValue(false, forKey: "isAuthorized")
        KeychainTokens.standart.delete(service: "accessToken", account: "londxz@yandex.ru")
        KeychainTokens.standart.delete(service: "refreshToken", account: "londxz@yandex.ru")
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let vc = LoginViewController(authService: AuthService())
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.tintColor = .black
            sceneDelegate.window?.rootViewController = navController
        }
        
        segmentControl.selectedSegmentIndex = 0
        print("logout done")
    }
}
