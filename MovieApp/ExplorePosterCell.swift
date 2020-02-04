//
//  ExplorePosterCell.swift
//  RumblApp
//
//  Created by Umamaheshwari on 29/01/20.
//  Copyright © 2020 Umamaheshwari. All rights reserved.
//

import UIKit
import AVFoundation

protocol UpdateVideoDelegate: class {
    func showPlayerPage(with currentIndex: IndexPath)
    func cacheObject(with thumbnail: UIImage, key: NSString)
}

class ExplorePosterCell: UITableViewCell {
    
    var moviePosters: [VideoNode] = []
    var cache: NSCache<NSString, UIImage>!
    @IBOutlet var collectionViewPosters: UICollectionView!
    weak var updateDelegate: UpdateVideoDelegate?
    var section: Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with moviePosters: [VideoNode], section: Int, cache: NSCache<NSString, UIImage>) {
        self.cache = cache
        self.moviePosters.removeAll()
        self.moviePosters = moviePosters
        self.section = section
        self.collectionViewPosters.reloadData()
    }
    
    
    func getThumbnailImageFromVideoUrl(videoURL: String, completion: @escaping ((_ image: UIImage?) ->Void)) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: URL(string: videoURL)!)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 1, timescale: 2)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                self.updateDelegate?.cacheObject(with: thumbImage, key: videoURL as NSString)
                DispatchQueue.main.async {
                    
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
//MARK: UICollection Delegate and Datasource
extension ExplorePosterCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviePosters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "posterCellID", for: indexPath) as! CellImageView
        let programPoster = moviePosters[indexPath.row].video
        cell.imageViewPoster.image = UIImage(named: "placeholderPoster")!
        if let cachedImage = self.cache.object(forKey: "\(programPoster.encodeUrl)" as NSString) {
            cell.imageViewPoster.image = cachedImage
        } else {
            getThumbnailImageFromVideoUrl(videoURL: programPoster.encodeUrl) { (thumbnailImage) in
                if thumbnailImage != nil {
                    cell.imageViewPoster.image = thumbnailImage
                }
            }
        }
        
        cell.imageViewPoster.layer.cornerRadius = 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = IndexPath(row: indexPath.row, section: section)
        updateDelegate?.showPlayerPage(with: index)
    }
    
    // Align spacing between each sections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8,left: 5,bottom: 0,right: 0)
    }
}
