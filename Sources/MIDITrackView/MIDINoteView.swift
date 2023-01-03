// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public struct MIDINoteView: View {
    @Binding var midiNote: MIDINote
    @Binding var zoomMultiplier: Double
    var color: Color

    public var body: some View {
        let noteRect = CGRect(x: midiNote.position * zoomMultiplier,
                          y: midiNote.level,
                          width: midiNote.length * zoomMultiplier,
                          height: midiNote.height)
        let notePath = Path(roundedRect: noteRect, cornerRadius: 10)

        Canvas { context, size in
            context.fill(notePath, with: .color(color))
        }
    }
}
