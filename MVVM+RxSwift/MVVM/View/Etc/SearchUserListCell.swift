import UIKit
import RxSwift
import SDWebImage
protocol SearchUserListCellDelegate {
    func selectButtonClick(index: Int)
}

class SearchUserListCell: UITableViewCell {
    
    private let onFavoriteButtonChanged: (Int) -> Void
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var favoriteStar: UIButton!
    
    var searchUserListCellDelegate: SearchUserListCellDelegate?
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<UserData>
    let onChanged: Observable<Int>
    
    required init?(coder aDecoder: NSCoder) {
        let data = PublishSubject<UserData>()
        let changing = AsyncSubject<Int>()
        
        onChanged = changing
        onFavoriteButtonChanged = { changing.onNext($0) }
        
        onData = data.asObserver()

        super.init(coder: aDecoder)
        
        data.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] userData in
                self?.backgroundColor = .clear
                self?.selectionStyle = .none
                self?.userName?.text = userData.login
                self?.userScore?.text = userData.score

//                userData.favoriteStarValue
//                    .bind(to: (self?.favoriteStar.rx.image(for: UIControl.State.normal))!)
//                    .disposed(by: self!.disposeBag)
//                
//                if SqlService.shared.idSet.contains(userData.id) {
//                    userData.favoriteStarValue.onNext(UIImage.init(named: "star_on")!)
////                    self?.favoriteStar.setImage(UIImage.init(named: "star_on"), for: UIControl.State.normal)
//                } else {
//                    userData.favoriteStarValue.onNext(UIImage.init(named: "star_off")!)
////                    self?.favoriteStar.setImage(UIImage.init(named: "star_off"), for: UIControl.State.normal)
//                }
                
                self?.avatarImg.sd_setImage(with: URL(string: userData.avatar_url))
            })
            .disposed(by: disposeBag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //disposeBag = DisposeBag()
    }
 
    @IBAction func favoriteButtonClick(_ sender: Any) {
        print("favoriteButtonClick")
        onFavoriteButtonChanged(1)
    }
}


