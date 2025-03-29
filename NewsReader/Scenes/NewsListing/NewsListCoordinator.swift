//
//  NewsListCoordinator.swift
//  NewsReader
//
//  Created by Usama Jamil on 01/03/2022.
//

import Foundation
import UIKit
import RxSwift

protocol NewsListCoordinatorType: Coordinator<ResultType<Void>> {
    
    var root: UINavigationController! { get }
}

class NewsListCoordinator: Coordinator<ResultType<Void>>, NewsListCoordinatorType {
    
    //MARK: Properties
    
    var root: UINavigationController!
    var result = PublishSubject<ResultType<Void>>()
    private let window: UIWindow
    
    
    //MARK: Init

    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<ResultType<Void>> {
        
        let viewModel: NewsListViewModelType = NewsListViewModel(helper: DBHelper())
        let mainVC = NewsListingController(viewModel: viewModel)
        root = UINavigationController(rootViewController: mainVC)
        
        root.interactivePopGestureRecognizer?.isEnabled = false
        root.navigationBar.setBackgroundImage(UIImage(), for: .default)
        root.navigationBar.shadowImage = UIImage()
        root.navigationBar.isTranslucent = true
        root.navigationBar.tintColor = .primary
        root.navigationBar.isHidden = false
        
    
        self.window.rootViewController = self.root
        self.window.makeKeyAndVisible()
        
        viewModel.outputs.cellSelection.subscribe { [weak self] event in
            guard let self = self else {return}
            if let details = event.element {
                self.navigateToDetails(details: details)
            }
        }.disposed(by: disposeBag)
        
        
        return result
    }
    
    func navigateToDetails(details: NewsDetail) {
        let detailVM = NewsDetailsViewModel.init(newsDetail: details, helper: DBHelper())
        let viewController = NewsDetailsController(viewModel: detailVM)
        root.pushViewController(viewController, animated: true)
    }
}

