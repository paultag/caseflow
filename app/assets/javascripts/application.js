//= require jquery.min
//= require jquery_ujs
//= require moment.min
//= require lodash.min
//= require angular.min
//= require angular-route.min
//= require angular-animate.min
//= require loading-bar.min
//= require bootstrap-sprockets

//= require ./configs/angular
//= require ./configs/loading-bar
//= require ./configs/rails
//= require ./configs/lodash

//= require ./directives/navigation
//= require ./directives/form

//= require ./factories/certifications_factory

//= require ./controllers/app_controller
//= require ./controllers/nav_controller
//= require ./controllers/certifications/index_controller
//= require ./controllers/certifications/start_controller
//= require ./controllers/certifications/questions_controller
//= require ./controllers/certifications/generate_controller

//= require ./controllers/tests_controller

//= require ./routes

//= require_self

(function() {
  "use strict";

  $(document).popover({
    selector: "[data-toggle=popover]"
  });
})();
