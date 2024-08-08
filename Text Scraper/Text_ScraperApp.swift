//
//  AnnotatorApp.swift
//  Annotator
//
//  Created by Bean John on 8/7/24.
//

import SwiftUI

@main
struct Text_ScraperApp: App {
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	var body: some Scene {
		MenuBarExtra {
			MenuBarView()
		} label: {
			Label("Text Scraper", systemImage: "text.viewfinder")
		}
		
		Settings {
			SettingsView()
		}
	}
}
