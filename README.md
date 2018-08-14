## Cali
an Outlook Calendar clone
<img src="https://github.com/will3/cali/blob/master/icon.png" width="60">

Hi, my name is Will. I'm an iOS developer based in Auckland.  
Over the last two weeks, I've been working on a clone of the Outlook Calendar App. I think the App has lots of well made features, and I had lots of fun working on this project. :]

<span><img src="https://github.com/will3/cali/blob/master/ms1.gif" width="200"></span>
<span><img src="https://github.com/will3/cali/blob/master/ms3.gif" width="200"></span>

## Custom layout library  

I've written a custom layout library to help me layout custom views:  
[Layouts](https://github.com/will3/layouts)
[Documentation](https://will3.github.io/layoutsdoc/Classes/LayoutBuilder.html)
It's a convention over configuration, CSS inspired framework with a chainable interface


## Browsable internal documentation

Documentation generation is fully automated and extracted from file
[link](http://will3.github.io/calidoc)  

<img src="https://github.com/will3/cali/blob/master/doc.png" width="400">

## Dependency injection

I've implemented a DI container to control dependencies injected
UI Tests for e.g., will always run on the same date, which reduces side effects and false positives
Unit tests uses a container that returns mock objects

## UI tests

UI Tests are written using the page pattern  
for e.g.
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

- More unit and UI test coverage  
  Due to time constraints, I've only wrote a few tests
- Geocoding weather location
	currently, it's only based on user location
- Adding location to events
  No way of adding a location when creating events
- Local notifications
	Ability to configure and show notifications as reminders