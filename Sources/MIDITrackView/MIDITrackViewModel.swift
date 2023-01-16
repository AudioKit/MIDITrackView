// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public struct MIDITrackViewModel {
    public init(midiNotes: [MIDITrackViewNote] = [], length: CGFloat = 0.0, height: CGFloat = 0.0) {
        self.midiNotes = midiNotes
        self.length = length
        self.height = height
    }

    /// The notes rendered in the view.
    public var midiNotes: [MIDITrackViewNote]
    /// The length of the track.
    public var length: CGFloat
    /// The height of the track.
    public var height: CGFloat
}
