# virtual-view


## What is it?

`virtual-view` is a view for the [virtual dom](https://github.com/Matt-Esch/virtual-dom) similar to a [backbone view](http://backbonejs.org/#View).


## Support

The `virtual-view` provides you with the following:

- [selector](https://github.com/Matt-Esch/virtual-dom/blob/master/virtual-hyperscript/README.md):
	This will be the first argument in the h() ([virtual-hyperscript](https://github.com/Matt-Esch/virtual-dom/blob/master/virtual-hyperscript/README.md)) function.
	In here you can add a tagName, id and className all at once.
	The sting will be parsed e.g. `span#super-span.special-layout.show`.

- [this.addClass](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L28):
	This function allows you to add a a single class or multiple classes to the virtual tree and adds them if they are unique.

- [this.removeClass](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L48):
	This function allows you to remove a single class or multiple classes fromthe virtual tree

- el:
	Contains the DOM node

- $el:
	Contains the VirtualDom node representation

Do make sure classes are separated by a space.



## Example

Below you can find an example (in [coffee-script](https://github.com/jashkenas/coffeescript)) showing you how you could use the `virtual-view`.


```coffeescript
VirtualView = require 'virtual-view'



class Main extends VirtualView

	# Set selector
	selector : '#main'


	initialize: ->

		# Add a single class
		@addClass 'this-class'

		# Add multiple classes
		@addClass 'test1 test2 test3 test4'

		setTimeout(=>

			# Remove a single class
			@removeClass 'this-class'

			# Remove a multiple classes
			@removeClass 'test3 test4'

		,3000)


module.exports = Main


# Prepend the main to the body
document.body.insertBefore (new Main).el, document.body.firstChild
```



#### Obviously it's far from done =)