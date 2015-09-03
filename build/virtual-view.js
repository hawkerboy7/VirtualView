(function() {
  var VText, VirtualView, clone, createElement, d, diff, h, isVNode, patch;

  d = require('dom-delegator')();

  h = require('virtual-dom/h');

  clone = require('clone');

  diff = require('virtual-dom/diff');

  patch = require('virtual-dom/patch');

  VText = require('virtual-dom/vnode/vtext');

  isVNode = require('virtual-dom/vnode/is-vnode');

  createElement = require('virtual-dom/create-element');

  VirtualView = (function() {
    var counter, error, isString, links;

    links = {};

    counter = 1;

    function VirtualView() {
      var VV, args, events, func, handler, key, properties, ref, rootNode;
      this.VV = new (VV = (function() {
        function VV() {}

        return VV;

      })());
      args = Array.prototype.slice.call(arguments);
      if (rootNode = (ref = args[0]) != null ? ref.root : void 0) {
        delete args[0].root;
        if (Object.keys(args[0]).length === 0) {
          args.shift();
        }
      }
      this.VV.vid = counter++;
      links[this.VV.vid] = {};
      properties = properties || {};
      if (events = this.events) {
        for (key in events) {
          handler = events[key];
          if (isString(handler)) {
            func = this[handler];
          } else {
            func = handler;
          }
          properties["ev-" + key] = func;
        }
      }
      this.VV.$el = h(this.selector, properties);
      if (this.VV.$el.properties.className) {
        this.VV.classes = this.VV.$el.properties.className.split(' ');
      }
      if (rootNode) {
        this.VV.$elPrevious = clone(this.VV.$el);
        window.VV = this;
        this.el = createElement(this.VV.$el);
      }
      if (this.initialize) {
        this.initialize.apply(this, args);
      }
    }

    VirtualView.prototype.addClass = function(className) {
      var add, j, len, name, ref;
      if (!isString(className)) {
        return error(2);
      }
      add = [];
      ref = className.split(' ');
      for (j = 0, len = ref.length; j < len; j++) {
        name = ref[j];
        if (this.VV.classes.indexOf(name) === -1) {
          add.push(name);
        }
      }
      if (add.length === 0) {
        return;
      }
      this.VV.$el.properties.className = (this.VV.classes = this.VV.classes.concat(add)).join(' ');
      return this.update();
    };

    VirtualView.prototype.removeClass = function(className) {
      var classes, j, len, name, ref, remove;
      if (!isString(className)) {
        return error(2);
      }
      remove = [];
      ref = className.split(' ');
      for (j = 0, len = ref.length; j < len; j++) {
        name = ref[j];
        if (this.VV.classes.indexOf(name) !== -1) {
          remove.push(name);
        }
      }
      if (remove.length === 0) {
        return;
      }
      this.VV.classes = this.VV.classes.filter(function(i) {
        return remove.indexOf(i) < 0;
      });
      classes = void 0;
      if (this.VV.classes.length !== 0) {
        classes = this.VV.classes.join(' ');
      }
      this.VV.$el.properties.className = classes;
      return this.update();
    };

    VirtualView.prototype.append = function(vView, silent) {
      var child;
      if (isString(vView)) {
        vView = {
          $el: new VText(vView),
          VV: {
            vid: counter++
          }
        };
        child = vView.$el;
        links[vView.VV.vid] = {};
      } else if (!((child = vView.VV.$el) && isVNode(child))) {
        return error(1);
      }
      vView.parent = this;
      links[this.VV.vid][vView.VV.vid] = this.VV.$el.children.length;
      this.VV.$el.children.push(child);
      return this.update(silent);
    };

    VirtualView.prototype.prepend = function(vView, silent) {
      var child, key, links_connected;
      if (isString(vView)) {
        child = new VText(vView);
      } else if (!((child = vView.$el) && isVNode(child))) {
        return error(1);
      }
      vView.parent = this;
      links_connected = links[this.VV.vid];
      for (key in links_connected) {
        if (!links_connected.hasOwnProperty(key)) {
          return;
        }
        links_connected[key]++;
      }
      links_connected[vView.id] = 0;
      this.VV.$el.children.unshift(child);
      return this.update(silent);
    };

    VirtualView.prototype.update = function(silent) {
      if (VV === this) {
        if (silent) {
          return;
        }
        this.el = patch(this.el, diff(this.VV.$elPrevious, this.VV.$el));
        this.VV.$elPrevious = clone(this.VV.$el);
      } else {
        VV.update(silent);
      }
      return this;
    };

    VirtualView.prototype.remove = function() {
      var remove;
      if (this.parent) {
        remove = links[this.parent.VV.vid][this.VV.vid];
        this.parent.VV.$el.children.splice(remove, 1);
        return this.parent.update();
      } else {
        return this.el.parentNode.removeChild(this.el);
      }
    };

    error = function(code) {
      console.log("Error code: " + code);
      if (code === 1) {
        console.log('Only a "string" or a "VirtualNode" is a valid input');
      }
      if (code === 2) {
        return console.log('Only a "string" is a valid input');
      }
    };

    isString = function(string) {
      return typeof string === 'string' || string instanceof String;
    };

    return VirtualView;

  })();

  module.exports = VirtualView;

}).call(this);
