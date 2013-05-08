//
//  pLPostRequestController.h
//  PrayList
//
//  Created by Peter Opheim on 2/19/13.
//  Copyright (c) 2013 Peter Opheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface pLPostRequestController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    
    IBOutlet UIBarButtonItem *cancelButton;
    IBOutlet UIBarButtonItem *postButton;
    IBOutlet UIImageView *userImage;
    IBOutlet UITextView *requestText;
    IBOutlet UICollectionView *groupView;
    
}

@end
