import Foundation

struct LocalizableStrings {

    // General

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
        
    }
    
    struct InstructionsAView {
        
        static let title = NSLocalizedString("instructions_a_view_title", comment: "")
        static let applePodcastsStep1 = NSLocalizedString("instructions_a_view_apple_podcasts_step1", comment: "")
        static let applePodcastsStep2 = NSLocalizedString("instructions_a_view_apple_podcasts_step2", comment: "")
        static let applePodcastsStep3 = NSLocalizedString("instructions_a_view_apple_podcasts_step3", comment: "")
        static let applePodcastsStep4 = NSLocalizedString("instructions_a_view_apple_podcasts_step4", comment: "")
        static let applePodcastsStep5 = NSLocalizedString("instructions_a_view_apple_podcasts_step5", comment: "")
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
        
    }
    
    struct ArchivedPodcastDetail {
        
        static let totalSize = NSLocalizedString("archived_podcast_detail_total_size", comment: "")
        static let lastChecked = NSLocalizedString("archived_podcast_detail_last_checked", comment: "")
        static let downloadingEpisode = NSLocalizedString("archived_podcast_detail_downloading_episode", comment: "")
        static let availableOffline = NSLocalizedString("archived_podcast_detail_available_offline", comment: "")
        static let exportButtonLabel = NSLocalizedString("archived_podcast_detail_export_button_label", comment: "")
        static let exportOptionsText = NSLocalizedString("archived_podcast_detail_export_options_text", comment: "")
        
    }
    
    struct Settings {
        
        static let title = NSLocalizedString("settings_screen_title", comment: "")
        
        struct AddPodcast {
            
            static let sectionHeader = NSLocalizedString("settings_screen_add_podcast_section_header", comment: "")
            static let whenAddingOptionLabel = NSLocalizedString("settings_screen_when_adding_option_label", comment: "")
            static let whenAddingPreviewFirstOption = NSLocalizedString("settings_screen_when_adding_preview_first_option", comment: "")
            static let whenAddingJustAddToArchiveOption = NSLocalizedString("settings_screen_when_adding_just_add_to_archive_option", comment: "")
            static let whenAddingAddAndDownloadAllEpisodesOption = NSLocalizedString("settings_screen_when_adding_add_and_download_all_episodes_option", comment: "")
            
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
