Hi,  
My name is Will, I'm an iOS developer based in Auckland. 
I've had lots of fun working on the project

<span><img src="https://github.com/will3/cali/blob/master/ms1.gif" width="200"></span>
<span><img src="https://github.com/will3/cali/blob/master/ms3.gif" width="200"></span>

- Custom layout library  

I've written a custom layout library Layouts to help me layout views
It's a convention over configuration, CSS inspired framework with a chainable interface

- Browsable internal documentation  
[link](http://will3.github.io/calidoc)  

<img src="https://github.com/will3/cali/blob/master/doc.png" width="400">

- Dependency injection
I've built a simple DI container to support mocks in unit / UI tests  
UI Tests are always run at the same date at 1970, for e.g.

- UI tests  
UI tests always run with the same preconditions, with mock dependencies that returns service calls instantly

Tests are written using the page pattern:
for e.g.
```
    MainView(app: app)
        .createEvent()
        .save()
        .openEvent()
```

- Unit tests  
I used Quick to generate test specifications that are easier to read
