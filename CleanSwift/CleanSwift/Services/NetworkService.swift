import Foundation
import Alamofire
import SwiftyJSON

class NetworkService {
    static let shared = NetworkService()
    
    private var searchUrl = "https://api.github.com/search/users"
     
    func fetchUserInfoList(searchText: String?, page: Int, completionHandler: @escaping (Result<JSON, Error>) -> Void) {
        let parameters: Parameters = ["q": searchText!, "page": page]
        AF.request(searchUrl, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON(queue: .main, options: .allowFragments, completionHandler: { response in
                 switch response.result {
                 case .success(let userDatas):
                    let json = JSON(userDatas)
                    completionHandler(.success(json["items"]))
                 case .failure(let error):
                    completionHandler(.failure(error))
                }})
    }
}
 
