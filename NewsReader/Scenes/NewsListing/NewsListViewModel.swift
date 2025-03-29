//
//  NewsListingVM.swift
//  NewsReader
//
//  Created by Usama Jamil on 01/03/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

//MARK: Inputs
protocol NewsListViewModelInputs {
    var fetchObserver: AnyObserver<Void> {get}
    var cellSelectionObserver: AnyObserver<NewsDetail> {get}
    var newsObserver: AnyObserver<Void> {get}
    var savedNewsObserver: AnyObserver<Void> {get}
}

//MARK: Outputs
protocol NewsListViewModelOutputs {
    var fetchData: Observable<Void> {get}
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { get }
    var cellSelection: Observable<NewsDetail> {get}
}

protocol NewsListViewModelType {
    var inputs: NewsListViewModelInputs { get }
    var outputs: NewsListViewModelOutputs { get }
}

public class NewsListViewModel: NSObject, NewsListViewModelType, NewsListViewModelInputs, NewsListViewModelOutputs {
    
    //MARK: Subjects
    
    private let fetchDataSubject = PublishSubject<Void>()
    private let cellSelectionSubject = PublishSubject<NewsDetail>()
    private let newsSubject = PublishSubject<Void>()
    private let savedNewsSubject = PublishSubject<Void>()
    private let dataSourceSubject = BehaviorSubject<[SectionModel<Int, ReusableTableViewCellViewModelType>]>(value: [])
    
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    var inputs: NewsListViewModelInputs { return self }
    var outputs: NewsListViewModelOutputs { return self }
    private let apiClient = WebAPIClient()
    
    public var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { return dataSourceSubject.asObservable() }
    private var newsList = [NewsDetail]()
    private var pagination = Pagination.init(limit: 10, count: 10, total: 10, offset: 0)
    private var savedNewsList = [NewsDetail]()
    private var vmsList  = [ReusableTableViewCellViewModelType]()
    private var dbHelper : DBHelperType?
    
    var repository : ApiRepository { ApiRepository(client: WebAPIClient())}
    
    
    // MARK: - Observer/Observables
    
    var fetchData: Observable<Void> { return fetchDataSubject.asObservable() }
    var fetchObserver: AnyObserver<Void> { return fetchDataSubject.asObserver()}
    var cellSelection: Observable<NewsDetail> { return cellSelectionSubject.asObservable() }
    var cellSelectionObserver: AnyObserver<NewsDetail> { return cellSelectionSubject.asObserver() }
    var savedNewsObserver: AnyObserver<Void> { return savedNewsSubject.asObserver() }
    var newsObserver: AnyObserver<Void> { return newsSubject.asObserver() }
    
    
    // MARK: - Init
    
    init(helper: DBHelperType) {
        super.init()
        
        self.dbHelper = helper
        self.fetchSavedNews()
        
        if pagination.offset + pagination.limit <= pagination.total {
            fetchDataSubject.asObservable()
                .map { NewsRequest(pagination: self.pagination) }
                .flatMapLatest { [unowned self] request -> Observable<News> in
                    return self.repository.fetchNews(apiRequest: request)
                }.subscribe({ event in
                    if let element = event.element {
                        print(element.pagination)
                        self.newsList.append(contentsOf: element.data)
                        self.pagination = element.pagination
                        self.pagination.offset = element.pagination.offset + element.pagination.limit
                        self.generateViewModels(newsCollection: self.newsList)
                    }
                })
                .disposed(by: disposeBag)
        }
        
        newsSubject.subscribe { [weak self] event in
            guard let self = self else {return}
            self.generateViewModels(newsCollection: self.newsList)
            
        }.disposed(by: disposeBag)
        
        savedNewsSubject.subscribe { [weak self] event in
            guard let self = self else {return}
            self.fetchSavedNews()
            self.generateViewModels(newsCollection: self.savedNewsList)
        }.disposed(by: disposeBag)
        
    }
    
    func fetchSavedNews() {
        if let db = dbHelper {
            savedNewsList = db.fetch()
        }
    }
    
    func generateViewModels(newsCollection: [NewsDetail]) {
        vmsList.removeAll()
        for news in newsCollection {
            let newsVM = NewsItemCellViewModel(newsDetail: news)
            vmsList.append(newsVM)
        }
        dataSourceSubject.onNext([SectionModel.init(model: 0, items: vmsList)])
    }
}

