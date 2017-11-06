//
//  MainTableViewController.swift
//  DaumBookFinderWithXML
//
//  Created by 이영록 on 2017. 4. 30..
//  Copyright © 2017년 jellyworks. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, XMLParserDelegate, UISearchBarDelegate {
	let apiKey = "12e019b25265e571f9c178f4d9e4540d"
	var item:[String:String] = [:]
	var items:[[String:String]] = []
	var currentElement:String = ""
	var currentPage = 1
	
	@IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
		searchBar.delegate = self
     }
	
	func search(page:Int){
		print("Page : \(page)")
		items = []
		let str = "http://apis.daum.net/search/book?apikey=\(apiKey)&output=xml&q=\(searchBar.text!)&pageno=\(page)&result=20" as NSString
		
		let strURL = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
		print(strURL ?? "url is error")
		if let strURL = strURL, let url = URL(string:strURL),
			let parser = XMLParser(contentsOf: url){
			parser.delegate = self
			
			let success = parser.parse()
			if success {
				print("parse success!")
				print(items.count)
				tableView.reloadData()
			} else {
				print("parse failure!")
			}
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		currentPage = 1
		search(page: currentPage)
	}
	
	@IBAction func actPrev(_ sender: UIBarButtonItem) {
		currentPage -= 1
		search(page:currentPage)
	}
	
	@IBAction func actNext(_ sender: UIBarButtonItem) {
		currentPage += 1
		search(page:currentPage)
	}
	
	// MARK: - XMLParser Delegate
	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
		currentElement = elementName
		if elementName == "item"{
			item = [:]
		}
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		item[currentElement] = string.trimmingCharacters(in: CharacterSet.whitespaces)
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if(elementName == "item") {
			items.append(item)
		}
	}
	
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		print("items.count = \(items.count)")
        return items.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let book = items[indexPath.row]


		if let imageView = cell.viewWithTag(1) as? UIImageView
			,let strURL = book["cover_l_url"]{
			imageView.downloadedFrom(link: strURL)
		}

		
		let lblTitle = cell.viewWithTag(2) as? UILabel
		lblTitle?.text = book["title"]
		
		let lblAuthor = cell.viewWithTag(3) as? UILabel
		lblAuthor?.text = book["author"]

		let lblPub = cell.viewWithTag(4) as? UILabel
		lblPub?.text = book["pub_nm"]
		
		let lblPrice = cell.viewWithTag(5) as? UILabel
		lblPrice?.text = book["sale_price"]
		return cell
    }
	
	

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	
		if let detailViewController = segue.destination as? DetailViewController
		   ,let indexPath = tableView.indexPathForSelectedRow {
			let book = items[indexPath.row]
			detailViewController.linkURL = book["link"]
		}
	}
	

}
