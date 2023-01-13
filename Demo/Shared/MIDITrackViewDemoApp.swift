// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI
import MIDIKitSMF
import MIDITrackView

class MIDITrackData {
    var midiNotes: [MIDITrackViewNote]!
    var tempo: Double!
    var ticksPerQuarter: UInt16!
    var height: CGFloat = 200.0
    var length: CGFloat = 0.0
    init() {
        let url = Bundle.main.url(forResource: "Demo", withExtension: "mid")!
        let midiFile = try! MIDIFile(midiFile: url)
        self.tempo = 0.0
        self.ticksPerQuarter = 0

        guard case .track(let track) = midiFile.chunks[1] else { return }
        // Special case where this type of midi file stores tempo in first track
        guard case .track(let tempo) = midiFile.chunks[0] else { return }
        // Special case where MIDI timebase is musical
        if case .musical(let ticksPerQuarter) = midiFile.timeBase { self.ticksPerQuarter = ticksPerQuarter }

        var highNote: UInt7 = 0
        var lowNote: UInt7 = UInt7.max
        var noteRange: UInt7 = 0
        var noteHeight: CGFloat = 0.0
        var maxHeight: CGFloat = 0.0
        var noteEvents: [MIDIEvent.NoteOn] = []
        var noteEventPositions: [UInt32] = []
        var noteEventLengths: [UInt32] = []
        var notePosition: UInt32 = 0
        
        for event in tempo.events {
            switch(event) {
            case .tempo(_, let tempoEvent):
                self.tempo = tempoEvent.bpm
            default:
                break
            }
        }

        var i = 0

        for event in track.events {
            switch(event) {
            case .noteOn(let noteOnDelta, let noteOnEvent):
                notePosition += noteOnDelta.ticksValue(using: midiFile.timeBase)
                noteEvents.append(noteOnEvent)
                noteEventPositions.append(notePosition)

                let events = Array(track.events[i ..< track.events.count])

                let noteOffEvent = events.first { event in
                    if case .noteOff(let noteOffDelta, let noteOffEvent) = event {
                        notePosition += noteOffDelta.ticksValue(using: midiFile.timeBase)
                        return noteOnEvent.note == noteOffEvent.note
                    } else {
                        return false
                    }
                }

                noteEventLengths.append(noteOffEvent?.smfUnwrappedEvent.delta.ticksValue(using: midiFile.timeBase) ?? 0 - noteOnDelta.ticksValue(using: midiFile.timeBase))

                highNote = (noteOnEvent.note.number > highNote) ? noteOnEvent.note.number : highNote
                lowNote = (noteOnEvent.note.number < lowNote) ? noteOnEvent.note.number : lowNote
                noteRange = highNote - lowNote
                noteHeight = self.height / CGFloat(noteRange)
                maxHeight = self.height - noteHeight

                i += 1
            default:
                i += 1
                break
            }
        }

        guard noteEvents.count * 2 == noteEventPositions.count + noteEventLengths.count else { return }

        var midiNotes: [MIDITrackViewNote] = []

        i = 0

        for noteEvent in noteEvents {
            let noteNumber = noteEvent.note.number - lowNote
            let notePosition = CGFloat(noteEventPositions[i])
            let noteLength = CGFloat(noteEventLengths[i])
            let noteLevel = maxHeight - CGFloat(noteNumber) * noteHeight

            let note = MIDITrackViewNote(position: notePosition, level: noteLevel, length: noteLength, height: noteHeight)

            midiNotes.append(note)

            i += 1
        }
        self.midiNotes = midiNotes
        length = CGFloat(noteEventPositions[i - 1] + noteEventLengths[i - 1])
    }
}

@main
struct MIDITrackViewDemoApp: App {
    let midiTrackData = MIDITrackData()
    var body: some Scene {
        WindowGroup {
            MIDITrackViewDemo()
                .environmentObject(
                    MIDITrackViewModel(midiNotes: midiTrackData.midiNotes,
                                       length: midiTrackData.length,
                                       height: midiTrackData.height,
                                       bpm: midiTrackData.tempo,
                                       ticksPerQuarter: midiTrackData.ticksPerQuarter)
                )
        }
    }
}
