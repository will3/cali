Hi,  
My name is Will, I'm an iOS developer based in Auckland. 
I've had lots of fun working on this project, I think the App is well made, and it has lots of interesting features to replicate.

![gif 1](https://github.com/will3/cali/blob/master/ms1.gif?raw=true)
![gif 2](https://github.com/will3/cali/blob/master/ms3.gif?raw=true)

- Custom layout library  
I made my own layout library Layouts to help me programmatically layout views
It's a convention over configuration, Flexbox inspired framework with a chainable interface

- Full Apple style documentation: link  

- Dependency injection  

- UI Automated tests  
UI tests always run with the same preconditions, and without any service calls to reduce failure points.
Tests are written using the page pattern  
for e.g.
```
    MainView(app: app)
        .createEvent()
        .save()
        .openEvent()
```

- Unit tests  
I used Quick to generate specs which makes tests easier to read
