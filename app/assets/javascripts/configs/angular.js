/* global angular */

(function() {
  'use strict';

  angular.module('rails', []);
  angular.module('directives', []);
  angular.module('factories', []);
  angular.module('controllers', ['ngAnimate']);

  angular.module('application', ['ngRoute', 'rails', 'directives', 'factories', 'controllers']);
})();
