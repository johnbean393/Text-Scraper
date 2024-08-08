//
//  Extensions+NSScreen.swift
//  Annotator
//
//  Created by Bean John on 8/8/24.
//

import Foundation
import AppKit

public extension NSScreen {
	
	var displayID: CGDirectDisplayID? {
		return deviceDescription[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")] as? CGDirectDisplayID
	}
	
	var realFrame: CGRect {
		let frame: CGRect = self.frame
		let scale: CGFloat = self.backingScaleFactor
		return CGRect(
			x: frame.minX,
			y: frame.minY,
			width: frame.width * scale,
			height: frame.height * scale
		)
	}
	
}
