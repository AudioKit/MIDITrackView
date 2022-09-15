// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public struct MIDINoteView: View {
    @Binding var midiNote: MIDINote
    var color: Color

    public var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(color)
            .frame(width: midiNote.length, height: midiNote.height)
            .position(x: midiNote.position, y: midiNote.level)
    }
}
