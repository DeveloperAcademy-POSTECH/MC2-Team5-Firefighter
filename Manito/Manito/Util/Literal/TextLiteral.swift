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
        static let menuDelete = "detail_menu_delete"
        static let menuLeave = "detail_menu_leave"
        static let delete = "detail_delete"
        static let leave = "detail_leave"
    }

    /// Detail Wait 화면에서 사용하는 텍스트
    enum DetailWait {
        static let copyCode = "detail_wait_copy_code"
        static let buttonWaiting = "datail_wait_button_waiting"
        static let buttonStart = "datail_wait_button_start"
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
        
        enum Error {
            static let fetchRoom = "detail_wait_fetch_error_message"
            static let startManitto = "detail_wait_start_error_message"
            static let deleteRoom = "detail_wait_delete_error_message"
            static let leaveRoom = "detail_wait_leave_error_message"
        }
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

        enum Error {
            static let message = "detail_edit_error_message"
            static let memberTitle = "detail_edit_member_error_title"
            static let memberMessage = "detail_edit_member_error_message"
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
            static let sendMessage = "letter_send_error_mesage"
            static let photoLoadMessage = "letter_send_photo_load_error_message"
            static let settingMessage = "letter_send_photo_setting_error_message"
            static let photosAuthorizationMessage = "letter_send_photo_photos_authorization_error_message"
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
        static let inputNameTitle = "create_room_input_name_title"
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

extension String {
    /// Localizable의 Key로부터 Value를 가져오는 메서드
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    /// Localizable의 Key로부터 Value를 가져오는 메서드 - Argument가 있는 경우
    func localized(with argument: CVarArg..., comment: String = "") -> String {
        return String(format: self.localized(comment: comment), argument)
    }
}
