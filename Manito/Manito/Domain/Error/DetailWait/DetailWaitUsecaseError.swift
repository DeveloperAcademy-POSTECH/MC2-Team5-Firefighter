//
//  DetailWaitUsecaseError.swift
//  Manito
//
//  Created by Mingwan Choi on 10/13/23.
//

import Foundation

enum DetailWaitUsecaseError: LocalizedError {
    case failedToFetchError
    case failedToStartError
    case failedToDeleteRoomError
    case failedToLeaveRoomError
}

extension DetailWaitUsecaseError {
    var errorDescription: String? {
        switch self {
        case .failedToFetchError:
            return ""
            
        case .failedToStartError:
            return ""
            
        case .failedToDeleteRoomError:
            return ""
            
        case .failedToLeaveRoomError:
            return ""
        }
    }
}
