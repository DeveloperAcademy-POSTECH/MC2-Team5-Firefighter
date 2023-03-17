//
//  URLLiteral+Path.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/16.
//

import Foundation

extension URLLiteral {

    // MARK: - main path

//    enum Main: String, RawRepresentable {
//        case fetchCommonMission =
//        case fetchManittoList =
//    }

    // MARK: - detailWait path

//    enum DetailWait: URLRepresentable {
//        case fetchWithFriend(roomId: String)
//        case fetchWaitingRoomInfo(roomId: String)
//        case patchStartManitto(roomId: String)
//        case putRoomInfo(roomId: String)
//        case deleteRoom(roomId: String)
//        case deleteLeaveRoom(roomId: String)
//
//        var rawValue: String {
//            switch self {
//            case .fetchWithFriend(roomId: let roomId):
//                return "/rooms/\(roomId)/participants"
//            case .fetchWaitingRoomInfo(roomId: let roomId):
//                return "/rooms/\(roomId)"
//            case .patchStartManitto(roomId: let roomId):
//                return "/rooms/\(roomId)/state"
//            case .putRoomInfo(roomId: let roomId):
//                return "/rooms/\(roomId)"
//            case .deleteRoom(roomId: let roomId):
//                return "/rooms/\(roomId)"
//            case .deleteLeaveRoom(roomId: let roomId):
//                return "/rooms/\(roomId)/participants"
//            }
//        }
//    }

    // MARK: - detailIng path

//    enum DetailIng: URLRepresentable {
//        case requestWithFriend(roomId: String)
//        case requestStartingRoomInfo(roomId: String)
//
//        var rawValue: String {
//            switch self {
//            case .requestWithFriend(roomId: let roomId):
//                return "/rooms/\(roomId)/participants"
//            case .requestStartingRoomInfo(roomId: let roomId):
//                return "/rooms/\(roomId)"
//            }
//        }
//    }

    // MARK: - detailDone path

//    enum DetailDone: URLRepresentable {
//        case requestWithFriend(roomId: String)
//        case requestMemory(roomId: String)
//        case requestDoneRoomInfo(roomId: String)
//        case requestExitRoom(roomId: String)
//        case requestDeleteRoom(roomId: String)
//
//        var rawValue: String {
//            switch self {
//            case .requestWithFriend(roomId: let roomId):
//                return "/rooms/\(roomId)/participants"
//            case .requestMemory(roomId: let roomId):
//                return "/rooms/\(roomId)/memories"
//            case .requestDoneRoomInfo(roomId: let roomId):
//                return "/rooms/\(roomId)"
//            case .requestExitRoom(roomId: let roomId):
//                return "/rooms/\(roomId)/participants"
//            case .requestDeleteRoom(roomId: let roomId):
//                return "/rooms/\(roomId)"
//            }
//        }
//    }

    // MARK: - RoomParticipation path

//    enum RoomParticipation: URLRepresentable {
//        case dispatchCreateRoom
//        case fetchVerifyCode
//        case dispatchJoinRoom(roomId: String)
//
//        var rawValue: String {
//            switch self {
//            case .dispatchCreateRoom:
//                return "/rooms"
//            case .fetchVerifyCode:
//                return "/invitations/verification"
//            case .dispatchJoinRoom(roomId: let roomId):
//                return "/rooms/\(roomId)/participants"
//            }
//        }
//    }
}
