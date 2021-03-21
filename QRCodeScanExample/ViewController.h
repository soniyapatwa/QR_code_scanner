//
//  ViewController.h
//  QRCodeScanExample
//
//  Created by Soniya Patwa on 07/09/18.
//  Copyright © 2018 myOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;


- (IBAction)startStopReading:(id)sender;

-(BOOL)startReading;
-(void)stopReading;
//-(void)loadBeepSound;

@end

