//
//  MemoryViewController.swift
//  Manito
//
//  Created by 최성희 on 2022/06/14.
//

import UIKit

final class MemoryViewController: BaseViewController {
    
    private enum MemoryType: Int {
        case manittee = 0
        case manitto = 1
    }
    
    // MARK: - properties
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.icShare, for: .normal)
        return button
    }()
    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [TextLiteral.letterHeaderViewSegmentControlManitti, TextLiteral.letterHeaderViewSegmentControlManitto])
        let font = UIFont.font(.regular, ofSize: 14)
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, .font: font]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: font]
        
        control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        control.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        control.selectedSegmentTintColor = .white
        control.backgroundColor = .darkGrey004
        control.addTarget(self, action: #selector(changedIndexValue(_:)), for: .valueChanged)
        
        return control
    }()
    
    private var detailDoneService: DetailDoneAPI = DetailDoneAPI(apiService: APIService())
    private var memoryType: MemoryType = .manittee {
        willSet {
            setupData(with: newValue)
        }
    }
    private var memory: Memory?
    private var roomId: String
    
    // MARK: - init
    
    init(roomId: String) {
        self.roomId = roomId
        super.init()
        requestMemory(roomId: roomId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
   }
    
    override func render() {
        
    }
    
    // MARK: - func
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let shareButton = makeBarButtonItem(with: shareButton)
        
        navigationItem.rightBarButtonItem = shareButton
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .automatic
        title = TextLiteral.memoryViewControllerTitleLabel
    }
    
    private func setupSegmentControl() {
        let font = UIFont.font(.regular, ofSize: 14)
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, .font: font]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: font]
 
//        memoryControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
//        memoryControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
//        memoryControl.selectedSegmentTintColor = .white
//        memoryControl.backgroundColor = .darkGrey004
//        memoryControl.addTarget(self, action: #selector(changedIndexValue(_:)), for: .valueChanged)
    }
    
    private func setupFont() {
//        memoryManitoLabel.font = .font(.regular, ofSize: 15)
//        fromManitiSecondLabel.font = .font(.regular, ofSize: 14)
//        fromManitiForthLabel.font = .font(.regular, ofSize: 14)
//        manitiNickLabel.font = .font(.regular, ofSize: 30)
    }
    
    private func setupViewLayer() {
//        fromManitiFirstView.makeBorderLayer(color: .white)
//        fromManitiSecondView.makeBorderLayer(color: .white)
//        fromManitiThirdView.makeBorderLayer(color: .white)
//        fromManitiForthView.makeBorderLayer(color: .white)
//        manitiIconBackView.layer.cornerRadius = 50
//        manitiIconView.layer.cornerRadius = 50
    }
    
    // MARK: - network
    
    private func setupData(with state: MemoryType) {
        switch state {
        case .manittee:
            dump(memory?.memoriesWithManittee)
        case .manitto:
            dump(memory?.memoriesWithManittee)
        }
    }
    
    private func requestMemory(roomId: String) {
        Task {
            do {
                let data = try await detailDoneService.requestMemory(roomId: roomId)
                if let memory = data {
                    self.memory = memory
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
            }
        }
    }
    
    // MARK: - selector
    
    @objc
    private func changedIndexValue(_ sender: UISegmentedControl) {
//        memoryControl.selectedSegmentIndex = sender.selectedSegmentIndex
//        memoryType = MemoryType(rawValue: sender.selectedSegmentIndex) ?? .manittee
    }
}
