//
//  TextLiteral.swift
//  Manito
//
//  Created by LeeSungHo on 2022/08/22.
//

import Foundation

enum TextLiteral {

    /// 프로젝트 내부에서 공통으로 사용하는 텍스트
    enum Common {
        static let confirm = "common_confirm"
        static let cancel = "common_cancel"
        static let done = "common_done"
        static let processing = "common_processing"
        static let waiting = "common_waiting"
        static let enterRoom = "common_enter_room"
        static let searchRoom = "common_search_room"
        static let createRoom = "common_create_room"
        static let people = "common_people"
        static let xPeople = "common_x_people"
        static let discardChanges = "common_discard_changes"
        static let warningTitle = "common_warning_title"

        enum Calendar {
            static let maxDateContent = "common_calendar_max_date_content"
            static let maxAlertTitle = "common_calendar_max_alert_title"
            static let pastAlertTitle = "common_calendar_past_alert_title"
            static let pastAlertMessage = "common_calendar_past_alert_message"
        }

        enum Error {
            static let title = "common_error_title"
            static let networkServer = "common_network_server_error"
            static let networkAuthorized = "common_network_authorized_error"
        }
    }

    /// Main 화면에서 사용하는 텍스트
    enum Main {
        static let listTitle = "main_list_title"
        static let menuTitle = "main_menu_title"
        static let commonMissionTitle = "main_common_mission_title"
        static let cellCreateRoomTitle = "main_cell_create_room_title"
        static let guide = "main_guide"

        enum Error {
            static let title = "main_error_title"
            static let message = "main_error_message"
        }
    }

    /// Detail 화면에서 공통으로 사용하는 텍스트
    enum Detail {
        static let menuModifiedRoomInfo = "detail_menu_modified_room_info"
        static let togetherFriendTitle = "detail_together_friend_title"
        static let informationTitle = "detail_information_title"
        static let manitteeTitle = "detail_manittee_title"
        static let change = "detail_change"
    }

    /// Detail Wait 화면에서 사용하는 텍스트
    enum DetailWait {
        static let copyCode = "detail_wait_copy_code"
        static let buttonWaiting = "datail_wait_button_waiting"
        static let buttonStart = "datail_wait_button_start"
        static let menuDelete = "detail_wait_menu_delete"
        static let menuLeave = "detail_wait_menu_leave"
        static let delete = "detail_wait_delete"
        static let leave = "detail_wait_leave"
        static let toastCopyMessage = "detail_wait_toast_copy_message"
        static let toastEditMessage = "detail_wait_toast_edit_message"
        static let duringTitle = "detail_wait_during_title"
        static let pastAlertTitle = "detail_wait_past_alert_title"
        static let pastAlertMessage = "detail_wait_past_alert_message"
        static let pastAdminAlertMessage = "detail_wait_past_admin_alert_message"
        static let deleteAlertTitle = "datail_wait_delete_alert_title"
        static let deleteAlertMessage = "datail_wait_delete_alert_message"
        static let exitAlertTitle = "datail_wait_exit_alert_title"
        static let exitAlertMessage = "datail_wait_exit_alert_message"
    }

    /// Detail Ing 화면에서 사용하는 텍스트
    enum DetailIng {
        static let individualMissionTitle = "detail_ing_individual_mission_title"
        static let selectManitteeTitle = "detail_ing_select_manittee_title"
        static let openManittoTitle = "detail_ing_open_manitto_title"
        static let openManittoPopupContent = "detail_ing_open_manitto_popup_content"
        static let openManittoPopupHelperContent = "detail_ing_open_manitto_popup_helper_content"
        static let guide = "detail_ing_guide"
        static let buttonOpen = "detail_ing_button_open"
        static let missionMenuSetting = "detail_ing_mission_menu_setting"
        static let missionMenuReset = "detail_ing_mission_menu_reset"
        static let missionMenuTitle = "detail_ing_mission_menu_title"
        static let resetAlertTitle = "detail_ing_reset_alert_title"
        static let resetAlertMessage = "detail_ing_reset_alert_message"
        static let resetAlertOk = "detail_ing_reset_alert_ok"
        static let missionEditAlertTitle = "detail_ing_mission_edit_alert_title"
        static let missionEditAlertMessage = "detail_ing_mission_edit_alert_message"

        enum Error {
            static let resetMessage = "detail_ing_reset_error_message"
            static let missionEditMessage = "detail_ing_mission_edit_error_message"
            static let openManittoMessage = "detail_ing_open_manitto_error_message"
        }
    }

    /// Detail Done 화면에서 사용하는 텍스트
    enum DetailDone {
        static let mission = "detail_done_mission"
        static let exitAlertTitle = "detail_done_exit_alert_title"
        static let exitAlertMessage = "detail_done_exit_alert_message"
        static let exitAlertAdminTitle = "detail_done_exit_alert_admin_title"
        static let exitAlertAdminMessage = "detail_done_exit_alert_admin_message"
    }

    /// Detail Edit 화면에서 사용하는 텍스트
    enum DetailEdit {
        static let periodSettingTitle = "detail_edit_period_setting_title"
        static let memberSettingTitle = "detail_edit_member_setting_title"
        static let memberAlertTitle = "detail_edit_member_alert_title"
        static let memberAlertMessage = "detail_edit_member_alert_message"

        enum Error {
            static let message = "detail_edit_error_message"
        }
    }

    /// Letter 화면에서 사용하는 텍스트
    enum Letter {
        static let title = "letter_title"
        static let manittoTitle = "letter_manitto_title"
        static let manitteTitle = "letter_manitte_title"
        static let guide = "letter_guide"
        static let buttonSend = "letter_button_send"
        static let emptyFromContent = "letter_empty_from_content"
        static let emptyToContent = "letter_empty_to_content"
        static let saveAlertTitle = "letter_save_alert_title"
        static let saveAlertMessage = "letter_image_save_alert_message"
        static let emailEmptyContent = "letter_email_empty_content"
        static let mission = "letter_mission"
        static let missionToday = "letter_mission_today"

        enum Error {
            static let fetchMessage = "letter_fetch_error_message"
            static let imageSaveMessage = "letter_image_save_error_message"
        }
    }

    /// Send Letter 화면에서 사용하는 텍스트
    enum SendLetter {
        static let title = "letter_send_title"
        static let photoTitle = "letter_send_photo_title"
        static let textTitle = "letter_send_text_title"
        static let buttonSend = "letter_send_button_send"
        static let photoMenuTitle = "letter_send_photo_menu_title"
        static let photoMenuTakePhoto = "letter_send_photo_menu_take_photo"
        static let photoMenuChoosePhoto = "letter_send_photo_menu_choose_photo"
        static let photoMenuDeletePhoto = "letter_send_photo_menu_delete_photo"

        enum Error {
            static let fetchMessage = "letter_send_error_mesage"
            static let photoLoadMessage = "letter_send_photo_load_error_message"
            static let settingMessage = "letter_send_photo_setting_error_message"
            static let deviceMessage = "letter_send_photo_device_error_message"
            static let authorizationMessage = "letter_photo_authorization_error_message"
            static let buttonSetting = "letter_send_photo_error_button_setting"
        }
    }

    /// Memory 화면에서 사용하는 텍스트
    enum Memory {
        static let title = "memory_title"
        static let manittoContent = "memory_manitto_content"
        static let manitteContent = "memory_manitte_content"

        enum Error {
            static let instaTitle = "memory_insta_error_title"
            static let instaMessage = "memory_insta_error_message"
        }
    }

    /// CreateRoom 화면에서 사용하는 텍스트
    enum CreateRoom {
        static let next = "create_room_next"
        static let previous = "create_room_previous"
        static let inputDateTitle = "create_room_input_date_title"
        static let inputPersonTitle = "create_room_input_person_title"
        static let inputNamePlaceholder = "create_room_input_name_placeholder"
        static let invitedCodeTitle = "create_room_invited_code_title"
    }

    /// ParticipateRoom  화면에서 사용하는 텍스트
    enum ParticipateRoom {
        static let title = "participate_room_title"
        static let chooseCharacterTitle = "participate_room_choose_character_title"
        static let chooseCharacterSubTitle = "participate_room_choose_character_subTitle"
        static let buttonYes = "participate_room_button_yes"
        static let buttonNo = "participate_room_button_no"
        static let inputCodePlaceholder = "participate_room_input_code_placeholder"

        enum Error {
            static let title = "participate_room_error_title"
            static let message = "participate_room_error_message"
            static let alreadyJoinTitle = "participate_room_already_join_error_title"
            static let alreadyJoinMessage = "participate_room_already_join_error_message"
        }
    }

    /// Setting 화면에서 사용하는 텍스트
    enum Setting {
        static let changeNickname = "setting_change_nickname"
        static let personalInformation = "setting_personal_information"
        static let termsOfService = "setting_terms_of_service"
        static let developerInfo = "setting_developer_info"
        static let inquiry = "setting_inquiry"
        static let logout = "setting_logout"
        static let withdrawal = "setting_withdrawal"
        static let logoutAlertTitle = "setting_logout_alert_title"
        static let withdrawalAlertMessage = "setting_withdrawal_alert_message"
        static let withdrawalAlertOk = "setting_withdrawal_alert_ok"

        enum Error {
            static let withDrawalMessage = "setting_withdrawal_error_message"
        }
    }

    /// Nickname 화면에서 사용하는 텍스트
    enum Nickname {
        static let changeTitle = "nickname_change_title"
        static let createTitle = "nickname_create_title"
        static let placeholder = "nickname_placeholder"
    }

    /// 메일 작성 부분에서 사용하는 텍스트
    enum Mail {
        static let inquiryMessage = "mail_inquiry_message"
        static let inquiryTitle = "mail_inquiry_title"
        static let reportMessage = "mail_report_message"
        static let reportTitle = "mail_report_title"
        static let aenittoEmail = "mail_aenitto_email"

        enum Error {
            static let title = "mail_error_title"
            static let message = "mail_error_message"
        }
    }
}

//enum TextLiteral {
//
//    // MARK: - App Name
//    static let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "애니또"
//
//    // MARK: - AnyWhere
//    static let done: String = "완료"
//    static let cancel: String = "취소"
//    static let doing: String = "진행중"
//    static let waiting: String = "대기중"
//    static let confirm: String = "확인"
//    static let choose: String = "선택"
//    static let enterRoom: String = "방 참가하기"
//    static let searchRoom: String = "방 조회하기"
//    static let during: String = "진행 기간"
//    static let delete: String = "삭제"
//    static let leave: String = "나가기"
//    static let togetherFriend: String = "함께하는 친구들"
//    static let copyCode: String = "방 코드 복사"
//    static let change: String = "변경"
//    static let modifiedRoomInfo: String = "방 정보 수정"
//    static let maxMessage: String = "최대 7일까지 선택가능해요"
//    static let destructive: String = "변경 사항 폐기"
//    static let per: String = "인"
//    static let x: String = "X"
//    static let createRoom: String = "방 생성하기"
//    static let next: String = "다음"
//    static let previous: String = "이전"
//    static let errorAlertTitle: String = "오류 발생"
//    static let alert: String = "경고"
//    static let fail: String = "실패"
//
//    // MARK: - SettingDeveloperInfo
//    static let settingDeveloperInfoTitle: String = "개발자 정보"
//
//    // MARK: - SettingViewController
//    static let settingViewControllerChangeNickNameTitle: String = "닉네임 변경하기"
//    static let settingViewControllerPersonalInfomationTitle: String = "개인정보 처리방침"
//    static let settingViewControllerTermsOfServiceTitle: String = "이용 약관"
//    static let settingViewControllerDeveloperInfoTitle: String = "개발자 정보"
//    static let settingViewControllerHelpTitle: String = "문의하기"
//    static let settingViewControllerLogoutTitle: String = "로그아웃"
//    static let settingViewControllerWithdrawalTitle: String = "서비스 탈퇴"
//    static let settingViewControllerLogoutAlertTitle: String = "로그아웃 하시겠습니까?"
//    static let settingViewControllerWithdrawalMessage: String = "서비스 탈퇴 시 지금까지 내용이 전부 삭제됩니다. \n 탈퇴 하시겠습니까?"
//    static let settingViewControllerWithdrawal: String = "탈퇴"
//    static let settingViewControllerFailMessage: String = "서비스 탈퇴에 실패했습니다. 다시 시도해주세요."
//
//    // MARK: - CreateNickNameViewController
//    static let createNickNameViewControllerTitle: String = "닉네임 설정"
//    static let createNickNameViewControllerAskNickName: String = "닉네임을 적어주세요"
//
//    // MARK: - CommonMissonView
//    static let commonMissionViewTitle: String = "오늘의 공통미션"
//
//    // MARK: - ManitoRoomCollectionViewCell
//    static let manitoRoomCollectionViewCellRoomLabelTitle: String = "마니또"
//
//    // MARK: - CreateRoomCollectionViewCell
//    static let createRoomCollectionViewCellMenuLabel: String = "새로운 마니또 시작"
//
//    // MARK: - MainViewController
//    static let mainViewControllerMenuTitle: String = "참여중인 애니또"
//    static let mainViewControllerGuideText: String = "공통 미션이란?\n마니또에 참여한 모두에게 \n수행하는 미션이에요. "
//    static let mainViewControllerNewRoomAlert: String = "새로운 마니또 시작"
//    static let mainViewControllerShowIdErrorAlertTitle: String = "해당 마니또 방의 정보를 불러오지 못했습니다."
//    static let mainViewControllerShowIdErrorAlertMessage: String = "해당 마니또 방으로 이동할 수 없습니다."
//
//    // MARK: - SelectManitteeViewController
//    static let selectManitteeViewControllerInformationText: String =
//    """
//    레버를 스와이프해서
//    내 마니띠를 확인하세요.
//    """
//
//    // MARK: - OpenManittoViewController
//    static let openManittoViewControllerTitle: String = "당신의 마니또는?"
//    static let openManittoViewControllerErrorTitle: String = "오류"
//    static let openManittoViewControllerErrorDescription = "마니또를 확인할 수 없습니다."
//    static let openManittoViewControllerPopupDescription: String =
//        """
//        내일 함께 했던 추억이 열립니다.
//        마니또 방에서 확인해 보세요!
//        """
//
//    // MARK: - ChooseCharacterViewController
//    static let chooseCharacterViewControllerTitleLabel: String = "캐릭터 선택"
//    static let chooseCharacterViewControllerSubTitleLabel: String = "당신만의 캐릭터를 정해주세요"
//
//    // MARK: - CheckRoomViewController
//    static let checkRoomViewControllerQuestionLabel: String = "이 방으로 입장할까요?"
//    static let checkRoomViewControllerNoButtonLabel: String = "NO"
//    static let checkRoomViewControllerYesBUttonLabel: String = "YES"
//    static let checkRoomViewControllerErrorAlertTitle: String = "해당하는 애니또 방이 없어요"
//    static let checkRoomViewControllerErrorAlertMessage: String = "초대 코드를 다시 확인해 주세요"
//
//    // MARK: - InputInvitedCodeView
//    static let inputInvitedCodeViewRoomCodeText: String = "초대코드 입력"
//
//    // MARK: - LetterHeaderView
//    static let letterHeaderViewSegmentControlManitti: String = "마니띠에게"
//    static let letterHeaderViewSegmentControlManitto: String = "마니또로부터"
//
//    // MARK: - BottomSendLetterView
//    static let sendLetterViewSendLetterButton: String = "쪽지 쓰기"
//
//    // MARK: - IndividualMissionView
//    static let individualMissionViewTitleLabel: String = "오늘의 개별 미션"
//
//    // MARK: - CreateLetterTextView
//    static let letterTextViewTitleLabel: String = "쪽지 작성"
//
//    // MARK: - CreateLetterPhotoView
//    static let letterPhotoViewTitleLabel: String = "사진 추가"
//    static let letterPhotoViewTakePhoto: String = "사진 촬영"
//    static let letterPhotoViewChoosePhoto: String = "사진 보관함에서 선택"
//    static let letterPhotoViewDeletePhoto: String = "사진 지우기"
//    static let letterPhotoViewChoosePhotoToManitto: String = "마니또에게 보낼 사진 선택"
//    static let letterPhotoViewSetting: String = "설정"
//    static let letterPhotoViewFail: String = "사진을 불러올 수 없습니다."
//    static let letterPhotoViewErrorTitle: String = "오류"
//    static let letterPhotoViewSettingFail = "설정 화면을 연결할 수 없습니다."
//    static let letterPhotoViewDeviceFail = "해당 기기에서 카메라를 사용할 수 없습니다."
//    static let letterPhotoViewSettingAuthorization = "\(appName)가 카메라에 접근이 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?"
//
//    // MARK: - LetterViewController
//    static let letterViewControllerTitle = "쪽지함"
//    static let letterViewControllerGuideText = "쪽지 쓰기는?\n마니띠에게만 쓰기가 가능해요.\n마니또로부터는 확인만 할 수 있어요."
//    static let letterViewControllerEmptyViewFrom = """
//        쪽지함이 비었어요.
//        곧 마니또가 쪽지를 보낼거에요!
//        """
//    static let letterViewControllerEmptyViewTo = """
//        쪽지함이 비었어요.
//        마니띠에게 쪽지를 보내볼까요?
//        """
//    static let letterViewControllerErrorTitle: String = "오류"
//    static let letterViewControllerErrorDescription: String = "쪽지를 가져올 수 없습니다."
//
//    // MARK: - LetterImageViewController
//    static let letterImageViewControllerErrorTitle = "오류 발생"
//    static let letterImageViewControllerErrorMessage = "사진을 저장할 수 없습니다."
//    static let letterImageViewControllerSuccessTitle = "저장 성공"
//    static let letterImageViewControllerSuccessMessage = "사진을 앨범에 저장했어요."
//
//    // MARK: - CreateLetterViewController
//    static let createLetterViewControllerSendButton: String = "보내기"
//    static let createLetterViewControllerTitle: String = "쪽지 작성하기"
//    static let createLetterViewControllerErrorTitle = "오류 발생"
//    static let createLetterViewControllerErrorMessage = "쪽지 전송에 실패했습니다. 다시 시도해주세요."
//
//
//    // MARK: - DetailIngViewController
//    static let detailIngViewControllerManitoOpenButton: String = "마니또 공개"
//    static let detailIngViewControllerGuideText: String = "개별 미션이란?\n나의 마니띠에게\n수행하는 미션이에요."
//    static let detailIngViewControllerDoneMissionText: String = "종료된 마니또예요"
//    static let detailIngViewControllerDoneExitAlertTitle: String = "정말 방을 나가시겠습니까?"
//    static let detailIngViewControllerDoneExitAlertAdminTitle: String = "정말 방을 삭제하시겠습니까?"
//    static let detailIngViewControllerDoneExitAlertMessage: String = "나간 방은 다시 들어올 수 없어요"
//    static let detailIngViewControllerDoneExitAlertAdmin: String = "방장이 방을 삭제하면\n 참여자들의 방도 삭제됩니다"
//    static let detailIngViewControllerDetailInformatioin: String = "진행 정보"
//    static let detailIngViewControllerMissionEditTitle: String = "개별 미션 설정"
//    static let detailIngViewControllerSelfEditMissionTitle: String = "개별 미션 직접 설정"
//    static let detailIngViewControllerResetMissionTitle: String = "기본 미션으로 변경"
//    static let detailIngViewControllerResetMissionAlertTitle: String = "개별 미션을 되돌리시겠습니까?"
//    static let detailIngViewControllerResetMissionAlertMessage: String = "기존에 주어지는 기본 미션으로 재설정됩니다."
//    static let detailIngViewControllerResetMissionAlertOkTitle: String = "되돌리기"
//    static let detailIngViewControllerResetMissionErrorAlertOkTitle: String = "오류 발생"
//    static let detailIngViewControllerResetMissionErrorAlertOkMessage: String = "미션을 되돌릴 수 없습니다.\n다시 시도해주세요."
//
//    // MARK: - CalendarView
//    static let calendarViewAlertMaxTitle: String = "최대 선택 기간을 넘었어요"
//
//    static let calendarViewAlertPastTitle: String = "지난 날을 선택하셨어요"
//    static let calendarViewAlertPastMessage: String = "오늘보다 이전 날짜는 \n 선택하실 수 없어요"
//
//    // MARK: - DatailWaitViewController
//    static let datailWaitViewControllerDeleteTitle: String = "방을 삭제하실 건가요?"
//    static let datailWaitViewControllerExitTitle: String = "정말 나가실거예요?"
//    static let datailWaitViewControllerDeleteMessage: String = "방을 삭제하시면 다시 되돌릴 수 없습니다."
//    static let datailWaitViewControllerExitMessage: String = "초대코드를 입력하면 \n 다시 들어올 수 있어요."
//    static let datailWaitViewControllerButtonWaitingText: String = "시작을 기다리는 중..."
//    static let datailWaitViewControllerButtonStartText: String = "마니또 시작"
//
//    static let detailWaitViewControllerDeleteRoom: String = "방 삭제"
//    static let detailWaitViewControllerLeaveRoom: String = "방 나가기"
//    static let detailWaitViewControllerCode: String = "초대코드"
//    static let detailWaitViewControllerCopyCode: String = "코드 복사 완료!"
//    static let detailWaitViewControllerPastAlertTitle: String = "마니또 시작일이 지났어요"
//    static let detailWaitViewControllerPastAlertMessage: String = "방장이 진행기간을 재설정 \n 할 때까지 기다려주세요."
//    static let detailWaitViewControllerPastAdminAlertMessage: String = "진행기간을 재설정 해주세요"
//    static let detailWaitViewControllerDeleteErrorMessage: String = "방 삭제에 실패했습니다. 다시 시도해주세요"
//    static let detailWaitViewControllerStartErrorMessage: String = "마니또 시작에 실패했습니다. 다시 시도해주세요"
//    static let detailWaitViewControllerLeaveErrorMessage: String = "방 나가기에 실패했습니다. 다시 시도해주세요"
//    static let detailWaitViewControllerLoadDataMessage: String = "방 정보를 불러올 수 없습니다. 다시 시도해주세요"
//
//    // MARK: - MemoryViewController
//    static let memoryViewControllerTitleLabel: String = "함께 했던 기록"
//    static let memoryViewControllerManittoText: String = "나를 챙겨줘서 고마워, 마니또"
//    static let memoryViewControllerManitteeText: String = "내가 챙겨줘서 좋았지? 마니띠"
//    static let memoryViewControllerAlertTitle: String = "스토리 공유에 실패했어요"
//    static let memoryViewControllerAlertMessage: String = "스토리 공유를 하려면 인스타그램이 필요합니다"
//
//    // MARK: - DetailEditViewController
//    static let detailEditViewControllerStartSetting: String = "진행기간 설정"
//    static let detailEditViewControllerSetMember: String = "인원 설정"
//    static let detailEditViewControllerChangeRoomInfoAlertTitle: String = "인원을 다시 설정해 주세요"
//    static let detailEditViewControllerChangeRoomInfoAlertMessage: String = "현재 인원보다 최대 인원을 \n더 적게 설정할 수 없어요."
//    static let detailEditViewControllerChangeErrorTitle: String = "오류 발생"
//    static let detailEditViewControllerChangeErrorMessage: String = "방 정보 수정에 실패했습니다. 다시 시도해주세요"
//
//    // MARK: - InputNameView
//    static let inputNameViewRoomNameText: String = "방 이름을 적어주세요"
//
//    // MARK: - InputPersonView
//    static let inputPersonViewTitle: String = "최대 참여 인원을 설정해 주세요"
//
//    // MARK: - InputDateView
//    static let inputDateViewTitle: String = "진행 기간을 설정해 주세요"
//
//    // MARK: - ChangeNickNameViewController
//    static let changeNickNameViewControllerTitle: String = "닉네임 변경"
//
//    // MARK: - InvitedCodeViewController
//    static let invitedCodeViewCOntroller: String = "글자를 탭하여 코드를 복사하세요"
//
//    // MARK: - MissionEditViewController
//    static let missionEditViewControllerChangeMissionAlertTitle: String = "개별 미션을 수정하시겠습니까?"
//    static let missionEditViewControllerChangeMissionAlertMessage: String = "기본 미션으로 변경을 통해\n되돌릴 수 있습니다."
//    static let missionEditViewControllerChangeMissionErrorAlertTitle: String = "오류 발생"
//    static let missionEditViewControllerChangeMissionErrorAlertMessage: String = "개별 미션을 수정 할 수 없습니다.\n다시 시도해주세요."
//}
