// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public class MIDITrackViewModel: ObservableObject {
    public init(midiNotes: [MIDITrackViewNote] = [], length: CGFloat = 0.0, height: CGFloat = 0.0, bpm: Double, ticksPerQuarter: UInt16) {
        self.midiNotes = midiNotes
        self.length = length
        self.height = height
        self.playPos = 0.0
        self.bpm = bpm
        self.ticksPerQuarter = ticksPerQuarter
        self.timer = Timer()
    }

    /// Play the MIDI track.
    public func play() {
        self.timer = Timer.scheduledTimer(withTimeInterval: (1.0 / self.bpm) * 60.0 / Double(ticksPerQuarter),
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
    /// The BPM of the track.
    public var bpm: Double
    /// The amount of ticks per quarter note for the track.
    public var ticksPerQuarter: UInt16
    /// Timer which scrolls the track playhead.
    public var timer: Timer
}
