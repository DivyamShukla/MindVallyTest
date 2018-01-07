# MindVallyTest

This repository contains a sample project and a library project. In sample project it is represented that how to set Image on a imageView and that downloads those images Asynchronously. and also used to fetch XML and JSON data from any url.

for setting image on a url there is a method in library 

-(void)loadImage:(NSString*)url into:(UIImageView *)imgView

-(void)loadImage:(NSString*)url into:(UIImageView *)imgView withLoading:(BOOL)loading


there is a method for fetching data from any url no matters it is JSON, XML, or ANY other kind of. Need to set 

ResourceType :    
	kResourceTypeJSON,
	kResourceTypeXML,
	kResourceTypeAny
  
  
  -(void)getResourceFromURL:(NSString *)url ofType:(ResourceType)type onCompletion:(void(^)(BOOL success, NSError *error,  id data))completion  
