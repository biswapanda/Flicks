//
//  MovieDetailViewController.swift
//  Flicks
//
//  Created by bis on 4/1/17.
//  Copyright © 2017 biswa. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieBackdropImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var movie: NSDictionary?
    let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
    
    func formatReleaseDate(_ dtStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dtStr)
        dateFormatter.dateFormat = "MMMM d, y"
        return dateFormatter.string(from: date!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let overview = movie!["overview"] as? String {
            self.movieOverviewLabel.text = overview
        } else {
            self.movieOverviewLabel.text = ""
        }
        self.movieOverviewLabel.sizeToFit()
        
        if let posterPath = movie!["poster_path"] as? String {
            let posterURL = URL(string: posterBaseUrl + posterPath)!
            self.movieBackdropImageView.setImageWith(posterURL)
        }
        else {
            self.movieBackdropImageView.image = UIImage(named: "moviePoster")
        }
        titleLabel.text = movie!["original_title"]  as? String
        releaseDateLabel.text = self.formatReleaseDate(movie!["release_date"]  as! String)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: infoView.frame.origin.y + infoView.frame.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
