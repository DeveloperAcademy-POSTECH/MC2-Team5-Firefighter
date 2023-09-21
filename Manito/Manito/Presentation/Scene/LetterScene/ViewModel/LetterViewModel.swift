//
//  LetterViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/20.
//

import Combine
import Foundation

final class LetterViewModel: BaseViewModelType {

    typealias MessageDetails = (roomId: String, mission: String, missionId: String, manitteeId: String)
    typealias ReportDetails = (nickname: String, content: String)

    enum MessageType: Int {
        case sent = 0
        case received = 1
    }

    enum RoomState: String {
        case processing = "PROCESSING"
        case post = "POST"
    }

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let segmentControlValueChanged: PassthroughSubject<Int, Never>
        let refresh: PassthroughSubject<Void, Never>
        let sendLetterButtonDidTap: AnyPublisher<Void, Never>
        let reportButtonDidTap: PassthroughSubject<String, Never>
    }

    struct Output {
        let messages: AnyPublisher<[MessageListItem]?, Error>
        let index: AnyPublisher<Int, Never>
        let messageDetails: AnyPublisher<MessageDetails, Never>
        let reportDetails: AnyPublisher<ReportDetails, Never>
        let roomState: AnyPublisher<RoomState, Never>
    }

    // MARK: - property

    private var cancelBag: Set<AnyCancellable> = Set()

    private let usecase: LetterUsecase
    private var messageDetails: MessageDetails
    private let roomState: RoomState
    private let messageType: MessageType

    // MARK: - init

    init(usecase: LetterUsecase,
         roomId: String,
         mission: String,
         missionId: String,
         roomState: String,
         messageType: MessageType) {
        self.usecase = usecase
        self.messageDetails = MessageDetails(roomId, mission, missionId, "")
        self.roomState = RoomState(rawValue: roomState)!
        self.messageType = messageType
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        let viewDidLoadType = input.viewDidLoad
            .compactMap { [weak self] in self?.messageType }

        let segmentValueType = input.segmentControlValueChanged
            .compactMap { MessageType(rawValue: $0) }

        let refreshWithType = input.refresh
            .map { MessageType.sent }

        let mergePublisher = Publishers.Merge3(viewDidLoadType, segmentValueType, refreshWithType)

        let messagesPublisher = mergePublisher
            .asyncMap { [weak self] type in
                try await self?.fetchMessages(with: type)
            }
            .eraseToAnyPublisher()

        let currentIndexPublisher = mergePublisher
            .compactMap { [weak self] type in
                self?.sendCurrentIndex(at: type)
            }
            .eraseToAnyPublisher()

        let messageDetailsPublisher = input.sendLetterButtonDidTap
            .map { [weak self] _ -> MessageDetails in
                self?.loadMessageDetails()
                return (self?.messageDetails)!
            }
            .eraseToAnyPublisher()

        let reportPublisher = input.reportButtonDidTap
            .map { [weak self] content -> ReportDetails in
                self?.usecase.loadNickname()
                return ((self?.usecase.nickname)!, content)
            }
            .eraseToAnyPublisher()

        let roomStatePublisher = input.viewDidLoad
            .compactMap { [weak self] in self?.roomState }
            .eraseToAnyPublisher()

        return Output(
            messages: messagesPublisher,
            index: currentIndexPublisher,
            messageDetails: messageDetailsPublisher,
            reportDetails: reportPublisher,
            roomState: roomStatePublisher
        )
    }

    // MARK: - Private - func

    private func sendCurrentIndex(at type: MessageType) -> Int {
        let currentIndex = self.currentIndex(at: type)
        return currentIndex
    }

    private func fetchMessages(with type: MessageType) async throws -> [MessageListItem] {
        let roomId = self.messageDetails.roomId

        switch type {
        case .sent:
            return try await self.fetchSendMessages(roomId: roomId, type: type)
        case .received:
            return try await self.fetchReceivedMessages(roomId: roomId, type: type)
        }
    }
}

// MARK: - Helper
extension LetterViewModel {
    private func currentIndex(at type: MessageType) -> Int {
        return type.rawValue
    }

    private func fetchSendMessages(roomId: String, type: MessageType) async throws -> [MessageListItem] {
        let messages = try await self.usecase.fetchSendLetter(roomId: roomId)
        return self.insertReportState(type, in: messages)
    }

    private func fetchReceivedMessages(roomId: String, type: MessageType) async throws -> [MessageListItem] {
        let messages = try await self.usecase.fetchReceiveLetter(roomId: roomId)
        return self.insertReportState(type, in: messages)
    }

    private func loadMessageDetails() {
        guard let manitteeId = self.usecase.manitteeId else { return }
        self.messageDetails.manitteeId = manitteeId
    }

    private func insertReportState(_ type: MessageType, in messages: [MessageListItemDTO]) -> [MessageListItem] {
        return messages.map { $0.toMessageListItem(canReport: (type == .received)) }
    }
}
