//
//  OverlayExitButton.swift
//  Annotator
//
//  Created by Bean John on 8/8/24.
//

import SwiftUI

struct OverlayExitButton: View {
	
	@State private var isHovering: Bool = false
	
    var body: some View {
		Button {
			AppDelegate.shared.dismissAnnotationWindows()
		} label: {
			Image(systemName: "xmark.circle.fill")
				.font(.largeTitle)
				.foregroundStyle(Color.secondary)
		}
		.buttonStyle(PlainButtonStyle())
		.keyboardShortcut(.escape)
		.scaleEffect(isHovering ? 1.1 : 1.0)
		.onHover { isHovering in
			withAnimation(.linear(duration: 0.2)) {
				self.isHovering = isHovering
			}
		}
    }
	
}

#Preview {
    OverlayExitButton()
}
