//
//  KeychainError.swift
//  Foursquare_clone_app
//
//  Created by maks on 29.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

enum SecureStoreError: Error {
    case string2DataConversionError
    case data2StringConversionError
    case unhandledError(message: String)
}

// MARK: - LocalizedError
extension SecureStoreError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .string2DataConversionError:
            return NSLocalizedString("String to Data conversion error", comment: "")

        case .data2StringConversionError:
            return NSLocalizedString("Data to String conversion error", comment: "")
        case .unhandledError(let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}
