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

	VVclasses : []


	constructor: ->

		# Set properties if not defined
		this.properties = this.properties || {}

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

					# Store the handler
					func = handler

				# Store function
				this.properties["ev-#{key}"] = func

		# Create VirtualNode and the DOM element
		@el = createElement @$el = h this.selector, this.properties

		# Store classes
		@VVclasses = @$el.properties.className.split ' ' if @$el.properties.className

		# Run initialize if set
		@initialize() if @initialize


	addClass: (className) ->

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
		@_update()


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
		@_update()


	append: (child) =>

		# Append a virtual child
		@$el.children.push child

		# Update (v)DOM
		@_update()


	prepend: (child) =>

		# Prepend a virtual child
		@$el.children.unshift child

		# Update (v)DOM
		@_update()


	_update: ->

		# Update the (v)DOM
		@el = patch @el, diff @el, @$el



module.exports = VirtualView