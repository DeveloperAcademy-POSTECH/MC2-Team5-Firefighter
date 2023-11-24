//
//  OpenManittoViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/18/23.
//

import Combine
import Foundation

final class OpenManittoViewModel: BaseViewModelType {

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let openManitto: AnyPublisher<Void, Never>
    }

    struct Output {
        let memberInfo: AnyPublisher<Result<[MemberInfo], Error>, Never>
        let randomIndex: AnyPublisher<Int, Never>
        let manittoIndex: AnyPublisher<Int, Never>
        let popupText: AnyPublisher<String, Never>
    }

    // MARK: - property

    private var cancelBag: Set<AnyCancellable> = Set()
    
    private var currentIndex: Int = 0

    private let usecase: OpenManittoUsecase
    private let roomId: String
    private let manittoNickname: String

    // MARK: - init

    init(usecase: OpenManittoUsecase,
         roomId: String,
         manittoNickname: String) {
        self.usecase = usecase
        self.roomId = roomId
        self.manittoNickname = manittoNickname
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        let memberInfo = input.viewDidLoad
            .compactMap { [weak self] in return self }
            .asyncMap { await $0.fetchMemberInfo() }
            .eraseToAnyPublisher()
        
        let timerPublisher = Timer.publish(every: 0.3, on: .main, in: .default)
            .autoconnect()
        
        let randomIndex = Publishers.CombineLatest(memberInfo, timerPublisher)
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.global())
            .map { result, _ -> [MemberInfo] in
                switch result {
                case .success(let list): return list
                case .failure: return []
                }
            }
            .prefix(10)
            .compactMap { [weak self] in self?.randomIndex(in: $0.count) }
            .eraseToAnyPublisher()
        
        let manittoIndex = Publishers.CombineLatest(memberInfo, input.openManitto)
            .delay(for: .seconds(1), scheduler: DispatchQueue.global())
            .compactMap { [weak self] result, _ -> Int? in
                switch result {
                case .success(let list): return self?.manittoIndex(in: list)
                case .failure: return nil
                }
            }
            .eraseToAnyPublisher()
        
        let popupText = input.openManitto
            .compactMap { [weak self] in self?.manittoPopupText() }
            .eraseToAnyPublisher()

        return Output(
            memberInfo: memberInfo,
            randomIndex: randomIndex, 
            manittoIndex: manittoIndex,
            popupText: popupText
        )
    }

    // MARK: - Private - func

    private func fetchMemberInfo() async -> Result<[MemberInfo], Error> {
        do {
            let list = try await self.usecase.fetchFriendList(roomId: self.roomId)
            let memberInfo = list.members
            return .success(memberInfo)
        } catch(let error) {
            return .failure(error)
        }
    }
    
    private func randomIndex(in count: Int) -> Int {
        let randomIndex = Int.random(in: 0...count-1, excluding: self.currentIndex)
        self.currentIndex = randomIndex
        return randomIndex
    }
    
    private func manittoIndex(in list: [MemberInfo]) -> Int? {
        return list.firstIndex(where: { $0.nickname == self.manittoNickname })
    }
    
    private func manittoPopupText() -> String {
        let userNickname = self.usecase.loadNickname()
        return TextLiteral.DetailIng.openManittoPopupContent.localized(with: userNickname, self.manittoNickname)
    }
}
