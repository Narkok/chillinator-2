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

    @IBOutlet weak var disk: Disk!
    
    @IBOutlet weak var button: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.rx.tap.asDriver().drive(onNext:{ [unowned self] _ in
            let images = ["http://nrkk.ru/frogogoTestAppAvatars/avatar1.png",
                          "http://nrkk.ru/frogogoTestAppAvatars/avatar2.png",
                          "http://nrkk.ru/frogogoTestAppAvatars/avatar3.png",
                          "http://nrkk.ru/frogogoTestAppAvatars/avatar4.png",
                          "http://nrkk.ru/frogogoTestAppAvatars/avatar5.png"]
            let num = Int.random(in: 0..<images.count)
            self.disk.setCover(url: images[num])
            self.disk.setPlayHeadPosition(relativeTime: 0)
            self.disk.setState(.start)
        }).disposed(by: disposeBag)
        
    }
}
