//
//  ViewController.m
//  QRCodeScanExample
//
//  Created by Soniya Patwa on 07/09/18.
//  Copyright © 2018 myOrganization. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _captureSession = nil;
    _isReading = NO;
    
    _viewPreview.layer.cornerRadius = 6;
    _viewPreview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewPreview.layer.borderWidth = 0.5;
    
    //[self loadBeepSound];
    
}

- (IBAction)startStopReading:(id)sender {
    if (!_isReading) {
        if ([self startReading]) {
            [_bbitemStart setTitle:@"Stop"];
            //[_lblStatus setText:@"Scanning for QR Code..."];
        }
    }
    else{
        [self stopReading];
        [_bbitemStart setTitle:@"Start!"];
    }
    
    _isReading = !_isReading;
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"Error with camera. %@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

//-(void)loadBeepSound{
//    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
//    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
//    NSError *error;
//
//    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
//    if (error) {
//        NSLog(@"Could not play beep file.");
//        NSLog(@"beeeppppp %@", [error localizedDescription]);
//    }
//    else{
//        [_audioPlayer prepareToPlay];
//    }
//}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            //[_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            _isReading = NO;
            
            if (_audioPlayer) {
                [_audioPlayer play];
            }
            
        }
    }
}

@end
