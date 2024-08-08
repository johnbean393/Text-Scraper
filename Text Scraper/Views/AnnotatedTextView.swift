//
//  AnnotatedTextView.swift
//  Annotator
//
//  Created by Bean John on 8/8/24.
//

import SwiftUI

struct AnnotatedTextView: View {
	
	init(
		withText: Binding<CapturedText>,
		minHeight: CGFloat = 10,
		minWidth: CGFloat = 10
	) {
		self._capturedText = withText
		self.minHeight = minHeight
		self.minWidth = minWidth
	}
	
	@Binding var capturedText: CapturedText
	
	var minHeight: CGFloat
	var minWidth: CGFloat

	var body: some View {
		textOverlay
	}

	var textOverlay: some View {
		RoundedRectangle(
			cornerRadius: capturedText.rect.height * 0.15
		)
		.fill(capturedText.backgroundColor)
		.frame(
			minWidth: minWidth,
			maxWidth: capturedText.rect.width,
			minHeight: minHeight,
			maxHeight: capturedText.rect.height
		)
		.overlay(alignment: .center) {
			Text(capturedText.text)
				.foregroundStyle(capturedText.backgroundColor.adaptedTextColor)
				.font(.largeTitle)
				.scaledToFit()
				.minimumScaleFactor(0.2)
				.lineLimit(1)
		}
	}

	var debugImage: some View {
		Group {
			if capturedText.cgImage != nil {
				Image(
					capturedText.cgImage!,
					scale: 1.0,
					label: Text("")
				)
				.resizable()
			} else {
				Rectangle()
			}
		}
		.frame(
			minWidth: minWidth,
			maxWidth: capturedText.rect.width,
			minHeight: minHeight,
			maxHeight: capturedText.rect.height
		)
		.border(Color.accentColor)
	}
}

// #Preview {
//    AnnotatedTextView()
// }
