//
//  TableViewController.swift
//  SolutionsViewer
//
//  Created by Carlo Donzelli on 29/07/2015.
//  Copyright (c) 2015 Carlo Donzelli. All rights reserved.
//

import UIKit

let kThumbnailWidth = CGFloat(80)
let kHorizontalSpacing = CGFloat(16.0)

typealias ImageDownloadBlock = (success: Bool, image: UIImage?, error: String?) -> Void

class SolutionsTableViewController: UITableViewController {
    
    let model = SolutionsViewModel()
    weak var delegate: SolutionsViewModelDelegate?    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "SolutionTableViewCell", bundle: nil), forCellReuseIdentifier: "SolutionTableViewCell")
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 200;
        title = "Solutions Viewer"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        model.delegate = self
        model.reload()
    }
    
    func downloadImageAtIndex(url: String, onCompletion: ImageDownloadBlock) {
        APIManager.sharedInstance.fetchImage(url, onCompletion: { (success, data, downloadError) -> Void in
            if success {
                let image = UIImage(data: data!)
                onCompletion(success: true, image: image, error: nil)
            } else {
                onCompletion(success: false, image: nil, error: "")
            }
        })
    }
    
}

// MARK: - UITableViewDataSource
extension SolutionsTableViewController: UITableViewDataSource {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.numberOfSections()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRowsInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let info = model.solutionInfoForIndex(indexPath.row),
        let cell = tableView.dequeueReusableCellWithIdentifier("SolutionTableViewCell") as? SolutionTableViewCell {
            cell.nameLabel.text = info.name
            cell.descriptionLabel.text = info.description
            
            downloadImageAtIndex(info.icon, onCompletion: { (success, image, error) -> Void in
                if success {
                    if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SolutionTableViewCell {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            cell.thumbnailView.image = image
                            cell.thumbnailWidth.constant = kThumbnailWidth
                            cell.horizontalSpacing.constant = kHorizontalSpacing
                        })
                    }
                } else {
                    cell.thumbnailView.image = nil
                    cell.thumbnailWidth.constant = 0
                    cell.horizontalSpacing.constant = 0

                }
            })
//            cell.descriptionLabel.layoutIfNeeded()
//            let size = cell.descriptionLabel.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
//            cell.descriptionLabel.frame = CGRectMake(0, 0, size.width, size.height)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension SolutionsTableViewController: UITableViewDelegate {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailViewController = storyboard.instantiateViewControllerWithIdentifier("detailViewController") as? DetailViewController {
            if let detailModel = model.detailViewModelForIndex(indexPath.row) {
                detailViewController.model = detailModel
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
}

// MARK: - SolutionsViewModelDelegate
extension SolutionsTableViewController: SolutionsViewModelDelegate {
    
    func loadingStarted() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func loadingEnded(success: Bool, error: String?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if success {
            tableView.reloadData()
        }
    }
    
}