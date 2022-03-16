//
//  tests.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 11/03/22.
//

import SwiftUI

struct tests: View {
    var attributedString: AttributedString {
        var string = AttributedString("This is a basic string.")
        string.inlinePresentationIntent = .stronglyEmphasized
        return string
    }
    let attributedString2 = try! AttributedString(
        markdown: "_Hamlet_ by William Shakespeare")
    
    let thankYouString = try! AttributedString(
        markdown:"**Thank you!** Please visit our [website](https://example.com)")
    
    var attributedString3: AttributedString {
        var string = AttributedString("This is a basic string that contains a link.")
        let range = string.range(of: "link")!
        string[range].link = URL(string: "https://www.example.com")
        return string
    }
    
    let blueColor = UIColor.blue
    var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
    
    var body: some View {
//        Capsule()
//        .stroke(
//            Color.purple,
//            style: StrokeStyle(
//                lineWidth: 5,
//                lineCap: .round,
//                lineJoin: .miter,
//                miterLimit: 0,
//                dash: [1, 20],
//                dashPhase: 1
//            )
//        )
        
        VStack(spacing: 20) {
            Text(attributedString)
            Text(attributedString2)
            //.font(.system(size: 20, weight: .light, design: .serif))
            Text(thankYouString)
            Text(attributedString3)
                //.foregroundColor(Color(cgColo))
            Text("")
        }
    }
}

struct tests_Previews: PreviewProvider {
    static var previews: some View {
        tests()
    }
}
