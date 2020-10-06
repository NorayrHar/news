//
//  NewsModel.m
//  News
//
//  Created by Norayr Harutyunyan on 10/5/20.
//

#import "NewsModel.h"

@implementation NewsModel

- (id) init:(NSDictionary*)dict {
    self = [super init];
    
    self.author = [dict objectForKey:@"author"];
    self.content = [dict objectForKey:@"content"];
    self.description_ = [dict objectForKey:@"description"];
    self.title = [dict objectForKey:@"title"];
    self.url = [dict objectForKey:@"url"];
    self.urlToImage = [dict objectForKey:@"urlToImage"];
    self.imageData = nil;

    if ([self.urlToImage isEqual:[NSNull null]] || self.urlToImage == nil) {
        
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            self.imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.urlToImage]];
            

            dispatch_async(dispatch_get_main_queue(), ^(void){
                    //Run UI Updates
                [[NSNotificationCenter defaultCenter]
                        postNotificationName:@"newsImageLoaded"
                        object:self];
            });
        });
    }
    
    return self;
}

@end
