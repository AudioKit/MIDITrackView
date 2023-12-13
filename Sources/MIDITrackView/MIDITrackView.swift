// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

/// A view representing a MIDI Track.
public struct MIDITrackView: View {
    /// The model for the view which contains an array of ``MIDITrackViewNote``, the track length, and the track height.
    @Binding var model: MIDITrackViewModel
    /// The track background color.
    private let trackColor: Color
    /// The color of the notes on the track.
    private let noteColor: Color
    public init(model: Binding<MIDITrackViewModel>, trackColor: SwiftUI.Color = Color.primary, noteColor: SwiftUI.Color = Color.accentColor) {
        _model = model
        self.trackColor = trackColor
        self.noteColor = noteColor
    }

    public var body: some View {
        Canvas { context, size in
            context.scaleBy(x: model.getZoomLevel(), y: 1.0)
            context.fill(Rectangle().path(in: CGRect(x: 0.0, y: 0.0, width: model.getLength(), height: model.getHeight())), with: .color(trackColor))
            context.translateBy(x: -model.getPlayPos(), y: 0.0)
            var notePath = Path()
            notePath.addRects(model.getMIDINotes())
            context.fill(notePath, with: .color(noteColor))
        }
    }
}
