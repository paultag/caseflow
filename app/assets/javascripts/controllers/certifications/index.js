/* global angular,alert */

(function() {
  "use strict";

  angular.module('controllers').controller('CertificationsIndexController',
    ['$controller', '$scope', '$http', '$location', 'certificationFactory',
    function ($controller, $scope, $http, $location, certificationFactory) {

      $controller('CertificationsController', {$scope: $scope});

      $scope.index = {};

      $scope.index.init = function() {
        $scope.index.id = null;
        $scope.index.loading = false;
        certificationFactory.data = null;
      };

      $scope.index.start = function() {
        $scope.index.loading = true;

        var request = $http.get('/api/certifications/start/' + $scope.index.id);

        request.success(function(cert) {
          certificationFactory.data = cert;

          $location.path('/certifications/' + $scope.index.id + '/start');
        });

        request.error(function() {
          alert("Sorry, Invalid ID!");
        });

        request.finally(function() {
          $scope.index.loading = false;
        });
      };
    }]);
})();
