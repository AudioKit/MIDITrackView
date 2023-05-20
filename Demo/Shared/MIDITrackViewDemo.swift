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

/// A class to manage audio playback within the view
struct Conductor {
    let midiInstrument = AppleSequencer()
    let arpeggioSynthesizer = MIDISampler(name: "Arpeggio Synth")
    let padSynthesizer = MIDISampler(name: "Pad Synth")
    let bassSynthesizer = MIDISampler(name: "Bass Synth")
    let drumKit = MIDISampler(name: "Drums")
    let engine = AudioEngine()
    var arpData: MIDITrackData
    var bassData: MIDITrackData
    var chordsData: MIDITrackData
    var drumsData: MIDITrackData
    init() {
        guard let url = Bundle.main.url(forResource: "type1Demo", withExtension: "mid") else {
            print("No URL found for MIDI file")
            arpData = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            bassData = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            chordsData = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            drumsData = MIDITrackData(length: 0.0, height: 0.0, noteData: [])
            return
        }

        midiInstrument.loadMIDIFile(fromURL: url)
        let arpNotes = midiInstrument.tracks[1].getMIDINoteData()
        let arpLength = midiInstrument.tracks[1].length
        let bassNotes = midiInstrument.tracks[2].getMIDINoteData()
        let bassLength = midiInstrument.tracks[2].length
        let padNotes = midiInstrument.tracks[3].getMIDINoteData()
        let padLength = midiInstrument.tracks[3].length
        let drumNotes = midiInstrument.tracks[4].getMIDINoteData()
        let drumLength = midiInstrument.tracks[4].length
        arpData = MIDITrackData(length: arpLength, height: 200.0, noteData: arpNotes)
        bassData = MIDITrackData(length: bassLength, height: 200.0, noteData: bassNotes)
        chordsData = MIDITrackData(length: padLength, height: 200.0, noteData: padNotes)
        drumsData = MIDITrackData(length: drumLength, height: 200.0, noteData: drumNotes)


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
    @State private var arpModel = MIDITrackViewModel()
    @State private var chordsModel = MIDITrackViewModel()
    @State private var bassModel = MIDITrackViewModel()
    @State private var drumsModel = MIDITrackViewModel()
    @State private var playPos = 0.0
    @State private var isPlaying = false
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    let conductor = Conductor()

    public var body: some View {
        VStack {
            ScrollView {
                MIDITrackView(trackColor: Color.cyan,
                              noteColor: Color.blue,
                              minimumZoom: 0.01,
                              maximumZoom: 500.0,
                              note: RoundedRectangle(cornerRadius: 10.0),
                              model: $arpModel,
                              playPos: $playPos)
                MIDITrackView(trackColor: Color.cyan,
                              noteColor: Color.blue,
                              minimumZoom: 0.01,
                              maximumZoom: 500.0,
                              note: RoundedRectangle(cornerRadius: 10.0),
                              model: $chordsModel,
                              playPos: $playPos)
                MIDITrackView(trackColor: Color.cyan,
                              noteColor: Color.blue,
                              minimumZoom: 0.01,
                              maximumZoom: 500.0,
                              note: RoundedRectangle(cornerRadius: 10.0),
                              model: $bassModel,
                              playPos: $playPos)
                MIDITrackView(trackColor: Color.cyan,
                              noteColor: Color.blue,
                              minimumZoom: 0.01,
                              maximumZoom: 500.0,
                              note: RoundedRectangle(cornerRadius: 10.0),
                              model: $drumsModel,
                              playPos: $playPos)
            }
            HStack {
                playPauseButton
                    .padding(50.0)
                stopButton
            }
            .onChange(of: isPlaying, perform: updatePlayer)
            .onReceive(timer, perform: { timer in
                playPos = conductor.midiInstrument.currentPosition.beats
            })
            .onAppear {
                timer.upstream.connect().cancel()
                arpModel = MIDITrackViewModel(midiNotes: conductor.arpData.midiNotes,
                                              length: conductor.arpData.length,
                                              height: conductor.arpData.height)
                chordsModel = MIDITrackViewModel(midiNotes: conductor.chordsData.midiNotes,
                                                 length: conductor.chordsData.length,
                                                 height: conductor.chordsData.height)
                bassModel = MIDITrackViewModel(midiNotes: conductor.bassData.midiNotes,
                                               length: conductor.bassData.length,
                                               height: conductor.bassData.height)
                drumsModel = MIDITrackViewModel(midiNotes: conductor.drumsData.midiNotes,
                                                length: conductor.drumsData.length,
                                                height: conductor.drumsData.height)
            }
        }
    }

    var playPauseButton: some View {
        Button(action: togglePlayback) {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(maxWidth: 100.0)
    }

    var stopButton: some View {
        Button(action: stopAndRewind) {
            Image(systemName: "square.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(maxWidth: 100.0)
    }

    func updatePlayer(isPlaying: Bool) {
        if isPlaying {
            timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
            conductor.midiInstrument.play()
        } else {
            timer.upstream.connect().cancel()
            conductor.midiInstrument.stop()
        }
    }

    func stopAndRewind() {
        isPlaying = false
        conductor.midiInstrument.rewind()
    }

    func togglePlayback() {
        isPlaying.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MIDITrackViewDemo()
    }
}
