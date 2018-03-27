//
//  ContactListTableViewCell.m
//  FetchContactList
//
//  Created by Zeeshan Khan on 3/27/18.
//  Copyright © 2018 Murtuza. All rights reserved.
//

#import "ContactListTableViewCell.h"
#import "APContact.h"
#import "APPhone.h"
#import "APJob.h"
#import "APName.h"
#import "APEmail.h"

@implementation ContactListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

#pragma mark - public
    
- (void)updateWithContact:(APContact *)contact
    {
        self.nameLabel.text = [self contactName:contact];
        /*
         elf.companyLabel.text = contact.job.company ?: @"(No company)";
         self.phonesLabel.text = [self contactPhones:contact];
         self.emailsLabel.text = [self contactEmails:contact];
         self.photoView.image = contact.thumbnail ?: [UIImage imageNamed:@"no_photo"];
         */
    }
    
#pragma mark - private
    
- (NSString *)contactName:(APContact *)contact
    {
        if (contact.name.compositeName)
        {
            return contact.name.compositeName;
        }
        else if (contact.name.firstName && contact.name.lastName)
        {
            return [NSString stringWithFormat:@"%@ %@", contact.name.firstName, contact.name.lastName];
        }
        else if (contact.name.firstName || contact.name.lastName)
        {
            return contact.name.firstName ?: contact.name.lastName;
        }
        else
        {
            return @"Untitled contact";
        }
    }
    
- (NSString *)contactPhones:(APContact *)contact
    {
        if (contact.phones.count > 0)
        {
            NSMutableString *result = [[NSMutableString alloc] init];
            for (APPhone *phone in contact.phones)
            {
                NSString *string = phone.localizedLabel.length == 0 ? phone.number :
                [NSString stringWithFormat:@"%@ (%@)", phone.number,
                 phone.localizedLabel];
                [result appendFormat:@"%@, ", string];
            }
            return result;
        }
        else
        {
            return @"(No phones)";
        }
    }
    
- (NSString *)contactEmails:(APContact *)contact
    {
        if (contact.emails.count > 1)
        {
            NSMutableString *result = [[NSMutableString alloc] init];
            for (APEmail *email in contact.emails)
            {
                [result appendFormat:@"%@, ", email.address];
            }
            return result;
        }
        else
        {
            return contact.emails.count == 1 ? contact.emails[0].address : @"(No emails)";
        }
    }

@end
