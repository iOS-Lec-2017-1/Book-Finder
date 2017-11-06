//
//  DetailViewController.swift
//  DaumBookFinderWithXML
//
//  Created by 이영록 on 2017. 4. 30..
//  Copyright © 2017년 jellyworks. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	var linkURL:String?
	
	@IBOutlet weak var webView: UIWebView!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		if let strURL = linkURL, let url = URL(string:strURL) {
			let request = URLRequest(url:url)
			webView.loadRequest(request)
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
