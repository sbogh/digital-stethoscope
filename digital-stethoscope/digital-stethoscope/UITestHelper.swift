//
//  UITestHelper.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/28/25.
//


import Foundation

func isUITestMode() -> Bool {
    ProcessInfo.processInfo.arguments.contains("--uitest")
}

