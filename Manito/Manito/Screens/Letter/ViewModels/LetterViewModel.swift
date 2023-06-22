//
//  LetterViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/20.
//

import Combine
import Foundation

final class LetterViewModel: ViewModelType {

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
        let messages: PassthroughSubject<[Message], NetworkError>
        let index: CurrentValueSubject<Int, Never>
        let messageDetails: AnyPublisher<MessageDetails, Never>
        let reportDetails: AnyPublisher<ReportDetails, Never>
        let roomState: AnyPublisher<RoomState, Never>
    }

    // MARK: - property

    private let messageSubject: PassthroughSubject<[Message], NetworkError> = PassthroughSubject()
    private lazy var indexSubject: CurrentValueSubject<Int, Never> = CurrentValueSubject(self.messageType.rawValue)

    private var cancelBag: Set<AnyCancellable> = Set()

    private let service: LetterServicable
    private var messageDetails: MessageDetails
    private let roomState: RoomState
    private let messageType: MessageType

    // MARK: - init

    init(service: LetterServicable,
         roomId: String,
         mission: String,
         missionId: String,
         roomState: String,
         messageType: MessageType) {
        self.service = service
        self.messageDetails = MessageDetails(roomId, mission, missionId, "")
        self.roomState = RoomState(rawValue: roomState)!
        self.messageType = messageType
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        let viewDidLoadType = input.viewDidLoad
            .map { [weak self] in self?.messageType }
            .map { $0! }

        let segmentValueType = input.segmentControlValueChanged
            .map { MessageType(rawValue: $0) }
            .map { $0! }

        let refreshWithType = input.refresh
            .map { MessageType.sent }

        Publishers.Merge3(viewDidLoadType, segmentValueType, refreshWithType)
            .sink(receiveValue: { [weak self] type in
                self?.fetchMessages(with: type)
                self?.sendCurrentIndex(at: type)
            })
            .store(in: &self.cancelBag)

        let messagePublisher = input.sendLetterButtonDidTap
            .map { [weak self] _ -> MessageDetails in
                self?.loadMessageDetails()
                return (self?.messageDetails)!
            }
            .eraseToAnyPublisher()

        let reportPublisher = input.reportButtonDidTap
            .map { [weak self] content -> ReportDetails in
                self?.service.loadNickname()
                return ((self?.service.nickname)!, content)
            }
            .eraseToAnyPublisher()

        let roomStatePublisher = input.viewDidLoad
            .map { [weak self] in (self?.roomState)! }
            .eraseToAnyPublisher()

        return Output(
            messages: self.messageSubject,
            index: self.indexSubject,
            messageDetails: messagePublisher,
            reportDetails: reportPublisher,
            roomState: roomStatePublisher
        )
    }

    // MARK: - Private - func

    private func sendCurrentIndex(at type: MessageType) {
        let currentIndex = self.currentIndex(at: type)
        self.indexSubject.send(currentIndex)
    }

    private func fetchMessages(with type: MessageType) {
        let roomId = self.messageDetails.roomId

        switch type {
        case .sent: self.fetchSendMessages(roomId: roomId)
        case .received: self.fetchReceivedMessages(roomId: roomId)
        }
    }
}

// MARK: - Helper
extension LetterViewModel {
    private func currentIndex(at type: MessageType) -> Int {
        return type.rawValue
    }

    private func fetchSendMessages(roomId: String) {
        Task {
            do {
                let messages = try await self.service.fetchSendLetter(roomId: roomId)
                let modifiedMessages = self.messageWithReportState(in: messages)
                self.messageSubject.send(modifiedMessages)
            } catch(let error) {
                guard let error = error as? NetworkError else { return }
                self.messageSubject.send(completion: .failure(error))
            }
        }
    }

    private func fetchReceivedMessages(roomId: String) {
        Task {
            do {
                let messages = try await self.service.fetchReceiveLetter(roomId: roomId)
                let modifiedMessages = self.messageWithReportState(in: messages)
                self.messageSubject.send(modifiedMessages)
            } catch(let error) {
                guard let error = error as? NetworkError else { return }
                self.messageSubject.send(completion: .failure(error))
            }
        }
    }

    private func loadMessageDetails() {
        guard let manitteeId = self.service.manitteeId else { return }
        self.messageDetails.manitteeId = manitteeId
    }

    private func messageWithReportState(in messages: [Message]) -> [Message] {
        if let messageType = MessageType(rawValue: self.indexSubject.value) {
            let canReport = messageType == .received
            return messages.map { item in
                var item = item
                item.canReport = canReport
                return item
            }
        }

        return []
    }
}
