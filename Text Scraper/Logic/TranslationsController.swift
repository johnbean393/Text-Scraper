//
//  AnnotationsController.swift
//  Annotator
//
//  Created by Bean John on 8/8/24.
//

import SwiftUI
import AppKit
import Foundation

public class AnnotationsController {
	
	/// Property that holds windows for annotation screens
	private var windows: [NSWindow] = []

	/// Computed property that returns all screens
	private var screens: [NSScreen] {
		return NSScreen.screens
	}
	
	/// Property containing timer that dismisses annotations
	private var timer: Timer? = nil

	/// Function to show annotation windows
	public func showAnnotationWindows() {
		// Hide Dock and Menu Bar
		NSApplication.shared.presentationOptions = [
			.hideDock,
			.hideMenuBar
		]
		// For each screen
		for screen in screens {
			// Init window
			let window = NSWindow.getOverlayWindow()
			// Set properties
			window.minSize = screen.realFrame.size
			window.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
			// Assign window to screen
			window.setPosition(
				vertical: .top,
				horizontal: .left,
				padding: 0,
				screen: screen
			)
			// Get content view
			window.contentView = NSHostingView(
				rootView: ContentView(nsScreen: screen)
			)
			windows.append(window)
		}
		// Set timer if needed
		self.setAutoDismissIfNeeded()
	}

	/// Function to dismiss annotation windows
	public func dismissAnnotationWindows() {
		// Close all windows
		for index in windows.indices {
			windows[index].close()
		}
		// Purge array
		windows.removeAll()
		// Purge timer
		self.removeAutoDismiss()
	}
	
	/// Function to set or extend time before window is dissmissed
	public func setAutoDismissIfNeeded() {
		// Clear timer
		self.removeAutoDismiss()
		// Set timer if needed
		let shouldAutoDismiss: Bool = UserDefaults.standard.bool(forKey: "shouldAutoDismiss")
		if shouldAutoDismiss {
			self.timer = Timer.scheduledTimer(
				withTimeInterval: 10,
				repeats: false
			) { _ in
				self.dismissAnnotationWindows()
			}
		}
	}
	
	/// Function to remove auto dismiss
	public func removeAutoDismiss() {
		if self.timer != nil {
			self.timer!.invalidate()
			self.timer = nil
		}
	}
}
