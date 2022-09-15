// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public struct MIDINote: Equatable, Identifiable {
    public init(position: CGFloat, level: CGFloat, length: CGFloat, height: CGFloat) {
        self.position = position
        self.level = level
        self.length = length
        self.height = height
    }

    public var id = UUID()

    var position: CGFloat
    var level: CGFloat
    var length: CGFloat
    var height: CGFloat
}
