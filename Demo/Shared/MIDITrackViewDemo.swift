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
    @StateObject private var data1 = MIDITrackViewModel()
    @StateObject private var data2 = MIDITrackViewModel()
    @StateObject private var data3 = MIDITrackViewModel()
    @StateObject private var data4 = MIDITrackViewModel()
    @StateObject private var data5 = MIDITrackViewModel()
    @StateObject private var data6 = MIDITrackViewModel()
    @StateObject private var data7 = MIDITrackViewModel()
    @StateObject private var data8 = MIDITrackViewModel()
    @StateObject private var data9 = MIDITrackViewModel()
    @StateObject private var data10 = MIDITrackViewModel()
    @StateObject private var data11 = MIDITrackViewModel()
    @StateObject private var data12 = MIDITrackViewModel()
    @StateObject private var data13 = MIDITrackViewModel()
    @StateObject private var data14 = MIDITrackViewModel()
    @StateObject private var data15 = MIDITrackViewModel()
    @StateObject private var data16 = MIDITrackViewModel()
    @StateObject private var data17 = MIDITrackViewModel()
    @StateObject private var data18 = MIDITrackViewModel()
    @StateObject private var data19 = MIDITrackViewModel()
    @StateObject private var data20 = MIDITrackViewModel()
    @StateObject private var data21 = MIDITrackViewModel()
    @StateObject private var data22 = MIDITrackViewModel()
    @StateObject private var data23 = MIDITrackViewModel()
    @StateObject private var data24 = MIDITrackViewModel()
    @StateObject private var data25 = MIDITrackViewModel()
    @StateObject private var data26 = MIDITrackViewModel()
    @StateObject private var data27 = MIDITrackViewModel()

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
                MIDITrackView(model: data1,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: data2,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: data3,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: data4,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: data5,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: data6,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: data7,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: data8,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: data9,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: data10,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: data11,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: data12,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: data13,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: data14,
                              trackColor: Color.cyan,
                              noteColor: Color.blue,
                              note: RoundedRectangle(cornerRadius: 10.0))
                MIDITrackView(model: data15,
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
        data1.midiNotes = conductor.data5.midiNotes
        data1.height = conductor.data5.height
        data1.length = conductor.data5.length
        data2.midiNotes = conductor.data6.midiNotes
        data2.height = conductor.data6.height
        data2.length = conductor.data6.length
        data3.midiNotes = conductor.data7.midiNotes
        data3.height = conductor.data7.height
        data3.length = conductor.data7.length
        data4.midiNotes = conductor.data8.midiNotes
        data4.height = conductor.data8.height
        data4.length = conductor.data8.length
        data5.midiNotes = conductor.data9.midiNotes
        data5.height = conductor.data9.height
        data5.length = conductor.data9.length
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
        data1.playPos = beatPos
        data2.playPos = beatPos
        data3.playPos = beatPos
        data4.playPos = beatPos
        data5.playPos = beatPos
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
