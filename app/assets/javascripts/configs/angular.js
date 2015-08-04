/* global angular */

(function() {
  'use strict';

  angular.module('rails', []);
  angular.module('directives', []);
  angular.module('factories', []);
  angular.module('controllers', ['ngRoute', 'ngAnimate', 'loading-bar']);

  angular.module('application', ['rails', 'directives', 'factories', 'controllers']);
})();
