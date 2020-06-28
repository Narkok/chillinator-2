//
//  StartScreenViewController.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 20/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import UIKit
import RxSwift

class StartScreenViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    
    private let viewModel = StartScreenViewModel()
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Анимация лого
        viewModel.output.didFinishLoading
            .drive(onNext:{ [weak self] in self?.animateLogo()})
            .disposed(by: disposeBag)
        
        /// Переход к плееру
        viewModel.output.player
            .delay(.seconds(2))
            .drive(onNext:{ [weak self] player in
                let playerController = PlayerViewController()
                playerController.modalPresentationStyle = .overFullScreen
                playerController.viewModel = PlayerViewModel(with: player)
                self?.present(playerController, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    
    /// Анимация лого
    private func animateLogo() {
        func addKeyframe(startTime: Double, rotateDirection: CGFloat) {
            UIView.addKeyframe(withRelativeStartTime: startTime, relativeDuration: 0.2, animations: { [weak logo] in logo?.rotate(by: rotateDirection * CGFloat.pi / 40) })
        }
        
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: .calculationModeLinear, animations: {
            addKeyframe(startTime: 0.0, rotateDirection: -1)
            addKeyframe(startTime: 0.2, rotateDirection:  1)
            addKeyframe(startTime: 0.4, rotateDirection: -1)
            addKeyframe(startTime: 0.6, rotateDirection:  1)
            addKeyframe(startTime: 0.8, rotateDirection:  0)
        }) { [weak self] _ in self?.logo.fadeOut() }
    }
}
