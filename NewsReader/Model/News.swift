//
//  News.swift
//  NewsReader
//
//  Created by Usama Jamil on 04/03/2022.
//

import Foundation
import RealmSwift

// MARK: - News
public struct News: Codable {
    let pagination: Pagination
    let data: [NewsDetail]
    
    enum CodingKeys: String, CodingKey {

       case pagination = "pagination"
       case data       = "data"
     
     }
}


// MARK: - Details
class NewsDetail: Codable {
    var author: String?
    var title: String?
    var datumDescription: String?
    var url: String?
    var source: String?
    var image: String?
    var category: String?
    var language: String?
    var country: String?
    var publishedAt: String?

    enum CodingKeys: String, CodingKey {
        case author, title
        case datumDescription = "description"
        case url, source, image, category, language, country
        case publishedAt = "published_at"
    }
    
    func convertToNewsObject(object: NewsDetailRL)-> NewsDetail {
        self.author = object.author
        self.title = object.title
        self.datumDescription = object.datumDescription
        self.url = object.url
        self.source = object.source
        self.image = object.image
        self.category = object.category
        self.language = object.language
        self.publishedAt = object.publishedAt
        
        return self
    }
}


// MARK: - Realm model

class NewsDetailRL: Object {
    @Persisted var author: String?
    @Persisted var title: String?
    @Persisted var datumDescription: String?
    @Persisted var url: String?
    @Persisted var source: String?
    @Persisted var image: String?
    @Persisted var category: String?
    @Persisted var language: String?
    @Persisted var country: String?
    @Persisted var publishedAt: String?
    
    override static func primaryKey() -> String? {
            return "publishedAt"
    }
    
    func convertToNewsObject(object: NewsDetail)-> NewsDetailRL {
        self.author = object.author
        self.title = object.title
        self.datumDescription = object.datumDescription
        self.url = object.url
        self.source = object.source
        self.image = object.image
        self.category = object.category
        self.language = object.language
        self.publishedAt = object.publishedAt
        
        return self
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let limit, count, total: Int
    var offset: Int
}
