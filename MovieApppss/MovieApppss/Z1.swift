//
//  Z1.swift
//  MovieApppss
//
//  Created by Mobi iOS on 11/09/25.
//

import Foundation
import UIKit
import FingerprintPro

class Z1: UIViewController {
    
    static func a1(k1: String) async -> (String, String) {
        let r1: Region = .eu
        
        let c1 = Configuration(
            apiKey: k1,
            region: r1,
            extendedResponseFormat: true
        )
        
        let p1 = FingerprintProFactory.getInstance(c1)
        
        do {
            let x1 = try await p1.getVisitorIdResponse()
            return (x1.visitorId, x1.requestId)
        } catch {
            return ("E1", "E1")
        }
    }
}
