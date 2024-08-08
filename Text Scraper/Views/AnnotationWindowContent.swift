//
//  AnnotationWindowContent.swift
//  Text Scraper
//
//  Created by Bean John on 8/9/24.
//

import SwiftUI

struct AnnotationWindowContent: View {
	
	/// The text capturer object for this screen
	@EnvironmentObject private var textCapturer: TextCapturer
	
	/// Binding to property storing the size of the selection
	@Binding var selectionRect: CGRect
	
	var body: some View {
		screenImage
			.scaledToFit()
			.overlay(alignment: .topLeading) {
				// If selecting, dim background
				if selectionRect != .zero {
					Color.black.opacity(0.3)
				}
			}
			.overlay(alignment: .topLeading) {
				ForEach($textCapturer.capturedTexts) { text in
					ZStack(alignment: .topLeading) {
						Color.clear
						AnnotatedTextView(
							withText: text,
							selectionRect: $selectionRect
						)
						.offset(
							x: text.wrappedValue.offsetX,
							y: text.wrappedValue.offsetY
						)
					}
				}
			}
	}
	
	var screenImage: some View {
		Group {
			if textCapturer.image == nil {
				EmptyView()
			} else {
				textCapturer.image!.resizable()
			}
		}
	}
}

//#Preview {
//    AnnotationWindowContent()
//}
