/* global angular */

(function() {
  "use strict";

  angular.module('controllers').controller('CertificationsGenerateController',
    ['$scope', '$http', '$location', '$routeParams', 'certificationsFactory',
      function ($scope, $http, $location, $routeParams, certificationsFactory) {
        $scope.certifications = certificationsFactory;

        $scope.generate = {};

        $scope.generate.init = function() {
          if (!$scope.certifications.data) {
            $location.path('/certifications/' + $routeParams.id + '/start');
          }
        };
      }]);
})();
