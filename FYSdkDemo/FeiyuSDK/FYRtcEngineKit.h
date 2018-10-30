//
//  FYRtcEngineKit.h
//  FyCloud
//
//  Created by zhangyusheng on 2017/8/17.
//  Copyright © 2017年 feiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FYErrorCode) {
    FYErrorMicrophonePermissionDenied = 200010,
    FYErrorCallAnswer = 200012,
    FYErrorCallOutgoing = 200013,
    FYErrorCallEnd = 200014,
    FYErrorSendDtmf = 200015,
    
    FYErrorCallFailed = 201000,
    FYErrorCallDeclined = 201001,
    FYErrorCallNotOnline = 201002,
    FYErrorCallNotFound = 201003,
    FYErrorCallRequestTimeout = 201004,
    FYErrorCallBusyHere = 201005,
    FYErrorCallForbidden = 201006,
    FYErrorCallTemporarilyUnavailable = 201007,
    FYErrorCallIntervalTooBrief = 201008,
    FYErrorCallRequestTerminated = 201009,
    FYErrorCallServiceUnavailable = 201010,
    FYErrorCallNoAnswer = 201011,
    
    FYErrorJoinChannel = 202000,
    FYErrorMute = 202010,
    FYErrorSetRing = 202020,
    FYErrorDialPeer = 202030,
    FYErrorCalleePrepare = 202040,
    FYErrorDialPstn = 202050,
    FYErrorDialBack = 202060,
    FYErrorMonitor = 202070,
    FYErrorMemberRemove = 202080,
    FYErrorChannelDestroy = 202090,
    FYErrorInvite = 202010,
    FYErrorDial = 202110,
};


@interface FYError :NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString * _Nonnull msg;
@property (nonatomic, strong) id _Nullable data;
@end


@interface FYOptionData :NSObject
@property (nonatomic, assign) BOOL isRecord;
@property (nonatomic, assign) int maxDuration;
@property (nonatomic, copy) NSString * _Nullable extraData;
@end


@class FYRtcEngineKit;
#pragma mark - FYRtcEngineKitDelegate
@protocol FYRtcEngineKitDelegate <NSObject>
@optional

/**
 *  The error occurred in SDK. The SDK needs to handle it
 *
 *  @param engine    The engine kit
 *  @param error     FYError
 */
- (void)rtcEngine:(FYRtcEngineKit * _Nonnull)engine didError:(FYError * _Nonnull)error;

#pragma mark SDK channel delegates
/**
 *  Event of the local user joined the channel
 *
 *  @param engine    The engine kit
 *  @param channel   The channel id
 *  @param uid       The local user id
 */
- (void)rtcEngine:(FYRtcEngineKit * _Nonnull)engine didJoinChannel:(NSString * _Nonnull)channel uid:(NSString * _Nonnull)uid;

/**
 *  Event of the local user leave the channel
 *
 *  @param engine    The engine kit
 *  @param channel   The Channel id
 */
- (void)rtcEngine:(FYRtcEngineKit * _Nonnull)engine didLeaveChannel:(NSString * _Nonnull)channel;

/**
 *  Event of remote user joined
 *
 *  @param engine    The engine kit
 *  @param uid       The remote user id
 */
- (void)rtcEngine:(FYRtcEngineKit * _Nonnull)engine didJoinedOfUid:(NSString * _Nonnull)uid;

/**
 *  Event of remote user offlined
 *
 *  @param engine    The engine kit
 *  @param uid       The remote user id
 */
- (void)rtcEngine:(FYRtcEngineKit * _Nonnull)engine didOfflineOfUid:(NSString * _Nonnull)uid;

/**
 *  Event of remote user audio muted or unmuted
 *
 *  @param engine    The engine kit
 *  @param muted     Muted or unmuted
 *  @param uid       The remote user id
 */
- (void)rtcEngine:(FYRtcEngineKit * _Nonnull)engine didAudioMuted:(BOOL)muted uid:(NSString * _Nonnull)uid;

/**
 *  Event of monitor channel success
 *
 *  @param engine    The engine kit
 *  @param channel   The channel id
 *  @param uid       The local user id of monitor
 */
- (void)rtcEngine:(FYRtcEngineKit * _Nonnull)engine didMonitorSuccess:(NSString * _Nonnull)channel uid:(NSString * _Nonnull)uid;


#pragma mark SDK VoIP delegates
/**
 *  Event of call incoming
 *
 *  @param engine    The engine kit
 *  @param caller    The caller
 */
- (void)rtcEngine:(FYRtcEngineKit * _Nonnull)engine didCallIncomingWithCaller:(NSString * _Nonnull)caller;

/**
 *  Event of call outgoing
 *
 *  @param engine    The engine kit
 *  @param callee    The callee
 *  @param uid       The user id of caller
 */
- (void)rtcEngine:(FYRtcEngineKit * _Nonnull)engine didCallOutgoingWithCallee:(NSString * _Nonnull)callee uid:(NSString * _Nonnull)uid;

/**
 *  Event of call connected
 *
 *  @param engine    The engine kit
 */
- (void)rtcEngineDidCallConnect:(FYRtcEngineKit * _Nonnull)engine;

/**
 *  Event of call end
 *
 *  @param engine    The engine kit
 */
- (void)rtcEngineDidCallEnd:(FYRtcEngineKit * _Nonnull)engine;

/**
 *  Event of callee prepare success
 *
 *  @param engine    The engine kit
 */
- (void)rtcEngineDidCalleePrepareSuccess:(FYRtcEngineKit * _Nonnull)engine;

/**
 *  Event of callee prepare success
 *
 *  @param engine    The engine kit
 */
- (void)rtcEngine:(FYRtcEngineKit * _Nonnull)engine didDialBackSuccess:(NSString * _Nonnull)dialBackId;

/**
 *  Event of remote is received peer call
 *
 *  @param engine    The engine kit
 */
- (void)rtcEngineDidPeerCallReceived:(FYRtcEngineKit * _Nonnull)engine;
@end


#pragma mark - FYRtcEngineKit
@interface FYRtcEngineKit : NSObject
/**
 * Initializes the FYRtcEngineKit.
 *
 * @param appId     The appId is issued to the application developers by Feiyu Cloud.
 * @param appToken  The appToken is issued to the application developers by Feiyu Cloud.
 * @param delegate  The FYRtcEngineKitDelegate
 *
 * @return FYRtcEngineKit
 */
+ (instancetype _Nonnull)sharedEngineWithAppId:(NSString * _Nonnull)appId
                             appToken:(NSString * _Nonnull)appToken
                             delegate:(id<FYRtcEngineKitDelegate> _Nullable)delegate;

/**
 * Get the version of Feiyu cloud.
 *
 * @return string, sdk version
 */
+ (NSString * _Nonnull)version;

/**
 * Create an open UDP socket to the FYRtcEngineKit cloud service to join a channel.
 * Users in the same channel can talk to each other with same appId.
 * Users using different appID cannot call each other.
 *
 * @param channelId  Joining in the same channel indicates those clients have entered in one room.
 * @param uid        Optional, this argument is the unique ID for each member in one channel.
 * If not specified, set to nil, the SDK automatically allocates an ID, and the id could be gotten in join Channel success call back.
 * @param option      Add optional options (isRecord/maxDuration/extraData)
 */
- (void)joinChannel:(NSString * _Nonnull)channelId uid:(NSString * _Nullable)uid option:(FYOptionData * _Nullable)option;

/**
 * Create an open UDP socket to the FYRtcEngineKit cloud service to call remote FYRtcEngineKit cloud client.
 * Users using different appId cannot call each other.
 *
 * @param calleeUid    callee's user id
 * @param uid          Optional, this argument is the unique ID for caller in a call.
 * If not specified, or set to nil, the SDK automatically allocates an ID, and the id could be gotten in outgoingCall or callConnect
 * @param option      Add optional options (isRecord/maxDuration/extraData)
 */
- (void)dialPeer:(NSString * _Nonnull)calleeUid callerUid:(NSString * _Nullable)callerUid option:(FYOptionData * _Nullable)option;

/**
 * Create an open UDP socket to the FYRtcEngineKit cloud service to call PSTN number.
 * Users using different appId cannot call each other.
 *
 * @param calleeNumber    callee's phone number. the format is PSTN E164. eg. Chinese number: +86136********
 * @param uid             Optional, this argument is the unique ID for caller in a call.
 * If not specified, set to nil, the SDK automatically allocates an ID, and the id could be gotten in outgoingCall or callConnect event.
 * @param display         display number. the format is PSTN E164. eg. Chinese number: +86136********
 * @param option      Add optional options (isRecord/maxDuration/extraData)
 */
- (void)dialPstn:(NSString * _Nonnull)calleeNumber
       callerUid:(NSString * _Nullable)uid
         display:(NSString * _Nullable)display
          option:(FYOptionData * _Nullable)option;

/**
 * Create a dialBack. Call the callee succeed then call callerNumber.
 *
 * @param calleeNumber       callee's phone number. the format is PSTN E164. eg. Chinese number: +86136********
 * @param calleeDisplay      display number. the format is PSTN E164. eg. Chinese number: +86136********
 * @param callerNumber       caller's phone number. the format is PSTN E164. eg. Chinese number: +86136********
 * @param callerDisplay      display number. the format is PSTN E164. eg. Chinese number: +86136********
 * @param option         Add optional options (isRecord/maxDuration/extraData)
 */
- (void)dialBack:(NSString * _Nonnull)calleeNumber
   calleeDisplay:(NSString * _Nullable)calleeDisplay
    callerNumber:(NSString * _Nonnull)callerNumber
   callerDisplay:(NSString * _Nullable)callerDisplay
          option:(FYOptionData * _Nullable)option;

/**
 * prepare receive dialPeer call when client as callee.
 *
 * @param calleeUid    this argument is the unique ID for callee in a call.
 */
- (void)calleePrepare:(NSString * _Nonnull)uid;

/**
 * lets the user leave a channel, i.e., hanging up or exiting a call.
 * After joining a channel, the user must call the leaveChannel method to end the call before joining another one.
 */
- (void)leaveChannel;

/**
 * hanging up or exiting a call.
 */
- (void)endCall;

/**
 * answer call
 */
- (void)answerCall;

/**
 * Send the specified dtmf.
 * The dtmf is automatically played to the user.
 *
 * @param dtmf The dtmf name specified as a char, must be ’0’,’1’,’2’,’3’,’4’,’5’,’6’,’7’,’8’,’9’,’#’,’*’
 **/
- (void)sendDtmf:(char)dtmf;

/**
 * Mutes / Unmutes audio with uid.
 *
 * @param uid
 * @param channelId Channel Id
 * @param mute YES: Mutes all remote received audio. NO: Unmutes all remote received audio.
 */
- (void)muteAudio:(NSString * _Nonnull)uid channelId:(NSString * _Nonnull)channelId mute:(BOOL)mute;

/**
 * Mutes / Unmutes other remote audio without uid
 *
 * @param uid
 * @param channelId Channel Id
 * @param mute YES: Mutes other received audio. NO: Unmutes other received audio.
 */
- (void)muteOtherAudio:(NSString * _Nonnull)uid channelId:(NSString * _Nonnull)channelId mute:(BOOL)mute;

/**
 * Mutes / Unmutes all audio.
 *
 * @param channelId Channel Id
 * @param mute YES: Mutes all remote received audio. NO: Unmutes all remote received audio.
 */
- (void)muteAllAudio:(NSString * _Nonnull)channelId mute:(BOOL)mute;

/**
 * Mutes / Unmutes local audio.
 *
 * @param mute YES: Mutes the local audio. NO: Unmutes the local audio.
 */
- (void)muteLocalAudio:(BOOL)mute;

/**
 * Enable / Disable speaker of device
 *
 * @param enable YES: Switches to speakerphone. NO: Switches to headset.
 */
- (void)enableSpeaker:(BOOL)enable;

/**
 * Sets the path to a wav file used for ringing. The file must be a wav 16bit linear. Local ring is disabled if null.
 *
 * @param path The path to a wav file to be used for ringing
 **/
- (void)setRing:(NSString * _Nullable)path;

/**
 * Specifies the SDK output log file.
 *
 * @param path The full file path of the log file.
 */
+ (void)setLogfile:(NSString * _Nullable)path;

/**
 * Specifies the SDK output log filter.
 *
 * @param filter 0: close log, 1: just lib log, 2: all log.
 */
+ (void)setLogFilter:(int)filter;


- (void)startMonitor:(NSString * _Nonnull)channelId uid:(NSString * _Nullable)uid;
- (void)stopMonitor;
- (void)removeChannelMumber:(NSString * _Nonnull)uid channelId:(NSString * _Nonnull)channelId;
- (void)destroyChannel:(NSString * _Nonnull)channelId;

// add for pbx
- (void)dial:(NSString * _Nonnull)callee
      callId:(NSString * _Nonnull)callId
callerVosUid:(NSString * _Nonnull)vosUid
callerVosPwd:(NSString * _Nonnull)vosPwd
  enableOpus:(BOOL)enable;

// add for totalk
- (void)dialPstn:(NSString * _Nonnull)calleeNumber
       callerUid:(NSString * _Nullable)uid
         display:(NSString * _Nullable)display
          option:(FYOptionData * _Nullable)option
      enableOpus:(BOOL)enable;

@end
