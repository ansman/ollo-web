(function() {
  "use strict";

  var Mixin = {};

  function callFunction(object, funcName) {
    var args = 3 <= arguments.length ? [].slice.call(arguments, 2) : [];
    if(object === null || object === undefined) return;
    if(typeof object[funcName] !== 'function') return;
    object[funcName].apply(object, args);
  }

  function applyMixin(applyProperty, appliedCallback, originalArgs) {
    var base, extensions, i, k, extension;
    base = originalArgs[0];
    extensions = 2 <= originalArgs.length ? [].slice.call(originalArgs, 1) : [];

    for(i = 0; i < extensions.length; i++) {
      extension = extensions[i];
      for(k in extension) {
        applyProperty(base, k, extension[k]);
      }
      appliedCallback(base, extension);
    }
  }

  Mixin.include = function() {
    applyMixin(
      function(base, k, v) {
        if(k !== 'included') base.prototype[k] = v;
      },
      function(base, extension) {
        callFunction(extension, 'included', base);
        callFunction(base, 'didInclude', extension);
      },
      arguments
    );
  };

  Mixin.extend = function(base) {
    applyMixin(
      function(base, k, v) {
        if(k !== 'extended') base[k] = v;
      },
      function(base, extension) {
        callFunction(extension, 'extended', base);
        callFunction(base, 'didExtend', extension);
      },
      arguments
    );
  };

  Mixin.includeMixinBase = function() {
    var classes, i;
    classes = [].slice.call(arguments, 0);

    function extend(cls) {
      cls.include = function() {
        Mixin.include.apply(Mixin, [cls].concat([].slice.call(arguments, 0)));
      };
      cls.extend = function() {
        Mixin.extend.apply(Mixin, [cls].concat([].slice.call(arguments, 0)));
      };
    }

    for(i = 0; i < classes.length; ++i) {
      extend(classes[i]);
    }
  };

  window.Mixin = Mixin;
})();
