//
//  GeneralSettingsView.swift
//  Text Scraper
//
//  Created by Bean John on 8/8/24.
//

import SwiftUI
import LaunchAtLogin
import KeyboardShortcuts

struct GeneralSettingsView: View {
	
	@AppStorage("shouldAutoDismiss") private var shouldAutoDismiss: Bool = false
	@AppStorage("confirmBeforeCopying") private var confirmBeforeCopying: Bool = false
	
	var body: some View {
		Form {
			VStack(alignment: .leading) {
				shortcut
				launch
				dismiss
			}
		}
		.padding()
	}
	
	var launch: some View {
		Group {
			HStack {
				VStack(alignment: .leading) {
					Text("Launch at Login")
						.font(.title3)
						.bold()
					Text("Whether the app launches when you power on your Mac.")
						.font(.caption)
				}
				Spacer()
				LaunchAtLogin.Toggle("")
					.toggleStyle(.switch)
			}
		}
	}
	
	var shortcut: some View {
		Group {
			HStack {
				VStack(alignment: .leading) {
					Text("Shortcut")
						.font(.title3)
						.bold()
					Text("The shortcut used to trigger and dismiss text annotations.")
						.font(.caption)
				}
				Spacer()
				KeyboardShortcuts.Recorder("", name: .showAnnotations)
			}
		}
	}
	
	var dismiss: some View {
		Group {
			HStack {
				VStack(alignment: .leading) {
					Text("Auto Dismiss Text")
						.font(.title3)
						.bold()
					Text("Controls whether text annotations are dismissed after 10 seconds.")
						.font(.caption)
				}
				Spacer()
				Toggle("", isOn: $shouldAutoDismiss)
					.toggleStyle(.switch)
			}
		}
	}
	
	var showCopySheet: some View {
		Group {
			HStack {
				VStack(alignment: .leading) {
					Text("Confirm Before Copying")
						.font(.title3)
						.bold()
					Text("Controls whether a prompt is shown before copying text.")
						.font(.caption)
				}
				Spacer()
				Toggle("", isOn: $confirmBeforeCopying)
					.toggleStyle(.switch)
			}
		}
	}
}

#Preview {
    GeneralSettingsView()
}
