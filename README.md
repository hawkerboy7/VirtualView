# virtual-view



## What is it?

`virtual-view` is a view for the [virtual dom](https://github.com/Matt-Esch/virtual-dom) similar to a [backbone view](http://backbonejs.org/#View).



## Support

The `virtual-view` provides you with the following

- [selector](https://github.com/Matt-Esch/virtual-dom/blob/master/virtual-hyperscript/README.md)<br>
	This will be the first argument in the h() ([virtual-hyperscript](https://github.com/Matt-Esch/virtual-dom/blob/master/virtual-hyperscript/README.md)) function.
	In here you can add a tagName, id and className all at once.
	The sting will be parsed e.g. `span#super-class.special-layout.show`.

- [this.addClass](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L29)<br>
	This function allows you to add a a single class or multiple classes to the virtual tree. It only adds the unique ones.

- [this.removeClass](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L49)<br>
	This function allows you to remove a single class or multiple classes from the virtual tree. It removes them if they are found.

- [this.append](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L78)<br>
	This function allows you to append a child to the virtual tree. It should eiter be a [VText](https://github.com/Matt-Esch/virtual-dom#example---creating-a-vtree-using-the-objects-directly) or a virtualView.$el (which is a [VirtualNode](https://github.com/Matt-Esch/virtual-dom/blob/master/virtual-hyperscript/README.md))

- [this.prepend](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L87)<br>
	Same as append only this will prepend.

- el<br>
	Contains the DOM node

- $el<br>
	Contains the VirtualDom node representation



## Example

Below you can find an example (in [coffee-script](https://github.com/jashkenas/coffeescript)) showing you how you could use the `virtual-view`.


```coffeescript
VirtualView = require 'virtual-view'



class Secondary extends VirtualView

	selector: '#secondary.make-me-the-first-child'

	initialize: ->

		# Add a VText
		@append new VText 'I am Secondary (the first child)'



class Main extends VirtualView

	# Set selector
	selector : '#main'


	initialize: ->

		# Add a single class
		@addClass 'this-class'

		# Add a VText
		@append new VText 'append-1'

		# Add a VText
		@append new VText 'append-2'

		# Add a Virtual Node
		@prepend (new Secondary).$el

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



#### Obviously it's not done =)
It still needs the event listener support for example.