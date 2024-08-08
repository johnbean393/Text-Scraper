//
//  AnnotatedTextView.swift
//  Annotator
//
//  Created by Bean John on 8/8/24.
//

import AppKit
import ExtensionKit
import SwiftUI

struct AnnotatedTextView: View {
	init(
		withText: Binding<CapturedText>,
		selectionRect: Binding<CGRect>,
		minHeight: CGFloat = 10,
		minWidth: CGFloat = 10
	) {
		self._capturedText = withText
		self._selectionRect = selectionRect
		self.minHeight = minHeight
		self.minWidth = minWidth
	}

	/// Binding to property storing captured text, its image and its position
	@Binding var capturedText: CapturedText
	/// Binding to property storing the size of the selection
	@Binding var selectionRect: CGRect

	/// Users defaults value for whether assistive read is on
	@AppStorage("assistiveReadEnabled") var assistiveReadEnabled: Bool = false

	var minHeight: CGFloat
	var minWidth: CGFloat

	var inSelection: Bool {
		return CGRectContainsRect(selectionRect, capturedText.rect)
	}

	var body: some View {
		Group {
			if !assistiveReadEnabled {
				textOverlay
			} else {
				assistiveReadImage
			}
		}
		.if(inSelection) { view in
			// Glow if selected
			view.glow(color: Color.white, radius: 3, blurred: false)
		}
	}

	var textOverlay: some View {
		RoundedRectangle(
			cornerRadius: capturedText.rect.height * 0.20
		)
		.stroke(
			Color.accentColor,
			lineWidth: 1
		)
		.fill(capturedText.backgroundColor)
		.frame(
			minWidth: minWidth,
			maxWidth: capturedText.rect.width,
			minHeight: minHeight,
			maxHeight: capturedText.rect.height
		)
		.overlay(alignment: .center) {
			text
		}
		.contextMenu {
			copyButton
		}
	}

	var copyButton: some View {
		Button {
			let pasteboard: NSPasteboard = NSPasteboard.general
			pasteboard.declareTypes([.string], owner: nil)
			pasteboard.setString(capturedText.text, forType: .string)
		} label: {
			Label("Copy", systemImage: "document.on.document")
		}
	}

	var text: some View {
		Text(capturedText.text)
			.foregroundStyle(capturedText.backgroundColor.adaptedTextColor)
			.font(.largeTitle)
			.scaledToFit()
			.minimumScaleFactor(0.2)
			.lineLimit(1)
			.textSelection(.enabled)
	}

	var assistiveReadImage: some View {
		ZStack {
			RoundedRectangle(
				cornerRadius: capturedText.rect.height * 0.20
			)
			.fill(Color.accentColor)
			.frame(
				minWidth: minWidth + 2,
				maxWidth: capturedText.rect.width + 2,
				minHeight: minHeight + 2,
				maxHeight: capturedText.rect.height + 2
			)
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
			.clipShape(
				RoundedRectangle(
					cornerRadius: capturedText.rect.height * 0.20
				)
			)
		}
	}
}

// #Preview {
//    AnnotatedTextView()
// }
