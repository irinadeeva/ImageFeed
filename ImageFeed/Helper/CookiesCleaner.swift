//
//  CookiesCleaner.swift
//  ImageFeed
//
//  Created by Irina Deeva on 07/02/24.
//

import WebKit

protocol CookiesCleanerProtocol: AnyObject {
    func clean()
}

class CookiesCleaner: CookiesCleanerProtocol{
    func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
