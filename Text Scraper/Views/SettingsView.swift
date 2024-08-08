//
//  SettingsView.swift
//  Annotator
//
//  Created by Bean John on 8/7/24.
//

import SwiftUI

struct SettingsView: View {
	
	var body: some View {
		TabView {
			GeneralSettingsView()
				.tabItem {
					Label("General", systemImage: "gear")
				}
		}
		.frame(maxWidth: 450, maxHeight: 250)
	}
	
}

#Preview {
    SettingsView()
}
