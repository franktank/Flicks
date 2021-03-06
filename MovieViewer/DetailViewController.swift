//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Franky Liang on 1/18/16.
//  Copyright © 2016 Franky Liang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var infoView: UIView!
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height )
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"]
        overviewLabel.text = overview as? String
        
        overviewLabel.sizeToFit()
        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String{
            
            
            
            //let imageURL = NSURL(string: baseURL + posterPath)
            
            let posterURL = baseURL + posterPath
            
            let imageRequest = NSURLRequest(URL: NSURL(string: posterURL)!)
            
            posterImageView.setImageWithURLRequest( imageRequest, placeholderImage: nil, success: {(imageRequest, imageResponse, image) -> Void in
                
                if imageResponse != nil {
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = image
                    UIView.animateWithDuration(1.2, animations:{ () -> Void in self.posterImageView.alpha = 1.0})
                    
                } else {
                    
                 self.posterImageView.image = image
                    
                }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in })
            
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
