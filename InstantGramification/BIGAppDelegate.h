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
This app isn't ready for the app store because it's buggy and just not interesting yet.

 Things to do:
        - Error handling is not complete.
        - Add indication whether GPS/data (Reachability) is even working.
        - Settings to change how often to udpate. In my opinion there should be no auto update. For the auto-update I'm just tracking how far I get from the original location where I made a request. The specs were to update ever so many Meters an individual moved and I could easily add up the distance traveled but this is a concern of mine.
        - If device isn't using Wifi to pinpoint location alert user to enable those settings.
        - Hallway testing.

 UX concerns:
        - Quick tutorial on what the app does.
        - Dropped pins should display at least the title and subtitle for the user to know a little about a location they're about to select. Sexier with an image. Could be interesing to have the user click on a location and a cluster of images unfold showing some profile pictures of the people who have been there. Or the total number of images taken at a location which may signfiy popularity of a location.
         - Allow user to back out of selected location by stopping url request. So I would have to create NSOperationQueue's than use the easy access global ones so I could just cancel them.
        - The user should be doing something with the app. I think it's better that the user update the list of locations rather than walk so many meters to have app update on it's own (Also, user is draining battery life by checking distance traveled all the time.) If auto-updating is necesary than there should be a progress bar or some indication of when or how far the user has moved. Settings for when to update would be needed.
 
 Random thoughts on how I would make this app more interesting: 
        
        - Number of comments beneath the thumbnail images would make the app more interesting. User cares what other people care to talk about especially if it's focused and in numbers.
 
        - There's nothing for the user to do than observe pictures that exist. Something to make the app more interesting would be to use the iOS hooks and let the user create their own images for a location. Add comments to what's being talk about. But that would be things you would do in Instagram. What makes this app special?
 
        - I only care about locations around me. (User may not care about auto dropping pins. Maybe better if the user chooses when the pin drops.)
 
        - What am I doing in this area & why do I care?
        - I'm looking for some place other people find interesting enough that they take pictures.
            (Maybe I should remove dropped pins that don't have any images because they wouldn't be
            interesting. I would also have to make an additional request to get this.)
        
        -What might I find? Is the mystery appealing to me or would I rather know?

        - Who are the people doing the posting?
        -Am I looking for class, gender (Check api if any of this info is shared). Is it more interesting for me to post the profile pictures of the people who have taken pictures at this location? Interesting to have both and displaying them in different sections in the collection view?
*/