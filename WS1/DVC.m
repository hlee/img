//
//  DVC.m
//  WS1
//
//  Created by Ken Lu on 3/26/13.
//  Copyright (c) 2013 Computerlab. All rights reserved.
//

#import "DVC.h"
#import "WS1AppDelegate.h"

@interface DVC ()


@end

@implementation DVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", self.ttext);
//    NSData * imageData = [NSData dataWithContentsOfURL : [NSURL URLWithString : @"http://commons.wikimedia.org/wiki/File:Aerial_view_of_Nauru.jpg"]];
//    self.image = [[UIImage alloc] initWithData:imageData];
    
    
//    NSURL *url = [NSURL URLWithString:((WS1AppDelegate *)[UIApplication sharedApplication].delegate).photoURLString];
                  //@"http://www.iteye.com/upload/logo/user/78758/bc4c8145-28bf-33d0-8fa9-fe07225b61c3.gif"];
//    NSData *data = [NSData dataWithContentsOfURL:url];
    //self.image = [[UIImage alloc] initWithData:data];
//    NSData *data = ((WS1AppDelegate *)[UIApplication sharedApplication].delegate).photo;
    self.bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320,420)];
    self.bgImage.image = [[UIImage alloc] initWithData:self.myData];
    [self.view addSubview:self.bgImage];
    
    

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
