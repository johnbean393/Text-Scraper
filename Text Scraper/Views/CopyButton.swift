//
//  CopyButton.swift
//  Text Scraper
//
//  Created by Bean John on 8/22/24.
//

import SwiftUI

struct CopyButton: View {
	
	var text: String
	
    var body: some View {
		Button {
			text.copy()
		} label: {
			Label("Copy", systemImage: "document.on.document")
		}
    }
}

#Preview {
	CopyButton(text: "Hello, World!")
}
