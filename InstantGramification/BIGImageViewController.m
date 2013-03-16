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
#import <ASIHTTPRequest.h>

NSString *kDetailedViewControllerID = @"DetailView";    // view controller storyboard id
NSString *kCellID = @"cellID";                          // UICollectionViewCell storyboard id

@implementation BIGImageViewController

- (void)dealloc {
    [self.imageCollection release], self.imageCollection = nil;
    [self.locationObj release], self.locationObj = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageCollection = [[NSMutableArray alloc] initWithArray:self.locationObj.imageCollection];
    
    if(self.imageCollection.count == 0) {
        UILabel *noImageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 44.0f)] autorelease];
        [self.view addSubview:noImageLabel];
        
        noImageLabel.textColor = [UIColor whiteColor];
        noImageLabel.backgroundColor = [UIColor blackColor];
        noImageLabel.text = @"No images at this location, sorry!";
//        noImageLabel.textAlignment
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
    [self performSegueWithIdentifier:@"displayDetailedImage" sender:self];
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label

    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    BIGLocationImage* locationImage = [self.imageCollection objectAtIndex:indexPath.row];
    
    dispatch_queue_t imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(imageQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:locationImage.url];
            ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
            NSError *error = [request error];
            [request startSynchronous];

            if (!error) {
                NSMutableData *response = [request rawResponseData];
                cell.image.image = [UIImage imageWithData:response];
            }
        });
    });

    return cell;
}

// the user tapped a collection item, load and set the image on the detail view controller
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"displayDetailedImage"])
    {
        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];

        BIGLocationImage *location = (BIGLocationImage *)[self.imageCollection objectAtIndex:selectedIndexPath.row];

        DetailViewController *detailViewController = [segue destinationViewController];
        
        NSURL *url = [NSURL URLWithString:location.detailImageURL];
        ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
        NSError *error = [request error];
        [request startSynchronous];
        
        if (!error) {
            NSMutableData *response = [request rawResponseData];
            detailViewController.image = [UIImage imageWithData:response];
        }
    }
}

- (void)setImageCollectionObj:(BIGLocation *)locationObj {
    BIGLocationImage *locationImageObj = (BIGLocationImage *)[locationObj.imageCollection objectAtIndex:0];
    NSLog(@"success! setimagecollectionobj called %@", locationImageObj.url);
    
    [self.imageCollection initWithArray:locationObj.imageCollection];
}

@end
