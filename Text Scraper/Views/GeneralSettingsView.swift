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
	
	var body: some View {
		Form {
			VStack(alignment: .leading) {
				launch
				shortcut
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
}

#Preview {
    GeneralSettingsView()
}
