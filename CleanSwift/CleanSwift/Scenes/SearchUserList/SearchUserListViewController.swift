//
//  SearchUserListViewController.swift
//  CleanSwift_test
//
//  Created by Paul Jang on 2019/12/22.
//  Copyright (c) 2019 Paul Jang. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Alamofire
import SDWebImage


protocol SearchUserListDisplayLogic: class {
    func displaySearchList(viewModel: SearchUserList.listPreview.ViewModel)
}

class SearchUserListViewController: UIViewController, SearchUserListDisplayLogic  {
    var interactor: SearchUserListBusinessLogic?
    var router: (NSObjectProtocol & SearchUserListRoutingLogic & SearchUserListDataPassing)?
     
    var displayedDatas: [SearchUserList.listPreview.ViewModel.listPreviewData] = []
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchListTableView: UITableView!
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = SearchUserListInteractor()
        let presenter = SearchUserListPresenter()
        let router = SearchUserListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
  
    // MARK: Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
  
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
         
        searchTextField.delegate = self
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
        
        interactor?.doDBLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchListTableView.reloadData()
    }
    
    func gitSearch(search_word: String?)
    {
        let request = SearchUserList.listPreview.Request(searchText: search_word)
        interactor?.pageInit()
        interactor?.doSearchUser(request: request)
    }
    
    @IBAction func searchButtonClick(_ sender: Any) {
        gitSearch(search_word: searchTextField.text)
        
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func deleteButtonClick(_ sender: Any) {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        
        gitSearch(search_word: "")
        
        searchListTableView.reloadData()
    }
    
    @IBAction func nextPageClick(_ sender: Any) {
        let request = SearchUserList.listPreview.Request(searchText: searchTextField.text)
        interactor?.doSearchUser(request: request)
    }
    
    func displaySearchList(viewModel: SearchUserList.listPreview.ViewModel) {
        displayedDatas = viewModel.displayedData
        searchListTableView.reloadData()
    }
}

extension SearchUserListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        gitSearch(search_word: searchTextField.text)
        textField.resignFirstResponder()
        return true
    }
}

extension SearchUserListViewController: UITableViewDataSource, UITableViewDelegate, SearchUserListCellDelegate {
    
    func selectButtonClick(index: Int) {
        let cell = searchListTableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as! SearchUserListCell
        
        let completionHandlerRequest = SearchUserList.CompletionHandler.Request(id: "", tag: cell.favoriteStar.tag)
        interactor?.completionHandler(request: completionHandlerRequest, completionHandler: { (imageName, tag) in
            cell.favoriteStar.tag = tag
            cell.favoriteStar.setImage(UIImage.init(named: imageName), for: UIControl.State.normal)
        })
        
        let request = SearchUserList.favoriteModel.Request(favoriteSelect: displayedDatas[index])
        interactor?.doFavoriteCheck(request: request, state: cell.favoriteStar.tag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserListCell", for: indexPath) as! SearchUserListCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.searchUserListCellDelegate = self
        cell.userName?.text = displayedDatas[indexPath.row].login
        cell.userScore?.text = displayedDatas[indexPath.row].score
        
        cell.avatarImg.tag = indexPath.row
        cell.avatarImg.sd_setImage(with: URL(string: displayedDatas[indexPath.row].avatar_url))
        
        let request = SearchUserList.CompletionHandler.Request(id: displayedDatas[indexPath.row].id, tag: -1)
        interactor?.completionHandler(request: request, completionHandler: { (imageName, tag) in
            cell.favoriteStar.tag = tag
            cell.favoriteStar.setImage(UIImage.init(named: imageName), for: UIControl.State.normal)
        })

        return cell
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}