
#import <MapKit/MapKit.h>

@class SPGooglePlacesAutocompleteQuery;

@interface OSLocationPicker : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MKMapViewDelegate>
    
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;


@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) NSArray *searchResultPlaces;
@property (strong, nonatomic) SPGooglePlacesAutocompleteQuery *searchQuery;
@property (strong, nonatomic) MKPointAnnotation *selectedPlaceAnnotation;
@property (nonatomic) BOOL shouldBeginEditing;
@property (strong ,nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@end
