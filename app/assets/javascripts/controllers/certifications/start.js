/* global angular */

(function() {
  "use strict";

  angular.module('controllers').controller('CertificationsStartController',
    ['$controller', '$scope', '$http', '$location', '$routeParams', 'certificationFactory',
    function ($controller, $scope, $http, $location, $routeParams, certificationFactory) {

      $controller('CertificationsController', {$scope: $scope});

      $scope.start = {};

      $scope.start.test = "hello there!";

      $scope.start.init = function() {
        if (certificationFactory.data) {
          $scope.start.cert = certificationFactory.data
        }
        else {
          var request = $http.get('/api/certifications/start/' + $routeParams.id);

          request.success(function(cert) {
            $scope.start.cert = certificationFactory.data = cert;
          });

          request.error(function() {
            $location.path('/certifications/');
          });
        }
      };
    }]);
})();
