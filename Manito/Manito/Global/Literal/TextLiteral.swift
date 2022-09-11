//
//  TextLiteral.swift
//  Manito
//
//  Created by LeeSungHo on 2022/08/22.
//

import Foundation

enum TextLiteral {
    
    // MARK: - AnyWhere
    static let done: String = "완료"
    static let cancel: String = "취소"
    static let doing: String = "진행중"
    static let waiting: String = "대기중"
    static let confirm: String = "확인"
    static let choose: String = "선택"
    static let enterRoom: String = "방 참가하기"
    static let searchRoom: String = "방 조회하기"
    static let during: String = "진행 기간"
    static let delete: String = "삭제"
    static let leave: String = "나가기"
    static let togetherFriend: String = "함께하는 친구들"
    static let copyCode: String = "방 코드 복사"
    static let change: String = "변경"
    static let modifiedRoomInfo: String = "방 정보 수정"
    static let maxMessage: String = "최대 7일까지 선택가능해요"
    static let destructive: String = "변경 사항 폐기"
    static let per: String = "인"
    static let minMember: String = "5인"
    static let maxMember: String = "15인"
    static let x: String = "X"
    static let createRoom: String = "방 생성하기"
    static let next: String = "다음"
    static let previous: String = "이전"
    
    // MARK: - SettingDeveloperInfo
    static let settingDeveloperInfoTitle: String = "개발자 정보"
    
    // MARK: - SettingViewController
    static let settingViewControllerChangeNickNameTitle: String = "닉네임 변경하기"
    static let settingViewControllerPersonalInfomationTitle: String = "개인정보 처리방침"
    static let settingViewControllerTermsOfServiceTitle: String = "이용 약관"
    static let settingViewControllerDeveloperInfoTitle: String = "개발자 정보"
    static let settingViewControllerHelpTitle: String = "문의하기"
    static let settingViewControllerLogoutTitle: String = "로그아웃"
    
    // MARK: - CreateNickNameViewController
    static let createNickNameViewControllerTitle: String = "닉네임 설정"
    static let createNickNameViewControllerAskNickName: String = "닉네임을 적어주세요"
    
    // MARK: - CommonMissonView
    static let commonMissionViewTitle: String = "오늘의 공통미션"
    
    // MARK: - ManitoRoomCollectionViewCell
    static let manitoRoomCollectionViewCellRoomLabelTitle: String = "마니또"
    
    // MARK: - CreateRoomCollectionViewCell
    static let createRoomCollectionViewCellMenuLabel: String = "새로운 마니또 시작"
    
    // MARK: - MainViewController
    static let mainViewControllerMenuTitle: String = "참여중인 애니또"
    static let mainViewControllerGuideTitle: String = "공통 미션이란?"
    static let mainViewControllerGuideDescription: String = "공통 미션이란?\n매일 매일 업데이트되는 미션!\n두근두근 미션을 수행해보세요!"
    static let mainViewControllerNewRoomAlert: String = "새로운 마니또 시작"

    
    
    // MARK: - OpenManittoViewController
    static let openManittoViewController: String = "당신의 마니또는?"
    
    // MARK: - OpenManittoPopupViewController
    static let openManittoPopupViewControllerOpenMentLabel: String = """
        함께 했던 추억이 열렸습니다.
        마니또 방에서 확인해보세요!
        """

    // MARK: - ChooseCharacterViewController
    static let chooseCharacterViewControllerTitleLabel: String = "캐릭터 선택"
    static let chooseCharacterViewControllerSubTitleLabel: String = "당신만의 캐릭터를 정해주세요"
    
    // MARK: - CheckRoomViewController
    static let checkRoomViewControllerQuestionLabel: String = "이 방으로 입장할까요?"
    static let checkRoomViewControllerNoButtonLabel: String = "NO"
    static let checkRoomViewControllerYesBUttonLabel: String = "YES"
    static let checkRoomViewControllerErrorAlertTitle: String = "해당하는 애니또 방이 없어요"
    static let checkRoomViewControllerErrorAlertMessage: String = "이미 참여중인 방이거나,\n 초대 코드를 확인해 주세요"
    
    // MARK: - InputInvitedCodeView
    static let inputInvitedCodeViewRoomCodeText: String = "초대코드 입력"
    
    // MARK: - LetterHeaderView
    static let letterHeaderViewSegmentControlManitti: String = "마니띠에게"
    static let letterHeaderViewSegmentControlManitto: String = "마니또로부터"
    
    // MARK: - SendLetterView
    static let sendLetterViewSendLetterButton: String = "쪽지 쓰기"
    
    // MARK: - IndividualMissionView
    static let individualMissionViewTitleLabel: String = "오늘의 개별 미션"
    
    // MARK: - LetterTextView
    static let letterTextViewTitleLabel: String = "쪽지 작성"
    
    // MARK: - LetterPhotoView
    static let letterPhotoViewTitleLabel: String = "사진 추가"
    static let letterPhotoViewTakePhoto: String = "사진 쵤영"
    static let letterPhotoViewChoosePhoto: String = "사진 보관함에서 선택"
    static let letterPhotoViewDeletePhoto: String = "사진 지우기"
    static let letterPhotoViewChoosePhotoToManitto: String = "마니또에게 보낼 사진 선택"
    static let letterPhotoViewSetting: String = "설정"
    static let letterPhotoViewFail: String = "사진을 불러올 수 없습니다."
    
    // MARK: - LetterViewController
    static let letterViewControllerTitle = "쪽지함"
    static let letterViewControllerGuideTitle = "쪽지 쓰기는?"
    static let letterViewControllerGuideText = "쪽지 쓰기는?\n보낸 쪽지함에서 쓰기가 가능해요!\n받은 쪽지함은 확인만 할 수 있어요."
    
    // MARK: - CreateLetterViewController
    static let createLetterViewControllerSendButton: String = "보내기"
    static let createLetterViewControllerTitle: String = "쪽지 작성하기"

    
    // MARK: - DetailIngViewController
    static let detailIngViewControllerManitoOpenButton: String = "마니또 공개"
    static let detailIngViewControllerGuideTitle: String = "개별 미션이란?"
    static let detailIngViewControllerText: String = "개별 미션이란?\n나의 마니띠에게 전하는\n둘만의 미션을 확인할 수 있어요!"
    static let detailIngViewControllerDoneMissionText: String = "종료된 마니또예요"
    
    // MARK: - CalendarView
    static let calendarViewAlertMaxTitle: String = "최대 선택 기간을 넘었어요"
    
    static let calendarViewAlertPastTitle: String = "지난 날을 선택하셨어요"
    static let calendarViewAlertPastMessage: String = "오늘보다 이전 날짜는 \n 선택하실 수 없어요"
    
    // MARK: - DatailWaitViewController
    static let datailWaitViewControllerDeleteTitle: String = "방을 삭제하실 건가요?"
    static let datailWaitViewControllerExitTitle: String = "정말 나가실거예요?"
    static let datailWaitViewControllerDeleteMessage: String = "방을 삭제하시면 다시 되돌릴 수 없습니다."
    static let datailWaitViewControllerExitMessage: String = "초대코드를 입력하면 \n 다시 들어올 수 있어요."
    static let datailWaitViewControllerButtonWaitingText: String = "시작을 기다리는 중..."
    static let datailWaitViewControllerButtonStartText: String = "마니또 시작"
    
    static let detailWaitViewControllerDeleteRoom: String = "방 삭제"
    static let detailWaitViewControllerLeaveRoom: String = "방 나가기"
    static let detailWaitViewControllerCode: String = "초대코드"
    static let detailWaitViewControllerCopyCode: String = "코드 복사 완료!"
    static let detailWaitViewControllerPastAlertTitle: String = "마니또 시작일이 지났어요"
    static let detailWaitViewControllerPastAlertMessage: String = "방장이 진행기간을 재설정 \n 할 때까지 기다려주세요."
    static let detailWaitViewControllerPastOwnerAlertMessage: String = "진행기간을 재설정 해주세요"
    
    // MARK: - DetailEditViewController
    static let detailEditViewControllerStartSetting: String = "진행기간 설정"
    static let detailEditViewControllerSetMember: String = "인원 설정"
    static let detailEditViewControllerChangeRoomInfoAlertTitle: String = "인원을 다시 설정해 주세요"
    static let detailEditViewControllerChangeRoomInfoAlertMessage: String = "현재 인원보다 최대 인원을 \n더 적게 설정할 수 없어요."
    
    // MARK: - InputNameView
    static let inputNameViewRoomNameText: String = "방 이름을 적어주세요"
    
    // MARK: - InputPersonView
    static let inputPersonViewTitle: String = "최대 참여 인원을 설정해 주세요"
    
    // MARK: - InputDateView
    static let inputDateViewTitle: String = "진행 기간을 설정해 주세요"
    
    // MARK: - UserDefault+Extension
    static let userNickname: String = "UserNickname"

    // MARK: - ChangeNickNameViewController
    static let changeNickNameViewControllerTitle: String = "닉네임 변경하기"
    
    // MARK: - InvitedCodeViewController
    static let invitedCodeViewCOntroller: String = "글자를 탭하여 코드를 복사하세요"
}
