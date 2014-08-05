//
//  RDPImageFetcher.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/28/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPImageFetcher.h"
#import "RDPImageBlur.h"

#define numImagesTotal 10
NSString * const kIndexInArray = @"kArray";
NSString * const kIndexInFiles = @"kFiles";

@implementation RDPImageFetcher

static RDPImageFetcher *imageFetcher = nil;

- (id)init
{
    self = [super init];
    if (self) {
        [self loadIndices];
        _numImages = numImagesTotal;
    }
    return self;
}

+ (RDPImageFetcher *)getImageFetcher
{
    if (imageFetcher) {
        return imageFetcher;
    }

    imageFetcher = [[self alloc] init];
    return imageFetcher;
}

- (UIImage *)getCurrentBlurredImage
{
    int index = imageFetcher.indexOfImageFile;
    return imageFetcher.blurredImagesArray[index];
}

#pragma mark - Image Arrays

- (NSMutableArray *)clearImagesArray
{
    
    if (_clearImagesArray != nil) {
        return _clearImagesArray;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i=0; i < imageFetcher.numImages; i++) {
        NSString *imageFileName = [[NSString stringWithFormat:@"%d", i] stringByAppendingString:@".jpg"];
        
        // Get the path for the file if it exists in our documents directory
        NSString *imageFilePath = [self documentsPathForFileName:imageFileName];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imageFilePath];
        
        UIImage *image;
        if (fileExists) { // If the image exists in our documents directory, load from the image data
            NSData *pngData = [NSData dataWithContentsOfFile:imageFilePath];
            image = [UIImage imageWithData:pngData];
        }
        else { // If the image has not yet been written to our documents directory, get it from our app files then write it to documents
            image = [UIImage imageNamed:imageFileName];
            NSData *pngData = UIImagePNGRepresentation(image);
            [self saveImageWithName:imageFileName andImageData:pngData];
            
        }
        
        [array addObject:image];
    }
    
    imageFetcher.clearImagesArray = array;
    
    return array;
}

- (NSMutableArray *)blurredImagesArray
{
    
    if (_blurredImagesArray != nil) {
        return _blurredImagesArray;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i=0; i < imageFetcher.numImages; i++) {
        NSString *imageFileName = [[NSString stringWithFormat:@"%d", i] stringByAppendingString:@"_blur.jpg"];
        
        // Get the path for the file if it exists in our documents directory
        NSString *imageFilePath = [self documentsPathForFileName:imageFileName];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imageFilePath];
        
        UIImage *image;
        if (fileExists) { // If the image exists in our documents directory, load from the image data
            NSData *pngData = [NSData dataWithContentsOfFile:imageFilePath];
            image = [UIImage imageWithData:pngData];
        }
        else { // If the image has not yet been written to our documents directory, get it from our app files then write it to documents
            image = [UIImage imageNamed:imageFileName];
            NSData *pngData = UIImagePNGRepresentation(image);
            [self saveImageWithName:imageFileName andImageData:pngData];
            
        }
        [array addObject:image];
    }
    
    imageFetcher.blurredImagesArray = array;
    
    return array;
}

#pragma mark - Document Paths

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

- (void)saveImageWithName:(NSString *)name andImageData:(NSData *)data
{
    NSString *path = [self documentsPathForFileName:name];
    [data writeToFile:path atomically:YES];
}

#pragma mark - Blur and Save Image

- (void)saveBlurredImageWithName:(NSString *)name andImage:(UIImage *)image andIndex:(int)index
{
    NSString *path = [self documentsPathForFileName:name];
    
    UIImage *blurredImage = [RDPImageBlur applyBlurOnImage:image];
    
    // Save the blurred image to our array
    self.blurredImagesArray[index] = blurredImage;
    NSLog(@"SUCCESS! Saved blurred image %d", index);
    
    // Save the image data for the blurred image to our documents
    NSData *pngData = UIImagePNGRepresentation(blurredImage);
    [pngData writeToFile:path atomically:YES];
}

#pragma mark - Getting the Next Image

- (void)nextImage
{
    // Get the next image from the client
    RDPHTTPClient *client = [RDPHTTPClient sharedRDPHTTPClient];
    client.delegate = self;
    [client getNextImage];
}

-(void)RDPHTTPClient:(RDPHTTPClient *)client didGetImageURLs:(NSArray *)images {
    
    // TODO: load more than one image at a time, but let view display
    // the first image when it is immediately returned
    NSURL *imageURL = images[0];
    [self nextImageToDisplay:imageURL];
}

- (void)nextImageToDisplay:(NSURL *)imageURL
{
    NSURL *nextImageURL = imageURL;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:nextImageURL];
        
        // Get the image from the data returned from the server
        UIImage *image =[UIImage imageWithData:imageData];
        
        // Save the image to our local images array
        int index = imageFetcher.indexOfImageFile;
        imageFetcher.clearImagesArray[index] = image;
    
        // Update the image file index
        int nextIndex = (imageFetcher.indexOfImageFile + 1) % imageFetcher.numImages;
        imageFetcher.indexOfImageFile = nextIndex;
    
        NSLog(@"index: %d", index);
    
        // Save the clear image to our documents
        NSString *fileName = [[NSString stringWithFormat:@"%d", index] stringByAppendingString:@".jpg"];
        [self saveImageWithName:fileName andImageData:imageData];
        
        // Save the blurred image to our documents and to the blurred array
        NSString *blurredFileName = [[NSString stringWithFormat:@"%d", index] stringByAppendingString:@"_blur.jpg"];

        [self saveBlurredImageWithName:blurredFileName andImage:image andIndex:index];

    });
}

# pragma mark - Save and Load Indices

-(void)saveIndices
{
    [[NSUserDefaults standardUserDefaults]
     setObject:[NSNumber numberWithInt:self.indexOfImageFile] forKey:kIndexInFiles];
    
    [[NSUserDefaults standardUserDefaults]
     setObject:[NSNumber numberWithInt:self.indexOfImageArray] forKey:kIndexInArray];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)loadIndices
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kIndexInArray])
    {
        self.indexOfImageFile = [[[NSUserDefaults standardUserDefaults]
                                   objectForKey:kIndexInFiles] intValue];
        
        self.indexOfImageArray = [[[NSUserDefaults standardUserDefaults]
                                   objectForKey:kIndexInArray] intValue];
    }
    else
    {
        self.indexOfImageArray = 0;
        self.indexOfImageFile = 0;
    } 
}


@end