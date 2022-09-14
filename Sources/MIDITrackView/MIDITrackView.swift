// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

public struct MIDITrackView: View {

    public init() {}

    public var body: some View {
        VStack {
            ZStack {
                // Where a model will come in handy...
                Note(notePosition: 80, noteLevel: 5, noteLength: 102, noteHeight: 5)
                Note(notePosition: 103, noteLevel: 23, noteLength: 75, noteHeight: 5)
                Note(notePosition: 157, noteLevel: 36, noteLength: 25, noteHeight: 5)
                Note(notePosition: 208, noteLevel: 5, noteLength: 102, noteHeight: 5)
                Note(notePosition: 301, noteLevel: 23, noteLength: 75, noteHeight: 5)
                Note(notePosition: 376, noteLevel: 36, noteLength: 25, noteHeight: 5)
                Note(notePosition: 402, noteLevel: 5, noteLength: 102, noteHeight: 5)
                Note(notePosition: 450, noteLevel: 23, noteLength: 75, noteHeight: 5)
                Note(notePosition: 500, noteLevel: 36, noteLength: 25, noteHeight: 5)
            }
        }
        .frame(width: 500, height: 200, alignment: .center)
        .background(Color.cyan)
        .cornerRadius(10.0)
    }
}
