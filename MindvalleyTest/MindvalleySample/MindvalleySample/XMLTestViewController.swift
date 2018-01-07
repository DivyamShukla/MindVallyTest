//
//  XMLTestViewController.swift
//  MindvalleySample
//
//  Created by Divyam Shukla on 1/6/18.
//  Copyright © 2018 Mindvalley. All rights reserved.
//

import UIKit

class XMLTestViewController: UIViewController {

    @IBOutlet weak var xmlPreview: UITextView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var test_url = "https://www.w3schools.com/xml/plant_catalog.xml"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Load XML"
        indicator.startAnimating()
        loadXMLData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadXMLData()
    {
        indicator.stopAnimating();
        indicator.hidesWhenStopped = true;
        MindvalleyLibrary.shared().getResourceFromURL(test_url, of: kResourceTypeXML, onCompletion:{(success: Bool ,error: Error?, data: Any?) in
            if(success){
                self.xmlPreview.text = data as! String
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
