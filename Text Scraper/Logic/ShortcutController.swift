//
//  ShortcutController.swift
//  Annotator
//
//  Created by Bean John on 8/8/24.
//

import Foundation
import KeyboardShortcuts

public class ShortcutController {
	
	/// Function to set default keyboard shortcuts
	public static func setDefaultShortcuts() {
		// Set default shortcut if no value
		if KeyboardShortcuts
			.getShortcut(for: .showAnnotations) == nil {
			// Set to "Function + t"
			KeyboardShortcuts.setShortcut(
				.init(.t, modifiers: [.command, .control]),
				for: .showAnnotations
			)
		}
	}
	
	/// Function to setup keyboard shortcuts
	public static func setupShortcuts(
		show: @escaping () -> Void
	 ) {
		KeyboardShortcuts
			.onKeyDown(for: .showAnnotations) {
				// Display annotation windows
				show()
			}
	}
	
}
