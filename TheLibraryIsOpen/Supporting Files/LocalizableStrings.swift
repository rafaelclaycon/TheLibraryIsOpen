import Foundation

struct LocalizableStrings {

    static let ok = NSLocalizedString("ok", comment: .empty)
    static let episode = NSLocalizedString("episode", comment: .empty)
    static let episodes = NSLocalizedString("episodes", comment: .empty)
    static let cancel = NSLocalizedString("cancel", comment: .empty)
    static let mostRecentFirst = NSLocalizedString("most_recent_first", comment: .empty);
    static let oldestFirst = NSLocalizedString("oldest_first", comment: .empty);
    static let sizeNotReportedByAuthor = NSLocalizedString("size_not_reported_by_author", comment: .empty)
    static let group = NSLocalizedString("group", comment: .empty)
    static let groups = NSLocalizedString("groups", comment: .empty)
    
    struct MainView {
        
        static let title = NSLocalizedString("main_view_title", comment: .empty)
        static let addPodcastButtonLabel = NSLocalizedString("main_view_add_podcast_button_label", comment: .empty)
        
        struct EmptyStateView {
            
            static let title = NSLocalizedString("main_view_empty_state_view_title", comment: .empty)
            static let description = NSLocalizedString("main_view_empty_state_view_description", comment: .empty)
            static let howDoesThisWorkButtonLabel = NSLocalizedString("main_view_empty_state_view_how_does_this_work_button_label", comment: .empty)
            
        }
        
        struct ListOptions {
            
            static let sortByTitle = NSLocalizedString("main_view_list_options_sort_by_title", comment: .empty)
            static let sortByTotalSize = NSLocalizedString("main_view_list_options_sort_by_total_size", comment: .empty)
            static let showEpisodeCount = NSLocalizedString("main_view_list_options_show_episode_count", comment: .empty)
            static let showTotalSize = NSLocalizedString("main_view_list_options_show_total_size", comment: .empty)
            
        }
        
        struct PodcastRow {
            
            static let episodeCountNoEpisodes = NSLocalizedString("main_view_podcast_row_episode_count_no_episodes", comment: .empty)
            static let episodeCountSingleEpisode = NSLocalizedString("main_view_podcast_row_episode_count_single_episode", comment: .empty)
            static let episodeCountMultipleEpisodes = NSLocalizedString("main_view_podcast_row_episode_count_multiple_episodes", comment: .empty)
            static let notExportedYet = NSLocalizedString("main_view_podcast_row_not_exported_yet", comment: .empty)
            static let exportedAt = NSLocalizedString("main_view_podcast_row_exported_at", comment: .empty)
            static let noSizeInformation = NSLocalizedString("main_view_podcast_row_no_size_information", comment: .empty)
            static let deletePodcastSwipeActionLabel = NSLocalizedString("main_view_podcast_delete_podcast_swipe_action_label", comment: .empty)
            
        }
        
        struct ErrorMessages {
            
            static let errorLoadingPodcasts = NSLocalizedString("main_view_error_messages_error_loading_podcasts", comment: .empty)
            static let podcastDeletionConfirmationTitle = NSLocalizedString("main_view_error_messages_podcast_deletion_confirmation_title", comment: .empty)
            static let podcastDeletionConfirmationMessage = NSLocalizedString("main_view_error_messages_podcast_deletion_confirmation_message", comment: .empty)
            static let deletionFailureTitle = NSLocalizedString("main_view_error_messages_deletion_failure_title", comment: .empty)
            
        }
        
    }
    
    struct PlayerPickerView {
        
        static let title = NSLocalizedString("player_picker_view_title", comment: .empty)
        static let other = NSLocalizedString("player_picker_view_other", comment: .empty)
        
    }
    
    struct UnfortunatelyView {
        
        static let title = NSLocalizedString("unfortunately_view_title", comment: .empty)
        static let explanation1stParagraph = NSLocalizedString("unfortunately_view_explanation_1st_paragraph", comment: .empty)
        static let explanation2ndParagraph = NSLocalizedString("unfortunately_view_explanation_2nd_paragraph", comment: .empty)
        static let explanation3rdParagraph = NSLocalizedString("unfortunately_view_explanation_3rd_paragraph", comment: .empty)
        static let openApplePodcastsButtonTitle = NSLocalizedString("unfortunately_view_open_apple_podcasts_button_title", comment: .empty)
        static let couldNotOpenPodcastsAppAlertTitle = NSLocalizedString("unfortunately_view_could_not_open_podcasts_app_alert_title", comment: .empty)
        static let couldNotOpenPodcastsAppAlertMessage = NSLocalizedString("unfortunately_view_could_not_open_podcasts_app_alert_message", comment: .empty)
        
    }
    
    struct GetLinkInstructionsView {
        
        static let title = NSLocalizedString("get_link_instructions_view_title", comment: .empty)
        static let generalExplanationText = NSLocalizedString("get_link_instructions_view_general_explanation_text", comment: .empty)
        
        struct ApplePodcasts {
            
            static let imageName = NSLocalizedString("get_link_instructions_view_apple_podcasts_image_name", comment: .empty)
            static let step1 = NSLocalizedString("get_link_instructions_view_apple_podcasts_step1", comment: .empty)
            static let step2 = NSLocalizedString("get_link_instructions_view_apple_podcasts_step2", comment: .empty)
            static let step3 = NSLocalizedString("get_link_instructions_view_apple_podcasts_step3", comment: .empty)
            static let step4 = NSLocalizedString("get_link_instructions_view_apple_podcasts_step4", comment: .empty)
            static let step5 = NSLocalizedString("get_link_instructions_view_apple_podcasts_step5", comment: .empty)
            static let step6 = NSLocalizedString("get_link_instructions_view_apple_podcasts_step6", comment: .empty)
            
        }
        
        struct Castro {
            
            static let imageName = NSLocalizedString("get_link_instructions_view_castro_image_name", comment: .empty)
            static let step1 = NSLocalizedString("get_link_instructions_view_castro_step1", comment: .empty)
            static let step2 = NSLocalizedString("get_link_instructions_view_castro_step2", comment: .empty)
            static let step3 = NSLocalizedString("get_link_instructions_view_castro_step3", comment: .empty)
            static let step4 = NSLocalizedString("get_link_instructions_view_castro_step4", comment: .empty)
            static let step5 = NSLocalizedString("get_link_instructions_view_castro_step5", comment: .empty)
            static let step6 = NSLocalizedString("get_link_instructions_view_castro_step6", comment: .empty)
            
        }
        
        struct Overcast {
            
            static let imageName = NSLocalizedString("get_link_instructions_view_overcast_image_name", comment: .empty)
            static let step1 = NSLocalizedString("get_link_instructions_view_overcast_step1", comment: .empty)
            static let step2 = NSLocalizedString("get_link_instructions_view_overcast_step2", comment: .empty)
            static let step3 = NSLocalizedString("get_link_instructions_view_overcast_step3", comment: .empty)
            static let step4 = NSLocalizedString("get_link_instructions_view_overcast_step4", comment: .empty)
            static let step5 = NSLocalizedString("get_link_instructions_view_overcast_step5", comment: .empty)
            static let step6 = NSLocalizedString("get_link_instructions_view_overcast_step6", comment: .empty)
            
        }
        
        struct PocketCasts {
            
            static let imageName = NSLocalizedString("get_link_instructions_view_pocket_casts_image_name", comment: .empty)
            static let step1 = NSLocalizedString("get_link_instructions_view_pocket_casts_step1", comment: .empty)
            static let step2 = NSLocalizedString("get_link_instructions_view_pocket_casts_step2", comment: .empty)
            static let step3 = NSLocalizedString("get_link_instructions_view_pocket_casts_step3", comment: .empty)
            static let step4 = NSLocalizedString("get_link_instructions_view_pocket_casts_step4", comment: .empty)
            static let step5 = NSLocalizedString("get_link_instructions_view_pocket_casts_step5", comment: .empty)
            static let step6 = NSLocalizedString("get_link_instructions_view_pocket_casts_step6", comment: .empty)
            
        }
        
        static let nextButtonLabel = NSLocalizedString("get_link_instructions_view_next_button_label", comment: .empty)
        
    }
    
    struct PasteLinkView {
        
        static let title = NSLocalizedString("paste_link_view_title", comment: .empty)
        static let step6 = NSLocalizedString("paste_link_view_step6", comment: .empty)
        static let processLinkButtonLabel = NSLocalizedString("paste_link_view_process_link_button_label", comment: .empty)
        static let loaderLabel = NSLocalizedString("paste_link_view_loader_label", comment: .empty)
        
        static let spotifyLinksNotSupportedWarningTitle = NSLocalizedString("paste_link_view_spotify_links_not_supported_warning_title", comment: .empty)
        static let spotifyLinksNotSupportedWarningMessage = NSLocalizedString("paste_link_view_spotify_links_not_supported_warning_message", comment: .empty)
        
        static let unableToAccessFeedErrorTitle = NSLocalizedString("paste_link_view_unable_to_access_feed_error_title", comment: .empty)
        static let unableToAccessFeedErrorMessage = NSLocalizedString("paste_link_view_unable_to_access_feed_error_message", comment: .empty)
        
        static let invalidApplePodcastsLinkErrorTitle = NSLocalizedString("paste_link_view_invalid_apple_podcasts_link_error_title", comment: .empty)
        static let invalidApplePodcastsLinkErrorMessage = NSLocalizedString("paste_link_view_invalid_apple_podcasts_link_error_message", comment: .empty)
        
    }
    
    struct PodcastPreview {
        
        static let episodeList = NSLocalizedString("podcast_preview_episode_list", comment: .empty);
        static let groupedByYear = NSLocalizedString("podcast_preview_grouped_by_year", comment: .empty);
        static let selectAll = NSLocalizedString("podcast_preview_select_all", comment: .empty);
        static let unselectAll = NSLocalizedString("podcast_preview_unselect_all", comment: .empty);
        static let downloadEpisodesButtonTitle = NSLocalizedString("podcast_preview_download_episodes_button_title", comment: .empty);
        static let downloadButtonJustAddTitle = NSLocalizedString("podcast_preview_download_button_just_add_title", comment: .empty);
        static let remainingStorageSingularLabel = NSLocalizedString("podcast_preview_remaining_storage_singular_label", comment: .empty)
        static let remainingStoragePluralLabel = NSLocalizedString("podcast_preview_remaining_storage_plural_label", comment: .empty)
        static let remainingStorageErrorLabel = NSLocalizedString("podcast_preview_remaining_storage_error_label", comment: .empty)
        static let remainingStorageOverMinimumFreeStorageError = NSLocalizedString("remaining_storage_over_minimum_free_storage_error", comment: .empty)
        
        struct EpisodeGroupList {
            
            static let episode = NSLocalizedString("podcast_preview_episode_group_list_episode_label_singular", comment: "")
            static let episodes = NSLocalizedString("podcast_preview_episode_group_list_episode_label_plural", comment: "")
            
        }
        
        struct Messages {
            
            static let readyToDownloadSingleEpisodeConfirmationTitle = NSLocalizedString("podcast_preview_messages_ready_to_download_single_episode_confirmation_title", comment: .empty)
            static let readyToDownloadMultipleEpisodesConfirmationTitle = NSLocalizedString("podcast_preview_messages_ready_to_download_multiple_episodes_confirmation_title", comment: .empty)
            static let readyToDownloadConfirmationMessage = NSLocalizedString("podcast_preview_messages_ready_to_download_confirmation_message", comment: .empty)
            static let continueButtonLabel = NSLocalizedString("continue_button_label", comment: .empty)
            
        }
        
    }
    
    // MARK: - ArchivedPodcastDetail
    struct ArchivedPodcastDetail {
        
        struct Options {
            
            static let publicationDate = NSLocalizedString("archived_podcast_detail_options_publication_date", comment: .empty)
            static let showDownloadedEpisodesOnly = NSLocalizedString("archived_podcast_detail_options_show_downloaded_episodes_only", comment: .empty)
            static let showAllEpisodes = NSLocalizedString("archived_podcast_detail_options_show_all_episodes", comment: .empty)
            static let lookForNewEpisodes = NSLocalizedString("archived_podcast_detail_options_look_for_new_episodes", comment: .empty)
            static let viewHistory = NSLocalizedString("archived_podcast_detail_options_view_history", comment: .empty)
            static let deletePodcast = NSLocalizedString("archived_podcast_detail_options_delete_podcast", comment: .empty)
            
        }
        
        struct EpisodeRow {
            
            static let downloadingEpisode = NSLocalizedString("archived_podcast_detail_downloading_episode", comment: .empty)
            static let availableOffline = NSLocalizedString("archived_podcast_detail_available_offline", comment: .empty)
            
        }
        
        struct DownloadStrip {
            
            static let summaryMessageSingleEpisode = NSLocalizedString("archived_podcast_detail_download_summary_message_single_episode", comment: .empty)
            static let summaryMessageMultipleEpisodes = NSLocalizedString("archived_podcast_detail_download_summary_message_multiple_episodes", comment: .empty)
            
        }
        
        struct Info {
            
            static let downloadedEpisodes = NSLocalizedString("archived_podcast_detail_info_downloaded_episodes", comment: .empty)
            static let totalSize = NSLocalizedString("archived_podcast_detail_total_size", comment: .empty)
            static let unknownTotalSize = NSLocalizedString("archived_podcast_detail_unknown_total_size", comment: .empty)
            static let lastChecked = NSLocalizedString("archived_podcast_detail_last_checked", comment: .empty)
            static let unknownLastCheckedDate = NSLocalizedString("archived_podcast_detail_unknown_last_checked_date", comment: .empty)
            
        }
        
        struct Export {
            
            static let exportAllButtonLabel = NSLocalizedString("archived_podcast_detail_export_all_button_label", comment: .empty)
            static let exportOptionsText = NSLocalizedString("archived_podcast_detail_export_options_text", comment: .empty)
            
            struct Options {
                
                static let filesApp = NSLocalizedString("archived_podcast_detail_export_options_files_option_name", comment: .empty)
                static let other = NSLocalizedString("archived_podcast_detail_export_options_other_option_name", comment: .empty)
                
            }
            
            static let exportedFileNameSingleEpisode = NSLocalizedString("archived_podcast_detail_exported_file_name_single_episode", comment: .empty)
            static let exportedFileNameMultipleEpisodes = NSLocalizedString("archived_podcast_detail_exported_file_name_multiple_episodes", comment: .empty)
            static let exportSuccessfulMessageTitle = NSLocalizedString("archived_podcast_detail_export_export_successful_message_title", comment: .empty)
            static let exportSuccessfulMessageBody = NSLocalizedString("archived_podcast_detail_export_export_successful_message_body", comment: .empty)
            
        }
        
    }
    
    // MARK: - After Export Success View
    struct AfterExportSuccessView {
        
        static let exportSuccessfulTitle = NSLocalizedString("after_export_success_view_export_successful_title", comment: .empty)
        static let whatNowSubtitle = NSLocalizedString("after_export_success_view_what_now_subtitle", comment: .empty)
        static let explanationTextFirstParagraph = NSLocalizedString("after_export_success_view_explanation_text_first_paragraph", comment: .empty)
        static let explanationTextSecondParagraph = NSLocalizedString("after_export_success_view_explanation_text_second_paragraph", comment: .empty)
        
    }
    
    // MARK: - Settings View
    struct SettingsView {
        
        static let title = NSLocalizedString("settings_screen_title", comment: .empty)
        
        struct AddPodcast {
            
            static let sectionHeader = NSLocalizedString("settings_screen_add_podcast_section_header", comment: .empty)
            static let skipGetLinkInstructions = NSLocalizedString("settings_screen_add_podcast_skip_get_link_instructions_label", comment: .empty)
            
            struct WhenAdding {
                
                static let optionLabel = NSLocalizedString("settings_screen_when_adding_option_label", comment: .empty)
                static let previewFirstOption = NSLocalizedString("settings_screen_when_adding_preview_first_option", comment: .empty)
                static let justAddToArchiveOption = NSLocalizedString("settings_screen_when_adding_just_add_to_archive_option", comment: .empty)
                static let addAndDownloadAllEpisodesOption = NSLocalizedString("settings_screen_when_adding_add_and_download_all_episodes_option", comment: .empty)
                
            }
            
        }
        
        struct ArchivedPodcast {
            
            static let sectionHeader = NSLocalizedString("settings_screen_archived_podcast_section_header", comment: .empty)
            static let displayEpisodeArtworkOption = NSLocalizedString("settings_screen_archived_podcast_display_episode_artwork_option", comment: .empty)
            static let sectionFooter = NSLocalizedString("settings_screen_archived_podcast_section_footer", comment: .empty)
            
        }
        
        struct TipJar {
            
            static let sectionHeader = NSLocalizedString("settings_screen_tip_jar_section_header", comment: .empty)
            
        }
        
        struct Feedback {
            
            static let sectionHeader = NSLocalizedString("settings_screen_feedback_section_header", comment: .empty)
            static let reportABugButtonLabel = NSLocalizedString("settings_screen_feedback_section_report_a_bug_button_label", comment: .empty)
            static let reportATranslationErrorButtonLabel = NSLocalizedString("settings_screen_feedback_section_report_a_translation_error_button_label", comment: .empty)
            static let sectionFooter = NSLocalizedString("settings_screen_feedback_section_footer", comment: .empty)
            
        }
        
    }
    
    // MARK: - Podcast History Record
    struct PodcastHistoryRecord {
        
        struct None {
            
            static let title = NSLocalizedString("podcast_history_record_none_title", comment: .empty)
            static let description = NSLocalizedString("podcast_history_record_none_description", comment: .empty)
            
        }
        
        struct PodcastArchived {
            
            static let title = NSLocalizedString("podcast_history_record_podcast_archived_title", comment: .empty)
            static let singleEpisodeDescription = NSLocalizedString("podcast_history_record_podcast_archived_single_episode_description", comment: .empty)
            static let multipleEpisodesDescription = NSLocalizedString("podcast_history_record_podcast_archived_multiple_episodes_description", comment: .empty)
            
        }
        
        struct ArchiveExported {
            
            static let title = NSLocalizedString("podcast_history_record_archive_exported_title", comment: .empty)
            static let singleEpisodeDescription = NSLocalizedString("podcast_history_record_archive_exported_single_episode_description", comment: .empty)
            static let multipleEpisodesDescription = NSLocalizedString("podcast_history_record_archive_exported_multiple_episodes_description", comment: .empty)
            static let exportedToUnknown = NSLocalizedString("podcast_history_record_archive_exported_exported_to_unknown", comment: .empty)
            static let exportedToFiles = NSLocalizedString("podcast_history_record_archive_exported_exported_to_files", comment: .empty)
            static let exportedToThirdPartyService = NSLocalizedString("podcast_history_record_archive_exported_exported_to_third_party_service", comment: .empty)
            
        }
        
        struct CheckedForNewEpisodes {
            
            static let title = NSLocalizedString("podcast_history_record_checked_for_new_episodes_title", comment: .empty)
            static let noNewEpisodesDescription = NSLocalizedString("podcast_history_record_checked_for_new_episodes_no_new_episodes_description", comment: .empty)
            static let singleNewEpisodeDescription = NSLocalizedString("podcast_history_record_checked_for_new_episodes_single_new_episode_description", comment: .empty)
            static let multipleNewEpisodesDescription = NSLocalizedString("podcast_history_record_checked_for_new_episodes_multiple_new_episodes_description", comment: .empty)
            
        }
        
        struct NewEpisodesDownloaded {
            
            static let title = NSLocalizedString("podcast_history_record_new_episodes_downloaded_title", comment: .empty)
            static let singleAddedEpisodeDescription = NSLocalizedString("podcast_history_record_new_episodes_downloaded_single_added_episode_description", comment: .empty)
            static let multipleAddedEpisodesDescription = NSLocalizedString("podcast_history_record_new_episodes_downloaded_multiple_added_episodes_description", comment: .empty)
            
        }
        
    }

}
