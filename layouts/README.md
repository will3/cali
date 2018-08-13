# Layouts

Layouts is simplier layout library. It's simple like CSS but completely different. It has a fluent, chainable interface. The potential is endless.

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

Design Philosophy

NSLayoutConstraint is very powerful. It is however, overkill for most applications. 
CSS for e.g. doesn't have nearly as much complexity, yet it works fine.
Layouts is a convention over configuration layout library
it implements a flexbox-like interface with .stack, and shorthands for nearly every layout need

Full documentation here: [link]

RoadMap
- Mac support  
- Backwards support iOS 9  
- Better documentation, maybe with pictures and stuff  