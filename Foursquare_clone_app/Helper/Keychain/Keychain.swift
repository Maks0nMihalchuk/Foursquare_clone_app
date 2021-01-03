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

    private func setupQuery (accessToken: Data?, for label: String) -> [String: Any] {
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

    private func saveTokenInKeychain (accessToken: String, for label: String) throws {
        let encodedToken = accessToken.data(using: .utf8)
        let query = setupQuery(accessToken: encodedToken, for: label)

        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw error(from: status)
        }
    }

    private func removeTokenFromKeychain (for label: String) throws {
        let query = setupQuery(accessToken: nil, for: label)
        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    private func checkTokenInKeychain (for label: String) -> Bool {
        let query = setupQuery(accessToken: nil, for: label)
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

    private func getTokenFromKeychain (for label: String) throws -> String? {
        var query = setupQuery(accessToken: nil, for: label)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue ?? true

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
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
    func saveToken (accessToken: String, for label: String) {
        do {
            try saveTokenInKeychain(accessToken: accessToken, for: label)
        } catch {
            print("failed to save token: \(error.localizedDescription)")
        }
    }

    func checkKeychain (for label: String) -> Bool {
        let check = checkTokenInKeychain(for: label)

        return check
    }

    func removeToken (for label: String) {
        do {
            try removeTokenFromKeychain(for: label)
        } catch {
            print("Failed to delete token: \(error.localizedDescription)")
        }
    }

    func getToken (for label: String) -> String {
        var accessToken = String()
        do {
            guard let token = try Keychain.shared.getTokenFromKeychain(for: label) else {
                return "error when trying to get token from keychain"
            }
            accessToken = token
        } catch {
            print(error.localizedDescription)
        }

        return accessToken
    }
}
extension Keychain {
    private func error (from status: OSStatus) -> SecureStoreError {
        let message = SecCopyErrorMessageString(status, nil)
            as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        return SecureStoreError.unhandledError(message: message)
    }
}
