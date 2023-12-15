// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

struct MIDINoteView: Shape {
    let midiNotes: [CGRect]
    func path(in rect: CGRect) -> Path {
        var path = Path().path(in: rect)
        path.addRects(midiNotes)
        return path
    }
}

/// A view representing a MIDI Track.
public struct MIDITrackView: View {
    /// The model for the view which contains an array of MIDI notes (as `CGRect`), the track length, and the track height.
    @Binding var model: MIDITrackViewModel
    /// The track background color.
    private let trackColor: Color
    /// The color of the notes on the track.
    private let noteColor: Color
    public init(model: Binding<MIDITrackViewModel>, 
                trackColor: SwiftUI.Color = Color.primary,
                noteColor: SwiftUI.Color = Color.accentColor) {
        _model = model
        self.trackColor = trackColor
        self.noteColor = noteColor
    }

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0).fill(trackColor)
            MIDINoteView(midiNotes: model.getMIDINotes())
            .transform(CGAffineTransformConcat(
                CGAffineTransform(translationX: -model.getPlayPos(), y: 0.0), 
                CGAffineTransform(scaleX: model.getZoomLevel(), y: 1.0))
            )
            .fill(noteColor)
        }
        .drawingGroup()
    }
}
