//
//  NewsItemCellViewModel.swift
//  NewsReader
//
//  Created by Usama Jamil on 05/03/2022.
//

import Foundation
import RxSwift


// MARK: - Inputs

protocol NewsItemCellViewModelInputs {
    var imageUrlObserver: AnyObserver<String> {get}
    var newsTitleObserver: AnyObserver<String> {get}
    var newsDescObserver: AnyObserver<String> {get}
    var timeObserver: AnyObserver<String> {get}
}


// MARK: - Outputs

protocol NewsItemCellViewModelOutputs {
    var imageUrl: Observable<String> {get}
    var newsTitle: Observable<String> {get}
    var newsDesc: Observable<String> {get}
    var time: Observable<String> {get}
}

protocol NewsItemCellViewModelType {
    var inputs: NewsItemCellViewModelInputs { get }
    var outputs: NewsItemCellViewModelOutputs { get }
}

class NewsItemCellViewModel: NewsItemCellViewModelType, NewsItemCellViewModelInputs, NewsItemCellViewModelOutputs, ReusableTableViewCellViewModelType {
    
    
    // MARK: - Properties
    
    var inputs: NewsItemCellViewModelInputs { return self}
    var outputs: NewsItemCellViewModelOutputs { return self }
    var reusableIdentifier: String { return NewsItemCell.reuseIdentifier }
    
    // MARK: - Subjects
    
    var imageSubject : BehaviorSubject<String>
    var titleSubject : BehaviorSubject<String>
    var descSubject  : BehaviorSubject<String>
    var timeSubject  : BehaviorSubject<String>
    
    // MARK: - Observer/Observables
    
    var imageUrl: Observable<String> { return imageSubject.asObservable() }
    var imageUrlObserver: AnyObserver<String> { return imageSubject.asObserver() }
    var newsTitle: Observable<String> { return titleSubject.asObservable() }
    var newsTitleObserver: AnyObserver<String> { return titleSubject.asObserver() }
    var newsDesc: Observable<String> { return descSubject.asObservable() }
    var newsDescObserver: AnyObserver<String> { return descSubject.asObserver() }
    var timeObserver: AnyObserver<String> { return timeSubject.asObserver() }
    var time: Observable<String> { return timeSubject.asObservable() }
    
    var newsDetails: NewsDetail
    
    
    init(newsDetail: NewsDetail) {
        self.newsDetails = newsDetail
        titleSubject = BehaviorSubject<String>(value: newsDetail.title ?? "")
        descSubject = BehaviorSubject<String>(value: newsDetail.datumDescription ?? "")
        imageSubject = BehaviorSubject<String>(value: newsDetail.image ?? "")
        timeSubject = BehaviorSubject<String>(value: newsDetail.publishedAt ?? "")
    }

    
}
