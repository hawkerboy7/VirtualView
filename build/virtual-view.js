(function() {
  var VirtualView, clone,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  clone = require('clone');

  window.d = require('dom-delegator')();

  window.h = require('virtual-dom/h');

  window.diff = require('virtual-dom/diff');

  window.patch = require('virtual-dom/patch');

  window.VText = require('virtual-dom/vnode/vtext');

  window.isVNode = require('virtual-dom/vnode/is-vnode');

  window.createElement = require('virtual-dom/create-element');

  VirtualView = (function() {
    var counter, error, links;

    links = {};

    counter = 1;

    VirtualView.prototype.VVclasses = [];

    function VirtualView(rootNode) {
      this.remove = bind(this.remove, this);
      this.update = bind(this.update, this);
      this.prepend = bind(this.prepend, this);
      this.append = bind(this.append, this);
      this.removeClass = bind(this.removeClass, this);
      this.addClass = bind(this.addClass, this);
      var events, func, handler, key;
      this.id = counter++;
      links[this.id] = {};
      this.properties = this.properties || {};
      if (events = this.events) {
        for (key in events) {
          handler = events[key];
          if (typeof handler === 'string' || handler instanceof String) {
            func = this[handler];
          } else {
            func = handler;
          }
          this.properties["ev-" + key] = func;
        }
      }
      this.$el = h(this.selector, this.properties);
      if (this.$el.properties.className) {
        this.VVclasses = this.$el.properties.className.split(' ');
      }
      if (rootNode) {
        this.$elPrevious = clone(this.$el);
        window.VV = this;
        this.el = createElement(this.$el);
      }
      if (this.initialize) {
        this.initialize();
      }
    }

    VirtualView.prototype.addClass = function(className) {
      var add, j, len, name, ref;
      add = [];
      ref = className.split(' ');
      for (j = 0, len = ref.length; j < len; j++) {
        name = ref[j];
        if (this.VVclasses.indexOf(name) === -1) {
          add.push(name);
        }
      }
      if (add.length === 0) {
        return;
      }
      this.$el.properties.className = (this.VVclasses = this.VVclasses.concat(add)).join(' ');
      return this.update();
    };

    VirtualView.prototype.removeClass = function(className) {
      var classes, j, len, name, ref, remove;
      remove = [];
      ref = className.split(' ');
      for (j = 0, len = ref.length; j < len; j++) {
        name = ref[j];
        if (this.VVclasses.indexOf(name) !== -1) {
          remove.push(name);
        }
      }
      if (remove.length === 0) {
        return;
      }
      this.VVclasses = this.VVclasses.filter((function(_this) {
        return function(i) {
          return remove.indexOf(i) < 0;
        };
      })(this));
      classes = void 0;
      if (this.VVclasses.length !== 0) {
        classes = this.VVclasses.join(' ');
      }
      this.$el.properties.className = classes;
      return this.update();
    };

    VirtualView.prototype.append = function(vView, silent) {
      var child;
      if (typeof vView === 'string' || vView instanceof String) {
        child = new VText(vView);
      } else if (!((child = vView.$el) && isVNode(child))) {
        return error(1);
      }
      vView.parent = this;
      links[this.id][vView.id] = this.$el.children.length;
      this.$el.children.push(child);
      return this.update(silent);
    };

    VirtualView.prototype.prepend = function(vView, silent) {
      var child, key, links_connected;
      if (typeof vView === 'string' || vView instanceof String) {
        child = new VText(vView);
      } else if (!((child = vView.$el) && isVNode(child))) {
        return error(1);
      }
      vView.parent = this;
      links_connected = links[this.id];
      for (key in links_connected) {
        if (!links_connected.hasOwnProperty(key)) {
          return;
        }
        links_connected[key]++;
      }
      links_connected[vView.id] = 0;
      this.$el.children.unshift(child);
      return this.update(silent);
    };

    VirtualView.prototype.update = function(silent) {
      if (VV === this) {
        if (silent) {
          return;
        }
        this.el = patch(this.el, diff(this.$elPrevious, this.$el));
        this.$elPrevious = clone(this.$el);
      } else {
        VV.update(silent);
      }
      return this;
    };

    VirtualView.prototype.remove = function() {
      var remove;
      if (this.parent) {
        remove = links[this.parent.id][this.id];
        this.parent.$el.children.splice(remove, 1);
        return this.parent.update();
      } else {
        return this.el.parentNode.removeChild(this.el);
      }
    };

    error = function(code) {
      console.log("Error code: " + code);
      if (code === 1) {
        return console.log('Only a "string" or a "VirtualNode" is a valid input');
      }
    };

    return VirtualView;

  })();

  module.exports = VirtualView;

}).call(this);
