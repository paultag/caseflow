/* global angular,alert */

(function() {
  "use strict";

  angular.module('controllers').controller('CertificationsIndexController',
    ['$scope', '$http', '$location', 'certificationsFactory',
    function ($scope, $http, $location, certificationsFactory) {
      $scope.index = {};

      $scope.index.init = function() {
        certificationsFactory.data = {};
        $scope.index.id = null;
        $scope.index.loading = false;
      };

      $scope.index.go_to_start = function() {
        $scope.index.loading = true;

        var request = $http.get('/caseflow/api/certifications/start/' + $scope.index.id);

        request.success(function(certification) {
          certificationsFactory.data = certification;

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
