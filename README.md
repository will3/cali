## Cali

<img src="https://github.com/will3/cali/blob/master/icon.png" width="60">  
an Outlook Calendar clone  

---

<span><img src="https://github.com/will3/cali/blob/master/ms1.gif" width="200"></span>
<img src="https://github.com/will3/cali/blob/master/ms3.gif" width="200">

<img src="https://github.com/will3/cali/blob/master/today.gif" width="32">

## Custom layout library  

I've written a custom layout library to help me layout custom views:  
[Layouts](https://github.com/will3/layouts)  
[Layouts Documentation](https://will3.github.io/layoutsdoc/Classes/LayoutBuilder.html)  
It's a convention over configuration, CSS inspired framework with a chainable interface


## Browsable documentation

Documentation generation is fully automated
[Browse](https://will3.github.io/calidoc/Classes/Curl.html)  

<img src="https://github.com/will3/cali/blob/master/doc.png" width="400">

## Dependency injection

I've implemented a DI container to makes mocks and stubs possible in unit tests,  
and reduce side effects in UI tests.  
For e.g., UI tests will always run on the same date, and never make any actual service calls.

## UI tests

UI Tests are written using the page pattern  
For e.g.
```
// Test create event and open
    MainView(app: app)
        .createEvent()
        .save()
        .openEvent()
        .assertEventOpened()
```

## Unit tests
I've written some tests around formatters, and included examples on how I would write tests for View Controllers.

## If I had more time...

- **More unit and UI tests**  
  Due to time constraints, I've only written a few tests
- **Geocoding weather location**  
	Currently, it's only based on user location  
- **Adding location to events**  
  No way of adding a location when creating events  
- **Local notifications**  
	Ability to configure and show notifications as reminders  
- **Handle major location changes**  
- **Clean up submodules**  
	Move calidoc, layouts, layoutdoc to submodules
