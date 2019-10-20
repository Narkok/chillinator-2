//
//  PlayerViewController.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 18/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class PlayerViewController: UIViewController {
    
    var viewModel: PlayerViewModel?

    @IBOutlet weak var disk: Disk!
    
    @IBOutlet weak var button: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        
        guard let viewModel = viewModel else { return }
        print(viewModel)
    }
    
    
    /// Настройка экрана
    private func setup() {
        view.alpha = 0
        view.fadeIn()
    }
}
