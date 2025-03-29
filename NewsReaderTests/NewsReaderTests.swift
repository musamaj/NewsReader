//
//  NewsReaderTests.swift
//  NewsReaderTests
//
//  Created by Usama Jamil on 28/02/2022.
//

import XCTest
import RxSwift
@testable import NewsReader

class NewsReaderTests: XCTestCase {

    var sut: NewsListViewModelType!
    var controller: NewsListingController!
    var newsDetailVM : NewsDetailsViewModel!
    
    
    var dbHelper : DBHelperType!
    let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        super.setUp()
        
        dbHelper = DBHelper()
        sut = NewsListViewModel(helper: dbHelper)
        controller = NewsListingController(viewModel: sut)
        
        let details = NewsDetail()
        details.title = "L’ambassade d’allemagne au Maroc dément la publication d’un rapport des renseignements"
        details.datumDescription = "L’ambassade allemande à Rabat dément l’authenticité d’un rapport attribué aux services de renseignements en Allemagne (BND), consacré aux relations avec le Maroc. Le texte aurait rédigé par Isabel Werenfels, présentée par certains médias marocains comme la cheffe du bureau de renseignement pour l’Afrique du Nord et le Moyen-Orient au sein du BND. La semaine dernière, des extraits du prétendu rapport intitulé «Nous ne voulons pas d’une nouvelle Turquie en Méditerranée occidental», ont été relayé par certains sites marocains. "
        details.image = "https://static.yabiladi.com/files/articles/48ac2e85b365e88d32aa98d0762576b020211207235134150.png"
        
        newsDetailVM = NewsDetailsViewModel.init(newsDetail: details, helper: DBHelper())
    }
    
    func testApiFetching() {
        
        let expectation = self.expectation(description: "fetched")
        
        sut.inputs.fetchObserver.onNext(())
        sut.outputs.dataSource.subscribe { event in
            expectation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNewsActionOnSetup() {
        controller.setupViews()
        XCTAssertTrue(controller.newsButton.isSelected)
    }
    
    func testNewsDetailDataSource() {
        
        let expectation = self.expectation(description: "datasource")
        
        newsDetailVM.outputs.dataSource.subscribe { event in
            expectation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }

}
