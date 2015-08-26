(function() {
  var VirtualView,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.h = require('virtual-dom/h');

  window.diff = require('virtual-dom/diff');

  window.patch = require('virtual-dom/patch');

  window.VText = require('virtual-dom/vnode/vtext');

  window.createElement = require('virtual-dom/create-element');

  VirtualView = (function() {
    VirtualView.prototype.VVclasses = [];

    function VirtualView() {
      this.prepend = bind(this.prepend, this);
      this.append = bind(this.append, this);
      this.removeClass = bind(this.removeClass, this);
      this.el = createElement(this.$el = h(this.selector, this.properties));
      if (this.$el.properties.className) {
        this.VVclasses = this.$el.properties.className.split(' ');
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
      return this._update();
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
      return this._update();
    };

    VirtualView.prototype.append = function(child) {
      this.$el.children.push(child);
      return this._update();
    };

    VirtualView.prototype.prepend = function(child) {
      this.$el.children.unshift(child);
      return this._update();
    };

    VirtualView.prototype._update = function() {
      return this.el = patch(this.el, diff(this.el, this.$el));
    };

    return VirtualView;

  })();

  module.exports = VirtualView;

}).call(this);
