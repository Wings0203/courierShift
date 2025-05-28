//
//  EditProfileVCExtension.swift
//  courierShift
//
//  Created by Татьяна Федотова on 17.05.2025.
//

import UIKit

extension EditProfileVC: UIAdaptivePresentationControllerDelegate {

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onDismiss?()
    }
}
