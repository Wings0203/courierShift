//
//  ProfileView.swift
//  courierShift
//
//  Created by Татьяна Федотова on 16.05.2025.
//

import UIKit

class ProfileView {
    static let shared = ProfileView()
    private init() {}
    
    let noProfieIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = .noProfileIcon
        iv.contentMode = .scaleAspectFit
        
        iv.widthAnchor.constraint(equalTo: iv.heightAnchor).isActive = true
        
        return iv
    }()
    
    let editIcon: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "pencil.circle.fill", withConfiguration: config)
        btn.setImage(image, for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.tintColor = .black
        
        return btn
    }()
    
    let credentialsIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "person")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black
        
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: 24),
            iv.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Regular", size: 16)
        
        return lbl
    }()
    
    let phoneIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "phone")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black
        
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: 24),
            iv.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return iv
    }()
    
    let phoneLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Regular", size: 16)
        
        return lbl
    }()
    
    let emailIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "envelope")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black
        
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: 24),
            iv.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return iv
    }()
    
    let emailLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Regular", size: 16)
        
        return lbl
    }()
    
    let completedShiftsIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = .courierIcon
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black
        
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: 24),
            iv.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return iv
    }()
    
    let completedShiftsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Regular", size: 16)
        
        return lbl
    }()
    
    let deleteProfileButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Удалить аккаунт", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
}
