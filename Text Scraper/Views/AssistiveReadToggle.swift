//
//  AssistiveReadToggle.swift
//  Text Scraper
//
//  Created by Bean John on 8/8/24.
//

import SwiftUI

struct AssistiveReadToggle: View {
	
	@AppStorage("assistiveReadEnabled") var assistiveReadEnabled: Bool = false
	
    var body: some View {
		Toggle(isOn: $assistiveReadEnabled) {
			Label("Assistive Read", systemImage: "book.pages")
		}
		.toggleStyle(.switch)
    }
	
}

#Preview {
    AssistiveReadToggle()
}
