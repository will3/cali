# Layouts

Layouts is light weight layout framework that's built on top of NSLayoutConstraints. It is a convention over configuration library, and has a lot of shorthands built for most layout needs.

For e.g.
```
let parentLayout = 
layout(parent)
	// Height constraint of 50
	.height(50)
	// flexbox rows, essentially
	.stackHorizontal([
		// item 1
		layout(labelLeft)
			// 12px right margin
			.right(12),
		// item 2
		layout(labelRight)
	])
	// Align items vertically, if stacking vertically, align horizontally
	.alignItems(.center)
	.install()
```

Will add the two labels to parent, and stack them horizontally, like flexbox rows 

To uninstall / animate, simply keep the reference of the LayoutBuilder object: 

```
// let parentLayout = layout(parent).stackHorizontal([
// ...

// Update height to 200, it's still flexboxing
parentLayout.height(200).reinstall()

// Remove all constraints installed
parentLayout.uninstall()
```

### Why use Layouts

Layouts simplifies layout by sacrificing configurability. NSLayoutConstraint is overkill for most layout needs.

However, there are no shortage of great layout libraries on github, here's just a short list of libraries I took inspirations from:  
Masonry / SnapKit  
PureLayout  
LayoutKit  

### Documentation

Full documentation here: [link]()

### RoadMap

- Mac support  
- Backwards support iOS 9  
- Better documentation, maybe with pictures and stuff  