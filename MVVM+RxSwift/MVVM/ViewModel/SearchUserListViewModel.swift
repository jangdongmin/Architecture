import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON


struct Person {
    var userData: UserData
    var cell: SearchUserListCell
}

protocol SearchUserListViewModelType {
    var viewWillAppearOb: AnyObserver<Void> { get }
    var getSearchStr: BehaviorSubject<String> { get }
    var setSearchStr: BehaviorSubject<String> { get }
    
    var searchButtonClick: AnyObserver<Void> { get }
    var searchXButtonClick: AnyObserver<Void> { get }
    var nextPageButtonClick: AnyObserver<Void> { get }
     
    var allData: ReplaySubject<[UserData]>  { get }
    
//    var favoriteRelayFromCell: AnyObserver<(UserData)> { get }
    var favoriteClickByCell: AnyObserver<(UserData)> { get }
//    var favoriteCellClick: AnyObserver<Void> { get }
}

class SearchUserListViewModel: SearchUserListViewModelType {
    var viewWillAppearOb: AnyObserver<Void>
    
    var favoriteClickByCell: AnyObserver<(UserData)>
//    var favoriteCellClick: AnyObserver<Void>
    
    var getSearchStr = BehaviorSubject<String>(value: "")
    var setSearchStr = BehaviorSubject<String>(value: "")
    var allData = ReplaySubject<[UserData]>.create(bufferSize: 1)
   
    var searchButtonClick: AnyObserver<Void>
    var searchXButtonClick: AnyObserver<Void>
    var nextPageButtonClick: AnyObserver<Void>
     
    var tableViewData: [UserData] = []
    
    let disposeBag = DisposeBag()
    
    var page: Int = 1
    
    init() {
        SqlService.shared.searchAllData()
        
        let viewWillAppearPS = PublishSubject<Void>()
        let searchButtonPS = PublishSubject<Void>()
        let searchXButtonPS = PublishSubject<Void>()
        let nextPageButtonPS = PublishSubject<Void>()
//        let mfavoriteRelayFromCell = BehaviorSubject<(UserData, SearchUserListCell)>(value: UserData(id: "", avatar_url: "", score: "", login: ""))
        let favoriteClickByCell_PS = PublishSubject<(UserData)>()
        
        favoriteClickByCell = favoriteClickByCell_PS.asObserver()
        searchButtonClick = searchButtonPS.asObserver()
        searchXButtonClick = searchXButtonPS.asObserver()
        nextPageButtonClick = nextPageButtonPS.asObserver()
        
        viewWillAppearOb = viewWillAppearPS.asObserver()
        viewWillAppearPS
            .map({ _ -> [UserData] in
                return SqlService.shared.searchAllData()
            })
            .subscribe({ favoriteData in
                self.allData.onNext(favoriteData.element!)
            })
            .disposed(by: disposeBag)
        
        searchButtonPS.withLatestFrom(getSearchStr)
            .flatMapLatest { searchString -> Observable<JSON> in
                return NetworkService.init().fetchUserInfoList(searchText: searchString, page: self.page)
            }
            .map({ (JSON) -> Array<UserData> in
                var dataList = Array<UserData>()
                for (_, value) in JSON {
                    let data = UserData(id: value["id"].stringValue, avatar_url: value["avatar_url"].stringValue, score: value["score"].stringValue, login: value["login"].stringValue, favoriteState: false)
                    dataList.append(data)
                }
                return dataList
            })
            .subscribe(onNext: {
                self.tableViewData += $0
                self.allData.onNext(self.tableViewData)
            })
            .disposed(by: disposeBag)
        
        nextPageButtonPS
            .subscribe { _ in
                self.page += 1
                searchButtonPS.onNext(())
            }
            .disposed(by: disposeBag)
            
        searchXButtonPS
            .subscribe { _ in
                self.setSearchStr.onNext("")
                self.allData.onNext([])
            }
            .disposed(by: disposeBag)
        //userdata, cell
        favoriteClickByCell_PS.map { (userData) -> UserData in
            if userData.favoriteState {
                return userData.favoriteUpdated(false)
            } else {
                return userData.favoriteUpdated(true)
            }
        }.withLatestFrom(allData) { (updated, originals) -> [UserData] in
            originals.map {
                guard $0.id == updated.id else { return $0 }
                return updated
            }
        }.subscribe(onNext: allData.onNext).disposed(by: disposeBag)
        //.subscribe(onNext: allData.onNext).disposed(by: disposeBag)
        
        
        
//            .subscribe(onNext: {
//                print($0.0.id)
//                if SqlService.shared.idSet.contains($0.0.id) {
//                    $0.0.favoriteStarValue.onNext(UIImage.init(named: "star_off")!)
////                    SqlService.shared.deleteData(id: $0.0.id)
//
//                } else {
//                    $0.0.favoriteStarValue.onNext(UIImage.init(named: "star_on")!)
////                    SqlService.shared.saveData(id: $0.0.id, avatar_url: $0.0.avatar_url, score: $0.0.score, login: $0.0.login)
//                }
//            })
             
    }
}
