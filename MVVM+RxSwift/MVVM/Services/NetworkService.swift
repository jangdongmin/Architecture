import Foundation
import Alamofire
import SwiftyJSON
import RxCocoa
import RxSwift

class NetworkService {
    static let shared = NetworkService()
    let disposeBag = DisposeBag()
    private var searchUrl = "https://api.github.com/search/users"

    func fetchUserInfoList(searchText: String?, page: Int) -> Observable<JSON> {
        let parameters: Parameters = ["q": searchText!, "page": page]
             
        return Observable<JSON>.create { observer in
            AF.request(self.searchUrl, method: .get, parameters: parameters, encoding: URLEncoding.default)
                .responseJSON(queue: .main, options: .allowFragments, completionHandler: { response in
                    switch response.result {
                        case .success(let userDatas):
                            let json = JSON(userDatas)
                            observer.onNext(json["items"])
                        case .failure(let error):
                            observer.onError(error)
                    }
                    
                    observer.onCompleted()
                })
            
            return Disposables.create()
        }
    }
}
 
