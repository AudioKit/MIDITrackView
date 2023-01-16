// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI
import AudioKit
import MIDIKitSMF
import MIDITrackView

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct MIDITrackData {
    var midiNotes: [MIDITrackViewNote] = []
    var tempo: Double = 0.0
    var ticksPerQuarter: UInt16 = 0
    var height: CGFloat = 200.0
    var length: CGFloat = 0.0
    init() {
        var midiFile = MIDIFile()

        guard let url = Bundle.main.url(forResource: "Demo", withExtension: "mid") else {
            print("No URL found for MIDI file")
            return
        }

        do {
            midiFile = try MIDIFile(midiFile: url)
        } catch {
            print(error.localizedDescription, " - (MIDI File Not Found)")
        }

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
        var noteOnPositions: [UInt32] = []
        var noteOffPositions: [UInt32] = []
        var noteOnNumbers: [UInt7] = []
        var noteOffNumbers: [UInt7] = []
        var notePosition: UInt32 = 0

        for event in tempo.events {
            switch(event) {
            case .tempo(_, let tempoEvent):
                self.tempo = tempoEvent.bpm
            default:
                break
            }
        }

        for event in track.events {
            switch(event) {
            case .noteOn(let noteOnDelta, let noteOnEvent):
                notePosition += noteOnDelta.ticksValue(using: midiFile.timeBase)
                if noteOnEvent.midi1ZeroVelocityAsNoteOff && noteOnEvent.velocity.midi1Value == 0 {
                    noteOffPositions.append(notePosition)
                    noteOffNumbers.append(noteOnEvent.note.number)
                } else {
                    noteOnPositions.append(notePosition)
                    noteOnNumbers.append(noteOnEvent.note.number)
                }

                highNote = (noteOnEvent.note.number > highNote) ? noteOnEvent.note.number : highNote
                lowNote = (noteOnEvent.note.number < lowNote) ? noteOnEvent.note.number : lowNote
                noteRange = highNote - lowNote
                noteHeight = self.height / (CGFloat(noteRange) + 1)
                maxHeight = self.height - noteHeight
            case .noteOff(let noteOffDelta, let noteOffEvent):
                notePosition += noteOffDelta.ticksValue(using: midiFile.timeBase)
                noteOffPositions.append(notePosition)
                noteOffNumbers.append(noteOffEvent.note.number)
            default:
                notePosition += event.smfUnwrappedEvent.delta.ticksValue(using: midiFile.timeBase)
                break
            }
        }

        var midiNotes: [MIDITrackViewNote] = []

        for i in 0..<noteOnPositions.count {
            var noteNumber: UInt7 = 0
            var notePosition: CGFloat = 0.0
            var noteLength: CGFloat = 0.0

            if let number = noteOffNumbers[safe: i] {
                noteNumber = number - lowNote
            } else if let number = noteOnNumbers[safe: i] {
                noteNumber = number - lowNote
            }

            if let position = noteOnPositions[safe: i] { notePosition = CGFloat(position) }
            if let offPos = noteOffPositions[safe: i] { noteLength = CGFloat(offPos) - notePosition}

            let noteLevel = maxHeight - CGFloat(noteNumber) * noteHeight

            let note = MIDITrackViewNote(position: notePosition, level: noteLevel, length: noteLength, height: noteHeight)

            midiNotes.append(note)
        }

        self.midiNotes = midiNotes
        length = CGFloat(CGFloat(notePosition))
    }
}

/// A class to manage audio playback within the view
struct Conductor {
    let midiInstrument = AppleSequencer()
    let sampler = MIDISampler()
    let engine = AudioEngine()
    init() {
        guard let url = Bundle.main.url(forResource: "Demo", withExtension: "mid") else {
            print("No URL found for MIDI file")
            return
        }

        midiInstrument.loadMIDIFile(fromURL: url)
        midiInstrument.setGlobalMIDIOutput(sampler.midiIn)
        engine.output = sampler

        do {
            try engine.start()
        } catch {
            print(error.localizedDescription, " - (The audio engine could not start.)")
        }
    }
}

struct MIDITrackViewDemo: View {
    @State private var model = MIDITrackViewModel()
    @State private var isPlaying = false

    let conductor = Conductor()
    let midiTrackData = MIDITrackData()

    public var body: some View {
        VStack {
            MIDITrackView(trackColor: Color.cyan,
                          noteColor: Color.blue,
                          note: RoundedRectangle(cornerRadius: 10.0),
                          model: $model)
            .onTapGesture {
                isPlaying.toggle()
            }
            .onChange(of: isPlaying) { newValue in
                if newValue {
                    conductor.midiInstrument.play()
                } else {
                    conductor.midiInstrument.stop()
                }
            }
            .onAppear {
                model = MIDITrackViewModel(midiNotes: midiTrackData.midiNotes,
                                           length: midiTrackData.length,
                                           height: midiTrackData.height)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MIDITrackViewDemo()
    }
}
