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

extension Array where Element == CapturedText {
	/// Function that returns a range of CGFloat specifying the range of acceptable vertical positionings
	func yTolarance() -> ClosedRange<CGFloat> {
		let sortedY: [CGFloat] = self.map { $0.rect.midY }.sorted()
		guard let minY: CGFloat = sortedY.first else { return 0...0 }
		guard let maxY: CGFloat = sortedY.last else { return 0...0 }
		let extendBy: CGFloat = 10
		return (minY - extendBy)...(maxY + extendBy)
	}

	/// Function that returns a range of CGFloat specifying the range of acceptable horizontal positionings
	func xTolarance() -> ClosedRange<CGFloat> {
		let sortedX: [CGFloat] = self.map { $0.rect.midX }.sorted()
		guard let minX: CGFloat = sortedX.first else { return 0...0 }
		guard let maxX: CGFloat = sortedX.last else { return 0...0 }
		let extendBy: CGFloat = 300
		return (minX - extendBy)...(maxX + extendBy)
	}

	/// Function that groups captured text by line
	func grouped() -> [[CapturedText]] {
		var groups: [[CapturedText]] = []
		// For each piece of text
		for capturedText in self {
			// Declare flag
			var groupFound = false
			// Check against each group
			for index in groups.indices {
				// If in range
				let xPass: Bool = groups[index].xTolarance().contains(capturedText.rect.minX) || groups[index].xTolarance().contains(capturedText.rect.maxX)
				let yPass: Bool = groups[index].yTolarance().contains(capturedText.rect.minY) || groups[index].yTolarance().contains(capturedText.rect.maxY)
				if xPass && yPass {
					// Add to group
					groups[index].append(capturedText)
					// Move on
					groupFound = true
					break
				}
			}
			// If not in any existing group, start new group
			if groupFound == false {
				groups.append([capturedText])
			}
		}
		// Return group
		return groups
	}
}
