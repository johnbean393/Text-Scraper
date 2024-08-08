//
//  SelectionSheetView.swift
//  Text Scraper
//
//  Created by Bean John on 8/9/24.
//

import SwiftUI

struct SelectionSheetView: View {
	
	@Binding var isPresented: Bool
	var selectedTexts: [CapturedText]
	
    var body: some View {
		VStack {
			Text("\(selectedTexts.count) texts selected")
			Divider()
			HStack {
				joinAndCopyButton
				dismissButton
			}
			.buttonStyle(.plain)
		}
    }
	
	var joinAndCopyButton: some View {
		Button {
			let text: String = selectedTexts.map({ $0.text }).joined(separator: "\n")
			let pasteboard: NSPasteboard = NSPasteboard.general
			pasteboard.declareTypes([.string], owner: nil)
			pasteboard.setString(text, forType: .string)
			isPresented = false
		} label: {
			Label("Join and Copy", systemImage: "document.on.document")
				.labelStyle(.titleAndIcon)
				.foregroundStyle(Color.blue.adaptedTextColor)
				.shadow(radius: 1)
				.padding(7)
				.padding(.horizontal, 3)
				.background {
					Capsule()
						.fill(Color.blue)
				}
		}
	}
	
	var dismissButton: some View {
		Button {
			isPresented = false
		} label: {
			Label("Do Nothing", systemImage: "nosign")
				.labelStyle(.titleAndIcon)
				.foregroundStyle(Color.secondary.adaptedTextColor)
				.shadow(radius: 1)
				.padding(7)
				.background {
					Capsule()
						.fill(Color.secondary)
				}
		}
	}
	
}

//#Preview {
//    SelectionSheetView()
//}
