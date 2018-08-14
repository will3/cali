Hi,  
I'm Will, am a developer based in Auckland. 
I've had lots of fun working on the project.

<span><img src="https://github.com/will3/cali/blob/master/ms1.gif" width="200"></span>
<span><img src="https://github.com/will3/cali/blob/master/ms3.gif" width="200"></span>

- Custom layout library  

I've written a custom layout library Layouts to help me layout views
It's a convention over configuration, CSS inspired framework with a chainable interface

- Browsable internal documentation  
[link](http://will3.github.io/calidoc)  

<img src="https://github.com/will3/cali/blob/master/doc.png" width="400">

- Dependency injection
DI is implement to enable different containers to be written for tests
Unit tests uses a container that returns mock objects,
UI Tests uses a different container, so they always run at the same date, and never makes any service calls.


- UI tests  
UI Tests are written using the page pattern:
for e.g.
```
    MainView(app: app)
        .createEvent()
        .save()
        .openEvent()
```

- Unit tests
I used Cuckoo to generate mock classes, Quick for creating specs
If I had more time, I would improve test coverage
