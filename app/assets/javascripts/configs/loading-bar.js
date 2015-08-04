/* global angular */

(function() {
  'use strict';

  angular.module('loading-bar', ['angular-loading-bar'])
  .config(['cfpLoadingBarProvider', function(cfpLoadingBarProvider) {
    cfpLoadingBarProvider.includeSpinner = false;
  }])
})();
