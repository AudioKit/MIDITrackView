// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/
import SwiftUI
import AudioKit
import Foundation
import MIDITrackView


/// A class to manage audio playback within the view
class Conductor {
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
        midiInstrument.enableLooping()
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
