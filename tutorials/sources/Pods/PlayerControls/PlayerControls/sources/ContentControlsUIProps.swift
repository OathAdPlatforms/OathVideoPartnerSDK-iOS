//  Copyright 2018, Oath Inc.
//  Licensed under the terms of the MIT License. See LICENSE.md file in project root for terms.

import Foundation
import SafariServices

extension DefaultControlsViewController {
    struct UIProps {
        var loading: Bool
        var controlsViewHidden: Bool
        
        var playButtonHidden: Bool
        var playButtonAction: Command
        
        var pauseButtonHidden: Bool
        var pauseButtonAction: Command
        
        var replayButtonHidden: Bool
        var replayButtonAction: Command
        
        var nextButtonHidden: Bool
        var nextButtonAction: Command
        var nextButtonEnabled: Bool
        
        var prevButtonHidden: Bool
        var prevButtonAction: Command
        var prevButtonEnabled: Bool
        
        var seekerViewHidden: Bool
        var seekerViewCurrentTimeText: String
        var seekerViewCurrentTime: Int
        var seekerViewProgress: CGFloat
        var seekerViewBuffered: CGFloat
        var seekerViewAccessibilityLabel: String
        var seekerViewCuePoints: [Props.Progress]
        
        var seekerViewCurrentTimeColor: Color?
        var seekerViewProgressColor: Color?
        var seekerViewBufferedColor: Color?
        var seekerViewCuePointsColor: Color?
        var seekerViewFillerColor: Color?
        var seekerViewDurationColor: Color?
        var seekerViewDragControlColor: Color?
        
        var startSeekAction: CommandWith<Props.Progress>
        var updateSeekAction: CommandWith<Props.Progress>
        var stopSeekAction: CommandWith<Props.Progress>
        var seekToSecondsAction: CommandWith<Int>
        var seekBackButtonHidden: Bool
        var seekForwardButtonHidden: Bool
        
        var bottomItemsHidden: Bool
        var sideBarViewHidden: Bool
        
        var compasBodyViewHidden: Bool
        var compasDirectionViewHidden: Bool
        var compasDirectionViewTransform: CGAffineTransform
        var updateCameraAngles: CommandWith<CGPoint>
        var resetCameraAngles: Command
        var cameraPanGestureIsEnabled: Bool
        var compassViewBelowLive: Bool
        
        var videoTitleLabelHidden: Bool
        var videoTitleLabelText: String
        
        var durationTextLabelAccessibilityLabel: String
        var durationTextHidden: Bool
        var durationTextLabelText: String
        
        var thumbnailImageViewHidden: Bool
        var thumbnailImageUrl: URL?
        var thumbnailImage: UIImage?
        
        var errorLabelHidden: Bool
        var errorLabelText: String
        var retryButtonHidden: Bool
        var retryButtonAction: Command
        
        var pipButtonHidden: Bool
        var pipButtonEnabled: Bool
        var pipButtonAction: Command
        
        var settingsButtonHidden: Bool
        var settingsButtonEnabled: Bool
        var settingsButtonAction: Command
        
        var airplayActiveLabelHidden: Bool
        var airplayButtonHidden: Bool
        
        var liveIndicationViewIsHidden: Bool
        var liveDotColor: UIColor?
        
        var animationsEnabled: Bool
        var contentFullScreenAction: Command
        
        var isBrandedContentHidden: Bool
        var isBrandedContentClickable: Bool
        var brandedContentTitle: String
        var brandedContentCommand: CommandWith<SFSafariViewControllerDelegate>?
        
        //swiftlint:disable function_body_length
        //swiftlint:disable cyclomatic_complexity
        init(props: Props, controlsViewVisible: Bool) {
             let controlsHidden: Bool = {
                let isPlayerAbsent = props.player == nil
                let isControlsViewHidden = !controlsViewVisible
                let isAirPlayInactive = !(props.player?.item.playable?.airplay.isActive ?? false)
                
                return isPlayerAbsent || (isControlsViewHidden && isAirPlayInactive)
            }()
            controlsViewHidden = controlsHidden
            
            loading = props.player?.item.playable?.loading ?? false
            
            playButtonHidden = {
                let emptyPlaybackAcion = props.player?.item.playable?.playbackAction.play == nil
                let thumbnailHidden = props.player?.item.playable?.thumbnail?.url == nil
                return (emptyPlaybackAcion || controlsHidden) && thumbnailHidden
            }()
            
            playButtonAction = props.player?.item.playable?.playbackAction.play ?? .nop
            
            pauseButtonHidden = props.player?.item.playable?.playbackAction.pause == nil || controlsHidden
            
            pauseButtonAction = props.player?.item.playable?.playbackAction.pause ?? .nop
            
            replayButtonHidden = {
                guard props.player?.item.playable?.playbackAction.replay != nil else { return true }
                guard let playlist = props.player?.playlist else { return false }
                return playlist.next != nil
            }()
            
            replayButtonAction = props.player?.item.playable?.playbackAction.replay ?? .nop
            
            nextButtonEnabled = props.player?.playlist?.next != nil || controlsHidden
            
            nextButtonAction = props.player?.playlist?.next ?? .nop
            
            prevButtonEnabled = props.player?.playlist?.prev != nil || controlsHidden
            
            prevButtonAction = props.player?.playlist?.prev ?? .nop
            
            let nextButtonDisabled = !nextButtonEnabled
            let prevButtonDisabled = !prevButtonEnabled
            
            prevButtonHidden = (nextButtonDisabled && prevButtonDisabled) || controlsHidden
            
            nextButtonHidden = (nextButtonDisabled && prevButtonDisabled) || controlsHidden
            
            seekerViewHidden = props.player?.item.playable?.seekbar == nil || controlsHidden
            
            durationTextLabelAccessibilityLabel = {
                guard let duration = props.player?.item.playable?.seekbar?.duration else { return "" }
                return TimeFormatter.voiceOverReadable(from: duration) ?? ""
            }()
            
            durationTextHidden = props.player?.item.playable?.seekbar == nil || controlsHidden
            
            durationTextLabelText = {
                guard let seekbar = props.player?.item.playable?.seekbar else { return "" }
                return TimeFormatter.string(from: seekbar.duration)
            }()
            
            seekBackButtonHidden = props.player?.item.playable?.seekbar?.seeker.seekTo == nil || controlsHidden
            
            seekForwardButtonHidden = props.player?.item.playable?.seekbar?.seeker.seekTo == nil || controlsHidden
            
            seekToSecondsAction = props.player?.item.playable?.seekbar?.seeker.seekTo ?? .nop
            
            seekerViewAccessibilityLabel = {
                guard let duration = props.player?.item.playable?.seekbar?.duration else { return "" }
                guard let currentTime = props.player?.item.playable?.seekbar?.currentTime else { return "" }
                guard let currentTimeString = TimeFormatter.voiceOverReadable(from: currentTime) else { return "" }
                guard let durationString =  TimeFormatter.voiceOverReadable(from: duration) else { return "" }
                return "Current position \(currentTimeString) of \(durationString))"
            }()
            
            startSeekAction = props.player?.item.playable?.seekbar?.seeker.state.start ?? .nop
            
            updateSeekAction = props.player?.item.playable?.seekbar?.seeker.state.update ?? .nop
            
            stopSeekAction = props.player?.item.playable?.seekbar?.seeker.state.stop ?? .nop
            
            seekerViewCurrentTimeText = {
                guard let seekbar = props.player?.item.playable?.seekbar else { return "" }
                return TimeFormatter.string(from: seekbar.currentTime)
            }()
            
            seekerViewCurrentTime = props.player?.item.playable?.seekbar?.currentTime ?? 0
            
            seekerViewProgress = CGFloat(props.player?.item.playable?.seekbar?.progress.value ?? 0)
            
            seekerViewBuffered = CGFloat(props.player?.item.playable?.seekbar?.buffered.value ?? 0)
            
            seekerViewCuePoints = props.player?.item.playable?.seekbar?.seeker.cuePoints ?? []
            
            seekerViewCurrentTimeColor = props.player?.item.playable?.seekbar?.seekbarColors?.currentTimeColor
            
            seekerViewProgressColor = props.player?.item.playable?.seekbar?.seekbarColors?.progressColor
            
            seekerViewBufferedColor = props.player?.item.playable?.seekbar?.seekbarColors?.bufferedColor
            
            seekerViewFillerColor = props.player?.item.playable?.seekbar?.seekbarColors?.fillerColor
            
            seekerViewCuePointsColor = props.player?.item.playable?.seekbar?.seekbarColors?.cuePointsColor
            
            seekerViewDragControlColor = props.player?.item.playable?.seekbar?.seekbarColors?.dragControlColor
            
            bottomItemsHidden = {
                guard let playable = props.player?.item.playable else { return false }
                let hasNoTitle = playable.title.count == 0
                let hasNoSettings = playable.settings.isHidden
                let hasNoPipButton = playable.pictureInPictureControl.isUnsupported
                let hasNoAirplayButton = playable.airplay.isHidden
                return (hasNoTitle && hasNoSettings && hasNoPipButton && hasNoAirplayButton) || controlsHidden
            }()
            
            sideBarViewHidden = (props.player?.item.playable?.sideBarViewHidden ?? true) || controlsHidden
            
            compasBodyViewHidden = props.player?.item.playable?.camera == nil || controlsHidden
            
            compasDirectionViewHidden = props.player?.item.playable?.camera == nil || controlsHidden
            
            compasDirectionViewTransform = {
                guard let camera = props.player?.item.playable?.camera else { return CGAffineTransform.identity }
                return CGAffineTransform(rotationAngle: .init(-camera.angles.horizontal))
            }()
            
            updateCameraAngles = {
                guard let camera = props.player?.item.playable?.camera else { return .nop }
                return camera.moveTo.map { translation in
                    var angles = camera.angles
                    angles.horizontal += Float(translation.x) * 0.01
                    angles.vertical += Float(translation.y) * 0.01
                    return angles
                }
            }()
            
            resetCameraAngles = {
                guard let camera = props.player?.item.playable?.camera else { return .nop }
                return camera.moveTo.bind(to: .init(horizontal: 0.0, vertical: 0.0))
            }()
            
            cameraPanGestureIsEnabled = props.player?.item.playable?.camera != nil || controlsHidden
            
            videoTitleLabelHidden = props.player?.item.playable == nil || controlsHidden
            
            videoTitleLabelText = props.player?.item.playable?.title ?? ""
            
            thumbnailImageViewHidden = props.player?.item.playable?.thumbnail?.url == nil
            
            thumbnailImageUrl = props.player?.item.playable?.thumbnail?.url
            
            thumbnailImage = props.player?.item.playable?.thumbnail?.image
            
            errorLabelText = props.player?.item.nonplayable ?? props.player?.item.playable?.error?.message ?? ""
            
            errorLabelHidden = (props.player?.item.nonplayable == nil) && (props.player?.item.playable?.error == nil)
            
            retryButtonHidden = props.player?.item.playable?.error == nil
            
            retryButtonAction = props.player?.item.playable?.error?.retryAction ?? .nop
            
            pipButtonHidden = (props.player?.item.playable?.pictureInPictureControl.isUnsupported ?? true) || controlsHidden
            
            pipButtonEnabled = props.player?.item.playable?.pictureInPictureControl.possible != nil
            
            pipButtonAction = props.player?.item.playable?.pictureInPictureControl.possible ?? .nop
            
            settingsButtonHidden = (props.player?.item.playable?.settings.isHidden ?? true) || controlsHidden
            
            settingsButtonEnabled = props.player?.item.playable?.settings.enabled != nil
            
            settingsButtonAction = props.player?.item.playable?.settings.enabled ?? .nop
            
            airplayActiveLabelHidden = !(props.player?.item.playable?.airplay.isActive ?? false)
            airplayButtonHidden = (props.player?.item.playable?.airplay.isHidden ?? true) || controlsHidden
            
            liveIndicationViewIsHidden = props.player?.item.playable?.live.isHidden ?? true
            
            liveDotColor = props.player?.item.playable?.live.dotColor?.color ?? nil
            
            animationsEnabled = props.player?.item.playable?.animationsEnabled ?? false
            
            compassViewBelowLive = {
                guard
                    props.player?.item.playable?.camera != nil,
                    props.player?.item.playable?.live.isHidden == false
                    else { return false }
                return true
            }()
            
            contentFullScreenAction = props.player?.item.playable?.contentFullScreen ?? .nop
            
            isBrandedContentHidden = props.player?.item.playable?.brandedContent == nil
            
            isBrandedContentClickable = props.player?.item.playable?.brandedContent?.action != nil
            
            brandedContentTitle = props.player?.item.playable?.brandedContent?.advertisementText ?? ""
            
            brandedContentCommand = props.player?.item.playable?.brandedContent?.action ?? .nop
        }
    }
}
