//
//  TableViewController.m
//  News
//
//  Created by Norayr Harutyunyan on 10/5/20.
//
// 5b7f605a80cc41fb892d32992a3ce286

#import "TableViewController.h"
#import "NewsModel.h"
#import "NewsCellTableViewCell.h"
#import "NewsDetailsViewController.h"

@interface TableViewController () {
    NSMutableArray *newsList;
    
    UIRefreshControl *refreshControl;

    int total;
    int pageSize;
    int page;
    bool newsLoading;
}
    
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"News";
    
    total = 0;
    pageSize = 20;
    page = 1;
    newsLoading = false;

    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(needCellReload:)
            name:@"newsImageLoaded"
            object:nil];

    newsList = [[NSMutableArray alloc] init];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    [self.tableView addSubview:refreshControl];

    [self loadNews];
    
}

- (void) loadNews {
    
    if (newsLoading == true) {
        return;
    }
        
    newsLoading = true;
    
    NSString *targetUrl = [NSString stringWithFormat:@"http://newsapi.org/v2/top-headlines?country=ru&pageSize=%d&page=%d&apiKey=5b7f605a80cc41fb892d32992a3ce286", pageSize, page];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:targetUrl]];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {

        NSDictionary *object = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:0
                              error:nil];
        
        
        if (object != nil) {
            NSString *status = [object objectForKey:@"status"];
            if ([[status lowercaseString] isEqualToString:@"ok"]) {
                NSArray *articles = [object objectForKey:@"articles"];
                self->total = [[object objectForKey:@"totalResults"] intValue];
                
                for (id news in articles) {
                    NewsModel *newsModel = [[NewsModel alloc] init:news];
                    
                    [self->newsList addObject:newsModel];
                }
                                
                self->page = self->page + 1;
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    //UI Updates
                    [self.tableView reloadData];
                    self->newsLoading = false;
                });
            }
        }
        
        NSLog(@"Data received: %@", object);

    }] resume];
}

- (void)refreshTable {
    [refreshControl endRefreshing];
    total = 0;
    page = 1;

    [newsList removeAllObjects];
    [self.tableView reloadData];
    [self loadNews];
}

- (void) needCellReload:(NSNotification *) notification {
    
    NewsModel *newsModel = notification.object;
    
    if (newsModel != nil) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newsModel.cellRow inSection:0];

        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (newsList.count != 0) {
        if (newsList.count == total) {
            return newsList.count;
        }
        
        return newsList.count + 1;
    }

    return newsList.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == newsList.count && indexPath.row != 0) {
        [self loadNews];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadingCell"];

        return cell;
    }

    
    NewsCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NewsModel *newsModel = [newsList objectAtIndex:indexPath.row];
    newsModel.cellRow = indexPath.row;
    
    if ([newsModel.title isEqual:[NSNull null]]) {
        cell.labelTitle.text = @"";
    } else {
        cell.labelTitle.text = newsModel.title;
    }
    
    if ([newsModel.description_ isEqual:[NSNull null]]) {
        cell.labelDescription.text = @"";
    } else {
        cell.labelDescription.text = newsModel.description_;
    }

    if (newsModel.imageData != nil) {
        UIImage *image = [UIImage imageWithData:newsModel.imageData];
        cell.imageViewNews.image = image;
        [cell.activityIndicatorView stopAnimating];
    } else {
        cell.imageViewNews.image = nil;
        [cell.activityIndicatorView startAnimating];
    }
    
    return  cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == newsList.count && indexPath.row != 0) {
        return 60;
    }
    
    return 320;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NewsModel *newsModel = [newsList objectAtIndex:indexPath.row];
    NewsDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"deatils"];
    
    if (vc != nil) {
        vc.newsModel = newsModel;
        [self.navigationController pushViewController:vc animated:true];
    }
}

@end
