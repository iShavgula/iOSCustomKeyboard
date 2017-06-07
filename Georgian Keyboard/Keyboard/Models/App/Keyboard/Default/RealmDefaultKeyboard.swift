//
//  RealmDefaultKeyboard.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 18/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import Foundation

class DefaultKeyboard {
    class func get() -> Keyboard? {
        if let fileUrl = Bundle.main.path(forResource: "default_keyboard", ofType: "geojson")?.url {
            do {
                let contents = try Data(contentsOf: fileUrl)
                guard let contentJSONString = String(data: contents, encoding: String.Encoding.utf8) else {
                    return nil
                }
                guard let realmKeyboard = RealmKeyboard.initWithJsonString(jsonString: contentJSONString) else {
                    return nil
                }
                realmKeyboard.precalculate()
                return Keyboard(object: realmKeyboard)
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        
        return nil
    }
}

extension DefaultKeyboard {
    class func iPhone6() -> Keyboard {
        let rKeyboard = RealmKeyboard()
        
        let portraintInfo = RealmKeyboardInfo()
        portraintInfo.horizontalInset = 3
        portraintInfo.verticalInset = 6
        portraintInfo.height = 216
        portraintInfo.width = 375
        rKeyboard.portraitInfo = portraintInfo
        
        let landscapeInfo = RealmKeyboardInfo()
        landscapeInfo.horizontalInset = 2.5
        landscapeInfo.verticalInset = 4
        landscapeInfo.height = 162
        landscapeInfo.width = 667
        rKeyboard.landscapeInfo = landscapeInfo
        
        let georgian = englishLayout(
            alphabet: [
                (["ქ", "წ", "ე", "რ", "ტ", "ყ", "უ", "ი", "ო", "პ"],
                 ["ქ", "ჭ", "ე", "ღ", "თ", "ყ", "უ", "ი", "O", "P"]),
                (["ა", "ს", "დ", "ფ", "გ", "ჰ", "ჯ", "კ", "ლ"],
                 ["ა", "შ", "D", "ფ", "გ", "ჰ", "ჟ", "კ", "ლ"]),
                (["ზ", "ხ", "ც", "ვ", "ბ", "ნ", "მ"],
                 ["ძ", "ხ", "ჩ", "ვ", "ბ", "ნ", "მ"])
            ], numbers: [
                (["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                 ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="]),
                (["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
                 ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"]),
                ([".", ",", "?", "!", "'"],
                 [".", ",", "?", "!", "'"])
            ])
        georgian.name = "georgian"
        rKeyboard.languages.append(georgian)
        
        
        let english = englishLayout(
            alphabet: [
                (["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                 ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]),
                (["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                 ["A", "S", "D", "F", "G", "H", "J", "K", "L"]),
                (["z", "x", "c", "v", "b", "n", "m"],
                 ["Z", "X", "C", "V", "B", "N", "M"])
            ], numbers: [
                (["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                 ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="]),
                (["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
                 ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"]),
                ([".", ",", "?", "!", "'"],
                 [".", ",", "?", "!", "'"])
            ])
        english.name = "english"
        rKeyboard.languages.append(english)
        
        rKeyboard.bottom = bottomDefault()
        
        rKeyboard.precalculate()
        return Keyboard(object: rKeyboard)!
    }
    
    private class func englishLayout(
        alphabet: [(inputs: [String], shiftInputs: [String])],
        numbers: [(inputs: [String], shiftInputs: [String])]) -> RealmKeyboardLanguage {
        let language = RealmKeyboardLanguage()
        
        language.horizontalPositioningPortrait = RealmKeyboardHorizontalPositioning()
        language.horizontalPositioningPortrait?.type = RealmKeyboardKeyPositioningType.Auto.rawValue
        language.horizontalPositioningPortrait?.value.value = 1
        
        language.horizontalPositioningLandscape = RealmKeyboardHorizontalPositioning()
        language.horizontalPositioningLandscape?.type = RealmKeyboardKeyPositioningType.Auto.rawValue
        language.horizontalPositioningLandscape?.value.value = 1
        
        // alphabet
        if true {
            if true {
                let line = getLine()
                line.index = 0
                
                let skl = sideKey(isLeft: true, row: 0)
                skl.index = 0
                line.keys.append(skl)
                
                for i in 1..<11 {
                    let key = keyOfType(.none)
                    key.index = i
                    key.input = alphabet[0].inputs[i - 1]
                    key.shiftInput = alphabet[0].shiftInputs[i - 1]
                    line.keys.append(key)
                }
                
                let skr = sideKey(isLeft: false, row: 0)
                skr.index = 10
                line.keys.append(skr)
                
                language.alphabet.append(line)
            }
            
            if true {
                let line = getLine()
                line.index = 1
                
                let skl = sideKey(isLeft: true, row: 1)
                skl.index = 0
                line.keys.append(skl)
                
                for i in 1..<10 {
                    let key = keyOfType(.none)
                    key.index = i
                    key.input = alphabet[1].inputs[i - 1]
                    key.shiftInput = alphabet[1].shiftInputs[i - 1]
                    
                    if i == 1 {
                        key.horizontalPositioningPortrait?.emptyLeft = 0.5
                        key.horizontalPositioningLandscape?.emptyLeft = 0.5
                    }
                    if i == 9 {
                        key.horizontalPositioningPortrait?.emptyRight = 0.5
                        key.horizontalPositioningLandscape?.emptyRight = 0.5
                    }
                    
                    line.keys.append(key)
                }
                
                let skr = sideKey(isLeft: false, row: 1)
                skr.index = 10
                line.keys.append(skr)
                
                language.alphabet.append(line)
            }
            
            if true {
                let line = getLine()
                line.index = 1
                
                let skl = sideKey(isLeft: true, row: 2)
                skl.index = 0
                line.keys.append(skl)
                
                let shift = keyOfType(.shift)
                shift.index = 1
                line.keys.append(shift)
                
                for i in 2..<9 {
                    let key = keyOfType(.none)
                    key.index = i
                    key.input = alphabet[2].inputs[i - 2]
                    key.shiftInput = alphabet[2].shiftInputs[i - 2]
                    
                    if i == 2 {
                        key.horizontalPositioningPortrait?.emptyLeft = 0.25
                        key.horizontalPositioningLandscape?.emptyLeft = 0.25
                    }
                    if i == 8 {
                        key.horizontalPositioningPortrait?.emptyRight = 0.25
                        key.horizontalPositioningLandscape?.emptyRight = 0.25
                    }
                    
                    line.keys.append(key)
                }
                
                let delete = keyOfType(.delete)
                delete.index = 9
                line.keys.append(delete)
                
                let skr = sideKey(isLeft: false, row: 2)
                skr.index = 10
                line.keys.append(skr)
                
                language.alphabet.append(line)
            }
        }
        
        // numbers
        if true {
            if true {
                let line = getLine()
                line.index = 0
                
                let skl = sideKey(isLeft: true, row: 0)
                skl.index = 0
                line.keys.append(skl)
                
                for i in 1..<11 {
                    let key = keyOfType(.none)
                    key.index = i
                    key.input = numbers[0].inputs[i - 1]
                    key.shiftInput = numbers[0].shiftInputs[i - 1]
                    line.keys.append(key)
                }
                
                let skr = sideKey(isLeft: false, row: 0)
                skr.index = 10
                line.keys.append(skr)
                
                language.numbers.append(line)
            }
            
            if true {
                let line = getLine()
                line.index = 0
                
                let skl = sideKey(isLeft: true, row: 1)
                skl.index = 0
                line.keys.append(skl)
                
                for i in 1..<11 {
                    let key = keyOfType(.none)
                    key.index = i
                    key.input = numbers[1].inputs[i - 1]
                    key.shiftInput = numbers[1].shiftInputs[i - 1]
                    line.keys.append(key)
                }
                
                let skr = sideKey(isLeft: false, row: 1)
                skr.index = 10
                line.keys.append(skr)
                
                language.numbers.append(line)
            }
            
            if true {
                let line = getLine()
                line.index = 1
                
                let skl = sideKey(isLeft: true, row: 2)
                skl.index = 0
                line.keys.append(skl)
                
                let shift = keyOfType(.shiftNumbers)
                shift.index = 1
                line.keys.append(shift)
                
                for i in 2..<7 {
                    let key = keyOfType(.none)
                    key.index = i
                    key.input = numbers[2].inputs[i - 2]
                    key.shiftInput = numbers[2].shiftInputs[i - 2]
                    
                    if i == 2 {
                        key.horizontalPositioningPortrait?.emptyLeft = 0.25
                        key.horizontalPositioningLandscape?.emptyLeft = 0.25
                    }
                    if i == 6 {
                        key.horizontalPositioningPortrait?.emptyRight = 0.25
                        key.horizontalPositioningLandscape?.emptyRight = 0.25
                    }
                    
                    key.horizontalPositioningPortrait?.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
                    key.horizontalPositioningPortrait?.value.value = 52
                    
                    key.horizontalPositioningLandscape?.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
                    key.horizontalPositioningLandscape?.value.value = 73
                    
                    line.keys.append(key)
                }
                
                let delete = keyOfType(.delete)
                delete.index = 7
                line.keys.append(delete)
                
                let skr = sideKey(isLeft: false, row: 0)
                skr.index = 8
                line.keys.append(skr)
                
                language.numbers.append(line)
            }
        }
        
        return language
    }
    
    private class func bottomDefault() -> RealmKeyboardLine {
        let line = getLine()
        line.index = 0
        
        let skl = sideKey(isLeft: true, row: 3)
        skl.index = 0
        line.keys.append(skl)
        
        let numbers = keyOfType(.numbers)
        numbers.index = 1
        line.keys.append(numbers)
        
        let language = keyOfType(.language)
        language.index = 1
        line.keys.append(language)
        
        let space = keyOfType(.space)
        space.index = 1
        line.keys.append(space)
        
        let returnn = keyOfType(.returnn)
        returnn.index = 1
        line.keys.append(returnn)
        
        let skr = sideKey(isLeft: false, row: 3)
        skr.index = 10
        line.keys.append(skr)
        
        return line
    }
    
    class func getLine() -> RealmKeyboardLine {
        let line = RealmKeyboardLine()
        line.index = 0
        
        line.horizontalPositioningPortrait = RealmKeyboardHorizontalPositioning()
        line.horizontalPositioningPortrait?.type = RealmKeyboardKeyPositioningType.Auto.rawValue
        line.horizontalPositioningPortrait?.value.value = 1
        
        line.horizontalPositioningLandscape = RealmKeyboardHorizontalPositioning()
        line.horizontalPositioningLandscape?.type = RealmKeyboardKeyPositioningType.Auto.rawValue
        line.horizontalPositioningLandscape?.value.value = 1
        
        return line
    }
    
    
    
    class func sideKey(isLeft: Bool, row: Int) -> RealmKeyboardKey {
        let key = RealmKeyboardKey()
        key.style = KKeyStyle.dark.rawValue
        key.canPopup = false
        key.canHiglight = true
        
        key.type = KKeyType.none.rawValue
        
        if isLeft {
            switch row {
            case 0:
                key.type = KKeyType.doubleShiftLeft.rawValue
                
            case 1:
                key.type = KKeyType.doubleShiftRight.rawValue
                
            case 2:
                key.type = KKeyType.none.rawValue
                key.input = ","
                key.shiftInput = ","
                
            case 3:
                key.type = KKeyType.language.rawValue
                
            default:
                break
            }
        } else {
            switch row {
            case 0:
                key.type = KKeyType.shiftLeft.rawValue
                
            case 1:
                key.type = KKeyType.shiftRight.rawValue
                
            case 2:
                key.type = KKeyType.none.rawValue
                key.input = "."
                key.shiftInput = "."
                
            case 3:
                key.type = KKeyType.dismiss.rawValue
                
            default:
                break
            }
        }
        
        key.horizontalPositioningPortrait = RealmKeyboardHorizontalPositioning()
        key.horizontalPositioningPortrait!.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
        key.horizontalPositioningPortrait!.value.value = 0
        
        key.horizontalPositioningLandscape = RealmKeyboardHorizontalPositioning()
        key.horizontalPositioningLandscape!.type = RealmKeyboardKeyPositioningType.Auto.rawValue
        key.horizontalPositioningLandscape!.value.value = 0.105
        
        return key
    }
    
    class func keyOfType(_ type: KKeyType) -> RealmKeyboardKey {
        let key = RealmKeyboardKey()
        key.type = type.rawValue
        
        key.horizontalPositioningPortrait = RealmKeyboardHorizontalPositioning()
        key.horizontalPositioningLandscape = RealmKeyboardHorizontalPositioning()
        
        switch type {
        case .none:
            key.horizontalPositioningPortrait?.type = RealmKeyboardKeyPositioningType.Auto.rawValue
            key.horizontalPositioningPortrait?.value.value = 0.1
            
            key.horizontalPositioningLandscape?.type = RealmKeyboardKeyPositioningType.Auto.rawValue
            key.horizontalPositioningLandscape?.value.value = 0.079
            
        case .space:
            key.type = KKeyType.space.rawValue
            key.horizontalPositioningPortrait?.type = RealmKeyboardKeyPositioningType.Rest.rawValue
            
            key.horizontalPositioningLandscape?.type = RealmKeyboardKeyPositioningType.Rest.rawValue
            
        case .shift:
            key.style = KKeyStyle.dark.rawValue
            key.shape = KKeyShape.shift.rawValue
            key.type = KKeyType.shift.rawValue
            
            key.horizontalPositioningPortrait?.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
            key.horizontalPositioningPortrait?.value.value = 48
            key.horizontalPositioningPortrait?.emptyRight = 0.25
            
            key.horizontalPositioningLandscape?.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
            key.horizontalPositioningLandscape?.value.value = 68
            key.horizontalPositioningLandscape?.emptyRight = 0.25
            
        case .shiftNumbers:
            key.style = KKeyStyle.dark.rawValue
            key.type = KKeyType.shiftNumbers.rawValue
            key.input = "#+="
            key.shiftInput = "123"
            
            key.horizontalPositioningPortrait?.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
            key.horizontalPositioningPortrait?.value.value = 48
            key.horizontalPositioningPortrait?.emptyRight = 0.25
            
            key.horizontalPositioningLandscape?.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
            key.horizontalPositioningLandscape?.value.value = 68
            key.horizontalPositioningLandscape?.emptyRight = 0.25
            
        case .delete:
            key.style = KKeyStyle.dark.rawValue
            key.type = KKeyType.delete.rawValue
            
            key.horizontalPositioningPortrait?.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
            key.horizontalPositioningPortrait?.value.value = 48
            key.horizontalPositioningPortrait?.emptyLeft = 0.25
            
            key.horizontalPositioningLandscape?.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
            key.horizontalPositioningLandscape?.value.value = 68
            key.horizontalPositioningLandscape?.emptyLeft = 0.25
            
        case .language:
            key.style = KKeyStyle.dark.rawValue
            key.type = KKeyType.language.rawValue
            
            key.horizontalPositioningPortrait?.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
            key.horizontalPositioningPortrait?.value.value = 46.5
            
            key.horizontalPositioningLandscape?.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
            key.horizontalPositioningLandscape?.value.value = 52
            
        case .numbers:
            key.style = KKeyStyle.dark.rawValue
            key.type = KKeyType.numbers.rawValue
            
            key.horizontalPositioningPortrait?.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
            key.horizontalPositioningPortrait?.value.value = 46.5
            
            key.horizontalPositioningLandscape?.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
            key.horizontalPositioningLandscape?.value.value = 52
            
        case .returnn:
            key.style = KKeyStyle.blue.rawValue
            key.type = KKeyType.returnn.rawValue
            
            key.horizontalPositioningPortrait?.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
            key.horizontalPositioningPortrait?.value.value = 93.5
            
            key.horizontalPositioningLandscape?.type = RealmKeyboardKeyPositioningType.Fixed.rawValue
            key.horizontalPositioningLandscape?.value.value = 104
            
        default:
            break
        }
        
        return key
    }
}
