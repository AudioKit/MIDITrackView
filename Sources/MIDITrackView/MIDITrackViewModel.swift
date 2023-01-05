// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public struct MIDITrackViewModel: Equatable {
    public init(midiNotes: [MIDINote], length: CGFloat, height: CGFloat) {
        self.midiNotes = midiNotes
        self.length = length
        self.height = height
    }

    /// The notes rendered in the view.
    public var midiNotes: [MIDINote]
    /// The length of the track.
    public var length: CGFloat
    /// The height of the track.
    public var height: CGFloat
}
