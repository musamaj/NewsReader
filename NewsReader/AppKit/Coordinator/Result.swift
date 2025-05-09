//
//  Result.swift
//  NewsReader
//
//  Created by Usama Jamil on 28/02/2022.
//

import Foundation

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}

public enum ResultType<T> {
    case success(T)
    case cancel
    
    public var isCancel: Bool {
        if case ResultType.cancel = self {
            return true
        }
        return false
    }
    
    public var isSuccess: T? {
        guard !isCancel else { return nil }
        if case let ResultType.success(value) = self {
            return value
        }
        return nil
    }

}
