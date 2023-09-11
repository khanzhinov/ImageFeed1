//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 06.09.2023.
//

import UIKit

final class AlertPresenter {
    private weak var delegate: AlertPresentableDelagate?
    
    init(delagate: AlertPresentableDelagate?) {
        self.delegate = delagate
    }
}

extension AlertPresenter: AlertPresenterProtocol {
    func show(_ alertArgs: AlertModel) {
        let alert = UIAlertController(title: alertArgs.title,
                                      message: alertArgs.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertArgs.buttonText, style: .default) { _ in
            alertArgs.completion()
        }
        
        alert.addAction(action)
        delegate?.present(alert: alert, animated: true)
    }
}
