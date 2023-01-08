// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public struct MIDITrackViewNote: Equatable, Identifiable {
    /// Unique identifier (for use in the model).
    public var id = UUID()
    /// The note rectangle (for use in rendering).
    public let rect: CGRect

    public init(position: CGFloat, level: CGFloat, length: CGFloat, height: CGFloat) {
        self.rect = CGRect(x: position,
                           y: level,
                           width: length,
                           height: height)
    }
}
