//
//  Extension+NSImage.swift
//  Text Scraper
//
//  Created by Bean John on 9/17/24.
//

import AppKit
import Foundation
import SwiftUI

extension CGImage {
	
	func getPixelColor(at pos: NSPoint) -> Color {
		let data: UnsafePointer<UInt8> = CFDataGetBytePtr(self.dataProvider!.data)
		let bytesPerPixel = self.bitsPerPixel / 8
		let pixelInfo = ((Int(self.width) * Int(pos.y)) + Int(pos.x)) * bytesPerPixel
		let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
		let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
		let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
		let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
		return Color(red: r, green: g, blue: b, opacity: a)
	}
	
}
