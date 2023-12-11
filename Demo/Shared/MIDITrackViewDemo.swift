// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI
import AudioKit
import MIDITrackView

extension Image {
    func playerStyle() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 100.0)
    }
}

struct MIDITrackViewDemo: View {
    @State private var isPlaying = false

    @StateObject var conductor = Conductor()

    public var body: some View {
        VStack {
            MIDITrackView(model: conductor.model,
                          trackColor: Color.cyan,
                          noteColor: Color.blue,
                          note: RoundedRectangle(cornerRadius: 10.0))
            HStack {
                playPauseButton
                    .padding(50.0)
                stopButton
            }
            .onChange(of: isPlaying, perform: updatePlayer)
            .onAppear(perform: setupView)
        }
    }

    var playPauseButton: some View {
        Button(action: togglePlayback) {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .playerStyle()
        }
    }

    var stopButton: some View {
        Button(action: stopAndRewind) {
            Image(systemName: "square.fill")
                .playerStyle()
        }
    }

    func setupView() {

    }

    func updatePlayer(isPlaying: Bool) {
        if isPlaying {
            conductor.midiInstrument.play()
        } else {
            conductor.midiInstrument.stop()
        }
    }

    func updatePos(time: Date) {

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
