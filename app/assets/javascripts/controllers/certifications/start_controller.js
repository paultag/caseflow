/* global angular */

(function() {
  "use strict";

  angular.module('controllers').controller('CertificationsStartController',
    ['$scope', '$http', '$location', '$routeParams', 'certificationsFactory',
    function ($scope, $http, $location, $routeParams, certificationsFactory) {
      $scope.certifications = certificationsFactory;

      $scope.start = {};

      $scope.start.init = function() {
        if (!$scope.certifications.data) {
          var request = $http.get('/caseflow/api/certifications/start/' + $routeParams.id);

          request.success(function(certification) {
            $scope.certifications.data = certificationsFactory.data =  certification;
          });

          request.error(function() {
            $location.path('/certifications');
          });
        }
      };
    }]);
})();
