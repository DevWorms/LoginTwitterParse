//
//  ViewController.swift
//  LoginTwitterParse
//
//  Created by Emmanuel Valentín Granados López on 02/10/15.
//  Copyright © 2015 DevWorms. All rights reserved.
//

import UIKit
import Parse
import ParseTwitterUtils

class ViewController: UIViewController {
    
    
    @IBOutlet weak var nameProfile: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func statusTwitter(sender: AnyObject) {
        
        print(PFUser.currentUser()?.username)
        self.status.text = PFUser.currentUser()?.username
    }
    
    @IBAction func loginTwitter(sender: AnyObject) {
        
        PFTwitterUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            
            let user = user
            
            if (user != nil) {
                if user!.isNew {
                    print("User signed up and logged in with Twitter!")
                } else {
                    print("User logged in with Twitter! " )
                }
                
                    let screenName = PFTwitterUtils.twitter()?.screenName
                    
                    let session = NSURLSession.sharedSession()
                    let urlString = "https://api.twitter.com/1.1/users/show.json?screen_name=" + screenName! //"https://api.twitter.com/1.1/account/verify_credentials.json"
                    let url = NSURL(string: urlString)
                    let request = NSMutableURLRequest(URL: url!)
                    PFTwitterUtils.twitter()!.signRequest(request)
                    let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                        if error == nil {
                            
                            //imprimir el json
                            //let datastring = NSString(data:data!, encoding:NSUTF8StringEncoding) as String?
                            //print("data: " + datastring!)
                            
                             do {
                                let result : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        
                                // success ...
                                
                                let names: String! = result?.objectForKey("name") as! String
                                
                                let screenName: String = result?.objectForKey("screen_name") as! String
                                
                                //let separatedNames: [String] = names.componentsSeparatedByString(" ")
                                
                                self.nameProfile.text = names
                                self.nickName.text = "@" + screenName
                                
                                let urlString = result?.objectForKey("profile_image_url_https") as! String
                                
                                let hiResUrlString = urlString.stringByReplacingOccurrencesOfString("_normal", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                                
                                let twitterPhotoUrl = NSURL(string: hiResUrlString)
                                let imageData = NSData(contentsOfURL: twitterPhotoUrl!)
                                let twitterImage: UIImage! = UIImage(data:imageData!)
                                
                                self.imageProfile.image = twitterImage
                                
                                print("imagen cargada")
                                
                            } catch {
                                // failure
                                print("Fetch failed: \((error as NSError).localizedDescription)")
                            }
                            
                        }
                        
                    }
                    dataTask.resume()
                
            } else {
                print("Uh oh. The user cancelled the Twitter login.")
            }
        }
        
    }
    
    @IBAction func logoutTwitter(sender: AnyObject) {
        
        PFUser.logOut()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

