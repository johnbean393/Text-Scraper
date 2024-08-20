//
//  Extension+View.swift
//  Text Scraper
//
//  Created by Bean John on 8/20/24.
//

import SwiftUI

extension View where Self: Shape {
	
	func glow(
		fill: some ShapeStyle,
		lineWidth: Double,
		blurRadius: Double = 8.0,
		lineCap: CGLineCap = .round
	) -> some View {
		self
			.stroke(style: StrokeStyle(lineWidth: lineWidth / 2, lineCap: lineCap))
			.fill(fill)
			.overlay {
				self
					.stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap))
					.fill(fill)
					.blur(radius: blurRadius)
			}
			.overlay {
				self
					.stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap))
					.fill(fill)
					.blur(radius: blurRadius / 2)
			}
	}
	
}
