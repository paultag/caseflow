/* global angular,alert */

(function() {
  "use strict";

  angular.module('controllers').controller('CertificationsIndexController',
    ['$scope', '$http', '$location', 'certificationFactory',
    function ($scope, $http, $location, certificationFactory) {

      $scope.index = {};

      $scope.index.init = function() {
        $scope.index.id = null;
        $scope.index.loading = false;
        certificationFactory.data = null;
      };

      $scope.index.start = function() {
        $scope.index.loading = true;

        var request = $http.get('/api/certifications/start/' + $scope.index.id);

        request.success(function(certification) {
          certificationFactory.data = certification;

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
