// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

/// A view representing a MIDI Track.
public struct MIDITrackView<Note: View>: View {
    /// The model for the view which contains an array of ``MIDITrackViewNote``, the track length, and the track height.
    private var model: MIDITrackViewModel
    /// The track background color.
    public var trackColor = Color.primary
    /// The color of the notes on the track.
    public var noteColor = Color.accentColor
    /// The view used in a note display.
    ///
    /// # Description:
    /// The type of view to display for the note. For example, `RoundedRectangle(cornerRadius: 10.0)`.
    public let note: Note
    public init(model: MIDITrackViewModel, trackColor: SwiftUI.Color = Color.primary, noteColor: SwiftUI.Color = Color.accentColor, note: Note) {
        self.model = model
        self.trackColor = trackColor
        self.noteColor = noteColor
        self.note = note
    }

    enum SymbolID: Int {
        case note
    }

    public var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                // Track playhead
                context.fill(Rectangle().path(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)), with: .color(trackColor))
                context.scaleBy(x: model.zoomLevel, y: 1.0)
                if let note = context.resolveSymbol(id: SymbolID.note) {
                    for midiNote in model.midiNotes {
                        let rect = CGRect(x: midiNote.rect.minX - model.playPos, y: midiNote.rect.minY, width: midiNote.rect.width, height: midiNote.rect.height)
                        context.draw(note, in: rect)
                    }
                }
            } symbols: {
                note.tag(SymbolID.note)
            }
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
