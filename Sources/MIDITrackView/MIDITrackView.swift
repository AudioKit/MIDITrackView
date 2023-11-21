// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

/// A view representing a MIDI Track.
public struct MIDITrackView<Note: View>: View {
    /// The model for the view which contains an array of ``MIDITrackViewNote``, the track length, and the track height.
    @Binding public var model: MIDITrackViewModel
    /// The track playhead position.
    @Binding public var playPos: Double

    /// The view zoom level.
    ///
    /// # Description:
    /// This property controls the zoom level of this view. Use the "pinch and drag" gesture on a device screen/trackpad
    /// to adjust the zoom level accordingly. If using a mouse, rotate the scroll wheel to do the same thing.
    ///
    ///
    @State public var zoomLevel = 50.0
    @State private var lastZoomLevel = 1.0

    /// The track background color.
    public var trackColor = Color.primary
    /// The color of the notes on the track.
    public var noteColor = Color.accentColor
    /// The color of the track playhead.
    public var playheadColor = Color.secondary
    /// The track minimum zoom level.
    public var minimumZoom = 0.01
    /// The track maximum zoom level.
    public var maximumZoom = 500.0
    /// The view used in a note display.
    ///
    /// # Description:
    /// The type of view to display for the note. For example, `RoundedRectangle(cornerRadius: 10.0)`.
    public let note: Note

    public init(trackColor: Color = .primary,
                noteColor: Color = .accentColor,
                playheadColor: Color = .secondary,
                minimumZoom: Double = 0.0,
                maximumZoom: Double = 0.0,
                note: Note,
                model: Binding<MIDITrackViewModel>,
                playPos: Binding<Double>) {
        self.trackColor = trackColor
        self.noteColor = noteColor
        self.playheadColor = playheadColor
        self.minimumZoom = minimumZoom
        self.maximumZoom = maximumZoom
        self.note = note
        _model = model
        _playPos = playPos
    }

    enum SymbolID: Int {
        case note
    }

    public var body: some View {
        ScrollView(.horizontal,
                   showsIndicators: true) {
            Canvas { context, size in
                // Track playhead
                context.stroke(Path(roundedRect: CGRect(x: playPos * zoomLevel, y: 0, width: 1, height: model.height), cornerRadius: 0), with: .color(playheadColor), lineWidth: 4)
                context.scaleBy(x: zoomLevel, y: 1.0)
                if let note = context.resolveSymbol(id: SymbolID.note) {
                    for midiNote in model.midiNotes {
                        let rect = midiNote.rect
                        context.draw(note, in: rect)
                    }
                }
            } symbols: {
                note.tag(SymbolID.note)
            }
            .frame(width: model.length * zoomLevel,
                   height: model.height,
                   alignment: .center)
            .background(trackColor)
            .cornerRadius(10.0)
        }
        .gesture(MagnificationGesture().onChanged { val in
            let delta = val / self.lastZoomLevel
            self.lastZoomLevel = val
            let newScale = self.zoomLevel * delta
            zoomLevel = max(min(newScale, maximumZoom), minimumZoom)

        }.onEnded { val in
            self.lastZoomLevel = 1.0
        })
        .onAppear {
            #if os(macOS)
            NSEvent.addLocalMonitorForEvents(matching: [.scrollWheel]) { event in
                let rot = event.deltaY
                let delta = rot > 0 ? (1 - rot / 100) : 1.0/(1 + rot/100)
                let newScale = self.zoomLevel * delta
                zoomLevel = max(min(newScale, maximumZoom), minimumZoom)
                return event
            }
            #endif
        }
    }
}
