//
//  CWS.m
//  WS1
//
//  Created by DR. EHSAN on 3/22/13.
//  Copyright (c) 2013 EHSAN. All rights reserved.
//

#import "CWS.h"
#import "WS1AppDelegate.h"
#import "DVC.h"
NSString *const FlickrAPIKey = @"ac35247e7b67528944f322cceb05704b";


@interface CWS ()

@property (nonatomic, strong) NSMutableArray *photoTitles;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) NSMutableArray *photoSmallImageData;
@property (nonatomic, strong) NSMutableArray *photoURLsLargeImage;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData* receivedData;

-(void)searchFlickrPhotos:(NSString *)text;


@end

@implementation CWS


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self.receivedData setData:nil];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}





- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSError* error;
    
    NSDictionary* results = [NSJSONSerialization JSONObjectWithData:self.receivedData
                                                            options:kNilOptions
                                                              error:&error];
    
	NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
    
	for (NSDictionary *photo in photos)
    {
		NSString *title = [photo objectForKey:@"title"];
        
		[self.photoTitles addObject:(title.length > 0 ? title : @"Untitled")];
		
        // Build the URL to where the image is stored (see the Flickr API)
        // In the format http://farmX.static.flickr.com/server/id/secret
        // Notice the "_s" which requests a "small" image 75 x 75 pixels
		NSString *photoURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        NSLog(@"photoURLString: %@", photoURLString);
		[self.photoSmallImageData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];
		photoURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
		[self.photoURLsLargeImage addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];//addObject:[NSURL URLWithString:photoURLString]];
        NSLog(@"photoURLsLareImage: %@\n\n", photoURLString);
//        ((WS1AppDelegate *)[UIApplication sharedApplication].delegate).photoURLString = photoURLString;
        [self.urls addObject:photoURLString];

	}
    
    [self.tableView reloadData];
}




-(void)searchFlickrPhotos:(NSString *)text
{
    // Build the string to call the Flickr API
	NSString *urlString =
    [NSString stringWithFormat:
     @"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=10&format=json&nojsoncallback=1", FlickrAPIKey, text];
    NSLog(@"REQ SENT: %@", urlString);
	NSURL *url = [NSURL URLWithString:urlString];
    
    // Setup and start async download
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    self.connection = [[NSURLConnection alloc] initWithRequest:request
                                                      delegate:self];
    
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoTitles = [[NSMutableArray alloc] init];
    self.urls = [[NSMutableArray alloc] init];
    self.photoSmallImageData = [[NSMutableArray alloc] init];
    self.photoURLsLargeImage = [[NSMutableArray alloc] init];
    self.receivedData = [[NSMutableData alloc] init];
    self.connection = [[NSURLConnection alloc] init];
    
    [self searchFlickrPhotos:@"flower"];


}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photoSmallImageData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"Cell";
    int row = indexPath.row;
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString* text = (NSString*) [self.photoTitles objectAtIndex:row];
    
    NSLog(@"text label: %@", text);
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", text];
    UIImageView* imageView = cell.imageView;
    NSData* imageData = (NSData*) [self.photoSmallImageData objectAtIndex:row];
    imageView.image = [UIImage imageWithData:imageData];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Show an alert with the index selected.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"iPad Selected"
                          message:[NSString stringWithFormat:@"iPad %d", indexPath.row]
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
//    NSString* photoURLString = ((WS1AppDelegate *)[UIApplication sharedApplication].delegate).photoURLString;
    ((WS1AppDelegate *)[UIApplication sharedApplication].delegate).photo = (NSData*)[self.photoURLsLargeImage objectAtIndex:indexPath.row];
    NSLog(@"%d", indexPath.row);
//    [self performSegueWithIdentifier:@"testID" sender:self.view];  
    //(NSString*) [self.urls objectAtIndex:indexPath.row];
//    NSLog(@"%@", photoURLString);
    
    //[alert show];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // assumes only one type, more extensive checking before cast to
    // make it safer is needed.
    DVC *viewController = (DVC *) segue.destinationViewController;
//    NSData *md = (NSData*)[self.photoURLsLargeImage objectAtIndex:[self.tableView indexPathForSelectedRow]];
    NSIndexPath *p = [self.tableView indexPathForSelectedRow];
    
    NSInteger row = p.row;
    viewController.myData = (NSData*)[self.photoURLsLargeImage objectAtIndex:row];
    NSLog(@"%d", row);
    viewController.ttext = @"sab";
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0f;
}

@end
