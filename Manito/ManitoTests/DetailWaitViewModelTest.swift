//
//  DetailWaitViewModelTest.swift
//  ManitoTests
//
//  Created by Mingwan Choi on 2023/06/06.
//

import XCTest
@testable import Manito


final class DetailWaitViewModelTest: XCTestCase {
    
    private let viewModel = DetailWaitViewModel(roomIndex: 1, detailWaitService: DetailWaitAPI(apiService: APIService()))
    
    func testExistFetchRoomInformation() {
        let _ = viewModel.fetchRoomInformation()
    }
}
