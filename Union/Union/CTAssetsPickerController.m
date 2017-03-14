
/*
 CTAssetsPickerController.m
 
 The MIT License (MIT)
 
 Copyright (c) 2013 Clement CN Tsang
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */


#import "CTAssetsPickerController.h"
#import "Macros.h"
#import "UIButton+Block.h"
#import "NSData+ImgType.h"
//#import "NSDate+TimeInterval.h"

#define IS_IOS7             ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define kThumbnailLength    ([[UIScreen mainScreen] bounds].size.width/4.f-2.f)
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)
#define kPopoverContentSize CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)


#pragma mark - Interfaces

@interface CTAssetsPickerController ()

@end


@interface CTAssetsGroupViewController : UITableViewController

@end


@interface CTAssetsGroupViewController()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;

@end


@interface CTAssetsViewController : UICollectionViewController

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end

@interface CTAssetsViewController ()

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;

@end


@interface CTAssetsGroupViewCell : UITableViewCell

- (void)bind:(ALAssetsGroup *)assetsGroup;

@end

@interface CTAssetsGroupViewCell ()

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end


@interface CTAssetsViewCell : UICollectionViewCell

- (void)bind:(ALAsset *)asset;

@end

@interface CTAssetsViewCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *videoImage;
@property CGRect rectInFullScreen;

@end


@interface CTAssetsSupplementaryView : UICollectionReusableView

@property (nonatomic, strong) UILabel *sectionLabel;

//- (void)setNumberOfPhotos:(NSInteger)numberOfPhotos numberOfVideos:(NSInteger)numberOfVideos;

@end


@interface CTAssetsSupplementaryView ()

@end






#pragma mark - CTAssetsPickerController


@implementation CTAssetsPickerController

- (id)init
{
    CTAssetsGroupViewController *groupViewController = [[CTAssetsGroupViewController alloc] init];
    
    if (self = [super initWithRootViewController:groupViewController])
    {
        _maximumNumberOfSelection   = NSIntegerMax;
        _assetsFilter               = [ALAssetsFilter allAssets];
        _showsCancelButton          = YES;
        
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            [self setContentSizeForViewInPopover:kPopoverContentSize];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end




#pragma mark - CTAssetsGroupViewController

@implementation CTAssetsGroupViewController


- (id)init
{
    if (self = [super initWithStyle:UITableViewStylePlain])
    {
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            [self setContentSizeForViewInPopover:kPopoverContentSize];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupButtons];
    [self localize];
    [self setupGroup];
}


#pragma mark - Setup

- (void)setupViews
{
    self.tableView.rowHeight = kThumbnailLength + 12;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //NSLog(@"frame :%@",NSStringFromCGRect(self.navigationController.navigationBar.frame));
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width,0)];
    self.tableView.tableHeaderView = headView;
}

- (void)setupButtons
{
    CTAssetsPickerController *picker = (CTAssetsPickerController *)self.navigationController;
    
    if (picker.showsCancelButton)
    {
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(dismiss:)];
    }
}

- (void)localize
{
    self.title = @"照片";
}

- (void)setupGroup
{
    if (!self.assetsLibrary)
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    
    if (!self.groups)
        self.groups = [[NSMutableArray alloc] init];
    else
        [self.groups removeAllObjects];
    
    CTAssetsPickerController *picker = (CTAssetsPickerController *)self.navigationController;
    ALAssetsFilter *assetsFilter = picker.assetsFilter;
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group)
        {
            [group setAssetsFilter:assetsFilter];
            
            if (group.numberOfAssets > 0)
                [self.groups addObject:group];
            
        }
        else
        {
            [self reloadData];
        }
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
        [self showNotAllowed];
        
    };
    
    // Enumerate Camera roll first
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    
    // Then all other groups
    NSUInteger type =
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}


#pragma mark - Reload Data

- (void)reloadData
{
    if (self.groups.count == 0)
        [self showNoAssets];
    
    [self.tableView reloadData];
}


#pragma mark - ALAssetsLibrary

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}


#pragma mark - Not allowed / No assets

- (void)showNotAllowed
{
    self.title              = nil;
    
    UIView *lockedView      = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *locked     = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CTAssetsPickerLocked"]];
    
    
    CGRect rect             = CGRectInset(self.view.bounds, 8, 8);
    UILabel *title          = [[UILabel alloc] initWithFrame:rect];
    UILabel *message        = [[UILabel alloc] initWithFrame:rect];
    
    title.text              = @"App没有获取相册的照片的权限";
    title.font              = [UIFont boldSystemFontOfSize:17.0];
    title.textColor         = [UIColor colorWithRed:129.0/255.0 green:136.0/255.0 blue:148.0/255.0 alpha:1];
    title.textAlignment     = NSTextAlignmentCenter;
    title.numberOfLines     = 5;
    
    message.text            = @"你可以在隐私设置中启用";
    message.font            = [UIFont systemFontOfSize:14.0];
    message.textColor       = [UIColor colorWithRed:129.0/255.0 green:136.0/255.0 blue:148.0/255.0 alpha:1];
    message.textAlignment   = NSTextAlignmentCenter;
    message.numberOfLines   = 5;
    
    [title sizeToFit];
    [message sizeToFit];
    
    locked.center           = CGPointMake(lockedView.center.x, lockedView.center.y - 40);
    title.center            = locked.center;
    message.center          = locked.center;
    
    rect                    = title.frame;
    rect.origin.y           = locked.frame.origin.y + locked.frame.size.height + 20;
    title.frame             = rect;
    
    rect                    = message.frame;
    rect.origin.y           = title.frame.origin.y + title.frame.size.height + 10;
    message.frame           = rect;
    
    [lockedView addSubview:locked];
    [lockedView addSubview:title];
    [lockedView addSubview:message];
    
    self.tableView.tableHeaderView  = lockedView;
    self.tableView.scrollEnabled    = NO;
}

- (void)showNoAssets
{
    UIView *noAssetsView    = [[UIView alloc] initWithFrame:self.view.bounds];
    
    CGRect rect             = CGRectInset(self.view.bounds, 10, 10);
    UILabel *title          = [[UILabel alloc] initWithFrame:rect];
    UILabel *message        = [[UILabel alloc] initWithFrame:rect];
    
    title.text              = @"没有照片";
    title.font              = [UIFont systemFontOfSize:26.0];
    title.textColor         = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    title.textAlignment     = NSTextAlignmentCenter;
    title.numberOfLines     = 5;
    
    message.text            = @"你可以从itunes同步照片";
    message.font            = [UIFont systemFontOfSize:18.0];
    message.textColor       = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    message.textAlignment   = NSTextAlignmentCenter;
    message.numberOfLines   = 5;
    
    [title sizeToFit];
    [message sizeToFit];
    
    title.center            = CGPointMake(noAssetsView.center.x, noAssetsView.center.y - 10 - title.frame.size.height / 2);
    message.center          = CGPointMake(noAssetsView.center.x, noAssetsView.center.y + 10 + message.frame.size.height / 2);
    
    [noAssetsView addSubview:title];
    [noAssetsView addSubview:message];
    
    self.tableView.tableHeaderView  = noAssetsView;
    self.tableView.scrollEnabled    = NO;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CTAssetsGroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[CTAssetsGroupViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell bind:[self.groups objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kThumbnailLength + 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTAssetsViewController *vc = [[CTAssetsViewController alloc] init];
    vc.assetsGroup = [self.groups objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (void)dismiss:(id)sender
{
    CTAssetsPickerController *picker = (CTAssetsPickerController *)self.navigationController;
    
    if ([picker.delegate respondsToSelector:@selector(assetsPickerControllerDidCancel:)])
        [picker.delegate assetsPickerControllerDidCancel:picker];
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end



#pragma mark - CTAssetsGroupViewCell

@implementation CTAssetsGroupViewCell


- (void)bind:(ALAssetsGroup *)assetsGroup
{
    self.assetsGroup            = assetsGroup;
    
    CGImageRef posterImage      = assetsGroup.posterImage;
    size_t height               = CGImageGetHeight(posterImage);
    float scale                 = height / kThumbnailLength;
    
    self.imageView.image        = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.textLabel.text         = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.detailTextLabel.text   = [NSString stringWithFormat:@"%ld",(long)[assetsGroup numberOfAssets]];
    self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
}

@end




#pragma mark - CTAssetsViewController

#define kAssetsViewCellIdentifier           @"AssetsViewCellIdentifier"
#define kAssetsSupplementaryViewIdentifier  @"AssetsSupplementaryViewIdentifier"

@implementation CTAssetsViewController

- (id)init
{
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                     = kThumbnailSize;
    layout.sectionInset                 = UIEdgeInsetsMake(9.0, 0, 0, 0);
    layout.minimumInteritemSpacing      = 2.0;
    layout.minimumLineSpacing           = 2.0;
    layout.footerReferenceSize          = CGSizeMake(0, 44.0);
    
    if (self = [super initWithCollectionViewLayout:layout])
    {
        self.collectionView.allowsMultipleSelection = YES;
        
        [self.collectionView registerClass:[CTAssetsViewCell class]
                forCellWithReuseIdentifier:kAssetsViewCellIdentifier];
        
        [self.collectionView registerClass:[CTAssetsSupplementaryView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                       withReuseIdentifier:kAssetsSupplementaryViewIdentifier];
        
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            [self setContentSizeForViewInPopover:kPopoverContentSize];
    }
    
    return self;
}

static bool goBottom = true;
- (void)viewDidLoad
{
    [super viewDidLoad];
    goBottom = true;
    [self setupViews];
    [self setupButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupAssets];
}

#pragma mark - Setup

- (void)setupViews
{
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)setupButtons
{
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(finishPickingAssets:)];
}

- (void)setupAssets
{
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    NSMutableArray *arrayTmp = [NSMutableArray array];
    
    [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset){
            if ([asset isKindOfClass:[ALAsset class]]) {
                [arrayTmp addObject:asset];
                
                NSString *type = [asset valueForProperty:ALAssetPropertyType];
                
                if ([type isEqual:ALAssetTypePhoto])
                    self.numberOfPhotos ++;
                if ([type isEqual:ALAssetTypeVideo])
                    self.numberOfVideos ++;
            }
        }else if (arrayTmp.count > 0){
            self.assets = [NSMutableArray arrayWithArray:arrayTmp];
            
            [self.collectionView reloadData];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assets.count-1 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionTop
                                                animated:YES];
        }
    }];
}


#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = kAssetsViewCellIdentifier;
    
    CTAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell bind:[self.assets objectAtIndex:indexPath.row]];
    
    if (goBottom) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assets.count-1 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionTop
                                            animated:YES];
        goBottom = false;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *viewIdentifiert = kAssetsSupplementaryViewIdentifier;
    
    CTAssetsSupplementaryView *view =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:viewIdentifiert forIndexPath:indexPath];
    
    //[view setNumberOfPhotos:self.numberOfPhotos numberOfVideos:self.numberOfVideos];
    
    return view;
}


#pragma mark - Collection View Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTAssetsPickerController *vc = (CTAssetsPickerController *)self.navigationController;
    
    return ([collectionView indexPathsForSelectedItems].count < vc.maximumNumberOfSelection);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setTitleWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setTitleWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
}


#pragma mark - Title

- (void)setTitleWithSelectedIndexPaths:(NSArray *)indexPaths
{
    // Reset title to group name
    if (indexPaths.count == 0)
    {
        self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        return;
    }
    
    //    BOOL photosSelected = NO;
    //    BOOL videoSelected  = NO;
    //    
    //    for (NSIndexPath *indexPath in indexPaths)
    //    {
    //        ALAsset *asset = [self.assets objectAtIndex:indexPath.item];
    //        
    //        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto])
    //            photosSelected  = YES;
    //        
    //        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    //            videoSelected   = YES;
    //        
    //        if (photosSelected && videoSelected)
    //            break;
    //    }
    //    
    //    NSString *format;
    //    
    //    if (photosSelected && videoSelected)
    //        format = NSLocalizedString(@"%d Items Selected", nil);
    //    
    //    else if (photosSelected)
    //        format = (indexPaths.count > 1) ? NSLocalizedString(@"%d Photos Selected", nil) : NSLocalizedString(@"%d Photo Selected", nil);
    //
    //    else if (videoSelected)
    //        format = (indexPaths.count > 1) ? NSLocalizedString(@"%d Videos Selected", nil) : NSLocalizedString(@"%d Video Selected", nil);
    //    
    //    self.title = [NSString stringWithFormat:format, indexPaths.count];
}


#pragma mark - Actions

- (void)finishPickingAssets:(id)sender
{
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems)
    {
        [assets addObject:[self.assets objectAtIndex:indexPath.item]];
    }
    
    CTAssetsPickerController *picker = (CTAssetsPickerController *)self.navigationController;
    
    if ([picker.delegate respondsToSelector:@selector(assetsPickerController:didFinishPickingAssets:)])
        [picker.delegate assetsPickerController:picker didFinishPickingAssets:assets];
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end



#pragma mark - CTAssetsViewCell

@implementation CTAssetsViewCell

static UIFont *titleFont = nil;

static CGFloat titleHeight;
static UIImage *videoIcon;
static UIColor *titleColor;
static UIImage *checkedIcon;
static UIImage *uncheckedIcon;
static UIColor *selectedColor;

+ (void)initialize
{
    titleFont       = [UIFont systemFontOfSize:12];
    titleHeight     = 20.0f;
    videoIcon       = [UIImage imageNamed:@"CTAssetsPickerVideo"];
    titleColor      = [UIColor whiteColor];
    checkedIcon     = [UIImage imageNamed:@"CTAssetsPickerChecked"];
    uncheckedIcon   = [UIImage imageNamed:@"CTAssetsPickerUnchecked"];
    selectedColor   = [UIColor colorWithWhite:1 alpha:0.3];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.opaque                     = YES;
        self.isAccessibilityElement     = YES;
        self.accessibilityTraits        = UIAccessibilityTraitImage;
        UIButton *btnLeftB = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self)-30, HEIGHT(self))];
        [self addSubview:btnLeftB];
        UIButton *btnRightS = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH(self)-30, 30, 30, HEIGHT(self)-30)];
        [self addSubview:btnRightS];
        //[btnLeftB setBackgroundColor:[UIColor blackColor]];
        //[btnRightS setBackgroundColor:[UIColor blackColor]];
        [btnLeftB handleClickEvent:UIControlEventTouchUpInside withClickBlock:^{
            [self checkImgInFullScreen:self withImgAsset:self.asset];
        }];
        [btnRightS handleClickEvent:UIControlEventTouchUpInside withClickBlock:^{
            [self checkImgInFullScreen:self withImgAsset:self.asset];
        }];
    }
    return self;
}

-(void)checkImgInFullScreen:(UIView*)View withImgAsset:(ALAsset*)asset{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView *bgColorView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bgColorView.alpha = 0.f;
    bgColorView.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1];
    bgColorView.tag = 7978;
    [keyWindow addSubview:bgColorView];
    
    UIScrollView *fullscreenBottomView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    fullscreenBottomView.contentSize = CGSizeMake(WIDTH(fullscreenBottomView), HEIGHT(fullscreenBottomView));
    fullscreenBottomView.backgroundColor = [UIColor clearColor];
    fullscreenBottomView.minimumZoomScale = 0.3f;
    fullscreenBottomView.maximumZoomScale = 3.f;
    fullscreenBottomView.contentMode = UIViewContentModeCenter;
    fullscreenBottomView.bounces = YES;
    fullscreenBottomView.bouncesZoom = YES;
    fullscreenBottomView.showsHorizontalScrollIndicator = NO;
    fullscreenBottomView.showsVerticalScrollIndicator = NO;
    fullscreenBottomView.delegate = self;
    fullscreenBottomView.tag = 9797;
    [keyWindow addSubview:fullscreenBottomView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitCheckImgView)];
    [fullscreenBottomView addGestureRecognizer:tap];
    
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    
    self.rectInFullScreen = [self.superview convertRect:self.frame toView:window];
    UIImageView *imgViewIsShowing = [[UIImageView alloc] initWithFrame:self.rectInFullScreen];
    
    UIImage *imgToShow = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
    if ([[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] firstObject] rangeOfString:@"gif"].length>0) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *imageBuffer = (Byte*)malloc((NSUInteger)rep.size);
        NSUInteger bufferSize = [rep getBytes:imageBuffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
        NSData *imageData = [NSData dataWithBytesNoCopy:imageBuffer length:bufferSize freeWhenDone:YES];
        UIImage *gif = [imageData imageForImageRawData];
        if(gif){
            imgToShow = gif;
        }
    }
    imgViewIsShowing.image = imgToShow;
    imgViewIsShowing.contentMode = UIViewContentModeScaleAspectFit;
    imgViewIsShowing.tag = 1001;
    [fullscreenBottomView addSubview:imgViewIsShowing];
    
    [UIView animateWithDuration:0.3f animations:^{
        imgViewIsShowing.frame = fullscreenBottomView.bounds;
        bgColorView.alpha = 1.f;
    }completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    if (scale<1.f) {
        [scrollView setZoomScale:1.f animated:YES];
        if (scale<0.7f)
            [self exitCheckImgView];
    }
}

-(void)exitCheckImgView{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIScrollView *viewScroll = (UIScrollView*)[keyWindow viewWithTag:9797];
    if (viewScroll) {
        if (viewScroll.zoomScale > 1.f) {
            [viewScroll setZoomScale:1.f animated:YES];
            [self performSelector:@selector(exitCheckBigImgView) withObject:nil afterDelay:0.5f];
        }else{
            [self exitCheckBigImgView];
        }
    }
}

-(void)exitCheckBigImgView{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *viewBg = [keyWindow viewWithTag:7978];
    UIScrollView *viewScroll = (UIScrollView*)[keyWindow viewWithTag:9797];
    [UIView animateWithDuration:0.3f animations:^{
        ((UIView*)[viewScroll.subviews firstObject]).frame = self.rectInFullScreen;
        viewScroll.alpha = 0.f;
        viewBg.alpha = 0.f;
    }completion:^(BOOL finished) {
        [viewScroll removeFromSuperview];
        [viewBg removeFromSuperview];
    }];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIImageView *subView = (UIImageView*)[scrollView viewWithTag:1001];
    return subView;
}



- (void)bind:(ALAsset *)asset
{
    self.asset  = asset;
    self.image  = [UIImage imageWithCGImage:asset.thumbnail];
    self.type   = [asset valueForProperty:ALAssetPropertyType];
    //self.title  = [NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setNeedsDisplay];
}


// Draw everything to improve scrolling responsiveness

- (void)drawRect:(CGRect)rect
{
    // Image
    [self.image drawInRect:CGRectMake(0, 0, kThumbnailLength, kThumbnailLength)];
    
    // Video title
    if ([self.type isEqual:ALAssetTypeVideo])
    {
        // Create a gradient from transparent to black
        CGFloat colors [] = {
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.8,
            0.0, 0.0, 0.0, 1.0
        };
        
        CGFloat locations [] = {0.0, 0.75, 1.0};
        
        CGColorSpaceRef baseSpace   = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient      = CGGradientCreateWithColorComponents(baseSpace, colors, locations, 2);
        
        CGContextRef context    = UIGraphicsGetCurrentContext();
        
        CGFloat height          = rect.size.height;
        CGPoint startPoint      = CGPointMake(CGRectGetMidX(rect), height - titleHeight);
        CGPoint endPoint        = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
        
        
        CGSize titleSize        = [self.title sizeWithFont:titleFont];
        [titleColor set];
        [self.title drawAtPoint:CGPointMake(rect.size.width - titleSize.width - 2 , startPoint.y + (titleHeight - 12) / 2)
                       forWidth:kThumbnailLength
                       withFont:titleFont
                       fontSize:12
                  lineBreakMode:NSLineBreakByTruncatingTail
             baselineAdjustment:UIBaselineAdjustmentAlignCenters];
        
        [videoIcon drawAtPoint:CGPointMake(2, startPoint.y + (titleHeight - videoIcon.size.height) / 2)];
    }
    
    if (self.selected){
        
        //        CGContextRef context    = UIGraphicsGetCurrentContext();
        //		CGContextSetFillColorWithColor(context, selectedColor.CGColor);
        //		CGContextFillRect(context, rect);
        
        [checkedIcon drawAtPoint:CGPointMake(0.95f*CGRectGetMaxX(rect) - checkedIcon.size.width,0.05f*CGRectGetMaxY(rect))];
    }else{
        
        [uncheckedIcon drawAtPoint:CGPointMake(0.95f*CGRectGetMaxX(rect) - uncheckedIcon.size.width,0.05f*CGRectGetMaxY(rect))];
        
    }
}

@end


#pragma mark - CTAssetsSupplementaryView

@implementation CTAssetsSupplementaryView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _sectionLabel               = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 8.0, 8.0)];
        _sectionLabel.font          = [UIFont systemFontOfSize:18.0];
        _sectionLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_sectionLabel];
    }
    
    return self;
}

//- (void)setNumberOfPhotos:(NSInteger)numberOfPhotos numberOfVideos:(NSInteger)numberOfVideos
//{
//    NSString *title;
//    
//    if (numberOfVideos == 0)
//        title = [NSString stringWithFormat:NSLocalizedString(@"%d Photos", nil), numberOfPhotos];
//    else if (numberOfPhotos == 0)
//        title = [NSString stringWithFormat:NSLocalizedString(@"%d Videos", nil), numberOfVideos];
//    else
//        title = [NSString stringWithFormat:NSLocalizedString(@"%d Photos, %d Videos", nil), numberOfPhotos, numberOfVideos];
//    
//    self.sectionLabel.text = title;
//}

@end
