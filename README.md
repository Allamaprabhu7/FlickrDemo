# FlickrDemo

Flickr public feed API is used to download data

API used "https://api.flickr.com/services/feeds/photos_public.gne"

App uses NSOperations to perfrom asynchronus data downlaods

Number of operations that can be downlaoded can be configured.

Code is optimized to handle events such that only donwlaoded datasource gets reloaded

Downloaded data is serialized to disk and shown on screen using UICollectionview.
