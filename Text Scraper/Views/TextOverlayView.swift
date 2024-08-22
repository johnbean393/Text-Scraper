//
//  TextOverlayView.swift
//  Text Scraper
//
//  Created by Bean John on 8/22/24.
//

import SwiftUI

struct TextOverlayView: View {
	
	var capturedText: CapturedText
	@Binding var showTextOverlay: Bool
	
    var body: some View {
		Text(capturedText.text)
			.foregroundStyle(capturedText.backgroundColor.adaptedTextColor)
			.font(.largeTitle)
			.scaledToFit()
			.minimumScaleFactor(0.2)
			.lineLimit(1)
			.textSelection(.enabled)
			.opacity(showTextOverlay ? 1.0 : 0.0)
    }
}

//#Preview {
//    TextOverlayView()
//}
