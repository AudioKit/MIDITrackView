// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public struct MIDINoteView: View {
    @Binding var midiNote: MIDINote
    var color: Color

    public var body: some View {
        let noteRect = CGRect(x: midiNote.position,
                          y: midiNote.level,
                          width: midiNote.length,
                          height: midiNote.height)
        let notePath = Path(roundedRect: noteRect, cornerRadius: 10)

        Canvas { context, size in
            context.fill(notePath, with: .color(color))
        }
    }
}
