/* global angular */

(function() {
  "use strict";

  angular.module('controllers').controller('NavController',
    ['$scope', '$location', function ($scope, $location) {
      $scope.nav = {};

      $scope.nav.activeLink = function(path) {
        return $location.path().match(new RegExp(path));
      };
    }]);
})();
