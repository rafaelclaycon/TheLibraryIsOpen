import Foundation

struct LocalizableStrings {

    // General

    static let episode = NSLocalizedString("episode", comment: "")
    static let episodes = NSLocalizedString("episodes", comment: "")
    static let cancel = NSLocalizedString("cancel", comment: "")
    
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
        
    }
    
    struct PodcastPreview {
        
        static let episodeList = NSLocalizedString("podcast_preview_episode_list", comment: "");
        static let groupedByYear = NSLocalizedString("podcast_preview_grouped_by_year", comment: "");
        static let selectAll = NSLocalizedString("podcast_preview_select_all", comment: "");
        static let unselectAll = NSLocalizedString("podcast_preview_unselect_all", comment: "");
        static let mostRecentFirst = NSLocalizedString("podcast_preview_most_recent_first", comment: "");
        static let oldestFirst = NSLocalizedString("podcast_preview_oldest_first", comment: "");
        static let downloadEpisodesButtonTitle = NSLocalizedString("podcast_preview_download_episodes_button_title", comment: "");
        
    }

}
