//
//  JSONTestViewController.swift
//  MindvalleySample
//
//  Created by Divyam Shukla on 1/6/18.
//  Copyright © 2018 Mindvalley. All rights reserved.
//

import UIKit

class JSONTestViewController: UIViewController {

    let testUrl : String = "http://pastebin.com/raw/wgkJgazE"
    
    @IBOutlet weak var jsonPreview: UITextView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Load Json"
        indicator.startAnimating();
        loadJsonData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadJsonData()
    {
        indicator.stopAnimating();
        indicator.hidesWhenStopped = true;
        MindvalleyLibrary.shared().getResourceFromURL(testUrl, of: kResourceTypeJSON, onCompletion:{(success: Bool ,error: Error?, data: Any?) in
            if(success){
                if(data is NSArray ){
                    let array : NSArray = data as! NSArray
                    self.jsonPreview.text = array.componentsJoined(by: ",")
                }
            }
            
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
