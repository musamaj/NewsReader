//
//  DBManager.swift
//  RxSwiftPractice
//
//  Created by Usama Jamil on 21/12/2021.
//

import Foundation
import RealmSwift

protocol DBHelperType {
    func save(object: NewsDetailRL)
    func fetch()-> [NewsDetail]
}

class DBHelper: DBHelperType {
    
    static let shared = DBHelper()
    
    func save(object: NewsDetailRL) {
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func fetch()-> [NewsDetail] {
        
        let realm = try! Realm()
        let news = realm.objects(NewsDetailRL.self)
        
        var newsObjects = [NewsDetail]()
        for obj in news {
            newsObjects.append(NewsDetail().convertToNewsObject(object: obj))
        }
        
        return Array(newsObjects)
    }
    
}
