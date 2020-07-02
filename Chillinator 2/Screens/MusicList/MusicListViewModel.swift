//
//  MusicListViewModel.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 22/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MusicListViewModel {
    
    let input = Input()
    let output: Output
    
    struct Input {
        let view = View()
        let parent = Parent()
        
        struct View {
            let willClose = PublishRelay<Void>()
        }
        
        struct Parent {
            let isPlaying = PublishRelay<Bool>()
        }
    }
    
    struct Output {
        let view: View
        let parent: Parent
        
        struct View {
            
        }
        
        struct Parent {
            let willClose: Driver<Void>
        }
    }
    
    
    init(data: Player) {
        
        let outputView = Output.View()
        
        let outputParent = Output.Parent(willClose: input.view.willClose.asDriver())
        
        output = Output(view: outputView,
                        parent: outputParent)
    }
}
