//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 29.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

class KeychainManager {

    static var shared: KeychainManager = {
        let keychain = KeychainManager()
        return keychain
    }()

    private func configureTokenRequest (accessToken: Data?, for label: String) -> [String: Any] {
        if let token = accessToken {
            let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecAttrLabel as String: "\(label)",
                                        kSecValueData as String: token]

            return query
        } else {
            let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecAttrLabel as String: "\(label)",
                                        kSecReturnData as String: kCFBooleanTrue ?? true]

            return query
        }
    }

    private func saveValueInKaychain (query: [String: Any]) throws {

        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw error(from: status)
        }
    }

    private func removeValueInKaychain (query: [String: Any]) throws {
        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    private func checkValueInKaychain (query: [String: Any]) -> Bool {
        let status = SecItemCopyMatching(query as CFDictionary, nil)

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

    private func getTokenFromKeychain (query: [String: Any]) throws -> String? {
        var setupQuery = query
        setupQuery[kSecMatchLimit as String] = kSecMatchLimitOne
        setupQuery[kSecReturnAttributes as String] = kCFBooleanTrue ?? true

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(setupQuery as CFDictionary, $0)
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
    func tokenRequest (accessToken: Data?, for label: String) -> [String: Any] {
        return configureTokenRequest(accessToken: accessToken, for: label)
    }
    func saveValue (query: [String: Any]) {
        do {
            try saveValueInKaychain(query: query)
        } catch {
            print("failed to save token: \(error.localizedDescription)")
        }
    }

    func checkValue (query: [String: Any]) -> Bool {
        let check = checkValueInKaychain(query: query)

        return check
    }

    func removeValue (query: [String: Any]) {
        do {
            try removeValueInKaychain(query: query)
        } catch {
            print("Failed to delete token: \(error.localizedDescription)")
        }
    }

    func getValue (query: [String: Any]) -> String {
        var accessToken = String()
        do {
            guard let token = try getTokenFromKeychain(query: query) else {
                return "error when trying to get token from keychain"
            }
            accessToken = token
        } catch {
            print(error.localizedDescription)
        }

        return accessToken
    }
}
extension KeychainManager {
    private func error (from status: OSStatus) -> SecureStoreError {
        let message = SecCopyErrorMessageString(status, nil)
            as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        return SecureStoreError.unhandledError(message: message)
    }
}
