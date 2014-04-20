//
//  YCScanContactViewController.m
//  YContacts
//
//  Created by Weiwei Shi on 4/20/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import "YCScanContactViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface YCScanContactViewController () <ABNewPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;
@property (nonatomic, assign) ABAddressBookRef addressBook;

-(BOOL)startReading;
-(void)stopReading;
-(void)loadBeepSound;

@end

@implementation YCScanContactViewController

@synthesize viewPreview = _viewPreview;
@synthesize captureSession = _captureSession;
@synthesize videoPreviewLayer = _videoPreviewLayer;
@synthesize audioPlayer = _audioPlayer;
@synthesize isReading = _isReading;
@synthesize addressBook = _addressBook;

#pragma mark - view controller life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self startReading];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadBeepSound];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startReading];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self stopReading];
    [super viewDidAppear:animated];
}

#pragma mark - address book access

// Check the authorization status of our application for Address Book
-(void)checkAddressBookAccess
{
    switch (ABAddressBookGetAuthorizationStatus())
    {
            // Update our UI if the user has granted access to their Contacts
        case  kABAuthorizationStatusAuthorized:
            [self accessGrantedForAddressBook];
            break;
            // Prompt the user for access to Contacts if there is no definitive answer
        case  kABAuthorizationStatusNotDetermined :
            [self requestAddressBookAccess];
            break;
            // Display a message if the user has denied or restricted access to Contacts
        case  kABAuthorizationStatusDenied:
        case  kABAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                            message:@"Permission was not granted for Contacts."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

// Prompt the user for access to their Address Book data
-(void)requestAddressBookAccess
{
    YCScanContactViewController * __weak weakSelf = self;
    
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error)
                                             {
                                                 if (granted)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [weakSelf accessGrantedForAddressBook];
                                                         
                                                     });
                                                 }
                                             });
}

// This method is called when the user has granted access to their address book data.
-(void)accessGrantedForAddressBook
{
    // Load data from the plist file
}

#pragma mark - QR code scan

-(void)loadBeepSound
{
    // Get the path to the beep.mp3 file and convert it to a NSURL object.
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    
    NSError *error;
    
    // Initialize the audio player object using the NSURL object previously set.
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    } else {
        // If the audio player was successfully initialized then load it in memory.
        [_audioPlayer prepareToPlay];
    }
}

- (BOOL)startReading
{
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    
    return YES;
}

-(void)stopReading
{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)    captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
          fromConnection:(AVCaptureConnection *)connection
{
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
            _isReading = NO;
            
            // If the audio player is not nil, then play the sound effect.
            if (_audioPlayer) {
                [_audioPlayer play];
            }
            
            // show add contact view
            [self performSelectorOnMainThread:@selector(showUnknownPersonViewController) withObject:nil waitUntilDone:NO];
        }
    }
}

#pragma mark - address book UI

-(void)showUnknownPersonViewController
{
	ABRecordRef aContact = ABPersonCreate();
	CFErrorRef anError = NULL;
	ABMultiValueRef email = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	bool didAdd = ABMultiValueAddValueAndLabel(email, @"John-Appleseed@mac.com", kABOtherLabel, NULL);
	
	if (didAdd == YES)
	{
		ABRecordSetValue(aContact, kABPersonEmailProperty, email, &anError);
		if (anError == NULL)
		{
			ABUnknownPersonViewController *picker = [[ABUnknownPersonViewController alloc] init];
			picker.unknownPersonViewDelegate = self;
			picker.displayedPerson = aContact;
			picker.allowsAddingToAddressBook = YES;
		    picker.allowsActions = YES;
			picker.alternateName = @"John Appleseed";
			picker.title = @"John Appleseed";
			picker.message = @"Company, Inc";
			
			[self.navigationController pushViewController:picker animated:YES];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
															message:@"Could not create unknown user"
														   delegate:nil
												  cancelButtonTitle:@"Cancel"
												  otherButtonTitles:nil];
			[alert show];
		}
	}
	CFRelease(email);
	CFRelease(aContact);
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView
       didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Dismisses the picker when users are done creating a contact or adding the displayed person properties to an existing contact.
- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView
                 didResolveToPerson:(ABRecordRef)person
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Does not allow users to perform default actions such as emailing a contact, when they select a contact property.
- (BOOL)unknownPersonViewController:(ABUnknownPersonViewController *)personViewControlle
shouldPerformDefaultActionForPerson:(ABRecordRef)person
                           property:(ABPropertyID)property
                         identifier:(ABMultiValueIdentifier)identifier
{
	return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
