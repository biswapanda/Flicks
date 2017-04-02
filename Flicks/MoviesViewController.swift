//
//  MoviesViewController.swift
//  Flicks
//
//  Created by bis on 3/31/17.
//  Copyright © 2017 biswa. All rights reserved.
//

import UIKit
import AFNetworking


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var movieTableView: UITableView!
    
    var feed: [NSDictionary] = []
    let posterBaseUrl = "http://image.tmdb.org/t/p/w90"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feed.count
    }
    
    func loadData() {
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        self.feed = responseDictionary["results"] as! [NSDictionary]
                        self.movieTableView.reloadData()
                    }
                }
        });
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell?.selectedBackgroundView = bgColorView
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.movieTableView.dequeueReusableCell(
            withIdentifier: "movieTableViewCell") as! MovieTableViewCell
        let index = indexPath.row
        let movie = self.feed[index]
        
        if let description = movie["overview"] as? String {
            cell.descriptionLabel.text = description
        } else {
            cell.descriptionLabel.text = ""
        }
        if let originalTitle = movie["original_title"] as? String {
            cell.titleLabel.text = originalTitle
        } else {
            cell.titleLabel.text = ""
        }
        if let posterPath = movie["poster_path"] as? String {
            let posterURL = URL(string: posterBaseUrl + posterPath)!
            cell.thumbImageView.setImageWith(posterURL)
        }
        else {
            cell.thumbImageView.image = UIImage(named: "moviePoster")
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let row = self.movieTableView.indexPath(for: sender as! UITableViewCell)!.row
        let mdvc = segue.destination as! MovieDetailViewController
        mdvc.movie = self.feed[row]
    }
    
}
