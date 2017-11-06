//
//  ImageViewEx.swift
//  DaumBookFinderWithXML
//
//  Created by 이영록 on 2017. 5. 2..
//  Copyright © 2017년 jellyworks. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
	func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//		sqrt(<#T##Double#>)
		contentMode = mode
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)
				else { return }
			DispatchQueue.main.async() { () -> Void in
				self.image = image
			}
			}.resume()
	}
	func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
		guard let url = URL(string: link) else { return }
		downloadedFrom(url: url, contentMode: mode)
	}
}
