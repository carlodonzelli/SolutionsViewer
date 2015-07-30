//
//  Parser.swift
//  SolutionsViewer
//
//  Created by Carlo Donzelli on 29/07/2015.
//  Copyright (c) 2015 Carlo Donzelli. All rights reserved.
//

import Foundation

let kName = "name"
let kDescription = "description"
let kIcon = "icon"
let kUrl = "url"

class Parser {
    
    func parse(entity: AnyObject, onCompletion: (objects:[AnyObject]) -> Void) {
        if let solutionsJSON = entity["solutions"] as? [JSON] {
            var solutionsArray = [Solution]()
            for solutionArray in solutionsJSON {
                if let solution: AnyObject = processEntity(solutionArray) {
                    solutionsArray.append(solution as! Solution)
                }
            }
            onCompletion(objects: solutionsArray)
        }
    }
    
    func processEntity(json: JSON) -> AnyObject? {
        var solution = Solution()
        solution.name = json[kName] as? String
        solution.description = json[kDescription] as? String
        solution.icon = json[kIcon] as? String
        solution.url = json[kUrl] as? String
        return solution
    }
}
