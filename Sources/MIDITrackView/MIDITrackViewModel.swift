// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public struct MIDITrackViewModel: Equatable {
    public init(midiNotes: [MIDINote], length: CGFloat, height: CGFloat) {
        self.midiNotes = midiNotes
        self.length = length
        self.height = height
    }

    var midiNotes: [MIDINote]
    var length: CGFloat
    var height: CGFloat
}
