import Foundation

class NewsRequest: APIRequest {
    var baseURL = URL(string: "http://api.mediastack.com/")!
    var method = ApiRequestType.GET
    var path = "v1/news"
    var parameters = [String: String]()

    init(pagination: Pagination) {
        parameters["access_key"] = "c80a89c14e4cb3a21d55071a248b0d71"
        parameters["offset"] = String(pagination.offset)
        parameters["limit"] = String(pagination.limit)
    }
}
