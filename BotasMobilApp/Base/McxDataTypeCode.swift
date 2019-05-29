//
//  McxDataType.swift
//  BotasMobilApp
//
//  Created by Admin on 30.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
enum McxDataTypeCode {
    /// <summary>
    /// A simple type representing Boolean values of true or false.
    /// </summary>
    
    case Boolean
    
    /// <summary>
    /// An 8-bit signed integer ranging in value -127 to 127.
    /// </summary>
    
    case Byte
    
    /// <summary>
    /// An integral type representing signed 16-bit integers with values between -32768 and 32767.
    /// </summary>
    
    case Int16
    
    /// <summary>
    /// An integral type representing signed 32-bit integers with values between -2147483648 and 2147483647.
    /// </summary>
    
    case Int32
    
    /// <summary>
    /// An integral type representing signed 64-bit integers with values between -9223372036854775808 and 9223372036854775807.
    /// </summary>
    
    case Int64
    
    /// <summary>
    /// Unsigned 16-bit integer, 0 to 65,535
    /// </summary>
    
    case UInt16
    
    /// <summary>
    /// Unsigned 32-bit integer, 0 to 4,294,967,295
    /// </summary>
    
    case UInt32
    
    /// <summary>
    /// Unsigned 64-bit integer, 0 to 18,446,744,073,709,551,615
    /// </summary>
    
    case UInt64
    
    /// <summary>
    /// A floating point type representing values ranging from approximately 1.5 x 10e-45 to 3.4 x 10e38 with a precision of 7 digits.
    /// </summary>
    
    case Float
    
    /// <summary>
    /// A floating point type representing values ranging from approximately 5.0 x 10e-324 to 1.7 x 10e308 with a precision of 15-16 digits.
    /// </summary>
    
    case Double
    
    /// <summary>
    /// The decimal keyword indicates a 128-bit data type, (-7.9 x 1028 to 7.9 x 1028) / (100 to 28)
    /// </summary>
    
    case Decimal
    
    /// <summary>
    /// A type representing Unicode character strings.
    /// </summary>
    
    case String
    
    /// <summary>
    /// A type representing a date and time value.
    /// </summary>
    
    case DateTime
    
    /// <summary>
    /// A data type that contains 128 bit guid type.
    /// </summary>
    
    case Guid
    
    /// <summary>
    /// A data type that contains binary data with a maximum size of 4 gigabytes.
    /// </summary>
    
    case ByteArray
    
    /// <summary>
    /// An IMcxGeometry type object.
    /// </summary>
    
    case Geometry
    
    /// <summary>
    /// An IMcxSymbolizer type object.
    /// </summary>
    
    case Symbolizer
    
    /// <summary>
    /// An IMcxGeometry type object.
    /// </summary>
    
    case IMcxGeometry
    
    case IMcxSymbolizer
    
    case Object

    case Unknown
}
