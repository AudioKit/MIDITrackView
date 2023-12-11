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
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @StateObject private var arpModel = MIDITrackViewModel()
    @StateObject private var chordModel = MIDITrackViewModel()
    @StateObject private var bassModel = MIDITrackViewModel()
    @StateObject private var drumsModel = MIDITrackViewModel()

    let conductor = Conductor()

    public var body: some View {
        VStack {
            ScrollView {
                MIDITrackView(model: arpModel,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: chordModel,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: bassModel,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: drumsModel,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
            }
            HStack {
                playPauseButton
                    .padding(50.0)
                stopButton
            }
            .onChange(of: isPlaying, perform: updatePlayer)
            .onReceive(timer, perform: updatePos)
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
        timer.upstream.connect().cancel()
        arpModel.midiNotes = conductor.arpData.midiNotes
        arpModel.height = conductor.arpData.height
        arpModel.length = conductor.arpData.length
        chordModel.midiNotes = conductor.chordsData.midiNotes
        chordModel.height = conductor.chordsData.height
        chordModel.length = conductor.chordsData.length
        bassModel.midiNotes = conductor.bassData.midiNotes
        bassModel.height = conductor.bassData.height
        bassModel.length = conductor.bassData.length
        drumsModel.midiNotes = conductor.drumsData.midiNotes
        drumsModel.height = conductor.drumsData.height
        drumsModel.length = conductor.drumsData.length
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

    func updatePos(time: Date) {
        let beatPos = conductor.midiInstrument.currentPosition.beats
        arpModel.playPos = beatPos
        chordModel.playPos = beatPos
        bassModel.playPos = beatPos
        drumsModel.playPos = beatPos
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
