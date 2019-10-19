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
    
    let viewModel = PlayerViewModel()

    @IBOutlet weak var disk: Disk!
    
    @IBOutlet weak var button: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
