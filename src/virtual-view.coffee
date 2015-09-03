#--------------------------------------------------
#	Virutal View Modules
#--------------------------------------------------
d             = require('dom-delegator')()
h             = require 'virtual-dom/h'
clone         = require 'clone'
diff          = require 'virtual-dom/diff'
patch         = require 'virtual-dom/patch'
VText         = require 'virtual-dom/vnode/vtext'
isVNode       = require 'virtual-dom/vnode/is-vnode'
createElement = require 'virtual-dom/create-element'



class VirtualView

	links   = {}
	counter = 1


	constructor: ->

		@VV = new class VV

		# Retrieve arguments
		args = Array.prototype.slice.call arguments

		# Check if root was provided
		if rootNode = args[0]?.root

			# Delete root from the provided arguments
			delete args[0].root

			# Remove the root property
			args.shift() if Object.keys(args[0]).length is 0

		# Set and increase id counter
		@VV.vid = counter++

		# Link storage
		links[@VV.vid] = {}

		# Define properties if not defined
		properties = properties || {}

		# Check if events have been set
		if events = this.events

			# Loop over all events
			for key of events

				# Get event handler
				handler = events[key]

				# Check if string is provided
				if isString handler

					# Store function
					func = @[handler]

				else

					# Store the handler as function
					func = handler

				# Store function
				properties["ev-#{key}"] = func

		# Create VirtualNode
		@VV.$el = h this.selector, properties

		# Store classes
		@VV.classes = @VV.$el.properties.className.split ' ' if @VV.$el.properties.className

		# Root Node extra's
		if rootNode

			# Store clone from $el for later use
			@VV.$elPrevious = clone @VV.$el

			# Store root VirtualNode
			window.VV = @

			# Provide a DOM node
			@el = createElement @VV.$el

		# Run initialize if set
		@initialize.apply @, args if @initialize


	addClass: (className) ->

		# Block non strings
		return error 2 if not isString className

		add = []

		# Loop over all classnames
		for name in className.split ' '

			# Add className if not found
			add.push name if @VV.classes.indexOf(name) is -1

		# Guard: Only continue if there are classes to be added
		return if add.length is 0

		# Create a one-string className from the classNames array
		# TODO: don't use concat (lower performance than a loop?)
		@VV.$el.properties.className = (@VV.classes = @VV.classes.concat(add)).join ' '

		# Update (v)DOM
		@update()


	removeClass: (className) ->

		# Block non strings
		return error 2 if not isString className

		remove = []

		# Loop over all classnames
		for name in className.split ' '

			# Add className if found
			remove.push name if @VV.classes.indexOf(name) isnt -1

		# Guard: Only continue if there are classes to be removed
		return if remove.length is 0

		# Remove classes from VV.classes
		# TODO: don't use .filter (lower performance than a loop?)
		@VV.classes = @VV.classes.filter((i) -> return remove.indexOf(i) < 0);

		# No classes by default
		classes = undefined

		# Create classes string if there are classes left
		classes = @VV.classes.join ' ' if @VV.classes.length isnt 0

		# Set className from the new classes array
		@VV.$el.properties.className = classes

		# Update (v)DOM
		@update()


	append: (vView, silent) ->

		# Check if string is provided
		if isString vView

			# Create VirtualNode text
			vView =
				$el: new VText vView
				VV:
					vid: counter++

			# Store $el as child
			child = vView.$el

			# Link storage
			links[vView.VV.vid] = {}

		else if not ((child = vView.VV.$el) and isVNode(child))

			return error 1

		# Provide the vView with a parent
		vView.parent = @

		# Store link id
		links[@VV.vid][vView.VV.vid] = @VV.$el.children.length

		# Append a VirtualNode child
		@VV.$el.children.push child

		# Update (v)DOM
		@update silent


	prepend: (vView, silent) ->

		# Check if string is provided
		if isString vView

			# Create VirtualNode text
			child = new VText vView

		else if not ((child = vView.$el) and isVNode(child))

			return error 1

		# Provide the vView with a parent
		vView.parent = @

		# Save links + id
		links_connected = links[@VV.vid]

		# Increse all link id's
		for key of links_connected

			# Guard
			return if not links_connected.hasOwnProperty key

			# Increase count
			links_connected[key]++

		# Store link id
		links_connected[vView.id] = 0

		# Prepend a virtual child
		@VV.$el.children.unshift child

		# Update (v)DOM
		@update silent


	update: (silent) ->

		if VV is @

			# Don't patch the (v)DOM
			return if silent

			# Update (v)DOM
			@el = patch @el, diff @VV.$elPrevious, @VV.$el

			# Store clone of 'old' $el
			@VV.$elPrevious = clone @VV.$el

		else

			# Update rootNode
			VV.update silent

		@


	remove: ->

		if @parent

			# Remove index
			remove = links[@parent.VV.vid][@VV.vid]

			# Remove item
			@parent.VV.$el.children.splice remove, 1

			# Update parent
			@parent.update()

		else

			# Remove trough parent
			@el.parentNode.removeChild @el


	error = (code) ->

		console.log "Error code: #{code}"

		console.log 'Only a "string" or a "VirtualNode" is a valid input' if code is 1

		console.log 'Only a "string" is a valid input' if code is 2


	isString = (string) ->

		typeof string is 'string' or string instanceof String



module.exports = VirtualView