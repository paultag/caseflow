//= require jquery.min
//= require jquery_ujs
//= require moment.min
//= require lodash.min
//= require bootstrap-sprockets



//= require_self

(function() {
  "use strict";

  $(document).popover({
    selector: "[data-toggle=popover]",
    trigger: "focus"
  });
})();
