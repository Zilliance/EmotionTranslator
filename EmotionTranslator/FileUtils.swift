//
//  FileUtils.swift
//  EmotionTranslator
//
//  Created by Ignacio Zunino on 19-09-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation
final class FileUtils {
    
    static var profileImagePath: URL {
        return FileUtils.getDocumentsDirectory().appendingPathComponent("profileImage.png")
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

}
