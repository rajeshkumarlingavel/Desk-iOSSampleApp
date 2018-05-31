//
//  ViewController.swift
//  DeskSDKDemo
//
//  Created by rajesh-2098 on 07/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
import ZohoDeskUIKit
import ZohoDeskSDK

class TicketListController: UIViewController {
    var orgId = ""
    var refreshControl:UIRefreshControl?
    var viewId = ""
   @IBOutlet weak var activityIndicator:UIActivityIndicatorView?
 
    @IBOutlet weak var ticketView:ZDTicketListView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        addTicketListComponent()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ticketView = nil
    }

    
    private func addTicketListComponent(){
        let configuration = ZDTicketListConfiguration(orgId: orgId)
        configuration.from = 0
        configuration.limit = 50
        configuration.viewId = self.viewId
        configuration.sortBy = "recentThread"
        
        ticketView = ZDTicketListView(frame: self.view.bounds, configuration: configuration)
        ticketView?.delegate = self
        ticketView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(ticketView!)
        view.sendSubview(toBack: ticketView!)
    }
    
   private func configureViews(){
        activityIndicator?.activityIndicatorViewStyle = .whiteLarge
        activityIndicator?.color = .gray
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
        }
    }

    
    func showDetail(ticketId:String){
        let storyBoard : UIStoryboard = UIStoryboard(name: Constant.mainStoryBoardName, bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: Constant.detailControllerId) as! DetailViewController
        nextViewController.configure(orgId: self.orgId, ticketId: ticketId)
        self.navigationController?.pushViewController(nextViewController, animated:true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension TicketListController:ZDTicketListViewDelegate{
    func didSelectTicket(ticketList: ZDTicketListView, configuration: ZDTicketListConfiguration, ticketId: String, index: Int) {
        showDetail(ticketId: ticketId)
    }
    
    public func shouldLoadMoreData(ticketList: ZDTicketListView) -> Bool {
        return true
    }
    
    public func didBeginLoadingData(ticketList: ZDTicketListView, from: Int) {
        if from > 0{return}
        view.bringSubview(toFront: activityIndicator!)
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
        print("Start Loading")
    }
    
    public func didEndLoadingData(ticketList: ZDTicketListView, error: Error?, statusCode: Int) {
        activityIndicator?.stopAnimating()
        print("End Loading - \(error.debugDescription) - statusCode - \(statusCode)")
    }
}

