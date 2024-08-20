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
	
	/// Property holding CGRect of selection
	@State private var selectionRect: CGRect = .zero
	
	/// Property denoting whether to show actions sheet
	@State private var showActionsSheet: Bool = false
	
	/// Property holding an NSScreen object
	var nsScreen: NSScreen
	
	/// Computed property that returns the dimensions of the display
	var size: CGSize {
		return nsScreen.frame.size
	}
	
	/// Computed property that returns all selected texts
	@State private var selectedTexts: [CapturedText] = []
	
	var body: some View {
		AnnotationWindowContent(selectionRect: $selectionRect)
			.frame(width: size.width, height: size.height)
			.task {
				await textCapturer.updateCapturedTexts()
			}
			.overlay(alignment: .topLeading) {
				AnnotationWindowControls()
			}
			.overlay(alignment: .topLeading) {
				SelectionIndicatorView(
					selectionRect: selectionRect
				)
			}
			.gesture(dragGesture)
			.sheet(isPresented: $showActionsSheet) {
				SelectionSheetView(
					isPresented: $showActionsSheet,
					selectedTexts: selectedTexts
				)
			}
			.onChange(of: selectionRect) {
				// Extend show time
				AppDelegate.shared.annotationsController
					.setAutoDismissIfNeeded()
			}
			.onChange(of: NSEvent.mouseLocation) {
				// Extend show time
				AppDelegate.shared.annotationsController
					.setAutoDismissIfNeeded()
			}
			.environmentObject(textCapturer)
	}
	
	var dragGesture: some Gesture {
		DragGesture()
			.onChanged { proxy in
				// Reset selection
				self.selectedTexts = []
				// Record change
				self.selectionRect = CGRect(
					origin: proxy.startLocation,
					size: proxy.translation
				)
			}
			.onEnded { _ in
				// Show sheet if applicable
				// Check that elements were selected
				if textCapturer.capturedTexts.map({
					CGRectContainsRect( selectionRect, $0.rect)
				}).contains(true) {
					self.selectedTexts = textCapturer.capturedTexts.filter({
						CGRectContainsRect(selectionRect, $0.rect)
					})
					self.showActionsSheet = true
				}
				// Reset
				self.selectionRect = .zero
			}
	}
	
}

// #Preview {
//    ContentView()
// }
