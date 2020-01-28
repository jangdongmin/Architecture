import UIKit
import RxCocoa
import RxSwift
import RxViewController

class FavoriteListViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel: SearchUserListViewModelType
   
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var favoriteListTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchXButton: UIButton!
    @IBOutlet weak var nextPageButton: UIButton!
    
    init(viewModel: SearchUserListViewModelType = SearchUserListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
           viewModel = SearchUserListViewModel()
           super.init(coder: aDecoder)
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
        setupBindings()
    }
    
    func setupBindings() {
        favoriteListTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let viewDidAppear = rx.viewWillAppear.map { _ in () }
        viewDidAppear
            .bind(to: viewModel.viewWillAppearOb)
            .disposed(by: disposeBag)
        
        searchTextField.rx.text
            .orEmpty
            .bind(to: viewModel.getSearchStr)
            .disposed(by: disposeBag)
        
        viewModel.setSearchStr
            .bind(to: searchTextField.rx.text)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .bind(to: viewModel.searchButtonClick)
            .disposed(by: disposeBag)
        
        searchXButton.rx.tap
            .bind(to: viewModel.searchXButtonClick)
            .disposed(by: disposeBag)
        
        nextPageButton.rx.tap
            .bind(to: viewModel.nextPageButtonClick)
            .disposed(by: disposeBag)
         
        viewModel.allData
            .bind(to: favoriteListTableView.rx.items(cellIdentifier: "SearchUserListCell",
                                         cellType: SearchUserListCell.self)) {
                _, item, cell in

                cell.onData.onNext(item)
                cell.onChanged
                    .map { _ in (item) }
                    .bind(to: self.viewModel.favoriteClickByCell)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

extension FavoriteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

