
#import <MapKit/MapKit.h>
#import "OSAddress.h"
@class SPGooglePlacesAutocompleteQuery;



@protocol LocationPickerDelegate <NSObject>

@required
- (void) userDidSaveAddress:(OSAddress *)address;
@end

@interface OSLocationPicker : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MKMapViewDelegate>


@property (nonatomic, assign) id<LocationPickerDelegate> delegate;
    
@property (strong, nonatomic) SPGooglePlacesAutocompleteQuery *searchQuery;
@property (strong, nonatomic) NSArray *searchResultPlaces;
@property (nonatomic) BOOL shouldBeginEditing;
@property (strong ,nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) MKPointAnnotation *selectedPlaceAnnotation;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) CLGeocoder *geocoder;


@end
