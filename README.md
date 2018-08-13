Hi,  
My name is Will, I'm an iOS developer based in Auckland. 
I've had lots of fun working on the project

<span><img src="https://github.com/will3/cali/blob/master/ms1.gif" width="200"></span>
<span><img src="https://github.com/will3/cali/blob/master/ms3.gif" width="200"></span>

- Custom layout library  
I made my own layout library Layouts to help me programmatically layout views
It's a convention over configuration, Flexbox inspired framework with a chainable interface

- Browsable internal documentation: [link](http://will3.github.io/calidoc)  

<img src="https://github.com/will3/cali/blob/master/doc.png" width="200">

- Dependency injection  

- UI Automated tests  
UI tests always run with the same date, and without any service calls to reduce failure points.
Tests are written using the page pattern:
for e.g.
```
    MainView(app: app)
        .createEvent()
        .save()
        .openEvent()
```

- Unit tests  
I used Quick to generate specs which makes tests easier to read
