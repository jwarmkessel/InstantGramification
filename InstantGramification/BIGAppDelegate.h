//
//  BIGAppDelegate.h
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/13/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TestFlight.h>

@interface BIGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Instagram *instagram;

@end

/****************************** My comments on the code ******************************/

/*
This app isn't ready for the app store because it's tedious, buggy, and just not interesting yet :). Striking these items means more planning and more time.
 
 App's use of Core Location is still buggy.
 Should pause core location when user isn't on the map screen. Not a big fan of auto updating nearby locations after 25M. (Currently handling this by updating after the user walks 25M from the original location rather than adding up the entire distance moved by user even within a 25M radius.)
 
 UX concerns:
 
 Dropped pins should display at least the title and subtitle for the user to know a little about a location they're about to select. Sexier with an image. Could be interesing to have the user click on a location and a cluster of images unfold showing some profile pictures of the people who have been there. Or the total number of images taken at a location which may signfiy popularity of a location.
 
 The user should be doing something with the app. I think it's better that the user update the list of locations rather than walk so many meters to have app update on it's own (Also, user is draining battery life by checking distance traveled all the time.) If auto-updating is necesary than there should be a progress bar or some indication of when or how far the user has moved. Settings for when to update would be needed.
 
 //TODO: Needs a loading mask when requests are being made to Instagram.
 
 //TODO: I should put the request code for the detailed view BIGLocation object. Perhaps load this when the user selects a location. Does the user care about a detailed view? Comments would be interesting. Use a delegate to set a flag or BIGImageViewController.
 
 Caching the images would contribute a lot to the experience if the user is going in and out of the  collection view and making a call to update images in the background to minimize waiting.
 
 Number of comments beneath the thumbnail images would make the app more interesting. User cares what other people care to talk about especially if it's focused and in numbers. 
 
 There's nothing for the user to do than observe pictures that exist. Something to make the app more interesting would be to use the iOS hooks and let the user create their own images for a location. Add comments to what's being talk about. But that would be things you would do in Instagram. What makes this app special?  
 
 My thoughts on how the user might be thinking and so I add some constraints:
 - I only care about locations around me. (User may not care about auto dropping pins. Maybe better if the user chooses when the pin drops.)
 
 - What am I doing in this area & why do I care?
 - I'm looking for some place other people find interesting enough that they take pictures.
 (Maybe I should remove dropped pins that don't have any images because they wouldn't be
 interesting. I would also have to make an additional request to get this.)
 -What might I find? Is the mystery appealing to me or would I rather know?
 
 - Who are the people doing the posting?
 -Am I looking for class, gender (Check api if any of this info is shared). Is it more interesting for me to post the profile pictures of the people who have taken pictures at this location? Interesting to have both and displaying them in different sections in the collection view?

*/