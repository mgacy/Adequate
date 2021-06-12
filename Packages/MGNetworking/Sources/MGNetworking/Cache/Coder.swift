//
//  Coder.swift
//  
//
//  Created by Mathew Gacy on 12/26/20.
//

import UIKit

public struct ImageError: Error {
    public init() {}
}

public struct Coder<T> {
    let encode: ((T) throws -> Data)
    let decode: ((Data) throws -> T)
}

public extension Coder {

    static func makeImageCoder() -> Coder<UIImage> {
        return Coder<UIImage>(
            encode: { image in
                guard let data = image.pngData() else {
                    throw ImageError()
                }
                return data
            },
            decode: { data in
                guard let image = UIImage(data: data) else {
                    throw ImageError()
                }
                return image
            }
        )
    }
}
