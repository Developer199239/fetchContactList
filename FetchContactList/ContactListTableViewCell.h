//
//  ContactListTableViewCell.h
//  FetchContactList
//
//  Created by Zeeshan Khan on 3/27/18.
//  Copyright © 2018 Murtuza. All rights reserved.
//

#import <UIKit/UIKit.h>
@class APContact;
@interface ContactListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
- (void)updateWithContact:(APContact *)contact;
@end
