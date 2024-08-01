//
//  Logger.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 7/31/24.
//

import Foundation
import os.log

class Logger: NSObject {
    
    enum LogType {
        case info
        case warning
        case error
    }
    
    // Log 출력 (print 사용)
    static func log(fileName: String = #file, funcName: String = #function, _ log: String? = nil) {
#if DEBUG
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy.MM.dd HH:mm:ss.SSS"
        if let log {
            print(dateFormat.string(from: Date()) + " " + (fileName as NSString).lastPathComponent + " " + funcName + " " + log)
        } else {
            print(dateFormat.string(from: Date()) + " " + (fileName as NSString).lastPathComponent + " " + funcName)
        }
#endif
    }
    
    static func slog(_ logger: os.Logger, type: LogType, message: String? = nil) {
        guard let message else { return }
#if DEBUG
        switch type {
        case .info:
            logger.info("\(message)")
        case .warning:
            logger.warning("\(message)")
        case .error:
            logger.error("\(message)")
        }
#endif
    }
    
    static func dummy() {}
}
