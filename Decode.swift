//
//  Decode.swift
//  DecodeString
//
//  Created by tom on 2018/4/19.
//  Copyright © 2018年 TZ. All rights reserved.
//

import Foundation

extension String {

    enum InvalidError: Error {
        case invalid_byte_index
        case invalid_continuation_byte
    }

    private struct ByteStruct {
        static var byteCount = 0
        static var byteIndex = 0
        static var byteArray = [Character]()
    }

    public func decodeStringFromPolling(_ string: String) -> String? {
        var resultString = string
        do {
            resultString = try decode(string)
        } catch {

        }

        return resultString
    }

    func decode(_ string: String) throws -> String {
        ucs2Decode(string)
        ByteStruct.byteIndex = 0
        var codePoints = [Int]()

        do {
            let tmp = try decodeSymbol()
            while true {
                codePoints.append(tmp)
            }
        } catch {

        }

        return ucs2encode(listToArray(codePoints))
    }

    func ucs2Decode(_ byteString: String) {
        _ = byteString.map { (character) in
            ByteStruct.byteArray.append(character)
        }
        ByteStruct.byteCount = byteString.count
    }

    func decodeSymbol() throws -> Int {
        let byte1: Character
        let byte2: Int
        let byte3: Int
        let byte4: Int
        let codePoint: Int

        if ByteStruct.byteIndex > ByteStruct.byteCount {
            throw InvalidError.invalid_byte_index
        }

        if ByteStruct.byteIndex == ByteStruct.byteCount {
            return -1
        }

//        let character = ByteStruct.byteArray[ByteStruct.byteIndex]
//        let string = String.init(character)
//        guard var unicodeScalar = UnicodeScalar.init(string) else {
//            return -1
//        }
//        var numeric = unicodeScalar.value
//        numeric = numeric & 0xff
//
//        guard let
//
        byte1 = {
            let string = String.init(ByteStruct.byteArray[ByteStruct.byteIndex])
            var numeric = convertStringToUnicodeScalar(string).value
            numeric = numeric & 0xFF
            return convertUnicodeScalarToCharacter(UnicodeScalar.init(numeric)!)
        }()

        return 1
    }

    func ucs2encode(_ array: [Int]) -> String {
        return ""
    }

    func listToArray(_ array: [Int]) -> [Int] {
        return [1]
    }

    private func convertUnicodeScalarToCharacter(_ unicodeScalar: UnicodeScalar) -> Character {
        return Character.init(unicodeScalar)
    }

    private func convertStringToUnicodeScalar(_ sting: String) -> UnicodeScalar {

        return UnicodeScalar.init(1)
    }

}
