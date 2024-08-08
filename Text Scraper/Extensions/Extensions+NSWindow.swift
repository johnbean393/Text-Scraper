//
//  Extensions+NSWindow.swift
//  Annotator
//
//  Created by Bean John on 8/8/24.
//

import AppKit
import Foundation

extension NSWindow.Position {
	func value(forWindow windowRect: CGRect, inScreen screenRect: CGRect) -> CGPoint {
		let xPosition = horizontal.valueFor(
			screenRange: screenRect.minX..<screenRect.maxX,
			width: windowRect.width,
			padding: padding
		)
		
		let yPosition = vertical.valueFor(
			screenRange: screenRect.minY..<screenRect.maxY,
			height: windowRect.height,
			padding: padding
		)
		
		return CGPoint(x: xPosition, y: yPosition)
	}
}

extension NSWindow.Position.Horizontal {
	func valueFor(
		screenRange: Range<CGFloat>,
		width: CGFloat,
		padding: CGFloat
	)
		-> CGFloat
	{
		switch self {
			case .left: return screenRange.lowerBound + padding
			case .center: return (screenRange.upperBound + screenRange.lowerBound - width) / 2
			case .right: return screenRange.upperBound - width - padding
		}
	}
}

extension NSWindow.Position.Vertical {
	func valueFor(
		screenRange: Range<CGFloat>,
		height: CGFloat,
		padding: CGFloat
	)
		-> CGFloat
	{
		switch self {
			case .top: return screenRange.upperBound - height - padding
			case .center: return (screenRange.upperBound + screenRange.lowerBound - height) / 2
			case .bottom: return screenRange.lowerBound + padding
		}
	}
}

public extension NSWindow.Position {
	enum Horizontal {
		case left, center, right
	}
	
	enum Vertical {
		case top, center, bottom
	}
}

public extension NSWindow {
	/// Struct to define the position of an NSWindow
	struct Position {
		public static let defaultPadding: CGFloat = 0
		public var vertical: Vertical
		public var horizontal: Horizontal
		public var padding = Self.defaultPadding
	}
	
	/// Static function that returns an NSWindow with properties appropriate for an overlay window
	static func getOverlayWindow() -> NSWindow {
		let window = NSWindow()
		window.standardWindowButton(.closeButton)?.isHidden = true
		window.standardWindowButton(.miniaturizeButton)?.isHidden = true
		window.standardWindowButton(.zoomButton)?.isHidden = true
		window.titleVisibility = .hidden
		window.titlebarAppearsTransparent = true
		window.canHide = false
		window.isMovable = true
		window.hasShadow = false
		window.isReleasedWhenClosed = false
		window.level = .screenSaver
		window.hidesOnDeactivate = false
		window.styleMask = .nonactivatingPanel
		window.collectionBehavior = [
			.canJoinAllSpaces,
			.fullScreenAuxiliary,
			.stationary,
			.ignoresCycle,
			.canJoinAllApplications
		]
		window.orderFrontRegardless()
		return window
	}
	
	/// Function that sets the position of a NSWindow
	func setPosition(_ position: Position, in screen: NSScreen) {
		let origin: CGPoint = position.value(
			forWindow: self.frame,
			inScreen: screen.frame
		)
		self.setFrameOrigin(origin)
	}
	
	/// Function that sets the position of a NSWindow with simplified parameters
	func setPosition(
		vertical: Position.Vertical,
		horizontal: Position.Horizontal,
		padding: CGFloat = Position.defaultPadding,
		screen: NSScreen
	) {
		setPosition(
			Position(vertical: vertical, horizontal: horizontal, padding: padding),
			in: screen
		)
	}
}
