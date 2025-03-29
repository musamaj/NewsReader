//
//  ApiResponseTests.swift
//  NewsReaderTests
//
//  Created by Usama Jamil on 07/03/2022.
//

import XCTest
@testable import NewsReader

class ApiResponseTests: XCTestCase {
    
    var sut: News!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        try givenSUTFromJSON()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    
    // MARK: - Type Tests
    func testConformsToDecodable() {
        XCTAssertTrue((sut as Any) is Decodable) 
    }
    
    func testDecodableSetsPaginationData() {
        XCTAssertEqual(sut.pagination.total, 10000)
    }

    func testDecodableSetsTitle() {
        XCTAssertEqual(sut.data[0].title, "L’ambassade d’allemagne au Maroc dément la publication d’un rapport des renseignements")
    }

    func testDecodableSetsSource() {
        XCTAssertEqual(sut.data[0].source, "yabiladi.com")
    }
    
    func testDecodableSetsDate() {
        XCTAssertEqual(sut.data[0].publishedAt, "2021-12-07T22:58:00+00:00")
    }
    
    private func givenSUTFromJSON() throws {
        let decoder = JSONDecoder()
        let data = try Data.fromJSON(fileName: "data")
        let launchResponse = try decoder.decode(News.self, from: data)
        sut = launchResponse
    }
}
