//
//  CapturedText.swift
//  Annotator
//
//  Created by Bean John on 8/8/24.
//

import DominantColors
import Foundation
import SwiftUI
import Vision

public struct CapturedText: Identifiable, Equatable {
	public init(from observation: VNRecognizedTextObservation, screen: NSScreen, cgImage: CGImage) throws {
		self.id = UUID()
		// Get text
		let topCandidate: VNRecognizedText? = observation.topCandidates(1).first
		let str: String = topCandidate?.string ?? ""
		self.text = str
		// Get rect
		guard let boundingBox: VNRectangleObservation = try topCandidate?.boundingBox(
			for: str.startIndex ..< str.endIndex
		) else {
			throw CapturedTextError.rectNotFound
		}
		// Scale rect
		let unscaledRect: CGRect = boundingBox.boundingBox
		let newHeight: CGFloat = screen.frame
			.height - (unscaledRect.origin.y * screen.frame.height)
		let scaledRect: CGRect = CGRect(
			x: unscaledRect.minX * screen.frame.width,
			y: newHeight,
			width: unscaledRect.width * screen.frame.width,
			height: unscaledRect.height * screen.frame.height
		)
		self.rect = scaledRect
		// Crop image to 2 rects, then find dominant color from larger one
		// For image
		let cropRectImage: CGRect = CGRect(
			x: unscaledRect.minX * screen.realFrame.width,
			y: (1 - unscaledRect.minY - unscaledRect.height) * screen.realFrame.height,
			width: unscaledRect.width * screen.realFrame.width,
			height: unscaledRect.height * screen.realFrame.height
		)
		if let croppedImage: CGImage = cgImage.cropping(
			to: cropRectImage
		) {
			self.cgImage = croppedImage
		} else {
			print("Failed to crop image")
		}
		// For color
		let cropRectColor: CGRect = CGRect(
			x: min(unscaledRect.minX * screen.realFrame.width - 4, 0),
			y: min(
				(1 - unscaledRect.minY - unscaledRect.height) * screen.realFrame.height - 4,
				0
			),
			width: unscaledRect.width * screen.realFrame.width + 8,
			height: unscaledRect.height * screen.realFrame.height + 8
		)
		if let croppedImage: CGImage = cgImage.cropping(
			to: cropRectColor
		) {
			if let dominantColor: CGColor = try? DominantColors
				.dominantColors(
					image: croppedImage,
					quality: .best
				)
					.first {
				self.backgroundColor = Color(
					cgColor: dominantColor
				)
				// Exit init
				return
			}
		} else {
			print("Failed to crop image")
		}
		// If fall through
		self.backgroundColor = Color(nsColor: .textBackgroundColor)
	}
	
	public var id: UUID
	
	public var text: String
	
	public var rect: CGRect
	public var backgroundColor: Color
	public var cgImage: CGImage?
	
	public var offsetX: CGFloat {
		return rect.origin.x
	}
	
	public var offsetY: CGFloat {
		return rect.origin.y - rect.height
	}
	
	public mutating func correctSpelling() {
		self.text.correctSpelling()
	}
	
	public enum CapturedTextError: Error {
		case rectNotFound
	}
}
