//
//  HomeViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/13.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: BaseViewModel {
    
    struct Input {
        let wsNameButton: ControlEvent<Void>
        let myProfileButton: ControlEvent<Void>
        let createButton: ControlEvent<Void>
        let postButton: ControlEvent<Void>
    }
    
    struct Output {
       
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        
        return Output(
        )
    }
    
}
