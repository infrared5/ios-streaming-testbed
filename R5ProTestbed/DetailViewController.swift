//
//  DetailViewController.swift
//  R5ProTestbed
//
//  Created by Andy Zupko on 12/16/15.
//  Copyright © 2015 Infrared5. All rights reserved.
//

import UIKit
import R5Streaming

class DetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var hostText: UITextField!
    
    @IBOutlet weak var streamText: UITextField!
    var r5ViewController : BaseTest? = nil
   
    var detailItem: NSDictionary? {
        didSet {
            // Update the view.
           // self.configureView()
        }
    }

    @IBAction func onStreamNameChange(sender: AnyObject) {
            Testbed.setStreamName(streamText.text!)
    }

    @IBAction func onHostChange(sender: AnyObject) {
            Testbed.setHost(hostText.text!)
    }
    func configureView() {
        // Update the user interface for the detail item.
        

     
        
        hostText.text = Testbed.parameters!["host"] as? String
        streamText.text  = Testbed.parameters!["stream1"] as? String
        
        hostText.delegate = self
        streamText.delegate = self
        
        if(self.detailItem != nil){
            
            if(self.detailItem!["description"] != nil){

                let navButton = UIBarButtonItem(title: "Info", style: UIBarButtonItemStyle.Plain, target: self, action: "showInfo")
                navButton.imageInsets = UIEdgeInsetsMake(10, 10, 10, 10);

                navigationItem.rightBarButtonItem =    navButton
            }
            
            Testbed.setLocalOverrides(self.detailItem!["LocalProperties"] as? NSMutableDictionary)
            
            
            let className = self.detailItem!["class"] as! String
            let mClass = NSClassFromString(className) as! BaseTest.Type;
           
            //only add this view if it isn't HOME
            if(!(mClass is Home.Type)){
                r5ViewController  = mClass.init()

                self.addChildViewController(r5ViewController!)
                self.view.addSubview(r5ViewController!.view)
    
                r5ViewController!.view.autoresizesSubviews = true
                r5ViewController!.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth];
            }

        }

    
    }
    
    func showInfo(){
        let alert = UIAlertView()
        alert.title = "Info"
        alert.message = self.detailItem!["description"] as? String
        alert.addButtonWithTitle("OK")
        alert.show()
        
      
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    override func viewWillDisappear(animated: Bool) {
     
       closeCurrentTest()
    }
    
    func closeCurrentTest(){
        
        if(r5ViewController != nil){
            r5ViewController!.closeTest()
        }
        r5ViewController = nil
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.view.autoresizesSubviews = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
