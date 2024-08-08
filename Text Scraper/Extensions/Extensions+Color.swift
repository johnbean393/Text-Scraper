//
//  Extensions+Color.swift
//  Annotator
//
//  Created by Bean John on 8/8/24.
//

import Foundation
import SwiftUI

extension Color {
	// Luminance computed property
	private var luminance: Double {
		// Convert SwiftUI Color to OSColor to CIColor
		let nsColor = NSColor(self)
		let ciColor = CIColor(color: nsColor)!
		
		// Extract RGB values
		let red: CGFloat = ciColor.red
		let green: CGFloat = ciColor.green
		let blue: CGFloat = ciColor.blue
		
		// Compute luminance.
		return 0.2126 * Double(red) + 0.7152 * Double(green) + 0.0722 * Double(blue)
	}
	
	// Computed property that returns most appropriate text color
	public var adaptedTextColor: Color {
		return (self.luminance > 0.5) ? Color.black : Color.white
	}
}
