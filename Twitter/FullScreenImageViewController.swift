//
//  FullScreenImageViewController.swift
//  Twitter
//
//  Created by Jiapei Liang on 2/27/17.
//  Copyright © 2017 jiapei. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var mediaUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        scrollView.delegate = self
        
        scrollView.contentSize = photoImageView.bounds.size
        
        scrollView.isUserInteractionEnabled = true
        
        scrollView.minimumZoomScale = 1
        
        scrollView.maximumZoomScale = 3
        
        scrollView.zoomScale = 1.001
        
        photoImageView.setImageWith(mediaUrl!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("Zomming")
    }
    
    @IBAction func exitFullScreen(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
