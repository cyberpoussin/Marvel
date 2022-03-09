# Marvel
An iOS app based on the Marvel API as part of a job application.

<img src="https://github.com/cyberpoussin/cyberpoussin/blob/main/MarvelDemo2.gif" width="200">

## Architecture
We have two screens here (a List of Heroes and the Details of each Hero). 
Which use two data sources: the Marvel API (for the general list of heroes), and the device storage (for the squad).

I decided to use a Store to communicate with these two data sources.
I am using two ViewModels (one per screen), which share the same Store.

In detail we could describe this architecture as follows:
Services - Provider - Store - ViewModels - Screens - Views

### Services and Providers
In these sample app, we use URLSession and UserDefauls, but because of the NetworkService and KeyValueServices protocol, it will be easy in the future to change (or mock) these services. 
The services are injected into the HeroesProvider by the constructor.

### Store
This store centralizes all the information concerning the two lists of heroes (the general one and the favorites list).
This is the source of truth for both screens list and details.
This store also accepts inputs (refresh lists, add / remove favorites).

### ViewModels
The two ViewModels (DetailsViewModel and ListViewModel) are subscribed to the Outputs of the store (thanks to Combine).
ViewModels never directly modify the data they publish to the views, but modify the store data (which is propagated, always top-down).

### Dumb View and Screens
Dumb Views and screens
We started by making "dumb" views which are easily testable in the Previews.
They are then encapsulated in Screens, which link them to their ViewModels.

## Images
For downloading, displaying and caching images, we created a View, called ImageLoader

## Navigation Bar and Table View background
To configure more precisely the navigation bar, but also the background of the tableviews and their cells: we have created two ViewModifiers which serve as configurators.
These ViewModifiers instantiate UIViewControllerRepresentable, which can access UIKit components that need to be modified.
