//
//  AnnotationWindowControls.swift
//  Text Scraper
//
//  Created by Bean John on 8/9/24.
//

import SwiftUI

struct AnnotationWindowControls: View {
    var body: some View {
		HStack {
			OverlayExitButton()
			AssistiveReadToggle()
		}
		.padding(5)
		.background {
			Capsule()
				.stroke(Color.secondary, lineWidth: 5)
				.fill(
					Color(
						nsColor: NSColor.windowBackgroundColor
					)
				)
		}
		.padding()
    }
}

#Preview {
    AnnotationWindowControls()
}
