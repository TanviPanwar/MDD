//
//  MimeType.swift
//  MDD
//
//  Created by iOS6 on 06/08/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import Foundation

let DEFAULT_MIME_TYPE = "application/octet-stream"
let mimeTypes = [
    "xml": "text/xml",
    "gif": "image/gif",
    "jpeg": "image/jpeg",
    "JPEG": "image/jpeg",
    "jpg": "image/jpeg",
    "JPG": "image/jpeg",
    "png": "image/png",
    "PNG": "image/png",
    "doc": "application/msword",
   // "doc": "application/msword",
    "pdf": "application/pdf",
    "xls": "application/vnd.ms-excel",
    "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "xlr": "application/vnd.ms-works",
]

public struct MimeType {
    let ext: String?
    public var value: String {
        guard let ext = ext else {
            return DEFAULT_MIME_TYPE
        }
        return mimeTypes[ext.lowercased()] ?? DEFAULT_MIME_TYPE
    }
    public init(path: String) {
        ext = NSString(string: path).pathExtension
    }
    
    public init(path: NSString) {
        ext = path.pathExtension
    }
    
    public init(url: URL) {
        ext = url.pathExtension
    }
}
