//
//  DetailViewModel.swift
//  SolutionsViewer
//
//  Created by Carlo Donzelli on 30/07/2015.
//  Copyright (c) 2015 Carlo Donzelli. All rights reserved.
//

import Foundation

class DetailViewModel {
    
    private let solution: Solution
    
    init(solution: Solution) {
        self.solution = solution
    }
    
    func getUrl() -> String? {
        if let url = self.solution.url {
            return url
        } else {
            return nil
        }
    }
    
}
