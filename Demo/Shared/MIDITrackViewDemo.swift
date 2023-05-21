// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI
import AudioKit
import MIDITrackView

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
            .onReceive(timer, perform: updatePos)
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

    func updatePos(time: Date) {
        playPos = conductor.midiInstrument.currentPosition.beats
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
