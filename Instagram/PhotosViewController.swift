//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Sean Crenshaw on 1/28/16.
//  Copyright © 2016 Sean Crenshaw. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pictures:[NSDictionary]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 205;
                
        // Do any additional setup after loading the view, typically from a nib.
        
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.pictures = responseDictionary["data"] as? [NSDictionary]
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if let pictures = pictures {
            return pictures.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        let pic = pictures![indexPath.section]
        let photoPath = pic.valueForKeyPath("images.low_resolution.url") as! String
        let photoURl = NSURL(string: photoPath)
        
        cell.photoView.setImageWithURL(photoURl!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        // Use the section number to get the right URL
        // profileView.setImageWithURL(...)
        let pic = pictures![section]
        let img = (pic["user"] as! NSDictionary)["profile_picture"] as! String
        let url = NSURL(string : img)
        profileView.setImageWithURL(url!)
        
        headerView.addSubview(profileView)
        
        // Add a UILabel for the username here
        let usernameLabel = UILabel(frame: CGRect(x: 50, y: -25, width: 200, height: 100))
        usernameLabel.text = pic["user"]!["full_name"] as? String
        let fontSize = usernameLabel.font.pointSize;
        usernameLabel.font = UIFont(name: "FreightSans", size: fontSize)
        usernameLabel.font = UIFont.boldSystemFontOfSize(fontSize)
        usernameLabel.textColor = UIColor.blueColor()
        headerView.addSubview(usernameLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

