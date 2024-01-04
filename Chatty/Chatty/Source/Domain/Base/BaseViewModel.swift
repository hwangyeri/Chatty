//
//  BaseViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import Foundation

protocol BaseViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
