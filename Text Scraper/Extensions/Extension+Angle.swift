//
//  Extension+Angle.swift
//  Text Scraper
//
//  Created by Bean John on 8/22/24.
//

import Foundation
import SwiftUI

public extension Angle {
	
	func getGradient() -> AngularGradient {
		return AngularGradient(
			stops: [
				.init(color: .white, location: 0.0),
				.init(color: .cyan, location: 0.2),
				.init(color: .blue, location: 0.3),
				.init(color: .purple, location: 0.4),
				.init(color: .pink, location: 0.6),
				.init(color: .yellow, location: 0.8),
				.init(color: .white, location: 1.0),
			],
			center: .center,
			angle: self
		)
	}
	
}
