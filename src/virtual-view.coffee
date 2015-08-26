#--------------------------------------------------
#	Virutal Dom
#--------------------------------------------------
window.h				= require 'virtual-dom/h'
window.diff				= require 'virtual-dom/diff'
window.patch			= require 'virtual-dom/patch'
window.VText			= require 'virtual-dom/vnode/vtext'
window.createElement	= require 'virtual-dom/create-element'



class VirtualView

	VVclasses : []


	constructor: ->

		# Create element
		@el = createElement @$el = h this.selector, this.properties

		# Store classes
		@VVclasses = @$el.properties.className.split ' ' if @$el.properties.className

		# Run initialize if set
		@initialize() if @initialize


	addClass: (className) ->

		add = []

		# Loop over all possible
		for name in className.split ' '

			# Add className if not found
			add.push name if @VVclasses.indexOf(name) is -1

		# Guard only add classes if they were not found
		return if add.length is 0

		# Create class name from array
		@$el.properties.className = (@VVclasses = @VVclasses.concat(add)).join ' '

		# Update (v)DOM
		@_update()


	removeClass: (className) ->

		remove = []

		# Loop over all possible
		for name in className.split ' '

			# Add className if not found
			remove.push name if @VVclasses.indexOf(name) isnt -1

		# Guard only remove classes if they were not found
		return if remove.length is 0

		# Remove classes from VVclasses
		@VVclasses = @VVclasses.filter((i) => return remove.indexOf(i) < 0);

		# No classes by default
		classes = undefined

		# Create classes string if there are classes left
		classes = @VVclasses.join ' ' if @VVclasses.length isnt 0

		# Set className from array
		@$el.properties.className = classes

		# Update (v)DOM
		@_update()


	append: (child)->

		# Add child
		@$el.children.push child

		# Update (v)DOM
		@_update()


	prepend: (child)->

		# Add child
		@$el.children.unshift child

		# Update (v)DOM
		@_update()


	_update: ->

		# Update the vdom
		@el = patch @el, diff @el, @$el









	# VVupdate: (selector, options, children) ->

	# 	# Update element
	# 	@el = patch @el, diff @el, @$el = h selector, options, children


	# VVselector: (selector) ->

	# 	properties = @$el.properties

	# 	properties.id = undefined
	# 	properties.className = undefined

	# 	# Update selector
	# 	@update selector, properties , @$el.children


	# VVproperties: (properties) ->

	# 	@el = patch @el, diff @el, @$el.properties = properties

	# 	# Update element
	# 	@update @$el.tagName, properties, @$el.children


	# VVchildren: (children) ->

	# 	# Update element
	# 	@update @$el.tagName, @$el.properties, children




module.exports = VirtualView