//
//  DetailViewController.swift
//  SomethingNewEveryDay
//
//  Created by Ty Parker on 12/12/14.
//  Copyright (c) 2014 Ty Parker. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var youDid: UILabel!
    @IBOutlet weak var youLearned: UILabel!
    @IBOutlet var object: PFObject!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       youDid.text = object.objectForKey("did") as? String
        youLearned.text = object.objectForKey("learned") as? String
        date.text = object.objectForKey("createdAt") as? String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
