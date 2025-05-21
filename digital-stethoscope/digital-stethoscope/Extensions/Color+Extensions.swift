//
//  Color+Extensions.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/27/25.
//

import SwiftUI

extension Color {
    static let primary = Color("primary")
    static let secondary = Color("secondary")
    static let navColor = Color("nav")
    static let CTA1 = Color("CTA1")
    static let CTA2 = Color("CTA2")
    static let accentColor = Color("accent")
}

extension Image {
//    static let logo = Image("Logo")
    static let portable = Image("portable")
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}
