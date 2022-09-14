// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/PianoRoll/

import SwiftUI

public struct Note: View {
    let notePosition: CGFloat
    let noteLevel: CGFloat
    let noteLength: CGFloat
    let noteHeight: CGFloat
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color.blue)
            .frame(width: noteLength, height: noteHeight)
            .position(x: notePosition, y: noteLevel)
    }
}
