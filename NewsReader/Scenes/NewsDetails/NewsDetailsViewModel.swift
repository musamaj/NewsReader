//
//  NewsDetailsViewModel.swift
//  NewsReader
//
//  Created by Usama Jamil on 06/03/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

//MARK: Inputs
protocol NewsDetailsViewModelInputs {
    var saveObserver: AnyObserver<Void> {get}
}

//MARK: Outputs
protocol NewsDetailsViewModelOutputs {
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { get }
}

protocol NewsDetailsViewModelType {
    var inputs: NewsDetailsViewModelInputs { get }
    var outputs: NewsDetailsViewModelOutputs { get }
}

class NewsDetailsViewModel: NSObject, NewsDetailsViewModelType, NewsDetailsViewModelInputs, NewsDetailsViewModelOutputs {
    
    //MARK: Subjects
    
    private let fetchDataSubject = PublishSubject<Void>()
    private let saveSubject = PublishSubject<Void>()
    private let dataSourceSubject = BehaviorSubject<[SectionModel<Int, ReusableTableViewCellViewModelType>]>(value: [])
    
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    var inputs: NewsDetailsViewModelInputs { return self }
    var outputs: NewsDetailsViewModelOutputs { return self }
    
    public var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { return dataSourceSubject.asObservable() }
    private var newsDetails : NewsDetail?
    private var dbHelper : DBHelperType?
    
    
    // MARK: - Observer/Observables
    
    var saveObserver: AnyObserver<Void> { return saveSubject.asObserver() }
    
    
    // MARK: - Init
    
    init(newsDetail: NewsDetail, helper: DBHelperType) {
        super.init()
        
        self.newsDetails = newsDetail
        self.dbHelper = helper
        generateViewModels()
        
        saveSubject.subscribe { [weak self] event in
            let _ = self?.dbHelper?.save(object: NewsDetailRL().convertToNewsObject(object: newsDetail))
        }.disposed(by: disposeBag)
    }
    
    func generateViewModels() {
        if let details = newsDetails {
            let newsVM = NewsDetailsItemCellViewModel(newsDetail: details)
            dataSourceSubject.onNext([SectionModel.init(model: 0, items: [newsVM])])
        }
    }
}
