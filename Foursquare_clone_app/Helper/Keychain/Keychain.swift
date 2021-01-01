//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 29.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

class Keychain {

    static var shared: Keychain = {
        let keychain = Keychain()
        return keychain
    }()

    private func setupQuery (accessToken: Data?, for label: String) -> CFDictionary {
        if let token = accessToken {
            let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecAttrLabel as String: "\(label)",
                                        kSecValueData as String: token]

            return query as CFDictionary
        } else {
            let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecAttrLabel as String: "\(label)",
                                        kSecReturnData as String: kCFBooleanTrue]

            return query as CFDictionary
        }
    }

    private func saveTokenInKeychain (accessToken: String, for label: String) throws {
        let encodedToken = accessToken.data(using: .utf8)
        let query = setupQuery(accessToken: encodedToken, for: label)

        let status = SecItemAdd(query, nil)
        if status != errSecSuccess {
            throw error(from: status)
        }
    }

    private func removeTokenFromKeychain (for label: String) throws {
        let query = setupQuery(accessToken: nil, for: label)
        let status = SecItemDelete(query)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    private func checkTokenInKeychain (for label: String) -> Bool {
        let query = setupQuery(accessToken: nil, for: label)
        let status = SecItemCopyMatching(query, nil)

        switch status {
        case errSecSuccess:
            print("data availability: true")
            return true
        case errSecItemNotFound:
            print("data availability: false")
            return false
        default:
            print("Unhandled error")
            return false
        }

    }

    private func getTokenFromKeychain (for label: String) throws -> String? {

        let query = setupQuery(accessToken: nil, for: label)

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query, $0)
        }

        switch status {
        case errSecSuccess:
            guard
                let queriedItem = queryResult as? [String: Any],
                let token = queriedItem[kSecValueData as String] as? Data,
                let accessToken = String(data: token, encoding: .utf8) else {
                    throw SecureStoreError.data2StringConversionError
            }
            return accessToken
        case errSecItemNotFound:
            return nil
        default:
            throw error(from: status)
        }
    }

// MARK: - public methods
    func saveToken (accessToken: String, for label: String) throws {
        try saveTokenInKeychain(accessToken: accessToken, for: label)
    }

    func checkKeychain (for label: String) -> Bool {
        let check = checkTokenInKeychain(for: label)

        return check
    }

    func removeToken (for label: String) throws {
        try removeTokenFromKeychain(for: label)
    }
}
extension Keychain {
    private func error (from status: OSStatus) -> SecureStoreError {
        let message = SecCopyErrorMessageString(status, nil)
            as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        return SecureStoreError.unhandledError(message: message)
    }
}
