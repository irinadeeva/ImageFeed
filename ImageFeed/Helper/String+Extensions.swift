//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Irina Deeva on 04/02/24.
//

import Foundation

private let dateTimeDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return dateFormatter
}()

extension String {
    var changeToDate: Date? { dateTimeDefaultFormatter.date(from: self) }
}
