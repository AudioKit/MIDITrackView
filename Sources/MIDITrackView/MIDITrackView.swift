// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

/// A view representing a MIDI Track.
public struct MIDITrackView: View {
    /// The view model.
    @Binding var model: MIDITrackViewModel
    /// The track background color.
    var trackColor = Color.primary
    /// The color of the notes on the track.
    var noteColor = Color.accentColor

    public init(model: Binding<MIDITrackViewModel>,
                trackColor: Color = .primary,
                noteColor: Color = .accentColor) {
        _model = model
        self.trackColor = trackColor
        self.noteColor = noteColor
    }

    public var body: some View {
        VStack {
            ZStack {
                ForEach(model.midiNotes) { midiNote in
                    MIDINoteView(
                        midiNote: $model.midiNotes[model.midiNotes.firstIndex(of: midiNote)!],
                        color: noteColor
                    )
                }
            }
        }
        .frame(width: model.length, height: model.height, alignment: .center)
        .background(trackColor)
        .cornerRadius(10.0)
    }
}
