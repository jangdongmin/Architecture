//
//  SearchUserListPresenter.swift
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

protocol SearchUserListPresentationLogic {
    func presentSearchList(response: SearchUserList.listPreview.Response)
}

class SearchUserListPresenter: SearchUserListPresentationLogic {
    weak var viewController: SearchUserListDisplayLogic?
   
    func presentSearchList(response: SearchUserList.listPreview.Response) {
        let viewModel = SearchUserList.listPreview.ViewModel(displayedData: response.searchResult as! [SearchUserList.listPreview.ViewModel.listPreviewData])
        viewController?.displaySearchList(viewModel: viewModel)
    }
}
