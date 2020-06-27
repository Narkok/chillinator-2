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
        viewModel.output.didFinishLoading
            .delay(.seconds(2))
            .withLatestFrom(viewModel.output.musicList)
            .drive(onNext:{ [weak self] musicList in
                let playerController = PlayerViewController()
                playerController.modalPresentationStyle = .overFullScreen
                playerController.viewModel = PlayerViewModel(data: musicList)
                self?.present(playerController, animated: false)
            }).disposed(by: disposeBag)
    }
    
    
    /// Анимация лого
    private func animateLogo() {
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2, animations: { [weak self] in self?.logo.rotate(by: -CGFloat.pi / 40) })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: { [weak self] in self?.logo.rotate(by:  CGFloat.pi / 40) })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2, animations: { [weak self] in self?.logo.rotate(by: -CGFloat.pi / 40) })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2, animations: { [weak self] in self?.logo.rotate(by:  CGFloat.pi / 40) })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: { [weak self] in self?.logo.rotate(by: 0) })
        }) { [weak self] _ in self?.logo.fadeOut() }
    }
}
