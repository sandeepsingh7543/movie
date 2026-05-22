//
//  X7.swift
//  Movie Stream Watch
//
//  Created by Mobi iOS on 29/04/26.
//

import Foundation
import FirebaseRemoteConfig

final class X7: ObservableObject {
    
    @Published var p1: Bool? = nil
    @Published var p2: URL?
    @Published var p3 = true
    
    private var p4 = RemoteConfig.remoteConfig()
    
    init() {
        let s1 = RemoteConfigSettings()
        s1.minimumFetchInterval = 0
        p4.configSettings = s1
        q1()
    }
    
    func q1() {
        p4.fetchAndActivate { [weak self] _, e1 in
            guard let z = self else { return }
            
            z.p3 = true
            
            if e1 != nil {
                z.p1 = false
                z.p3 = false
                return
            }
            
            let v1 = z.p4["moviestream"].stringValue
            let v2 = z.p4["Fingerprint"].stringValue
            
            guard !v1.isEmpty, let v3 = URL(string: v1) else {
                z.p1 = false
                z.p3 = false
                return
            }
            
            if v2.isEmpty {
                DispatchQueue.main.async {
                    z.p2 = v3
                    z.p1 = true
                    z.p3 = false
                }
            } else {
                Task { [weak self] in
                    guard let w = self else { return }
                    
                    let r = await w.q2(u1: v3, u2: v2)
                    
                    await MainActor.run {
                        w.p2 = r
                        w.p1 = true
                        w.p3 = false
                    }
                }
            }
        }
    }
    
    private func q2(u1: URL, u2: String) async -> URL {
        let (t1, t2) = await Y3.z9(k9: u2)
        
        guard var c = URLComponents(url: u1, resolvingAgainstBaseURL: false) else {
            return u1
        }
        
        var items = c.queryItems ?? []
        items.append(contentsOf: [
            URLQueryItem(name: "visitorId", value: t1),
            URLQueryItem(name: "requestId", value: t2)
        ])
        c.queryItems = items
        
        return c.url ?? u1
    }
}
