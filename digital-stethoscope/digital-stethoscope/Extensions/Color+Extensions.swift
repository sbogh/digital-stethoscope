//
//  Color+Extensions.swift
//  digital-stethoscope
//
//  Defines elements used thorughout the app in a clean and easily
//  useable way
//  Created by Siya Rajpal on 4/27/25.
//

import SwiftUI

// MARK: - Custom Color Extensions

// Extend the Color struct to include custom named colors from the asset catalog.
extension Color {
    static let primary = Color("primary")
    static let secondary = Color("secondary")
    static let navColor = Color("nav")
    static let CTA1 = Color("CTA1")
    static let CTA2 = Color("CTA2")
    static let accentColor = Color("accent")
}

// MARK: - Custom Image Extensions

// Extend the Image struct to include reusable asset references.
extension Image {
    static let logo = Image("Logo")
    static let portable = Image("portable")
}

// MARK: - Clamping Extension for Comparable Types

// Adds a `clamped(to:)` method to any Comparable type (e.g., Int, Double).
extension Comparable {
    /// Clamps a value to stay within a given closed range.
    /// - Parameter range: A closed range to clamp the value to.
    /// - Returns: The value clamped within the range.
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
