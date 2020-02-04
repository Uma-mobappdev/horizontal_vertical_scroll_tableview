//
//  ExploreViewController.swift
//  RumblApp
//
//  Created by Umamaheshwari on 29/01/20.
//  Copyright © 2020 Umamaheshwari. All rights reserved.
//

import UIKit
import AVFoundation

class ExploreViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var tableViewMovie: UITableView!
    var cache: NSCache<NSString, UIImage>!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cache = NSCache()
        self.automaticallyAdjustsScrollViewInsets = false
        var frame = CGRect.zero
        frame.size.height = 15
        self.tableViewMovie.tableHeaderView = UIView(frame: frame)
    }

}

extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return moviesData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMovieID") as! ExplorePosterCell
        cell.configure(with: moviesData[indexPath.section].nodes, section: indexPath.section, cache: cache)
        cell.updateDelegate = self
        return cell
    }
    
    //By default first section will show current video title and descriptions and other sections are splited according to the categories.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return moviesData[section].title ?? ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let headerView = UILabel()
        headerView.backgroundColor = UIColor.clear
        headerView.textColor = UIColor.black
        headerView.text = moviesData[section].title
        headerView.font = UIFont(name: "Avenir-Medium", size: 15)
        headerView.textAlignment = .left
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16.0
    }
}

extension ExploreViewController: UpdateVideoDelegate {
    func cacheObject(with thumbnail: UIImage, key: NSString) {
        self.cache.setObject(thumbnail, forKey: key)
    }
    
    func showPlayerPage(with currentIndex: IndexPath) {
        let playerViewController = self.storyboard!.instantiateViewController(withIdentifier: "PlayerController") as! PlayerController
        playerViewController.currentIndex = currentIndex
        playerViewController.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        playerViewController.modalPresentationStyle = .fullScreen
        let popover = playerViewController.presentationController
        popover?.delegate = self
        let pop = playerViewController.popoverPresentationController
        pop?.sourceView = self.view
        pop?.popoverLayoutMargins = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        pop?.sourceRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        presentDetail(playerViewController)
        //self.present(playerViewController, animated: true, completion: nil)
    }
}
