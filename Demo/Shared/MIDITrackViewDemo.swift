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

class MIDITrackData {
    var midiFile = MIDIFile()
    var midiNotes: [MIDITrackViewNote] = []
    var tempo: Double = 0.0
    var ticksPerQuarter: UInt16 = 0
    var height: CGFloat = 200.0
    var length: CGFloat = 0.0

    var highNote: UInt7 = 0
    var lowNote: UInt7 = UInt7.max
    var noteRange: UInt7 = 0
    var noteHeight: CGFloat = 0.0
    var maxHeight: CGFloat = 0.0
    var noteOnPositions: [UInt32] = []
    var noteOffPositions: [UInt32] = []
    var noteOnNumbers: [UInt7] = []
    var noteOffNumbers: [UInt7] = []
    var currentEventLocation: UInt32 = 0

    func handleNoteEvent(event: MIDIFileEvent) {
        switch(event) {
        case .noteOn(_, let noteOnEvent):
            if noteOnEvent.velocity.midi1Value == 0 {
                noteOffPositions.append(currentEventLocation)
                noteOffNumbers.append(noteOnEvent.note.number)
            } else {
                noteOnPositions.append(currentEventLocation)
                noteOnNumbers.append(noteOnEvent.note.number)
            }

            highNote = (noteOnEvent.note.number > highNote) ? noteOnEvent.note.number : highNote
            lowNote = (noteOnEvent.note.number < lowNote) ? noteOnEvent.note.number : lowNote
            noteRange = highNote - lowNote
            noteHeight = self.height / (CGFloat(noteRange) + 1)
            maxHeight = self.height - noteHeight
        case .noteOff(_, let noteOffEvent):
            noteOffPositions.append(currentEventLocation)
            noteOffNumbers.append(noteOffEvent.note.number)
        default:
            break
        }
    }

    init() {

        guard let url = Bundle.main.url(forResource: "type1Demo", withExtension: "mid") else {
            print("No URL found for MIDI file")
            return
        }

        do {
            midiFile = try MIDIFile(midiFile: url)
        } catch {
            print(error.localizedDescription, " - (MIDI File Not Found)")
        }

        // Special case where MIDI timebase is musical
        if case .musical(let ticksPerQuarter) = midiFile.timeBase { self.ticksPerQuarter = ticksPerQuarter }

        switch(midiFile.format) {
        case .singleTrack:
            // Do something to handle type 0 midi tracks
            guard case .track(let track) = midiFile.chunks[0] else { return }
            for event in track.events {
                currentEventLocation += event.smfUnwrappedEvent.delta.ticksValue(using: midiFile.timeBase)
                if let channel = event.event()?.channel {
                    if channel == 0 {
                        handleNoteEvent(event: event)
                    }
                }
            }
        case .multipleTracksSynchronous:
            guard case .track(let track) = midiFile.chunks[1] else { return }
            // Special case where this type of midi file stores tempo in first track
            guard case .track(let tempo) = midiFile.chunks[0] else { return }

            for event in tempo.events {
                switch(event) {
                case .tempo(_, let tempoEvent):
                    self.tempo = tempoEvent.bpm
                default:
                    break
                }
            }

            for event in track.events {
                currentEventLocation += event.smfUnwrappedEvent.delta.ticksValue(using: midiFile.timeBase)
                handleNoteEvent(event: event)
            }
        default:
            break
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
        length = CGFloat(CGFloat(currentEventLocation))
    }
}

/// A class to manage audio playback within the view
struct Conductor {
    let midiInstrument = AppleSequencer()
    let arpeggioSynthesizer = MIDISampler(name: "Arpeggio Synth")
    let padSynthesizer = MIDISampler(name: "Pad Synth")
    let bassSynthesizer = MIDISampler(name: "Bass Synth")
    let drumKit = MIDISampler(name: "Drums")
    let engine = AudioEngine()
    init() {
        guard let url = Bundle.main.url(forResource: "type1Demo", withExtension: "mid") else {
            print("No URL found for MIDI file")
            return
        }

        midiInstrument.loadMIDIFile(fromURL: url)
        midiInstrument.tracks[1].setMIDIOutput(arpeggioSynthesizer.midiIn)
        midiInstrument.tracks[2].setMIDIOutput(bassSynthesizer.midiIn)
        midiInstrument.tracks[3].setMIDIOutput(padSynthesizer.midiIn)
        midiInstrument.tracks[4].setMIDIOutput(drumKit.midiIn)
        engine.output = Mixer(arpeggioSynthesizer,
                              padSynthesizer,
                              bassSynthesizer,
                              drumKit)
        let samplerInstruments = [(arpeggioSynthesizer, "Sounds/Sampler Instruments/sqrTone1"),
                                  (padSynthesizer, "Sounds/Sampler Instruments/sawPiano1"),
                                  (bassSynthesizer, "Sounds/Sampler Instruments/sawPiano1"),
                                  (drumKit, "Sounds/Sampler Instruments/drumSimp")]
        for (sampler,path) in samplerInstruments {
            if let fileURL = Bundle.main.url(forResource: path, withExtension: "exs") {
                do {
                    try sampler.loadInstrument(url: fileURL)
                } catch {
                    Log("A file was not found.")
                }
            } else {
                Log("Could not find file")
            }
        }
        do {
            try engine.start()
        } catch {
            print(error.localizedDescription, " - (The audio engine could not start.)")
        }
    }
}

struct MIDITrackViewDemo: View {
    @State private var model = MIDITrackViewModel()
    @State private var playPos = 0.0
    @State private var isPlaying = false
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    let conductor = Conductor()
    let midiTrackData = MIDITrackData()

    public var body: some View {
        VStack {
            MIDITrackView(trackColor: Color.cyan,
                          noteColor: Color.blue,
                          minimumZoom: 0.01,
                          maximumZoom: 500.0,
                          note: RoundedRectangle(cornerRadius: 10.0),
                          model: $model,
                          playPos: $playPos)
            HStack {
                Button {
                    isPlaying.toggle()
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(maxWidth: 100.0)
                .padding(50.0)
                Button {
                    conductor.midiInstrument.stop()
                    conductor.midiInstrument.rewind()
                    isPlaying = false
                } label: {
                    Image(systemName: "square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(maxWidth: 100.0)
            }
            .onChange(of: isPlaying) { newValue in
                if newValue {
                    timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
                    conductor.midiInstrument.play()
                } else {
                    timer.upstream.connect().cancel()
                    conductor.midiInstrument.stop()
                }
            }
            .onReceive(timer, perform: { timer in
                playPos = conductor.midiInstrument.currentPosition.beats * Double(midiTrackData.ticksPerQuarter)
            })
            .onAppear {
                timer.upstream.connect().cancel()
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
