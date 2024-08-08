//
//  Extensions+Array.swift
//  Annotator
//
//  Created by Bean John on 8/8/24.
//

import Foundation

extension Array {
	func unique(_ selector: (Element, Element) -> Bool) -> [Element] {
		return reduce([Element]()) {
			if let last = $0.last {
				return selector(last, $1) ? $0 : $0 + [$1]
			} else {
				return [$1]
			}
		}
	}
}
