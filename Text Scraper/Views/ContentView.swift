//
//  ContentView.swift
//  Annotator
//
//  Created by Bean John on 8/7/24.
//

import ExtensionKit
import SwiftUI

struct ContentView: View {
	init(nsScreen: NSScreen) {
		self.nsScreen = nsScreen
		_textCapturer = StateObject(
			wrappedValue: TextCapturer(screen: nsScreen)
		)
	}
	
	/// The text capturer object for this screen
	@StateObject private var textCapturer: TextCapturer
	
	/// Property holding an NSScreen object
	var nsScreen: NSScreen
	
	/// Computed property that returns the dimensions of the display
	var size: CGSize {
		return nsScreen.frame.size
	}
	
	var body: some View {
		content
			.frame(width: size.width, height: size.height)
			.overlay(alignment: .topLeading) {
				OverlayExitButton()
					.padding()
			}
			.task {
				await textCapturer.updateCapturedTexts()
			}
	}
	
	var content: some View {
		screenImage
			.scaledToFit()
			.overlay(alignment: .topLeading) {
				ForEach($textCapturer.capturedTexts) { text in
					ZStack(alignment: .topLeading) {
						Color.clear
						AnnotatedTextView(
							withText: text
						)
						.offset(
							x: text.wrappedValue.offsetX,
							y: text.wrappedValue.offsetY
						)
					}
				}
			}
	}
	
	var screenImage: some View {
		Group {
			if textCapturer.image == nil {
				EmptyView()
			} else {
				textCapturer.image!.resizable()
			}
		}
	}
}

// #Preview {
//    ContentView()
// }
