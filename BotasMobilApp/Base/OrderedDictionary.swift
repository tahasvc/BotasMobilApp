//
//  OrderedDictionary.swift
//  BotasMobilApp
//
//  Created by Admin on 2.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import Darwin.mmap
struct OrderedDictionary<KeyType:Hashable, ValueType> {
    private var _dictionary:Dictionary<KeyType, ValueType>
    private var _keys:Array<KeyType>
    
    init() {
        _dictionary = [:]
        _keys = []
    }
    
    init(minimumCapacity:Int) {
        _dictionary = Dictionary<KeyType, ValueType>(minimumCapacity:minimumCapacity)
        _keys = Array<KeyType>()
    }
    
    init(_ dictionary:Dictionary<KeyType, ValueType>) {
        _dictionary = dictionary
        _keys = map(dictionary.keys) { $0 }
    }
    
    subscript(key:KeyType) -> ValueType? {
        get {
            return _dictionary[key]
        }
        set {
            if newValue == nil {
                self.removeValueForKey(key)
            }
            else {
                self.updateValue(newValue!, forKey: key)
            }
        }
    }
    
    mutating func updateValue(value:ValueType, forKey key:KeyType) -> ValueType? {
        let oldValue = _dictionary.updateValue(value, forKey: key)
        if oldValue == nil {
            _keys.append(key)
        }
        return oldValue
    }
    
    mutating func removeValueForKey(key:KeyType) {
        _keys = _keys.filter { $0 != key }
        _dictionary.removeValueForKey(key)
    }
    
    mutating func removeAll(keepCapacity:Int) {
        _keys = []
        _dictionary = Dictionary<KeyType,ValueType>(minimumCapacity: keepCapacity)
    }
    
    var count: Int { get { return _dictionary.count } }
    
    // keys isn't lazy evaluated because it's just an array anyway
    var keys:[KeyType] { get { return _keys } }
    
    // values is lazy evaluated because of the dictionary lookup and creating a new array
    var values:GeneratorOf<ValueType> {
        get {
            var index = 0
            return GeneratorOf<ValueType> {
                if index >= self._keys.count {
                    return nil
                }
                else {
                    let key = self._keys[index]
                    index++
                    return self._dictionary[key]
                }
            }
        }
    }
}

extension OrderedDictionary : SequenceType {
    func generate() -> GeneratorOf<(KeyType, ValueType)> {
        var index = 0
        return GeneratorOf<(KeyType, ValueType)> {
            if index >= self._keys.count {
                return nil
            }
            else {
                let key = self._keys[index]
                index++
                return (key, self._dictionary[key]!)
            }
        }
    }
}

func ==<Key: Equatable, Value: Equatable>(lhs: OrderedDictionary<Key, Value>, rhs: OrderedDictionary<Key, Value>) -> Bool {
    return lhs._keys == rhs._keys && lhs._dictionary == rhs._dictionary
}

func !=<Key: Equatable, Value: Equatable>(lhs: OrderedDictionary<Key, Value>, rhs: OrderedDictionary<Key, Value>) -> Bool {
    return lhs._keys != rhs._keys || lhs._dictionary != rhs._dictionary
}
