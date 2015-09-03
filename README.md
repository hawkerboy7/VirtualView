# virtual-view



## What is it?

The `virtual-view` is a view for the [virtual dom](https://github.com/Matt-Esch/virtual-dom) similar to a [backbone view](http://backbonejs.org/#View).



## Root Node
You can provide an argument for `vitrual-view` allowing for a single Root Node.
```coffeescript
# Require virtual-view
VirtualView = require 'virtual-view'

# Create the class Main
class Main extends VirtualView

	# Set selector
	selector: '#main'


# Main will now be a 'root' Virtual View and will also have the .el available
main = new Main root: true

main.el # => Contains the DOM node (<div id="main"></div>)

# sub will be a regular Virtual View
sub = new Main

sub.el # => Undefined
```


## Support

The `virtual-view` provides you with the following

- [el](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L65)<br>
	Contains the DOM node (which should be appended or prepended to the document.body)

- [$el](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L65)<br>
	Contains the VirtualDOM node representation ([VirtualNode](https://github.com/Matt-Esch/virtual-dom/blob/master/virtual-hyperscript/README.md))

- [selector](https://github.com/Matt-Esch/virtual-dom/blob/master/virtual-hyperscript/README.md)<br>
	This will be the first argument in the h() ([virtual-hyperscript](https://github.com/Matt-Esch/virtual-dom/blob/master/virtual-hyperscript/README.md)) function.
	In here you can add a tagName, id and className all at once.
	The sting will be parsed e.g. `span#super-class.special-layout.show`.

- [this.addClass( String )](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L79)<br>
	This function allows you to add a single class or multiple classes to the virtual tree. It only adds the unique ones.

- [this.removeClass( String )](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L100)<br>
	This function allows you to remove a single class or multiple classes from the virtual tree. It removes them if they are found.

- [this.append( String or VirtualView [, Param {silent:true}] )](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L130)<br>
	This function allows you to append a child to the virtual tree. The `silent` param allows you to append without triggering the update function on the Root Node. This way you won't unnessisarily render when appending or prepending multiple Virtual Views.

- [this.prepend( String or VirtualView [, Param {silent:true}] )](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L155)<br>
	Same as append only this will prepend.

- [this.update()](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L192)<br>
	This function allows you to re-render the Root Node. You can call this after you've changed atributes on any Virtual View. However classes should be changed trough the addClass and removeClass functions.

- [this.remove()](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L213)<br>
	Removes element from the DOM and VirtualDOM



## Example

Below you can find an example (in [coffee-script](https://github.com/jashkenas/coffeescript)) showing you how you could use the `virtual-view`.


```coffeescript
VirtualView = require 'virtual-view'



class Primary extends VirtualView

	selector: '#primary.make-me-the-first-child'

	events:
		'click' : 'remove'


	initialize: ->

		# Add a string
		@append 'I am Primary (the first child)'



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

		# Add a Virtual View
		@prepend new Primary

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
document.body.insertBefore (new Main root: true).el, document.body.firstChild
```


## It's not done yet!
Up next:

- Remove bug (multiple children cannot be removed out of order yet)

- [this.children]() This function will allow you to set a VirtualNode's children all at once.

- [this.toggleClass]() Toggles one or multiple classes on or off.

- [this.remove](https://github.com/hawkerboy7/virtual-view/blob/master/src/virtual-view.coffee#L168) still needs to be analized. It's not at a maximum effencientcy, also I am quite sure not everything is removed from memory completely.<br>
After removal all event listeners should be removed as well (this is still to be checked).

- Update the render procedure using Thunks or another method to prevent the diff function from checking Virtual Views that didn't change for sure