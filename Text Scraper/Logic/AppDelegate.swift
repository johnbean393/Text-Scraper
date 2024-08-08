//
//  AppDelegate.swift
//  Annotator
//
//  Created by Bean John on 8/7/24.
//

import AppKit
import Foundation
import KeyboardShortcuts

public class AppDelegate: NSObject, NSApplicationDelegate {
	
	/// Static constant for shared "AppDelegate" object
	static let shared: AppDelegate = AppDelegate()
	
	/// Property holding the annotations controller
	public var annotationsController: AnnotationsController = .init()
	
	/// Property containg a value denoting whether a annotation overlay is already present
	public var isShowing: Bool = true
	
	/// Function that is called when the app is launched
	public func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Set default shortcuts
		ShortcutController.setDefaultShortcuts()
		// Set up key watchers
		ShortcutController.setupShortcuts {
			if Self.shared.isShowing {
				Self.shared.annotationsController.showAnnotationWindows()
				Self.shared.isShowing.toggle()
			} else {
				Self.shared.dismissAnnotationWindows()
			}
		}
	}
	
	public func dismissAnnotationWindows() {
		Self.shared.annotationsController.dismissAnnotationWindows()
		Self.shared.isShowing.toggle()
	}
}
