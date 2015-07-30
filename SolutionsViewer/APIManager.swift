//
//  APIManager.swift
//  SolutionsViewer
//
//  Created by Carlo Donzelli on 29/07/2015.
//  Copyright (c) 2015 Carlo Donzelli. All rights reserved.
//

import Foundation

typealias JSON = [String: AnyObject]
typealias ObjectsFetchBlock = (success: Bool, objects: AnyObject?, error: String?) -> Void
typealias ImageFetchBlock = (success: Bool, data: NSData?, error: String?) -> Void


class APIManager: NSObject {
    
    private let defaultURL = "https://api.myjson.com/bins/1quht"
    private var session = NSURLSession.sharedSession()
    static let sharedInstance = APIManager()
    
    
    func fetchSolutions(onCompletion: ObjectsFetchBlock) {
        fetch(Parser()) { success, objects, error in
                onCompletion(success: success, objects: objects, error: error)           
        }
    }
    
    func fetchImage(urlPath: String, onCompletion: ImageFetchBlock) {
        let url = NSURL(string: urlPath)
        var imageRequest: NSURLRequest = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(imageRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { response, data, error in
            if(error == nil) {
                onCompletion(success: true, data: data, error: nil)
            } else {
                onCompletion(success: false, data: nil, error: error.localizedDescription)
            }
        })
    }
}


// MARK: - Private Methods
private extension APIManager {
    
    private func fetch(parser: Parser, onCompletion: ObjectsFetchBlock) {
        if let urlPath = NSURL(string: defaultURL) {
            check(parser, url: urlPath, onCompletion: onCompletion)
        }
    }
    
    private func check(parser: Parser, url: NSURL, onCompletion: ObjectsFetchBlock) {
        let request =  NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if (error == nil) {
                self.handleCheckSuccessfulCase(parser, data: data, onCompletion: onCompletion)
            } else {
                onCompletion(success: false, objects: nil, error: error.localizedDescription)
            }
        }
        task.resume()
    }
    
    private func handleCheckSuccessfulCase(parser: Parser, data: NSData, onCompletion: ObjectsFetchBlock) {
        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)
        if let jsonObject = jsonObject as? JSON {
            parser.parse(jsonObject, onCompletion: { (objects) -> Void in
                onCompletion(success: true, objects: objects, error: nil)
            })
        } else {
            onCompletion(success: false, objects: nil, error: "JSON format not valid.")
        }
    }
}


