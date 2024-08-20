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
		let startAngle: Angle = .degrees(Double.random(in: 0...360))
		self.startAngle = startAngle
		self.borderStyle = Self.getGradient(angle: startAngle)
	}

	/// Property denoting the border style's start angle
	var startAngle: Angle
	/// State property denoting gradient width
	@State private var gradientWidth: CGFloat = 0
	/// State property denoting whether accentColor is shown
	@State private var showAccentColor: Bool = false
	/// State property denoting whether text overlay is shown
	@State private var showTextOverlay: Bool = false
	
	/// State property denoting the border style
	@State private var borderStyle: AngularGradient

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
		.onAppear(perform: animateAppear)
	}

	var textOverlay: some View {
		ZStack {
			RoundedRectangle(
				cornerRadius: capturedText.rect.height * 0.20
			)
			.foregroundStyle(borderStyle)
			.frame(
				minWidth: minWidth + gradientWidth * 2,
				maxWidth: capturedText.rect.width + gradientWidth * 2,
				minHeight: minHeight + gradientWidth * 2,
				maxHeight: capturedText.rect.height + gradientWidth * 2
			)
			.blur(radius: gradientWidth)
			RoundedRectangle(
				cornerRadius: capturedText.rect.height * 0.20
			)
			.fill(capturedText.backgroundColor)
			.frame(
				minWidth: minWidth,
				maxWidth: capturedText.rect.width,
				minHeight: minHeight,
				maxHeight: capturedText.rect.height
			)
			.overlay {
				text
			}
		}
		.contextMenu {
			copyButton
		}
	}

	var copyButton: some View {
		Button {
			let pasteboard = NSPasteboard.general
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
			.opacity(showTextOverlay ? 1.0 : 0.0)
	}

	var assistiveReadImage: some View {
		ZStack {
			RoundedRectangle(
				cornerRadius: capturedText.rect.height * 0.20
			)
			.foregroundStyle(borderStyle)
			.frame(
				minWidth: minWidth + gradientWidth * 2,
				maxWidth: capturedText.rect.width + gradientWidth * 2,
				minHeight: minHeight + gradientWidth * 2,
				maxHeight: capturedText.rect.height + gradientWidth * 2
			)
			.blur(radius: gradientWidth)
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

	private func animateAppear() {
		// Animate appearance
		let phase1 = 1.0
		let phase2 = 0.5
		withAnimation(.easeOut(duration: phase1)) {
			gradientWidth = 5
			showTextOverlay = true
			borderStyle = Self.getGradient(
				angle: Angle(degrees: startAngle.degrees + 240)
			)
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + phase1) {
			withAnimation(.easeIn(duration: phase2)) {
				gradientWidth = 1.0
				borderStyle = AngularGradient(
					colors: [Color.accentColor],
					center: .center,
					angle: startAngle
				)
			}
		}
	}
	
	private static func getGradient(angle: Angle) -> AngularGradient {
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
			angle: angle
		)
	}
	
}

// #Preview {
//    AnnotatedTextView()
// }
