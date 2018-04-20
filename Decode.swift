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
        case invalid_Stirng(string: String)
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
        var codePoints = [UInt32]()

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

    func decodeSymbol() throws -> UInt32 {
        let byte1: Character
        var byte2: Character
        var byte3: Character
        var byte4: Character
        var codePoint: Character

        if ByteStruct.byteIndex > ByteStruct.byteCount {
            throw InvalidError.invalid_byte_index
        }

        if ByteStruct.byteIndex == ByteStruct.byteCount {
            return 1
        }

        byte1 = {
            let string = String.init(ByteStruct.byteArray[ByteStruct.byteIndex])
            var numeric = convertStringToUnicodeScalar(string).value
            numeric = numeric & 0xFF
            return convertUnicodeScalarToCharacter(UnicodeScalar.init(numeric)!)
        }()
        ByteStruct.byteIndex += 1

        if (convertStringToUnicodeScalar(String.init(byte1)).value & 0x80) == 0 {
            return convertStringToUnicodeScalar(String.init(byte1)).value
        }

        if (convertStringToUnicodeScalar(String.init(byte1)).value & 0xE0) == 0xC0 {
            byte2 = try readContinuationByte()
            codePoint = {
                let numeric = convertStringToUnicodeScalar(String.init(byte1)).value & 0x1F << 6 | convertStringToUnicodeScalar(String.init(byte2)).value
                return convertUnicodeScalarToCharacter(UnicodeScalar.init(numeric)!)
            }()
            if convertStringToUnicodeScalar(String.init(codePoint)).value >= 0x80 {
                return convertStringToUnicodeScalar(String.init(codePoint)).value
            }else {
                throw InvalidError.invalid_continuation_byte
            }
        }

        if (convertStringToUnicodeScalar(String.init(byte1)).value & 0xF0) == 0xE0 {
            byte2 = try readContinuationByte()
            byte3 = try readContinuationByte()
            codePoint = {
                let numeric = (convertStringToUnicodeScalar(String.init(byte1)).value & 0x0F) << 12 | convertStringToUnicodeScalar(String.init(byte2)).value << 6 | convertStringToUnicodeScalar(String.init(byte3)).value
                return convertUnicodeScalarToCharacter(UnicodeScalar.init(numeric)!)
            }()
            if convertStringToUnicodeScalar(String.init(codePoint)).value >= 0x0800 {
                try checkScalarValue(convertStringToUnicodeScalar(String.init(codePoint)).value)
            }else {
                throw InvalidError.invalid_continuation_byte
            }
        }

        if (convertStringToUnicodeScalar(String.init(byte1)).value & 0xF8) == 0xF0 {
            byte2 = try readContinuationByte()
            byte3 = try readContinuationByte()
            byte4 = try readContinuationByte()
            codePoint = {
                let numeric = convertStringToUnicodeScalar(String.init(byte1)).value << 0x12 | convertStringToUnicodeScalar(String.init(byte2)).value << 0x0C | convertStringToUnicodeScalar(String.init(byte3)).value << 0x06 | convertStringToUnicodeScalar(String.init(byte4)).value
                return convertUnicodeScalarToCharacter(UnicodeScalar.init(numeric)!)
            }()
            if convertStringToUnicodeScalar(String.init(codePoint)).value >= 0x010000, convertStringToUnicodeScalar(String.init(codePoint)).value >= 0x10FFFF {
                return convertStringToUnicodeScalar(String.init(codePoint)).value
            }
        }

        throw InvalidError.invalid_continuation_byte
    }

    func ucs2encode(_ array: [Int]) -> String {
        return ""
    }

    func listToArray(_ array: [UInt32]) -> [Int] {
        return [1]
    }

    private func convertUnicodeScalarToCharacter(_ unicodeScalar: UnicodeScalar) -> Character {
        return Character.init(unicodeScalar)
    }

    private func convertStringToUnicodeScalar(_ sting: String) -> UnicodeScalar {

        return UnicodeScalar.init(1)
    }

    private func readContinuationByte() throws -> Character {
        if ByteStruct.byteIndex >= ByteStruct.byteCount {
            throw InvalidError.invalid_byte_index
        }

        let continuationByte = convertStringToUnicodeScalar(String.init(ByteStruct.byteArray[ByteStruct.byteIndex])).value & 0xFF
        ByteStruct.byteIndex += 1

        if (continuationByte & 0xC0) == 0x80 {
            return Character.init(UnicodeScalar.init(continuationByte & 0x3F)!)
        }

        throw InvalidError.invalid_continuation_byte
    }

    private func checkScalarValue(_ codePoint: UInt32) throws {
        if codePoint >= 0xD800, codePoint <= 0xDFFF {
            throw InvalidError.invalid_Stirng(string: "Lone surrogate U+ + (UNICODE-->)\(codePoint)(<--UNICODE) + is not a scalar value")
        }
    }

}
