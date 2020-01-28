import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON


struct Person {
    var userData: UserData
    var cell: SearchUserListCell
}

protocol SearchUserListViewModelType {
    var allData: Observable<[UserData]> { get }
    
    var viewWillAppearOb: AnyObserver<Void> { get }
    
    var searchButtonClick: AnyObserver<Void> { get }
    var searchXButtonClick: AnyObserver<Void> { get }
    var nextPageButtonClick: AnyObserver<Void> { get }
    var favoriteClickByCell: AnyObserver<(UserData)> { get }
    
    var getSearchStr: BehaviorSubject<String> { get }
    var setSearchStr: BehaviorSubject<String> { get }
}

class SearchUserListViewModel: SearchUserListViewModelType {
    var getSearchStr = BehaviorSubject<String>(value: "")
    var setSearchStr = BehaviorSubject<String>(value: "")
    
    var allData: Observable<[UserData]>
    
    var viewWillAppearOb: AnyObserver<Void>
    var favoriteClickByCell: AnyObserver<(UserData)>
    
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
        let allData_BS = BehaviorSubject<[UserData]>(value: [])
        
        let favoriteClickByCell_PS = PublishSubject<(UserData)>()
        
        favoriteClickByCell = favoriteClickByCell_PS.asObserver()
        searchButtonClick = searchButtonPS.asObserver()
        searchXButtonClick = searchXButtonPS.asObserver()
        nextPageButtonClick = nextPageButtonPS.asObserver()
        viewWillAppearOb = viewWillAppearPS.asObserver()
        
        allData = allData_BS
        
        viewWillAppearPS
            .map({ _ -> [UserData] in
                return SqlService.shared.searchAllData()
            })
            .subscribe({ favoriteData in
                allData_BS.onNext(favoriteData.element!)
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
                allData_BS.onNext(self.tableViewData)
            })
            .disposed(by: disposeBag)
        
        nextPageButtonPS.withLatestFrom(getSearchStr)
            .subscribe(onNext: { (searchStr) in
                if searchStr.count > 0 {
                    self.page += 1
                    searchButtonPS.onNext(())
                }
            }).disposed(by: disposeBag)

        searchXButtonPS
            .subscribe { _ in
                self.setSearchStr.onNext("")
                allData_BS.onNext([])
            }
            .disposed(by: disposeBag)
        //userdata, cell
        favoriteClickByCell_PS.map { (userData) -> UserData in
            print("favoriteClickByCell_PS")
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
        }.subscribe(onNext: allData_BS.onNext).disposed(by: disposeBag)
    }
}
