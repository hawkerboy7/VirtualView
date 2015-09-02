# virtual-view



## What is it?

`virtual-view` is a view for the [virtual dom](https://github.com/Matt-Esch/virtual-dom) similar to a [backbone view](http://backbonejs.org/#View).



## Support

The `virtual-view` provides you with the following

- [el](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L65)<br>
	Contains the DOM node

- [$el](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L65)<br>
	Contains the VirtualDOM node representation ([VirtualNode](https://github.com/Matt-Esch/virtual-dom/blob/master/virtual-hyperscript/README.md))

- [selector](https://github.com/Matt-Esch/virtual-dom/blob/master/virtual-hyperscript/README.md)<br>
	This will be the first argument in the h() ([virtual-hyperscript](https://github.com/Matt-Esch/virtual-dom/blob/master/virtual-hyperscript/README.md)) function.
	In here you can add a tagName, id and className all at once.
	The sting will be parsed e.g. `span#super-class.special-layout.show`.

- [this.addClass](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L74)<br>
	This function allows you to add a single class or multiple classes to the virtual tree. It only adds the unique ones.

- [this.removeClass](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L95)<br>
	This function allows you to remove a single class or multiple classes from the virtual tree. It removes them if they are found.

- [this.append](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L125)<br>
	This function allows you to append a child to the virtual tree. It should either be a [VText](https://github.com/Matt-Esch/virtual-dom#example---creating-a-vtree-using-the-objects-directly) or an $el ([VirtualNode](https://github.com/Matt-Esch/virtual-dom/blob/master/virtual-hyperscript/README.md))

- [this.prepend](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L140)<br>
	Same as append only this will prepend.

- [this.update](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L159)<br>
	This function allows you to re-render the $el. You can call this after you've changed it's atributes. However classes should be changed trough the addClass and removeClass functions.

- [this.remove](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L168)<br>
	Removes element from the DOM and VirtualDOM



## Example

Below you can find an example (in [coffee-script](https://github.com/jashkenas/coffeescript)) showing you how you could use the `virtual-view`.


```coffeescript
VirtualView = require 'virtual-view'



class Secondary extends VirtualView

	selector: '#secondary.make-me-the-first-child'


	initialize: ->

		# Add a string
		@append 'I am Secondary (the first child)'

		setTimeout(=>

			# Remove this Virtual Node
			@remove()

		,8000)



class Main extends VirtualView

	# Set selector
	selector : '#main.show-me'


	initialize: ->

		# Add a single class
		@addClass 'this-class'

		# Add a string
		@append 'append-1 (text)'

		# Add a string
		@append 'append-2 (text)'

		# Add a Virtual Node
		@prepend new Secondary

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


## It's not done yet!

- [this.remove](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L168) still needs to be analized. It's not at a maximum effencientcy, also i am quite sure not everything is removed from memory completely.

- After removal all event listeners should be removed as well (this is still to be checked).