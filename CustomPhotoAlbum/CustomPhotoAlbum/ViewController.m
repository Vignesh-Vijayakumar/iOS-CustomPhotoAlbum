//
//  ViewController.m
//  CustomPhotoAlbum
//
//  Created by Skybridge Infotech on 09/06/17.
//  Copyright © 2017 VV. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AlbumListViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UITextField *albumNameTextField;

@end

@implementation ViewController

#pragma mark - View Controller Delegate Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.popupView.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Class Local Methods
-(bool)checkIsAlbumAlreadyExist:(NSString*)albumName
{
    __block PHAssetCollection *collection;
    
    // Find the album
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", albumName];
    collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                          subtype:PHAssetCollectionSubtypeAny
                                                          options:fetchOptions].firstObject;
    // Create the album
    if (collection)
    {
        return true;
    }
    
    return false;
}

-(void)createAlbum:(NSString*)albumName
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *createAlbum = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
        [createAlbum placeholderForCreatedAssetCollection];
    } completionHandler:nil];
}

-(void)customizedAlertBox:(NSString*)titleText MessageText:(NSString*)messageText
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:titleText
                                 message:messageText
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    
                                    
                                    
                                }];
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - View Controller Button Actions
- (IBAction)createAlbumButtonAction:(id)sender {
    
    self.popupView.hidden = NO;
    
}

- (IBAction)showAlbumButtonAction:(id)sender {
    
    AlbumListViewController *albumListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumListVCID"];
    [self.navigationController pushViewController:albumListVC animated:YES];
    
}

- (IBAction)popupCancelButtonAction:(id)sender {
    
    self.popupView.hidden = YES;
    
}

- (IBAction)popupSaveButtonAction:(id)sender {
    
    @try {
        
        if(self.albumNameTextField.text != nil && ![self.albumNameTextField.text isEqualToString:@""])
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                switch (status) {
                    case PHAuthorizationStatusAuthorized:
                        
                        if(![self checkIsAlbumAlreadyExist:self.albumNameTextField.text])
                        {
                            [self createAlbum:self.albumNameTextField.text];
                        }
                        else
                        {
                            [self customizedAlertBox:self.albumNameTextField.text MessageText:@"Already Exist"];
                        }
                        
                        break;
                    case PHAuthorizationStatusRestricted:
                        
                        break;
                    case PHAuthorizationStatusDenied:
                        
                        break;
                    default:
                        break;
                }
            }];
            
            self.popupView.hidden = YES;
        }
        else
        {
            [self customizedAlertBox:nil MessageText:@"Album name shouldn't be empty."];
        }
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}

#pragma mark - TextView Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    @try {
        
        if ([textField.text isEqualToString:@""] || [[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
        {
            [textField setText:@""];
            
            if([textField isEqual:self.albumNameTextField])
            {
                textField.placeholder = @"Enter Album Name";
            }
            
        }
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    @try {
        
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        [self.albumNameTextField resignFirstResponder];
        
        return YES;
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

@end
