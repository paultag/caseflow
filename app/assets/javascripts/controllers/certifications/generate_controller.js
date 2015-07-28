/* global angular,alert */

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

        $scope.generate.go_to_finish = function() {
          $scope.generate.loading = true;

          var data = $scope.certifications.data;
          var request = $http.post('/caseflow/api/certifications/certify/' + data.info.bfkey, {
            cert: {
              certification_date: data.info.bf41stat,
              file_name: data.info.file_name
            }
          });

          request.success(function() {
            $location.path('/certifications/' + data.info.bfkey + '/finish');
          });

          request.error(function() {
            alert("Sorry, Something has gone wrong!");
          });

          request.finally(function() {
            $scope.generate.loading = false;
          });
        };
      }]);
})();
