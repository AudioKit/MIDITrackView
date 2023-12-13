// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI
import Combine
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
    let conductor: Conductor
    @State private var arpModel: MIDITrackViewModel
    @State private var chordsModel: MIDITrackViewModel
    @State private var bassModel: MIDITrackViewModel
    @State private var drumsModel: MIDITrackViewModel
    @State private var isPlaying: Bool
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>

    init(conductor: Conductor) {
        self.conductor = conductor
        self.arpModel = MIDITrackViewModel(midiNotes: conductor.arpData.midiNotes, length: conductor.arpData.length, height: conductor.arpData.height, playPos: conductor.midiInstrument.currentPosition.beats, zoomLevel: 50.0, minimumZoom: 0.01, maximumZoom: 1000.0)
        self.chordsModel = MIDITrackViewModel(midiNotes: conductor.chordsData.midiNotes, length: conductor.chordsData.length, height: conductor.chordsData.height, playPos: conductor.midiInstrument.currentPosition.beats, zoomLevel: 50.0, minimumZoom: 0.01, maximumZoom: 1000.0)
        self.bassModel = MIDITrackViewModel(midiNotes: conductor.bassData.midiNotes, length: conductor.bassData.length, height: conductor.bassData.height, playPos: conductor.midiInstrument.currentPosition.beats, zoomLevel: 50.0, minimumZoom: 0.01, maximumZoom: 1000.0)
        self.drumsModel = MIDITrackViewModel(midiNotes: conductor.drumsData.midiNotes, length: conductor.drumsData.length, height: conductor.drumsData.height, playPos: conductor.midiInstrument.currentPosition.beats, zoomLevel: 50.0, minimumZoom: 0.01, maximumZoom: 1000.0)
        self.isPlaying = false
        self.timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    }

    public var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    MIDITrackView(model: $arpModel,
                                  trackColor: Color.cyan,
                                  noteColor: Color.blue)
                    MIDITrackView(model: $chordsModel,
                                  trackColor: Color.mint,
                                  noteColor: Color.green)
                    MIDITrackView(model: $bassModel,
                                  trackColor: Color.orange,
                                  noteColor: Color.yellow)
                    MIDITrackView(model: $drumsModel,
                                  trackColor: Color.teal,
                                  noteColor: Color.white)
                }
                .frame(minWidth: conductor.midiInstrument.length.beats, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity)
            }
            HStack {
                playPauseButton
                    .padding(50.0)
                stopButton
            }
        }
        .gesture(MagnificationGesture().onChanged { val in
            arpModel.updateZoomLevelMagnify(value: val)
            chordsModel.updateZoomLevelMagnify(value: val)
            bassModel.updateZoomLevelMagnify(value: val)
            drumsModel.updateZoomLevelMagnify(value: val)
        }.onEnded { val in
            arpModel.zoomLevelGestureEnded()
            chordsModel.zoomLevelGestureEnded()
            bassModel.zoomLevelGestureEnded()
            drumsModel.zoomLevelGestureEnded()
        })
        .onAppear {
            #if os(macOS)
            setupView()
            NSEvent.addLocalMonitorForEvents(matching: [.scrollWheel]) { event in
                arpModel.updateZoomLevelScroll(rot: event.deltaY)
                chordsModel.updateZoomLevelScroll(rot: event.deltaY)
                bassModel.updateZoomLevelScroll(rot: event.deltaY)
                drumsModel.updateZoomLevelScroll(rot: event.deltaY)
                return event
            }
            #endif
        }
        .onChange(of: isPlaying, perform: updatePlayer)
        .onReceive(timer, perform: updatePos)
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
    }

    func updatePlayer(isPlaying: Bool) {
        if isPlaying {
            timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
            conductor.midiInstrument.play()
        } else {
            timer.upstream.connect().cancel()
            conductor.midiInstrument.stop()
            arpModel.updatePlayPos(newPos: conductor.midiInstrument.currentPosition.beats)
            chordsModel.updatePlayPos(newPos: conductor.midiInstrument.currentPosition.beats)
            bassModel.updatePlayPos(newPos: conductor.midiInstrument.currentPosition.beats)
            drumsModel.updatePlayPos(newPos: conductor.midiInstrument.currentPosition.beats)
        }
    }

    func updatePos(time: Date) {
        arpModel.updatePlayPos(newPos: conductor.midiInstrument.currentPosition.beats.truncatingRemainder(dividingBy: conductor.midiInstrument.length.beats))
        chordsModel.updatePlayPos(newPos: conductor.midiInstrument.currentPosition.beats.truncatingRemainder(dividingBy: conductor.midiInstrument.length.beats))
        bassModel.updatePlayPos(newPos: conductor.midiInstrument.currentPosition.beats.truncatingRemainder(dividingBy: conductor.midiInstrument.length.beats))
        drumsModel.updatePlayPos(newPos: conductor.midiInstrument.currentPosition.beats.truncatingRemainder(dividingBy: conductor.midiInstrument.length.beats))
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
        MIDITrackViewDemo(conductor: Conductor())
    }
}
