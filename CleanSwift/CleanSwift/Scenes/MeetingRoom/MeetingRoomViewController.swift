//
//  MeetingRoomViewController.swift
//  CleanSwift_test
//
//  Created by Paul Jang on 2019/12/24.
//  Copyright (c) 2019 Paul Jang. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SwiftyJSON

protocol MeetingRoomDisplayLogic: class {
    func jsonParse(viewModel: MeetingRoom.Schedule.ViewModel)
    func currentTime(viewModel: MeetingRoom.Time.ViewModel)
    func timeSet(viewModel: MeetingRoom.TimeSet.ViewModel)
}

class MeetingRoomViewController: UIViewController, MeetingRoomDisplayLogic {
    var interactor: MeetingRoomBusinessLogic?
    var router: (NSObjectProtocol & MeetingRoomRoutingLogic & MeetingRoomDataPassing)?

    // MARK: Object lifecycle
  
    @IBOutlet weak var topMeetingRoomCollectionView: UICollectionView!
    @IBOutlet weak var detailMeetingRoomTableView: UITableView!
    @IBOutlet weak var availableRoomLabel: UILabel!
    
    var timeBlockDic = [Int:Array<String>]() //예약시간 표시하기 위해
    
    var currentTime: String = ""
    var timeSchedule: JSON = ""
    var availableRoom = [String]()
    
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
        let interactor = MeetingRoomInteractor()
        let presenter = MeetingRoomPresenter()
        let router = MeetingRoomRouter()
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
        
        self.navigationController?.isNavigationBarHidden = true
 
        topMeetingRoomCollectionView.dataSource = self
        topMeetingRoomCollectionView.delegate = self
              
        detailMeetingRoomTableView.dataSource = self
        detailMeetingRoomTableView.delegate = self
         
        preLoad()
    }
    
    override func viewDidLayoutSubviews() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(finishViewDidLayoutSubviews), object: nil)
        perform(#selector(finishViewDidLayoutSubviews), with: nil, afterDelay: 0)
    }
    
    @objc func finishViewDidLayoutSubviews() {
        detailMeetingRoomTableView.reloadData()
    }

    func preLoad() {
        //1. 현재시간 먼저 구하자
        interactor?.doCurrentTimeCalculate()
        
        //2. JSON 파싱
        interactor?.doJsonLoad()
        
        //3. 시간 처리작업
        let request = MeetingRoom.TimeSet.Request(json: timeSchedule)
        interactor?.doTimeSetting(request: request)
    }
    
    func timeSet(viewModel: MeetingRoom.TimeSet.ViewModel) {
        timeBlockDic = viewModel.timeBlockDic
        availableRoom = viewModel.availableRoom
        topMeetingRoomCollectionView.reloadData()
         
        let str = "현재 사용 가능 회의실 \(availableRoom.count)"
        let attributedString = NSMutableAttributedString(string: str,
                                                         attributes: [.font: UIFont(name: "AppleSDGothicNeo-Regular", size: 18.0)!,
                                                                      .foregroundColor: UIColor.black,
                                                                      .kern: 0.0])
        attributedString.addAttribute(.foregroundColor, value: UIColorFromRGB(rgbValue: 0x0077ff), range: NSRange(location: 13, length: str.count - 13))
        
        availableRoomLabel.attributedText = attributedString
    }
    
    func jsonParse(viewModel: MeetingRoom.Schedule.ViewModel) {
        timeSchedule = viewModel.timeSchedule
    }
    
    func currentTime(viewModel: MeetingRoom.Time.ViewModel) {
        currentTime = viewModel.time
    }
}

extension MeetingRoomViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableRoom.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopMeetingRoomCell", for: indexPath) as! TopMeetingRoomCell
        
        cell.meetingRoomName.text = availableRoom[indexPath.row]
        
        return cell
    }
}

extension MeetingRoomViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSchedule.count
    }
     
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMeetingRoomCell", for: indexPath) as! DetailMeetingRoomCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.addTimeBlocks()
        
        for (_, value) in cell.timeBlocks {
            value.backgroundColor = UIColorFromRGB(rgbValue: 0x0077ff)
        }
        
        if let arr = timeBlockDic[indexPath.row] {
            for (_, value) in arr.enumerated() {
                
                if let result = cell.timeBlocks[value] {
                    result.backgroundColor = UIColorFromRGB(rgbValue: 0xe8e8e8)
                }
            }
        }
         
        cell.meetingRoomNameLabel.text = timeSchedule[indexPath.row]["name"].string
        cell.meetingRoomPosLabel.text = timeSchedule[indexPath.row]["location"].string

        cell.currentTimeLabel.text = currentTime
        
        let request = MeetingRoom.UiPositionCompletionHandler.Request(cell: cell)
        interactor?.UiPositionCompletionHandler(request: request, completionHandler: { (stickPos, currentTimeLabelPos, overTimeViewArr) in
            cell.currentTimeLabelLeftMargin.constant = currentTimeLabelPos
            cell.stickLeftMargin.constant = stickPos
            
            for (_, view) in overTimeViewArr.enumerated() {
                view.backgroundColor = UIColorFromRGB(rgbValue: 0xe8e8e8)
            }
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 139
    }
}