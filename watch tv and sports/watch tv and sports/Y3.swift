//
//  Y3.swift
//  watch tv and sports
//
//  Created by Mobi iOS on 31/03/26.
//


import Foundation
import UIKit
import FingerprintPro

final class Y3: UIViewController {
    
    static func z9(k9: String) async -> (String, String) {
        
        let r0: Region = .eu
        
        let cfg = Configuration(
            apiKey: k9,
            region: r0,
            extendedResponseFormat: true
        )
        
        let inst = FingerprintProFactory.getInstance(cfg)
        
        do {
            let res = try await inst.getVisitorIdResponse()
            return (res.visitorId, res.requestId)
        } catch {
            return ("E1", "E1")
        }
    }
}