/* global angular */

(function() {
  "use strict";

  angular.module('controllers').controller('CertificationsStartController',
    ['$scope', '$http', '$location', '$routeParams', 'certificationFactory',
    function ($scope, $http, $location, $routeParams, certificationFactory) {

      $scope.start = {};

      $scope.start.test = "hello there!";

      $scope.start.init = function() {
        if (certificationFactory.data) {
          $scope.certification = certificationFactory.data
        }
        else {
          var request = $http.get('/api/certifications/start/' + $routeParams.id);

          request.success(function(certification) {
            $scope.certification = certificationFactory.data = certification;
          });

          request.error(function() {
            $location.path('/certifications/');
          });
        }
      };
    }]);
})();
