//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Franky Liang on 1/11/16.
//  Copyright © 2016 Franky Liang. All rights reserved.
//


import UIKit
import AFNetworking
import EZLoadingActivity


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var refreshControl: UIRefreshControl!
   
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var networkErrorLabel: UILabel!
  
    @IBOutlet weak var tableView: UITableView!
    
    var movies : [NSDictionary] = []
    
    var filteredMovies: [NSDictionary] = []
    
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkErrorLabel.hidden = true
        
        refreshControl  = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        //tableView.addSubview(refreshControl)
        	
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        //commented out and added function
        /*
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
       
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            
            if(error != nil){
                self.networkErrorLabel.hidden = false
                return
            }
        
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            
                            self.filteredMovies = responseDictionary["results"] as! [NSDictionary]
                            
                            
                            self.tableView.reloadData()
                            
                    }
                }
        });
        task.resume()
        
    })
        */
        // Do any additional setup after loading the view.
        EZLoadingActivity.show("Loading...", disableUI: false)
        networkRequest() { () -> Void in
            EZLoadingActivity.hide()
        
        }
    }
    
    
    /*
    override func viewDidAppear(animated: Bool) {
        
        EZLoadingActivity.showWithDelay("Loading...", disableUI: false, seconds: 1)
    }
    */
    
    //network request
    func networkRequest(completion: (() -> Void)?) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        
        print(url)
        
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        
        
        
            
            
        

            
            let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                completionHandler: { (dataOrNil, response, error) in
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                                NSLog("response: \(responseDictionary)")
                                
                                self.movies = responseDictionary["results"] as! [NSDictionary]
                                
                                self.filteredMovies = responseDictionary["results"] as! [NSDictionary]
                                
                                
                                self.tableView.reloadData()
                                
                              
                                if(completion != nil){
                                    completion!()
                                }
                                
                        }
                    }
                    else {
                        
                        
                        self.networkErrorLabel.hidden = false
                        return
                    }
                    
            });
            task.resume()
            
        
     
    }
    
    
    
    //delay
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
   
    func onRefresh() {
        networkRequest() { () -> Void in
            
        }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredMovies.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = filteredMovies[indexPath.row]
        
        let title = movie["title"] as! String
        
        let overview = movie["overview"] as! String
        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String{
        
        
        
        //let imageURL = NSURL(string: baseURL + posterPath)
        
        let posterURL = baseURL + posterPath
        
        let imageRequest = NSURLRequest(URL: NSURL(string: posterURL)!)
        
        cell.posterView.setImageWithURLRequest( imageRequest, placeholderImage: nil, success: {(imageRequest, imageResponse, image) -> Void in
            
            if imageResponse != nil {
                cell.posterView.alpha = 0.0
                cell.posterView.image = image
                UIView.animateWithDuration(1.2, animations:{ () -> Void in cell.posterView.alpha = 1.0})
            
            } else {
            
                cell.posterView.image = image
            
            }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in })
        
        
        }
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        //cell.posterView.setImageWithURL(imageURL!		)
        
        
        
        
        
        print("row \(indexPath.row)")
        
        return cell
        
        
    
    }
    
    func searchBar(searchBar : UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies.filter({ (movie: NSDictionary) -> Bool in
            let title = movie["title"] as! String
            return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        tableView.reloadData()
           
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        
        let indexPath = tableView.indexPathForCell(cell)
        
        let movie = movies[indexPath!.row]
        
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        
        detailViewController.movie = movie
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
