//
//  Extensions+String.swift
//  Annotator
//
//  Created by Bean John on 8/8/24.
//

import Foundation
import AppKit
import ExtensionKit

public extension String {
	
	mutating func correctSpelling() {
		// Get dominant language
		guard let dominantLang: String = try? self.strDominantLanguage() else {
			// Could not find dominant language
			return
		}
		// Setup spellchecker
		let spellChecker: NSSpellChecker = NSSpellChecker()
		guard spellChecker.setLanguage(dominantLang) else {
			// Language not availible
			return
		}
		// Perform check
		let resultRange: NSRange = spellChecker.checkSpelling(
			of: self,
			startingAt: 0
		)
		let hasErrors: Bool = resultRange.length > 0
		if !hasErrors { return }
		// Apply correction
		guard let corrected: String = spellChecker.correction(
			forWordRange: NSRange(
				self.startIndex..<self.endIndex,
				in: self
			),
			in: self,
			language: dominantLang,
			inSpellDocumentWithTag: 0
		) else {
			return
		}
		// Overwrite original
		print("Corrected spelling: \(self) -> \(corrected)")
		print("Range: \(resultRange)")
		self = corrected
	}
	
	/// Function to check if string is in a  language
	var language: Locale.Language? {
		// Get languages
		guard let langId = NSLinguisticTagger.dominantLanguage(for: self) else {
			// Return not in language if unidentified
			return nil
		}
		// Return result
		return Locale.Language(identifier: langId)
	}
	
}
