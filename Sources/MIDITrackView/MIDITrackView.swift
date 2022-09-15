// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public struct MIDITrackView: View {
    @Binding var model: MIDITrackViewModel
    var trackColor = Color.primary
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
