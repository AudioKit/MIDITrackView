// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public class MIDITrackViewModel: ObservableObject {
    public init(midiNotes: [MIDITrackViewNote] = [], length: CGFloat = 0.0, height: CGFloat = 0.0) {
        self.midiNotes = midiNotes
        self.length = length
        self.height = height
        self.playPos = 0.0
        self.timer = Timer()
    }

    /// Play the MIDI track.
    public func play() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                          repeats: true,
                                          block: { timer in
            self.playPos += 1
        })
        RunLoop.main.add(self.timer, forMode: .common)
    }

    /// Stop the MIDI track.
    public func stop() {
        self.timer.invalidate()
    }

    /// The notes rendered in the view.
    public var midiNotes: [MIDITrackViewNote]
    /// The length of the track.
    public var length: CGFloat
    /// The height of the track.
    public var height: CGFloat
    /// The playhead position (x).
    @Published var playPos: CGFloat
    /// Timer which scrolls the track playhead.
    public var timer: Timer
}
