//
//  ViewController.swift
//  SolutionsViewer
//
//  Created by Carlo Donzelli on 29/07/2015.
//  Copyright (c) 2015 Carlo Donzelli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("Set up repository")
        let apiManager = APIManager()
        apiManager.fetchJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

