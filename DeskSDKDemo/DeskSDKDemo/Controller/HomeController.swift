//
//  HomeController.swift
//  DeskSDKDemo
//
//  Created by Rajeshkumar Lingavel on 26/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
import ZohoDeskSDK

class HomeController: UIViewController {
    var orgId = ""{
        didSet{
            getAllViews()
        }
    }
    let cellReuseIdentifier = "Cell"
    
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var activityIndicatorView:UIActivityIndicatorView?
    var dataSource:[ZDView]?{
        didSet{
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllOrganization()
        getToken()
        configurateNavigation()
        configureViews()
    }
    
    private func configureViews(){
        
        activityIndicatorView?.startAnimating()
        activityIndicatorView?.activityIndicatorViewStyle = .whiteLarge
        activityIndicatorView?.color = .gray
        
        self.tableView?.tableFooterView = UIView()
    }
    
    func configurateNavigation(){
        self.title = "All Views"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
        }
    }
    
    func showTicketController(viewId:String){
        let storyBoard : UIStoryboard = UIStoryboard(name: Constant.mainStoryBoardName, bundle:nil)
        let ticketViewController = storyBoard.instantiateViewController(withIdentifier: Constant.ticketControllerId) as! TicketListController
        ticketViewController.orgId = orgId
        ticketViewController.viewId = viewId
        self.navigationController?.pushViewController(ticketViewController, animated:true)
        
    }
    
    func showAlert(message:String,onComplition:@escaping (()->())){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let retry = UIAlertAction(title: "Retry", style: UIAlertActionStyle.default) {
            UIAlertAction in
            onComplition()
        }
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func logOut(){
        activityIndicatorView?.startAnimating()
        ZohoAuth.revokeAccessToken { [weak self] (error) in
            guard let selfObject = self else{return}
            DispatchQueue.main.async {
                selfObject.activityIndicatorView?.stopAnimating()
                if let errorMsg = error{
                    selfObject.showAlert(message: errorMsg.localizedDescription , onComplition: {
                        selfObject.logOut()
                    })
                    return
                }
                selfObject.showLoginPage()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - Authentication Methods
extension HomeController{
    func getToken(){
        ZohoAuth.getOauth2Token {[weak self]  (token, error) in
            DispatchQueue.main.async {
                if token == nil{
                    self?.showLoginPage()
                }
                else{
                    self?.getAllOrganization()
                }
            }
        }
    }
    
    func showLoginPage(){
        ZohoAuth.presentZohoSign { [weak self] (token, error) in
             guard let selfObject = self else{return}
            if let errorObject = error{
                selfObject.showAlert(message: errorObject.localizedDescription, onComplition: {
                    selfObject.showLoginPage()
                })
            }
            else{
                selfObject.getAllOrganization()
            } 
            
        }
    }
}

extension HomeController : UITableViewDelegate,UITableViewDataSource{
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UITableViewCell
        cell.textLabel?.text = dataSource?[indexPath.row].name
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewId = dataSource?[indexPath.row].id {
            showTicketController(viewId: viewId)
        }
    }
    
}

//MARK:- NetworkMethods
extension HomeController{
    
    func getAllOrganization(){
        activityIndicatorView?.startAnimating()
        ZDOrganizationAPIHandler.getAllOrganizations { [weak self] (organizations, error, statusCode) in
            DispatchQueue.main.async {
                guard let selfObject = self else{return}
                if let org = organizations?.first,error == nil {
                    selfObject.orgId = org.id
                }
                else{
                    selfObject.showAlert(message: error?.localizedDescription ?? "Error while load organizations", onComplition: {
                        selfObject.getAllOrganization()
                    })
                }
            }
        }
    }
    /// This method will get all views from Desk SDK.
    func getAllViews(){
        if orgId.isEmpty{return}
        ZDViewsAPIHandler.listAllViews(self.orgId, department: "allDepartment") { [weak self] (views, error, statusCode) in
            DispatchQueue.main.async {
                guard let selfObject = self else{return}
                
                selfObject.activityIndicatorView?.stopAnimating()
                if  let viewObjects = views{
                    selfObject.dataSource = viewObjects.sorted(by: { $0.name < $1.name})
                }
                else if let errorObject = error{
                    selfObject.showAlert(message: errorObject.localizedDescription, onComplition: {
                        selfObject.getAllViews()
                    })
                }
                
            }
        }
    }
}
