import Foundation

struct LocalizableStrings {

    // General

    static let ok = NSLocalizedString("ok", comment: "")
    static let episode = NSLocalizedString("episode", comment: "")
    static let episodes = NSLocalizedString("episodes", comment: "")
    static let cancel = NSLocalizedString("cancel", comment: "")
    static let mostRecentFirst = NSLocalizedString("most_recent_first", comment: "");
    static let oldestFirst = NSLocalizedString("oldest_first", comment: "");
    static let sizeNotReportedByAuthor = NSLocalizedString("size_not_reported_by_author", comment: "")
    
    struct MainView {
        
        static let title = NSLocalizedString("main_view_title", comment: "")
        static let emptyStateTitle = NSLocalizedString("main_view_empty_state_title", comment: "")
        static let emptyStateDescription = NSLocalizedString("main_view_empty_state_description", comment: "")
        static let addPodcastButtonLabel = NSLocalizedString("main_view_add_podcast_button_label", comment: "")
        
        struct PodcastRow {
            
            static let episodeCountNoEpisodes = NSLocalizedString("main_view_podcast_row_episode_count_no_episodes", comment: "")
            static let episodeCountSingleEpisode = NSLocalizedString("main_view_podcast_row_episode_count_single_episode", comment: "")
            static let episodeCountMultipleEpisodes = NSLocalizedString("main_view_podcast_row_episode_count_multiple_episodes", comment: "")
            static let notExportedYet = NSLocalizedString("main_view_podcast_row_not_exported_yet", comment: "")
            
        }
        
    }
    
    struct PlayerPickerView {
        
        static let title = NSLocalizedString("player_picker_view_title", comment: "")
        static let other = NSLocalizedString("player_picker_view_other", comment: "")
        
    }
    
    struct UnfortunatelyView {
        
        static let title = NSLocalizedString("unfortunately_view_title", comment: "")
        static let explanation1stParagraph = NSLocalizedString("unfortunately_view_explanation_1st_paragraph", comment: "")
        static let explanation2ndParagraph = NSLocalizedString("unfortunately_view_explanation_2nd_paragraph", comment: "")
        static let explanation3rdParagraph = NSLocalizedString("unfortunately_view_explanation_3rd_paragraph", comment: "")
        static let openApplePodcastsButtonTitle = NSLocalizedString("unfortunately_view_open_apple_podcasts_button_title", comment: "")
        static let couldNotOpenPodcastsAppAlertTitle = NSLocalizedString("unfortunately_view_could_not_open_podcasts_app_alert_title", comment: "")
        static let couldNotOpenPodcastsAppAlertMessage = NSLocalizedString("unfortunately_view_could_not_open_podcasts_app_alert_message", comment: "")
        
    }
    
    struct InstructionsAView {
        
        static let title = NSLocalizedString("instructions_a_view_title", comment: "")
        static let generalExplanationText = NSLocalizedString("instructions_a_view_general_explanation_text", comment: "")
        
        struct ApplePodcasts {
            
            static let imageName = NSLocalizedString("instructions_a_view_apple_podcasts_image_name", comment: "")
            static let step1 = NSLocalizedString("instructions_a_view_apple_podcasts_step1", comment: "")
            static let step2 = NSLocalizedString("instructions_a_view_apple_podcasts_step2", comment: "")
            static let step3 = NSLocalizedString("instructions_a_view_apple_podcasts_step3", comment: "")
            static let step4 = NSLocalizedString("instructions_a_view_apple_podcasts_step4", comment: "")
            static let step5 = NSLocalizedString("instructions_a_view_apple_podcasts_step5", comment: "")
            static let step6 = NSLocalizedString("instructions_a_view_apple_podcasts_step6", comment: "")
            
        }
        
        struct Castro {
            
            static let imageName = NSLocalizedString("instructions_a_view_castro_image_name", comment: "")
            static let step1 = NSLocalizedString("instructions_a_view_castro_step1", comment: "")
            static let step2 = NSLocalizedString("instructions_a_view_castro_step2", comment: "")
            static let step3 = NSLocalizedString("instructions_a_view_castro_step3", comment: "")
            static let step4 = NSLocalizedString("instructions_a_view_castro_step4", comment: "")
            static let step5 = NSLocalizedString("instructions_a_view_castro_step5", comment: "")
            static let step6 = NSLocalizedString("instructions_a_view_castro_step6", comment: "")
            
        }
        
        struct Overcast {
            
            static let imageName = NSLocalizedString("instructions_a_view_overcast_image_name", comment: "")
            static let step1 = NSLocalizedString("instructions_a_view_overcast_step1", comment: "")
            static let step2 = NSLocalizedString("instructions_a_view_overcast_step2", comment: "")
            static let step3 = NSLocalizedString("instructions_a_view_overcast_step3", comment: "")
            static let step4 = NSLocalizedString("instructions_a_view_overcast_step4", comment: "")
            static let step5 = NSLocalizedString("instructions_a_view_overcast_step5", comment: "")
            static let step6 = NSLocalizedString("instructions_a_view_overcast_step6", comment: "")
            
        }
        
        struct PocketCasts {
            
            static let imageName = NSLocalizedString("instructions_a_view_pocket_casts_image_name", comment: "")
            static let step1 = NSLocalizedString("instructions_a_view_pocket_casts_step1", comment: "")
            static let step2 = NSLocalizedString("instructions_a_view_pocket_casts_step2", comment: "")
            static let step3 = NSLocalizedString("instructions_a_view_pocket_casts_step3", comment: "")
            static let step4 = NSLocalizedString("instructions_a_view_pocket_casts_step4", comment: "")
            static let step5 = NSLocalizedString("instructions_a_view_pocket_casts_step5", comment: "")
            static let step6 = NSLocalizedString("instructions_a_view_pocket_casts_step6", comment: "")
            
        }
        
        static let nextButtonLabel = NSLocalizedString("instructions_a_view_next_button_label", comment: "")
        
    }
    
    struct InstructionsBView {
        
        static let title = NSLocalizedString("instructions_b_view_title", comment: "")
        static let step6 = NSLocalizedString("instructions_b_view_step6", comment: "")
        static let processLinkButtonLabel = NSLocalizedString("instructions_b_view_process_link_button_label", comment: "")
        static let loaderLabel = NSLocalizedString("instructions_b_view_loader_label", comment: "")
        
        static let spotifyLinksNotSupportedWarningTitle = NSLocalizedString("instructions_b_view_spotify_links_not_supported_warning_title", comment: "")
        static let spotifyLinksNotSupportedWarningMessage = NSLocalizedString("instructions_b_view_spotify_links_not_supported_warning_message", comment: "")
        
    }
    
    struct PodcastPreview {
        
        static let episodeList = NSLocalizedString("podcast_preview_episode_list", comment: "");
        static let groupedByYear = NSLocalizedString("podcast_preview_grouped_by_year", comment: "");
        static let selectAll = NSLocalizedString("podcast_preview_select_all", comment: "");
        static let unselectAll = NSLocalizedString("podcast_preview_unselect_all", comment: "");
        static let downloadEpisodesButtonTitle = NSLocalizedString("podcast_preview_download_episodes_button_title", comment: "");
        static let downloadButtonJustAddTitle = NSLocalizedString("podcast_preview_download_button_just_add_title", comment: "");
        static let remainingStorageSingularLabel = NSLocalizedString("podcast_preview_remaining_storage_singular_label", comment: "")
        static let remainingStoragePluralLabel = NSLocalizedString("podcast_preview_remaining_storage_plural_label", comment: "")
        
        struct Messages {
            
            static let readyToDownloadSingleEpisodeConfirmationTitle = NSLocalizedString("podcast_preview_messages_ready_to_download_single_episode_confirmation_title", comment: "")
            static let readyToDownloadMultipleEpisodesConfirmationTitle = NSLocalizedString("podcast_preview_messages_ready_to_download_multiple_episodes_confirmation_title", comment: "")
            static let readyToDownloadConfirmationMessage = NSLocalizedString("podcast_preview_messages_ready_to_download_confirmation_message", comment: "")
            static let continueButtonLabel = NSLocalizedString("continue_button_label", comment: "")
            
        }
        
    }
    
    struct ArchivedPodcastDetail {
        
        static let totalSize = NSLocalizedString("archived_podcast_detail_total_size", comment: "")
        static let lastChecked = NSLocalizedString("archived_podcast_detail_last_checked", comment: "")
        static let downloadingEpisode = NSLocalizedString("archived_podcast_detail_downloading_episode", comment: "")
        static let availableOffline = NSLocalizedString("archived_podcast_detail_available_offline", comment: "")
        static let filter = NSLocalizedString("archived_podcast_detail_filter", comment: "")
        static let downloadSummaryMessageSingleEpisode = NSLocalizedString("archived_podcast_detail_download_summary_message_single_episode", comment: "")
        static let downloadSummaryMessageMultipleEpisodes = NSLocalizedString("archived_podcast_detail_download_summary_message_multiple_episodes", comment: "")
        static let unknownTotalSize = NSLocalizedString("archived_podcast_detail_unknown_total_size", comment: "")
        static let unknownLastCheckedDate = NSLocalizedString("archived_podcast_detail_unknown_last_checked_date", comment: "")
        
        struct Export {
            
            static let exportAllButtonLabel = NSLocalizedString("archived_podcast_detail_export_all_button_label", comment: "")
            static let exportOptionsText = NSLocalizedString("archived_podcast_detail_export_options_text", comment: "")
            
            struct Options {
                
                static let filesApp = NSLocalizedString("archived_podcast_detail_export_options_files_option_name", comment: "")
                static let other = NSLocalizedString("archived_podcast_detail_export_options_other_option_name", comment: "")
                
            }
            
            static let exportedFileNameSingleEpisode = NSLocalizedString("archived_podcast_detail_exported_file_name_single_episode", comment: "")
            static let exportedFileNameMultipleEpisodes = NSLocalizedString("archived_podcast_detail_exported_file_name_multiple_episodes", comment: "")
            
        }
        
    }
    
    struct Settings {
        
        static let title = NSLocalizedString("settings_screen_title", comment: "")
        
        struct AddPodcast {
            
            static let sectionHeader = NSLocalizedString("settings_screen_add_podcast_section_header", comment: "")
            static let skipGetLinkInstructions = NSLocalizedString("settings_screen_add_podcast_skip_get_link_instructions_label", comment: "")
            
            struct WhenAdding {
                
                static let optionLabel = NSLocalizedString("settings_screen_when_adding_option_label", comment: "")
                static let previewFirstOption = NSLocalizedString("settings_screen_when_adding_preview_first_option", comment: "")
                static let justAddToArchiveOption = NSLocalizedString("settings_screen_when_adding_just_add_to_archive_option", comment: "")
                static let addAndDownloadAllEpisodesOption = NSLocalizedString("settings_screen_when_adding_add_and_download_all_episodes_option", comment: "")
                
            }
            
        }
        
        struct ArchivedPodcast {
            
            static let sectionHeader = NSLocalizedString("settings_screen_archived_podcast_section_header", comment: "")
            static let displayEpisodeArtworkOption = NSLocalizedString("settings_screen_archived_podcast_display_episode_artwork_option", comment: "")
            static let sectionFooter = NSLocalizedString("settings_screen_archived_podcast_section_footer", comment: "")
            
        }
        
        struct TipJar {
            
            static let sectionHeader = NSLocalizedString("settings_screen_tip_jar_section_header", comment: "")
            
        }
        
        struct Feedback {
            
            static let sectionHeader = NSLocalizedString("settings_screen_feedback_section_header", comment: "")
            static let reportABugButtonLabel = NSLocalizedString("settings_screen_feedback_section_report_a_bug_button_label", comment: "")
            static let reportATranslationErrorButtonLabel = NSLocalizedString("settings_screen_feedback_section_report_a_translation_error_button_label", comment: "")
            static let sectionFooter = NSLocalizedString("settings_screen_feedback_section_footer", comment: "")
            
        }
        
    }

}
