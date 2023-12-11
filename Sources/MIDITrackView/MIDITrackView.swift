// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

/// A view representing a MIDI Track.
public struct MIDITrackView<Note: View>: View {
    /// The model for the view which contains an array of ``MIDITrackViewNote``, the track length, and the track height.
    @ObservedObject private var model: MIDITrackViewModel
    /// The track background color.
    public var trackColor = Color.primary
    /// The color of the notes on the track.
    public var noteColor = Color.accentColor
    /// The color of the track playhead.
    public var playheadColor = Color.secondary
    /// The view used in a note display.
    ///
    /// # Description:
    /// The type of view to display for the note. For example, `RoundedRectangle(cornerRadius: 10.0)`.
    public let note: Note
    public init(model: MIDITrackViewModel, trackColor: SwiftUI.Color = Color.primary, noteColor: SwiftUI.Color = Color.accentColor, playheadColor: SwiftUI.Color = Color.secondary, note: Note) {
        self.model = model
        self.trackColor = trackColor
        self.noteColor = noteColor
        self.playheadColor = playheadColor
        self.note = note
    }

    enum SymbolID: Int {
        case note
    }

    public var body: some View {
        ScrollView(.horizontal,
                   showsIndicators: true) {
            Canvas { context, size in
                // Track playhead
                context.stroke(Path(roundedRect: CGRect(x: model.playPos * model.zoomLevel, y: 0, width: 1, height: model.height), cornerRadius: 0), with: .color(playheadColor), lineWidth: 4)
                context.scaleBy(x: model.zoomLevel, y: 1.0)
                if let note = context.resolveSymbol(id: SymbolID.note) {
                    for midiNote in model.midiNotes {
                        let rect = midiNote.rect
                        context.draw(note, in: rect)
                    }
                }
            } symbols: {
                note.tag(SymbolID.note)
            }
            .frame(width: model.length * model.zoomLevel,
                   height: model.height,
                   alignment: .center)
            .background(trackColor)
            .cornerRadius(10.0)
        }
        .gesture(MagnificationGesture().onChanged { val in
            model.updateZoomLevelMagnify(value: val)

        }.onEnded { val in
            model.zoomLevelGestureEnded()
        })
        .onAppear {
            #if os(macOS)
            NSEvent.addLocalMonitorForEvents(matching: [.scrollWheel]) { event in
                model.updateZoomLevelScroll(rot: event.deltaY)
                return event
            }
            #endif
        }
    }
}
