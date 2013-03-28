//
//  BIGImageViewController.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/14/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGImageViewController.h"
#import "DetailViewController.h"
#import "Cell.h"
#import "BIGLocationImage.h"
#import "BIGLocation.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *kDetailedViewControllerID = @"DetailView";    // view controller storyboard id
NSString *kCellID = @"cellID";                          // UICollectionViewCell storyboard id

@implementation BIGImageViewController

- (void)dealloc {
    [self.imageCollection release], self.imageCollection = nil;
    [self.locationObj release], self.locationObj = nil;
    [self.loadingMask release], self.loadingMask = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    
    NSLog(@"collection view did load");
    [super viewDidLoad];

    if(!self.imageCollection) {
        self.imageCollection = [[NSMutableArray alloc] initWithArray:self.locationObj.imageCollection];
    }
    
    if([self.imageCollection count] == 0) {
        UILabel *noImageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 44.0f)] autorelease];
        [self.view addSubview:noImageLabel];
        
        noImageLabel.textColor = [UIColor whiteColor];
        noImageLabel.backgroundColor = [UIColor blackColor];
        noImageLabel.text = @"No images at this location, sorry!";
        noImageLabel.textAlignment = UITextAlignmentCenter;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"collection view will appear");
    if(showLoadingMask) {
        self.loadingMask = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.view addSubview:self.loadingMask];
        UILabel *loadingMaskLbl = [[[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];

        self.loadingMask.backgroundColor = [UIColor blackColor];
        self.loadingMask.alpha = 0.5;
        
        loadingMaskLbl.alpha = 1.0;
        [self.loadingMask addSubview:loadingMaskLbl];
        loadingMaskLbl.text =@"loading";
        loadingMaskLbl.textColor = [UIColor whiteColor];
        loadingMaskLbl.backgroundColor = [UIColor blackColor];
        [loadingMaskLbl setCenter:self.loadingMask.center];
        loadingMaskLbl.textAlignment = UITextAlignmentCenter;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.imageCollection count];
}

- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath: (NSIndexPath *)indexPath {
    NSLog(@"didSelectItemAtIndexPath");
    [self performSegueWithIdentifier:@"displayDetailedImage" sender:self];
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    BIGLocationImage* locationImage = [self.imageCollection objectAtIndex:indexPath.row];

    //Using SDWebImage to load view asynchronously.
    [cell.image setImageWithURL:[NSURL URLWithString:locationImage.url]
               placeholderImage:nil
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {  
                          if(!error) {
                              
                              locationImage.detailImage = image;
                              
                              //Check if the cell is the last in the row. If the image is finished loading then remove the loading mask.
                              NSInteger lastSectionIndex = [self.collectionView numberOfSections] - 1;
                              NSInteger lastRowIndex = [self.collectionView numberOfItemsInSection:lastSectionIndex] -1;
                              NSIndexPath *pathToLastRow = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
                              
                              if(showLoadingMask) {
                                  if([pathToLastRow isEqual:indexPath]) {
                                      [UIView animateWithDuration:0.3
                                                       animations:^(void){
                                                           self.loadingMask.alpha = 0.0;
                                                       }
                                                       completion:^(BOOL finished){
                                                           [self.loadingMask retain];
                                                           [self.loadingMask removeFromSuperview];
                                                       }
                                       ];
                                  }
                              }
                          }
                      }
     ];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Since the images will already be loaded there isn't a need to have loading mask.
    [self setDisplayLoadingMask:0];
    
    if ([[segue identifier] isEqualToString:@"displayDetailedImage"])
    {
        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        BIGLocationImage *location = (BIGLocationImage *)[self.imageCollection objectAtIndex:selectedIndexPath.row];
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.detailImage = location.detailImage;
    }
}

- (void)setImageCollectionObj:(BIGLocation *)locationObj {
    [self.imageCollection initWithArray:locationObj.imageCollection];
}

- (void)setDisplayLoadingMask:(int)display {
    showLoadingMask = display;
}

@end
