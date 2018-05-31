//
//  DetailViewController.swift
//  DeskSDKDemo
//
//  Created by Rajeshkumar Lingavel on 15/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
import ZohoDeskUIKit

class DetailViewController: UIViewController {
    
    fileprivate var orgId = ""
    fileprivate var ticketId = ""
    
   @IBOutlet weak var activityIndicatorView:UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.largeTitleDisplayMode = .never
        }
        
    }
    
    func configure(orgId:String,ticketId:String){
        self.orgId = orgId
        self.ticketId = ticketId
        
        addTicketDetailView()
        
    }
    
    private func configureViews(){
        activityIndicatorView?.startAnimating()
        activityIndicatorView?.activityIndicatorViewStyle = .whiteLarge
        activityIndicatorView?.color = .gray
    }
    
    func addTicketDetailView() -> Void{
        let configuration = ZDTicketDetailViewConfiguration(orgId: self.orgId, ticketId: ticketId)
        configuration.limit = 50
        let ticketdetails = ZDTicketDetailView(frame: self.view.bounds, configuration: configuration)
        ticketdetails.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        ticketdetails.delegate = self
        view.addSubview(ticketdetails)
        view.sendSubview(toBack: ticketdetails)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DetailViewController : ZDTicketdetailViewDelegate{
    func shouldLoadMoreData(ticketdetail: ZDTicketDetailView) -> Bool {
        return true
    }
    
    func didBeginLoadingData(ticketdetail: ZDTicketDetailView) {
        activityIndicatorView?.startAnimating()
    }
    
    func didEndLoadingData(ticketdetail: ZDTicketDetailView, error: Error?, statusCode: Int) {
        activityIndicatorView?.stopAnimating()
    }
    
    
}
