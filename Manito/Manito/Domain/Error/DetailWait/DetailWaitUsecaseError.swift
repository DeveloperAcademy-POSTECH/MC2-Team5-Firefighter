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
        case .failedToFetchError: return TextLiteral.DetailWait.Error.fetchRoom.localized()
        case .failedToStartError: return TextLiteral.DetailWait.Error.startManitto.localized()
        case .failedToDeleteRoomError: return TextLiteral.DetailWait.Error.deleteRoom.localized()
        case .failedToLeaveRoomError: return TextLiteral.DetailWait.Error.leaveRoom.localized()
        }
    }
}
