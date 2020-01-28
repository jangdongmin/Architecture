import UIKit
import RxSwift
import SDWebImage
protocol SearchUserListCellDelegate {
    func selectButtonClick(index: Int)
}

class SearchUserListCell: UITableViewCell {
    
    private let onFavoriteButtonChanged: () -> Void
    private let cellDisposeBag = DisposeBag()
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var favoriteStar: UIButton!
    
    var searchUserListCellDelegate: SearchUserListCellDelegate?
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<UserData>
    let onChanged: Observable<Void>
    
    required init?(coder aDecoder: NSCoder) {
        let data = PublishSubject<UserData>()
        let changing = PublishSubject<Void>()
        
        onChanged = changing
        onFavoriteButtonChanged = { changing.onNext(()) }
        
        onData = data.asObserver()

        super.init(coder: aDecoder)
        
        data.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] userData in
                self?.backgroundColor = .clear
                self?.selectionStyle = .none
                self?.userName?.text = userData.login
                self?.userScore?.text = userData.score
                
                if SqlService.shared.idSet.contains(userData.id) {
                    self?.favoriteStar.setImage(UIImage.init(named: "star_on"), for: UIControl.State.normal)
                } else {
                    self?.favoriteStar.setImage(UIImage.init(named: "star_off"), for: UIControl.State.normal)
                }
                
                self?.avatarImg.sd_setImage(with: URL(string: userData.avatar_url))
            })
            .disposed(by: cellDisposeBag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
 
    @IBAction func favoriteButtonClick(_ sender: Any) {
        print("favoriteButtonClick")
        onFavoriteButtonChanged()
    }
}


