// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/
import SwiftUI
import AudioKit
import Foundation
import MIDITrackView


/// A class to manage audio playback within the view
class Conductor: ObservableObject {
    let midiInstrument = AppleSequencer()
    let arpeggioSynthesizer = MIDISampler(name: "Arpeggio Synth")
    let padSynthesizer = MIDISampler(name: "Pad Synth")
    let bassSynthesizer = MIDISampler(name: "Bass Synth")
    let drumKit = MIDISampler(name: "Drums")
    let engine = AudioEngine()
    var midiTrackData: MIDITrackData!
    var model: MIDITrackViewModel = MIDITrackViewModel()
    var midiNoteData: [MIDINoteData] = []
    init() {
        guard let url = Bundle.main.url(forResource: "RUSH_E_FINAL", withExtension: "mid") else {
            print("No URL found for MIDI file")
            return
        }

        midiInstrument.loadMIDIFile(fromURL: url)

        var bogusTracks = 0
        var firstTime = true
        for track in midiInstrument.tracks {
            if let notEmpty = track.noteData?.isNotEmpty {
                if (notEmpty == true && firstTime == true) {
                    midiNoteData = track.getMIDINoteData()
                    firstTime = false
                } else if notEmpty == true {
                    midiNoteData.append(contentsOf: track.getMIDINoteData())
                } else {
                    bogusTracks += 1
                }
            }
        }
        midiTrackData = MIDITrackData(length: midiInstrument.length.beats, height: 200 * CGFloat(midiInstrument.trackCount - bogusTracks), noteData: midiNoteData)
        model.midiNotes = midiTrackData.midiNotes
        model.length = midiTrackData.length
        model.height = midiTrackData.height

        //midiInstrument.tracks[1].setMIDIOutput(arpeggioSynthesizer.midiIn)
        //midiInstrument.tracks[2].setMIDIOutput(bassSynthesizer.midiIn)
        //midiInstrument.tracks[3].setMIDIOutput(padSynthesizer.midiIn)
        //midiInstrument.tracks[4].setMIDIOutput(drumKit.midiIn)
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
