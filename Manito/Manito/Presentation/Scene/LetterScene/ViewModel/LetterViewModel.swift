//
//  LetterViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/20.
//

import Combine
import Foundation

final class LetterViewModel: BaseViewModelType {

    typealias MessageDetail = (roomId: String, mission: String, missionId: String, manitteeId: String)
    typealias ReportDetail = (nickname: String, content: String)

    enum MessageType: Int {
        case sent = 0
        case received = 1
    }

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let segmentControlValueChanged: PassthroughSubject<Int, Never>
        let refresh: PassthroughSubject<Void, Never>
        let sendLetterButtonDidTap: AnyPublisher<Void, Never>
        let reportButtonDidTap: PassthroughSubject<String, Never>
    }

    struct Output {
        let messages: AnyPublisher<Result<[MessageListItem], Error>, Never>
        let index: AnyPublisher<Int, Never>
        let messageDetails: AnyPublisher<MessageDetail, Never>
        let reportDetails: AnyPublisher<ReportDetail, Never>
        let roomStatus: AnyPublisher<RoomStatus, Never>
    }

    // MARK: - property

    private var cancelBag: Set<AnyCancellable> = Set()

    private let usecase: LetterUsecase
    private var messageDetail: MessageDetail
    private let roomStatus: RoomStatus
    private let messageType: MessageType

    // MARK: - init

    init(usecase: LetterUsecase,
         roomId: String,
         mission: String,
         missionId: String,
         roomStatus: RoomStatus,
         messageType: MessageType) {
        self.usecase = usecase
        self.messageDetail = MessageDetail(roomId, mission, missionId, "")
        self.roomStatus = roomStatus
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
            .asyncMap { [weak self] type -> Result<[MessageListItem], Error> in
                do {
                    let messages = try await self?.fetchMessages(with: type)
                    return .success(messages ?? [])
                } catch (let error) {
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()

        let currentIndexPublisher = mergePublisher
            .compactMap { [weak self] type in
                self?.sendCurrentIndex(at: type)
            }
            .eraseToAnyPublisher()

        let messageDetailsPublisher = input.sendLetterButtonDidTap
            .map { [weak self] _ -> MessageDetail in
                self?.loadMessageDetail()
                return (self?.messageDetail)!
            }
            .eraseToAnyPublisher()

        let reportPublisher = input.reportButtonDidTap
            .map { [weak self] content -> ReportDetail in
                self?.usecase.loadNickname()
                return ((self?.usecase.nickname)!, content)
            }
            .eraseToAnyPublisher()

        let roomStatusPublisher = input.viewDidLoad
            .compactMap { [weak self] in self?.roomStatus }
            .eraseToAnyPublisher()

        return Output(
            messages: messagesPublisher,
            index: currentIndexPublisher,
            messageDetails: messageDetailsPublisher,
            reportDetails: reportPublisher,
            roomStatus: roomStatusPublisher
        )
    }

    // MARK: - Private - func

    private func sendCurrentIndex(at type: MessageType) -> Int {
        let currentIndex = self.currentIndex(at: type)
        return currentIndex
    }

    private func fetchMessages(with type: MessageType) async throws -> [MessageListItem] {
        let roomId = self.messageDetail.roomId

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
        return await self.insertReportState(type, in: messages)
    }

    private func fetchReceivedMessages(roomId: String, type: MessageType) async throws -> [MessageListItem] {
        let messages = try await self.usecase.fetchReceiveLetter(roomId: roomId)
        return await self.insertReportState(type, in: messages)
    }

    private func loadMessageDetail() {
        guard let manitteeId = self.usecase.manitteeId else { return }
        self.messageDetail.manitteeId = manitteeId
    }

    private func insertReportState(_ type: MessageType, in messages: [MessageListItemDTO]) async -> [MessageListItem] {
        var resultMessages: [MessageListItem] = []
        for message in messages {
            resultMessages.append(await message.toMessageListItem(canReport: (type == .received)))
        }
        return resultMessages
    }
}
