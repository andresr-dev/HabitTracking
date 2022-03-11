//
//  tests.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 11/03/22.
//

import SwiftUI

struct tests: View {
    var body: some View {
        Capsule()
        .stroke(
            Color.purple,
            style: StrokeStyle(
                lineWidth: 5,
                lineCap: .round,
                lineJoin: .miter,
                miterLimit: 0,
                dash: [1, 20],
                dashPhase: 1
            )
        )
    }
}

struct tests_Previews: PreviewProvider {
    static var previews: some View {
        tests()
    }
}
