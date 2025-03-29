//
//  AppCoordinator.swift
//  NewsReader
//
//  Created by Usama Jamil on 01/03/2022.
//

import Foundation
import UIKit
import RxSwift

class AppCoordinator: Coordinator<ResultType<Void>> {

    private let window: UIWindow
    private let mainResult = PublishSubject<ResultType<Void>>()
    var result = PublishSubject<ResultType<Void>>()

    init(window: UIWindow) {
        self.window = window
        super.init()

    }
    
    override func start() -> Observable<ResultType<Void>> {
        showMain()
        
        return result
    }
    
    func showMain() {
        coordinate(to: NewsListCoordinator(window: window))
            .subscribe(onNext: { [weak self] result in
                guard let `self` = self else { return }
                self.mainResult.onNext(result)
            })
            .disposed(by: disposeBag)
    }
}

