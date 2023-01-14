// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI
import MIDITrackView
import AudioKit

/// A class to manage audio playback within the view
class Conductor {
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
    @EnvironmentObject var model: MIDITrackViewModel
    @State private var isPlaying = false
    let conductor = Conductor()

    public var body: some View {
        VStack {
            MIDITrackView(trackColor: Color.cyan, noteColor: Color.blue, note: RoundedRectangle(cornerRadius: 10.0))
                .onTapGesture {
                    isPlaying.toggle()
                }
                .onChange(of: isPlaying) { newValue in
                    if newValue {
                        model.play()
                        conductor.midiInstrument.play()
                    } else {
                        model.stop()
                        conductor.midiInstrument.stop()
                    }
                }
                .environmentObject(model)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MIDITrackViewDemo()
    }
}
