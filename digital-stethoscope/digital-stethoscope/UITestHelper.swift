//
//  UITestHelper.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/28/25.
//
//  A utility file to detect when the app is running in UI testing mode.
//

import Foundation

/// Checks if the app is currently running in UI test mode.
///
/// UI test mode is indicated by the presence of the `--uitest` flag
/// in the launch arguments. This allows conditional behavior in the app,
/// such as bypassing authentication or loading mock data.
///
/// - Returns: `true` if the app was launched with the `--uitest` argument, `false` otherwise.
func isUITestMode() -> Bool {
    ProcessInfo.processInfo.arguments.contains("--uitest")
}
