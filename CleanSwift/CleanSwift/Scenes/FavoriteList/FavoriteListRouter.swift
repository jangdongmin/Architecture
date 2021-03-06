//
//  FavoriteListRouter.swift
//  CleanSwift_test
//
//  Created by Paul Jang on 2019/12/23.
//  Copyright (c) 2019 Paul Jang. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol FavoriteListRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol FavoriteListDataPassing {
    var dataStore: FavoriteListDataStore? { get }
}

class FavoriteListRouter: NSObject, FavoriteListRoutingLogic, FavoriteListDataPassing {
    weak var viewController: FavoriteListViewController?
    var dataStore: FavoriteListDataStore?
  
  // MARK: Routing
  
//    func routeToSomewhere(segue: UIStoryboardSegue?) {
//        if let segue = segue {
//            let destinationVC = segue.destination as! SomewhereViewController
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
//        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
//            navigateToSomewhere(source: viewController!, destination: destinationVC)
//        }
//    }

  // MARK: Navigation
  
//    func navigateToSomewhere(source: FavoriteListViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }
  
  // MARK: Passing data
  
//    func passDataToSomewhere(source: FavoriteListDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
