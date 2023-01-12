// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

/// A view representing a MIDI Track.
public struct MIDITrackView<Note: View>: View {
    /// The view model.
    @Binding var model: MIDITrackViewModel

    /// The view zoom level.
    ///
    /// # Description:
    /// This property controls the zoom level of this view. Use the "pinch and drag" gesture on a device screen/trackpad
    /// to adjust the zoom level accordingly. If using a mouse, rotate the scroll wheel to do the same thing.
    ///
    /// ### Important values:
    /// __Default:__ 1.0, __Minimum:__ 0.1, __Maximum:__ 5.0.
    ///
    @State public var zoomLevel = 1.0
    @State private var lastZoomLevel = 1.0

    /// The track background color.
    var trackColor = Color.primary
    /// The color of the notes on the track.
    var noteColor = Color.accentColor

    /// The view used in a note display.
    ///
    /// # Description:
    /// This is what each note on the track will show up as.
    public let note: Note

    public init(model: Binding<MIDITrackViewModel>,
                trackColor: Color = .primary,
                noteColor: Color = .accentColor,
                note: Note) {
        _model = model
        self.trackColor = trackColor
        self.noteColor = noteColor
        self.note = note
    }

    enum SymbolID: Int {
        case note
    }

    public var body: some View {
        ScrollView(.horizontal,
                   showsIndicators: true) {
            Canvas { context, size in
                context.drawLayer { ctx in
                    ctx.scaleBy(x: zoomLevel, y: 1.0)
                    if let note = ctx.resolveSymbol(id: SymbolID.note) {
                        for midiNote in model.midiNotes {
                            let rect = midiNote.rect
                            ctx.draw(note, in: rect)
                        }
                    }
                }
                // Track playhead
                context.stroke(Path(roundedRect: CGRect(x: 100 * zoomLevel, y: 0, width: 1, height: model.height), cornerRadius: 0), with: .color(.secondary), lineWidth: 4)
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
            zoomLevel = max(min(newScale, 5.0), 0.1)

        }.onEnded { val in
            self.lastZoomLevel = 1.0
        })
        .onAppear {
            #if os(macOS)
            NSEvent.addLocalMonitorForEvents(matching: [.scrollWheel]) { event in
                let rot = event.deltaY
                let delta = rot > 0 ? (1 - rot / 100) : 1.0/(1 + rot/100)
                let newScale = self.zoomLevel * delta
                zoomLevel = max(min(newScale, 5.0), 0.1)
                return event
            }
            #endif
        }
    }
}
