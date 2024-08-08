//
//  TextCapturer.swift
//  Annotator
//
//  Created by Bean John on 8/8/24.
//

import Foundation
import ScreenCaptureKit
import SwiftUI
import Vision

@MainActor
public class TextCapturer: ObservableObject {
	public init(screen: NSScreen, capturedTexts: [CapturedText] = []) {
		self.screen = screen
		self.capturedTexts = capturedTexts
	}
	
	/// Property containing the screen this capturer is working with
	private var screen: NSScreen
	
	/// Published property containing texts and their associated CGRect's
	@Published var capturedTexts: [CapturedText]
	
	/// Published property containing an image of the screen for debugging
	@Published var image: Image?
	
	/// Function to update captured texts
	public func updateCapturedTexts() async {
		// Capture screen
		let cgImage: CGImage
		do {
			cgImage = try await captureScreen()
			image = Image(cgImage, scale: 1.0, label: Text("Screen"))
		} catch {
			print("error: \(error.localizedDescription)")
			return
		}
		// Form request
		let requestHandler = VNImageRequestHandler(
			cgImage: cgImage
		)
		let textRequest = VNRecognizeTextRequest { request, _ in
			guard let observations: [VNRecognizedTextObservation] = request.results as? [VNRecognizedTextObservation] else {
				return
			}
			// Get texts with corrected spelling
			let texts: [CapturedText?] = observations.map {
				guard let capturedText: CapturedText = try? CapturedText(
					from: $0,
					screen: self.screen,
					cgImage: cgImage
				) else {
					return nil
				}
				return capturedText
			}
			self.capturedTexts = texts
				.compactMap { $0 }
				.unique {
					$0.rect.origin == $1.rect.origin
				}
		}
		// Config request
		textRequest.recognitionLevel = .accurate
		textRequest.automaticallyDetectsLanguage = true
		textRequest.usesLanguageCorrection = true
		// Set langs
		let langs: [Locale.Language] = [
			Locale.Language(identifier: "en"),
			Locale.Language(identifier: "zh"),
			Locale.Language(identifier: "hi"),
			Locale.Language(identifier: "es"),
			Locale.Language(identifier: "fr"),
			Locale.Language(identifier: "ar"),
			Locale.Language(identifier: "bn"),
			Locale.Language(identifier: "ru"),
			Locale.Language(identifier: "pt"),
			Locale.Language(identifier: "ur"),
			Locale.Language(identifier: "id"),
			Locale.Language(identifier: "de"),
			Locale.Language(identifier: "ja"),
			Locale.Language(identifier: "tr"),
			Locale.Language(identifier: "vi"),
			Locale.Language(identifier: "th"),
			Locale.Language(identifier: "la")
		]
		let uniqueLangs: [Locale.Language] = (langs + Locale.Language.systemLanguages).unique(
			{ $0.minimalIdentifier == $1.minimalIdentifier }
		)
		textRequest.recognitionLanguages = uniqueLangs.map {
			$0.minimalIdentifier
		}
		// Run request
		do {
			try requestHandler.perform([textRequest])
		} catch { print("Vision request error: \(error)") }
	}
	
	/// Function to capture screen
	private func captureScreen() async throws -> CGImage {
		// Get sharable content
		let availableContent: SCShareableContent
		do {
			availableContent = try await SCShareableContent.current
		} catch {
			throw CaptureError.couldNotGetSharableContent
		}
		// Get this app
		guard let thisApp: SCRunningApplication = availableContent.applications.filter({
			$0.bundleIdentifier == Bundle.main.bundleIdentifier ?? ""
		}).first else {
			throw CaptureError.couldNotGetSCRunningApp
		}
		// Get this display
		guard let thisDisplay: SCDisplay = availableContent.displays.filter({
			$0.displayID == screen.displayID
		}).first else {
			throw CaptureError.couldNotCaptureMainDisplay
		}
		// Define config
		let contentFilter = SCContentFilter(
			display: thisDisplay,
			excludingApplications: [thisApp],
			exceptingWindows: []
		)
		let config = SCStreamConfiguration()
		config.captureResolution = .best
		config.width = Int(screen.realFrame.width)
		config.height = Int(screen.realFrame.height)
		// Capture and return
		if let cgImage = try? await SCScreenshotManager.captureImage(
			contentFilter: contentFilter,
			configuration: config
		) {
			return cgImage
		} else {
			throw CaptureError.unclearError
		}
	}
	
	public enum CaptureError: Error {
		case couldNotGetSharableContent
		case couldNotCaptureMainDisplay
		case couldNotGetSCRunningApp
		case unclearError
	}
}
