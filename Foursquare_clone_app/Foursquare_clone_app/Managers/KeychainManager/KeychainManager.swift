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

    func saveValue(value: Data?, with key: String) -> Bool {
        do {
            let isSuccess = try saveData(value: value, with: key)
            return isSuccess
        } catch {
            print("failed to save token: \(error.localizedDescription)")
            return false
        }
    }

    func checkForDataAvailability(for key: String) -> Bool {
        let check = checkData(for: key)

        return check
    }

    func removeValue(for key: String) {
        do {
            try removeData(for: key)
        } catch {
            print("Failed to delete token: \(error.localizedDescription)")
        }
    }

    func getValue(for key: String) -> String {
        var accessToken = String()
        do {

            guard let token = try getToken(for: key) else {
                return "error when trying to get token from keychain"
            }

            accessToken = token
        } catch {
            print(error.localizedDescription)
        }

        return accessToken
    }
}

// MARK: - error function setting
extension KeychainManager {
    private func error(from status: OSStatus) -> SecureStoreError {
        let message = SecCopyErrorMessageString(status, nil)
            as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        return SecureStoreError.unhandledError(message: message)
    }
}

// MARK: - functions for working with a keychain
private extension KeychainManager {

    func configureTokenRequest(accessToken: Data?, for key: String) -> [String: Any] {
        var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                   kSecAttrLabel as String: "\(key)"]

        if let token = accessToken {
            query[kSecValueData as String] = token

            return query
        } else {
            query[kSecReturnData as String] = kCFBooleanTrue ?? true

            return query
        }
    }

    func saveData(value: Data?, with key: String) throws -> Bool {
        let query = configureTokenRequest(accessToken: value, for: key)
        let status = SecItemAdd(query as CFDictionary, nil)

        if status != errSecSuccess {
            return false
        }

        return true
    }

    func removeData(for key: String) throws {
        let query = configureTokenRequest(accessToken: nil, for: key)
        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    func checkData(for key: String) -> Bool {
        let query = configureTokenRequest(accessToken: nil, for: key)
        let status = SecItemCopyMatching(query as CFDictionary, nil)

        switch status {
        case errSecSuccess:
            return true
        case errSecItemNotFound:
            return false
        default:
            return false
        }

    }

    func getToken(for key: String) throws -> String? {
        var setupQuery = configureTokenRequest(accessToken: nil, for: key)
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
}
