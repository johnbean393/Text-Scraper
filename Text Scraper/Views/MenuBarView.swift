//
//  MenuBarView.swift
//  Text Scraper
//
//  Created by Bean John on 8/9/24.
//

import SwiftUI

struct MenuBarView: View {
	
    var body: some View {
		VStack(alignment: .leading) {
			toggleWindow
			openSettings
			Divider()
			quit
		}
    }
	
	var toggleWindow: some View {
		Button {
			AppDelegate.shared.toggleAnnotationWindows()
		} label: {
			Text(AppDelegate.shared.isShowing ? "Hide Text" : "Show Text")
		}
	}
	
	var openSettings: some View {
		SettingsLink {
			Label("Show Settings", systemImage: "gear")
				.labelStyle(.titleOnly)
		}
	}
	
	var quit: some View {
		// Button to quit application
		Button("Quit") {
			// Quit application
			NSApplication.shared.terminate(nil)
		}
		.keyboardShortcut("q", modifiers: [.command])
	}
	
}

#Preview {
    MenuBarView()
}
