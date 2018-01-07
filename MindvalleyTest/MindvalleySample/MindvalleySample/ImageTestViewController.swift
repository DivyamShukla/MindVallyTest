//
//  ImageTestViewController.swift
//  MindvalleySample
//
//  Created by Divyam Shukla on 1/6/18.
//  Copyright © 2018 Mindvalley. All rights reserved.
//

import UIKit

class ImageTestViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    let testUrl : String = "http://pastebin.com/raw/wgkJgazE"
    
    var array = NSMutableArray()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Load images"
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        loadData()
    }
    
    @objc func refreshData(){
        MindvalleyLibrary.shared().clearCache(forKey: testUrl);
        loadData()
        self.refreshControl.endRefreshing()
    }
    
    
     func loadData(){
        MindvalleyLibrary.shared().getResourceFromURL(testUrl, of: kResourceTypeJSON, onCompletion:{(success: Bool ,error: Error?, data: Any?) in
            if(success){
                if(data is NSArray ){
                    self.array = data as! NSMutableArray
                    self.tableView.reloadData();
                }
            }
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MindVallyImageTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "MindVallyImageTableViewCell") as! MindVallyImageTableViewCell
        let dataDict :NSDictionary = self.array.object(at: indexPath.row) as! NSDictionary;
        
        let user: NSDictionary =  dataDict.value(forKey: "user") as! NSDictionary
        let profile_images:NSDictionary =  user.value(forKey: "profile_image") as! NSDictionary
       
        MindvalleyLibrary.shared().loadImage(profile_images.value(forKey: "small") as! String, into: cell.imgView, withLoading: true);
        cell.label?.text = user.value(forKey: "name") as! String
        
        return cell
    }

}
