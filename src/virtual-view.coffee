#--------------------------------------------------
#	Virutal Dom
#--------------------------------------------------

window.d             = require('dom-delegator')()
window.h             = require 'virtual-dom/h'
window.diff          = require 'virtual-dom/diff'
window.patch         = require 'virtual-dom/patch'
window.VText         = require 'virtual-dom/vnode/vtext'
window.createElement = require 'virtual-dom/create-element'




class VirtualView

	links   = {}
	counter = 1

	VVclasses : []


	constructor: ->

		# Set and increase id counter
		@id = counter++

		# Link storage
		links[@id] = {}

		# Define properties if not defined
		this.properties = this.properties || {}

		# Main view
		if @id is 1

			# Virtual view storage
			window.VV =
				main: @

		# Check if events have been set
		if events = this.events

			# Loop over all events
			for key of events

				# Get event handler
				handler = events[key]

				# Check if string is provided
				if typeof handler is 'string' or handler instanceof String

					# Store function
					func = @[handler]

				else

					# Store the handler as function
					func = handler

				# Store function
				this.properties["ev-#{key}"] = func

		# Create VirtualNode and the DOM element
		@el = createElement @$el = h this.selector, this.properties

		# Store classes
		@VVclasses = @$el.properties.className.split ' ' if @$el.properties.className

		# Run initialize if set
		@initialize() if @initialize


	addClass: (className) =>

		add = []

		# Loop over all classnames
		for name in className.split ' '

			# Add className if not found
			add.push name if @VVclasses.indexOf(name) is -1

		# Guard: Only continue if there are classes to be added
		return if add.length is 0

		# Create a one-string className from the classNames array
		# TODO: don't use concat (lower performance than a loop?)
		@$el.properties.className = (@VVclasses = @VVclasses.concat(add)).join ' '

		# Update (v)DOM
		@update()


	removeClass: (className) =>

		remove = []

		# Loop over all classnames
		for name in className.split ' '

			# Add className if found
			remove.push name if @VVclasses.indexOf(name) isnt -1

		# Guard: Only continue if there are classes to be removed
		return if remove.length is 0

		# Remove classes from VVclasses
		# TODO: don't use .filter (lower performance than a loop?)
		@VVclasses = @VVclasses.filter((i) => return remove.indexOf(i) < 0);

		# No classes by default
		classes = undefined

		# Create classes string if there are classes left
		classes = @VVclasses.join ' ' if @VVclasses.length isnt 0

		# Set className from the new classes array
		@$el.properties.className = classes

		# Update (v)DOM
		@update()


	append: (vView, silent) =>

		console.log 'silent: ', silent

		# Check if string is provided
		if typeof vView is 'string' or vView instanceof String

			# Create VirtualNode text
			child = new VText vView

		else return if not (child = vView?.$el)

		# Provide the vView with a parent
		vView.parent = @

		# Store link id
		links[@id][vView.id] = @$el.children.length

		# Append a VirtualNode child
		@$el.children.push child

		# Update (v)DOM
		@update()


	prepend: (vView) =>

		# Provide the vView with a parent
		vView.parent = @

		# Save links + id
		links_connected = links[@id]

		# Increse all link id's
		for key of links_connected

			# Guard
			return if not links_connected.hasOwnProperty key

			# Increase count
			links_connected[key]++

		# Store link id
		links_connected[vView.id] = 0

		# Prepend a virtual child
		@$el.children.unshift vView.$el

		# Update (v)DOM
		@update()


	update: =>

		# Update the (v)DOM
		@el = patch @el, diff @el, @$el

		# Update parent
		VV?.main?.update() if VV?.main isnt @

		@


	remove: =>

		if @parent

			# Remove index
			remove = links[@parent.id][@id]

			# Remove item
			@parent.$el.children.splice remove, 1

			# Update parent
			@parent.update()

		else

			# Remove trough parent
			@el.parentNode.removeChild @el


	error = (code)->

		console.log 'Error code:', 1



module.exports = VirtualView