//
//  Extension+Array.swift
//  Text Scraper
//
//  Created by Bean John on 9/17/24.
//

import Foundation

extension Array where Element: Hashable {
	var mode: Element? {
		return self.reduce([Element: Int]()) {
			var counts = $0
			counts[$1] = ($0[$1] ?? 0) + 1
			return counts
		}.max { $0.1 < $1.1 }?.0
	}
}
