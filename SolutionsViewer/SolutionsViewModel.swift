//
//  SolutionsModel.swift
//  SolutionsViewer
//
//  Created by Carlo Donzelli on 29/07/2015.
//  Copyright (c) 2015 Carlo Donzelli. All rights reserved.
//

import Foundation

protocol SolutionsViewModelDelegate: class {
    
    func loadingStarted()
    func loadingEnded(success: Bool, error: String?)
}

class SolutionsViewModel  {
    
    struct SolutionInfo {
        let name: String
        let description: String
        let icon: String
    }
    
    private var solutions = [Solution]()
    weak var delegate: SolutionsViewModelDelegate?
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return solutions.count
    }
    
    func solutionInfoForIndex(row: Int) -> SolutionInfo? {
        if row < solutions.count {
        let solution = solutions[row]
        return SolutionInfo(name: solution.name!, description: solution.description!, icon: solution.icon!)
        }
        return nil
    }
    
    func detailViewModelForIndex(row: Int) -> DetailViewModel? {
        if let solution = solutionForRow(row) {
            return DetailViewModel(solution: solution)
        } else {
            return nil
        }
    }
    
    func reload() {
        delegate?.loadingStarted()
        APIManager.sharedInstance.fetchSolutions { (success, objects, error) -> Void in
            if (success) {
                self.solutions = objects as! [Solution]
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.loadingEnded(success, error: error)
            })
        }
    }
}

// MARK: - Private Methods
private extension SolutionsViewModel {
    
    private func solutionForRow(row: Int) -> Solution? {
        if row < solutions.count {
            let solution = solutions[row]
            return solution
        }
        return nil
    }
}