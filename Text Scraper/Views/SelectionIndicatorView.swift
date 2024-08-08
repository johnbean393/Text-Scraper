//
//  SelectionIndicatorView.swift
//  Text Scraper
//
//  Created by Bean John on 8/9/24.
//

import SwiftUI

struct SelectionIndicatorView: View {
	var selectionRect: CGRect

	var body: some View {
		Rectangle()
			.stroke(Color.secondary, lineWidth: 0.5)
			.fill(Color.secondary.opacity(0.15))
			.frame(
				width: selectionRect.width,
				height: selectionRect.height
			)
			.offset(
				x: selectionRect.minX,
				y: selectionRect.minY
			)
	}
}

//#Preview {
//	SelectionIndicatorView()
//}
