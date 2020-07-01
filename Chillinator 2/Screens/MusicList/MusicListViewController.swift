//
//  MusicListViewController.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 22/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import UIKit

class MusicListViewController: UIViewController {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var viewModel: MusicListViewModel?

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
        open()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        close()
    }
    
    
    private func setup() {
        
    }
    
    
    /// Открыть список композиций
    private func open() {
        heightConstraint.constant = 550
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    
    /// Скрыть список композиций
    private func close() {
        heightConstraint.constant += 10
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { [weak self] _ in
            self?.heightConstraint.constant = 0
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            }) { [weak self] _ in self?.dismiss(animated: false) }
        }
    }
}
