# Converge

Description needed.

# Future Features
 * Robert
  * User accounts (using Parse)
    * User will register with
      * First Name
      * Last Name
      * Phone Number
      * Address
    * Login with facebook?
   * Avatar preferences?
   * Store preferences / logged in status
 * Tri
  * Create icons for searched interest points
    * beer, apples, generic restaurant symbols, etc. Think sunrise calendar.
  * Add icons for @1x, @2x, @3x into the image assets.
  * Layout refinements. Work with Mario.
 * Mario
  * Implement Hamburger menu.
    * Display settings here.
      * Choosing between imperial vs metric units
      * Radius from halfway points too?
  * Add filters to common interest points search.
    * Work with Lorenzo with this.
    * Distance filter (1 mi, 2 mi, etc). 
      * Look at Map VC for request.region = MKCoordinate....
      * Distance filter has to be transferred over and converted to degrees.
      * Make helper method - (double) convertDistanceFilterToDegrees...etc.
 * Joseph
  * New view (PinInformationViewController?)
    * New view comes up when the person clicks on more information on the pin.
    * Pass the pin information over.
      * This new view should display information by the restaurant
        * Info provided by Yelp? Look into Apple Maps API.
        * Display price information, description, phone number, etc.
        * Include a link to open up apple maps with the address
 * Lorenzo
  * Create custom annotations for the search results
    * There should be two custom annotations classes. 
      * One for search results and another for location1, loc2, halfway.
  * Zoom out the map accordingly to see all of the pins. Work with Robert on it.
 * Chris
  * Add the ability to work with multiple locations.
    * Requires change in the storyboard, homeVC, mapVC. 
    * Work with Robert if needed.
    * Storyboard will need to be smooth in adding the new locations.
 
