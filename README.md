# Waterfall View 
=============
[Pinterest Style Mosiac View Image Gallery blog](http://wp.me/p3mX74-pp)

Often in ios apps we need to represent images through gallery . Pinterest Style Mosiac View is one of those gallery representation style . Some people called this pattern as Waterfall View also. As we need this view pattern more than one apps we can make it generic by creating a UIView which will represent the Mosiac View. By doing this kind of thing we can use it anywhere we want . It may be full screen view or part of the screen. 

### PREREQUISITE:

Required basic idea in
- Category [help link](http://cupsofcocoa.com/2011/03/27/objective-c-lesson-8-categories)
- UIScrollView [help link](http://idevzilla.com/2010/09/16/uiscrollview-a-really-simple-tutorial)
- UIImage [help link](http://agilewarrior.wordpress.com/2012/01/25/how-to-display-image-on-iphone-using-uiimageview-and-uiscrollview)

### GETTING STARTED:

When we are going to download images from any url, then we don’t know about the height and width of the image . So, we may crop those image according to our UIImageView size or we will allocate one by one dynamically. Here, we allocate images dynamically. We will create threads for all urls and waiting for them to be downloaded. When anyone of them finishes loading ,it will be assigned to UIImageView of any column who has minimum height. This is the main idea of this project. But there is a problem . When we create threads we lost the image’s index no  in image array. So, When user tap on an image we can’t recognize the exact one. To remove this problem we use category of “UIImage” and “NSURL“. By ‘Tag” we can identify them.

[Pinterest Style Mosiac View Image Gallery blog](http://wp.me/p3mX74-pp)

![alt tag](https://raw.github.com/innofied/waterfallview/master/WaterfallView/Loading%20Gallery.png)
