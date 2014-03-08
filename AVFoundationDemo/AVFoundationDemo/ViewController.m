//
//  ViewController.m
//  AVFoundationDemo
//
//  Created by Weiwei Shi on 3/8/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *videoDevice;
@property (nonatomic, strong) AVCaptureInput *videoInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *frameOutput;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) CIContext *context;
@property (nonatomic, strong) CIDetector *faceDectector;

@property (nonatomic, strong) UIImageView *glasses;

@end

@implementation ViewController

@synthesize session = _session;
@synthesize videoDevice = _videoDevice;
@synthesize videoInput = _videoInput;
@synthesize frameOutput = _frameOutput;
@synthesize imageView = _imageView;

@synthesize context = _context;
@synthesize faceDectector = _faceDectector;

@synthesize glasses = _glasses;

- (CIContext *)context
{
    if (!_context) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

- (CIDetector *)faceDectector
{
    if (!_faceDectector) {
        NSDictionary *detectorOptions = [NSDictionary dictionaryWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
        _faceDectector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    }
    
    return _faceDectector;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPreset352x288;
    
    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil];
    
    self.frameOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.frameOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                                                 forKey:(id) kCVPixelBufferPixelFormatTypeKey];
    
    [self.session addInput:self.videoInput];
    [self.session addOutput:self.frameOutput];
    
    [self.frameOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    [self.session startRunning];
    
    self.glasses = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glasses.png"]];
    [self.glasses setHidden:YES];
    [self.view addSubview:self.glasses];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef pb = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pb];
    
    // filtering
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"];
    [filter setDefaults];
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:2.0] forKey:@"inputAngle"];
    
    CIImage *result = [filter valueForKey:@"outputImage"];
    
    // detect face
    NSArray *features = [self.faceDectector featuresInImage:result];
    
    BOOL faceFound = NO;
    
    for (CIFaceFeature *face in features) {
        if (face.hasLeftEyePosition && face.hasRightEyePosition) {
            CGPoint leftEye = face.leftEyePosition;
            CGPoint rightEye = face.rightEyePosition;
            
            CGPoint eyeCenter = CGPointMake((leftEye.x + rightEye.x) * 0.5, (leftEye.y + rightEye.y) * 0.5);
            double scalex = self.imageView.bounds.size.width / ciImage.extent.size.width;
            double scaley = self.imageView.bounds.size.height / ciImage.extent.size.height;
            
            self.glasses.center = CGPointMake(scaley * eyeCenter.y - self.glasses.bounds.size.height / 4.0, scalex * eyeCenter.x);
            
            double deltax = leftEye.x - rightEye.x;
            double deltay = leftEye.y - rightEye.y;
            double angle = atan2(deltax, deltay);
            
            self.glasses.transform = CGAffineTransformMakeRotation(angle + M_PI);
            
            double scale = 3.0 * sqrt(deltax * deltax + deltay * deltay);
            self.glasses.bounds = CGRectMake(0, 0, scale, scale);
            
            faceFound = YES;
            break;
        }
    }
    
    [self.glasses setHidden:!faceFound];
    
    CGImageRef ref = [self.context createCGImage:result fromRect:ciImage.extent];
    self.imageView.image = [UIImage imageWithCGImage:ref scale:1.0 orientation:UIImageOrientationRight];
    CGImageRelease(ref);
}

@end
