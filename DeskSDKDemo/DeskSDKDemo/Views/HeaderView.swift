//
//  HomeConrollerHeaderView.swift
//  DeskSDKDemo
//
//  Created by Rajeshkumar Lingavel on 30/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import Foundation
import ZohoDeskSDK
class HeaderView: UIView {
    @IBOutlet weak var profileImage:UIImageView?
    @IBOutlet weak var name:UILabel?
    @IBOutlet weak var emailId:UILabel?
    
    var dataModel:Profile?

    override func awakeFromNib() {
        backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
        profileImage?.layer.masksToBounds = true
        profileImage?.layer.cornerRadius = 40
        getProfileInformation()
    }
    
    func updateData(){
        
        self.getProfileImage(imageURLString:"https://profile.zoho.com/api/v1/user/\(dataModel?.primaryEmail ?? "")/photo") { (imageData) in
            self.profileImage?.image = UIImage(data: imageData ?? Data()) ?? UIImage(named: "default.png")
        }
        
        self.name?.text = dataModel?.displyName ?? ""
        self.emailId?.text = dataModel?.primaryEmail ?? ""
        
    }
    
}


//MARK:- Network Methods
extension HeaderView{
    
    func getProfileInformation(){
        guard let profileURL = URL(string: Constant.userProfileURL) else{return}
        ZDAPIExtension.makeAPIRequest(url: profileURL, method: "GET", paramType: "path", parameters: Parameters(), header: Headers()) { [weak self] (responceData, error, statusCode) in
            
            guard let selfObject = self else{return}
            if let responce = responceData{
                DispatchQueue.main.async {
                    selfObject.dataModel = Profile(json: selfObject.toJSON(data: responce) as? [String:AnyObject])
                    selfObject.updateData()
                }
            }
            else{
                
                selfObject.showAlert(message: error?.localizedDescription ?? "Error while load Profile", onComplition: {
                    selfObject.getProfileInformation()
                })
            }
            
        }
    }
    
    func getProfileImage(imageURLString:String,onComplition:@escaping ((Data?)->())) -> Void{
        guard let imageURL = URL(string: imageURLString) else{return}
        ZDAPIExtension.makeAPIRequest(url: imageURL, method: "GET", paramType: "path", parameters: ["photo_size":"medium"], header: Headers()) { (responceData, error, statusCode) in
            DispatchQueue.main.async {
                onComplition(responceData)
            }
        }
    }
    
    func showAlert(message:String,onComplition:@escaping (()->())){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let retry = UIAlertAction(title: "Retry", style: UIAlertActionStyle.default) {
            UIAlertAction in
            onComplition()
        }
        alertController.addAction(retry)
        getTopViewController()?.present(alertController, animated: true, completion: nil)
        
    }
    
    func toJSON(data:Data) -> AnyObject?{
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
        } catch _ {
            return nil
        }
    }
    
    internal func getTopViewController() -> UIViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
}

class Profile {
    
    var displyName = ""
    var photoURl:String?
    var primaryEmail = ""
    
    init?(json:[String:AnyObject]?) {
        guard let profile = json?["profile"] as? [String:AnyObject] else{return nil}
        
        self.displyName   = (profile["display_name"] as? String) ?? "User"
        self.primaryEmail = (profile["primary_email"] as? String) ?? ""
        self.photoURl     = profile["photo_url"] as? String
    }
}
