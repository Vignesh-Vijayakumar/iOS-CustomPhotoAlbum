//
//  AlbumListViewController.m
//  CustomPhotoAlbum
//
//  Created by Skybridge Infotech on 09/06/17.
//  Copyright © 2017 VV. All rights reserved.
//

#import "AlbumListViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AlbumTableViewCell.h"

@interface AlbumListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property NSMutableArray *albumNameArray;
@property (weak, nonatomic) IBOutlet UITableView *albumListTableView;

@end

@implementation AlbumListViewController

#pragma mark - View Controller Delegate Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @try {
        
        self.albumNameArray = [[NSMutableArray alloc]init];
        
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        
        for (NSInteger i =0; i < smartAlbums.count; i++) {
            PHAssetCollection *assetCollection = smartAlbums[i];
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            
            NSLog(@"sub album title is %@, count is %ld", assetCollection.localizedTitle, assetsFetchResult.count);
            
            [self.albumNameArray addObject:assetCollection.localizedTitle];
            
            if (assetsFetchResult.count > 0) {
                /*for (PHAsset *asset in assetsFetchResult) {
                 //you have got your image type asset.
                 }*/
            }
        }
        
        self.albumListTableView.dataSource = self;
        self.albumListTableView.delegate = self;
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.albumNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        
        static NSString *MyIdentifier = @"AlbumTableViewCellID";
        
        AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[AlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:MyIdentifier];
        }
        
        cell.backgroundColor = cell.contentView.backgroundColor;
        
        NSString *albumName = [self.albumNameArray objectAtIndex:indexPath.row];
        cell.albumName.text = albumName;
        
        
        return cell;
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
