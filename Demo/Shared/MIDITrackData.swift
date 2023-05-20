// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI
import AudioKit
import MIDITrackView

class MIDITrackData {
    var midiNotes: [MIDITrackViewNote] = []
    var length: CGFloat
    var height: CGFloat = 200.0
    var highNote: MIDINoteNumber = 0
    var lowNote: MIDINoteNumber = MIDINoteNumber.max
    var noteRange: MIDINoteNumber = 0
    var noteHeight: CGFloat = 0.0
    var maxHeight: CGFloat = 0.0

    init(length: CGFloat, height: CGFloat, noteData: [MIDINoteData]) {
        self.length = length
        self.height = height
        for note in noteData {
            highNote = (note.noteNumber > highNote) ? note.noteNumber : highNote
            lowNote = (note.noteNumber < lowNote) ? note.noteNumber : lowNote
        }
        self.noteRange = highNote - lowNote
        self.noteHeight = height / (CGFloat(noteRange) + 1)
        self.maxHeight = height - noteHeight
        for note in noteData {
            let noteLevel = maxHeight - CGFloat(note.noteNumber - lowNote) * noteHeight
            self.midiNotes.append(MIDITrackViewNote(position: note.position.beats, level: noteLevel, length: note.duration.beats, height: self.noteHeight))
        }
    }
}
