//
//  ContactListViewController.m
//  FetchContactList
//
//  Created by Zeeshan Khan on 3/27/18.
//  Copyright © 2018 Murtuza. All rights reserved.
//

#import "ContactListViewController.h"
#import "ContactListTableViewCell.h"
#import "APContact.h"
#import "APAddressBook.h"

@interface ContactListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) APAddressBook *addressBook;
    @property (weak, nonatomic) IBOutlet UITableView *tableView;
    @property (nonatomic, strong) NSArray *contacts;
@end

@implementation ContactListViewController
#pragma mark - life cycle
    
- (instancetype)initWithCoder:(NSCoder *)aDecoder
    {
        self = [super initWithCoder:aDecoder];
        if (self)
        {
            self.addressBook = [[APAddressBook alloc] init];
            __weak typeof(self) weakSelf = self;
            [self.addressBook startObserveChangesWithCallback:^
             {
                 [weakSelf loadContacts];
             }];
        }
        return self;
    }
    
    
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadContacts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        return self.contacts.count;
    }
    
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        NSString *identifier = @"ContactListTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                                forIndexPath:indexPath];
        if ([cell isKindOfClass:ContactListTableViewCell.class])
        {
            ContactListTableViewCell *contactCell = (ContactListTableViewCell *)cell;
            [contactCell updateWithContact:self.contacts[(NSUInteger)indexPath.row]];
        }
        return cell;
    }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        return 85.f;
    }
#pragma mark - UITableViewDelegate
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
    
    
#pragma mark - private
    
- (void)loadContacts
{
    self.contacts = nil;
    __weak __typeof(self) weakSelf = self;
    self.addressBook.fieldsMask = APContactFieldAll;
    self.addressBook.sortDescriptors = @[
                                         [NSSortDescriptor sortDescriptorWithKey:@"name.firstName" ascending:YES],
                                         [NSSortDescriptor sortDescriptorWithKey:@"name.lastName" ascending:YES]];
    self.addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0;
    };
    [self.addressBook loadContacts:^(NSArray<APContact *> *contacts, NSError *error) {
        if (contacts)
        {
            weakSelf.contacts = contacts;
            [weakSelf.tableView reloadData];
        }
        else if (error)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

@end
