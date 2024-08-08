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
			let pasteboard = NSPasteboard.general
			pasteboard.declareTypes([.string], owner: nil)
			pasteboard.setString(
				self.joinSelectedTexts(),
				forType: .string
			)
			isPresented = false
			AppDelegate.shared.dismissAnnotationWindows()
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
			Label("Cancel", systemImage: "nosign")
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
	
	private func joinSelectedTexts() -> String {
		let groupedTexts: [[CapturedText]] = selectedTexts.grouped()
		let lines: [String] = groupedTexts.map {
			$0.map { $0.text }.joined(separator: "    ")
		}
		let text: String = lines.joined(separator: "\n")
		return text
	}
	
}

// #Preview {
//    SelectionSheetView()
// }
