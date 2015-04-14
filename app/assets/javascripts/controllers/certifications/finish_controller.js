/* global angular */

(function() {
  "use strict";

  angular.module('controllers').controller('CertificationsFinishController',
    ['$scope', '$http', '$location', '$routeParams', 'certificationsFactory',
      function ($scope, $http, $location, $routeParams, certificationsFactory) {
        $scope.certifications = certificationsFactory;

        $scope.finish = {};

        $scope.finish.init = function() {
          if (!$scope.certifications.data) {
            $location.path('/certifications/' + $routeParams.id + '/start');
          }
        };
      }]);
})();
