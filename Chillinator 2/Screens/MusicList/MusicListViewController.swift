//
//  MusicListViewController.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 22/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import UIKit

class MusicListViewController: UIViewController {
    
    var viewModel: MusicListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.dismiss(animated: true)
    }
}
