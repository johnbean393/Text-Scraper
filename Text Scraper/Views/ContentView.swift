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
	
	/// Property denoting whether to show actions sheet ever
	@AppStorage("confirmBeforeCopying") private var confirmBeforeCopying: Bool = false
	
	/// Property holding an NSScreen object
	var nsScreen: NSScreen
	
	/// Computed property that returns the dimensions of the display
	var size: CGSize {
		return nsScreen.frame.size
	}
	
	/// Property denoting all selected texts
	@State private var selectedTexts: [CapturedText] = []
	
	/// Property denoting position of controls
	@State private var prevControlsPosition: CGPoint = .zero
	@State private var controlsPosition: CGPoint = .zero
	
	var body: some View {
		AnnotationWindowContent(selectionRect: $selectionRect)
			.frame(width: size.width, height: size.height)
			.task {
				await textCapturer.updateCapturedTexts()
			}
			.gesture(selectionDragGesture)
			.overlay(alignment: .topLeading) {
				AnnotationWindowControls()
					.offset(x: controlsPosition.x, y: controlsPosition.y)
					.simultaneousGesture(controlsDragGesture)
			}
			.overlay(alignment: .topLeading) {
				SelectionIndicatorView(
					selectionRect: selectionRect
				)
			}
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
	
	var selectionDragGesture: some Gesture {
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
					CGRectIntersectsRect(selectionRect, $0.rect)
				}).contains(true) {
					self.selectedTexts = textCapturer.capturedTexts.filter({
						CGRectIntersectsRect(selectionRect, $0.rect)
					})
					// Show sheet if wanted
					if confirmBeforeCopying {
						self.showActionsSheet = true
					} else {
						// Copy directly
						let text: String = SelectionSheetView.joinSelectedTexts(
							selectedTexts: selectedTexts
						)
						text.copy(showPopup: true)
						// Dismiss window
						AppDelegate.shared.dismissAnnotationWindows()
					}
				}
				// Reset
				self.selectionRect = .zero
			}
	}
	
	var controlsDragGesture: some Gesture {
		DragGesture()
			.onChanged { proxy in
				let x: CGFloat = self.prevControlsPosition.x + proxy.translation.width
				let y: CGFloat = self.prevControlsPosition.y + proxy.translation.height
				self.controlsPosition = CGPoint(
					x: min(max(x, 0), nsScreen.frame.width - 50),
					y: min(max(y, 0), nsScreen.frame.height - 50)
				)
			}
			.onEnded { proxy in
				self.prevControlsPosition = self.controlsPosition
			}
	}
	
}

// #Preview {
//    ContentView()
// }
