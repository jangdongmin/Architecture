import UIKit
import RxSwift
struct UserData {
    var id: String
    var avatar_url: String
    var score: String
    var login: String
    
    var favoriteState: Bool
    //var favoriteStarValue = BehaviorSubject<UIImage>(value: UIImage.init(named: "star_off")!)
    
    func favoriteUpdated(_ favoriteState: Bool) -> UserData {
        print(id)
        if favoriteState {
            SqlService.shared.saveData(id: id, avatar_url: avatar_url, score: score, login: login)
        } else {
             SqlService.shared.deleteData(id: id)
        }
        return UserData(id: id, avatar_url: avatar_url, score: score, login: login, favoriteState: favoriteState)
    }
    
    init(id: String, avatar_url: String, score: String, login: String, favoriteState: Bool) {
        self.id = id
        self.avatar_url = avatar_url
        self.score = score
        self.login = login
        self.favoriteState = favoriteState
    }
}
