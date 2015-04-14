/* global angular,alert */

(function() {
  "use strict";

  angular.module('controllers').controller('CertificationsQuestionsController',
    ['$scope', '$location', '$http', '$routeParams', 'certificationsFactory',
      function ($scope, $location, $http, $routeParams, certificationsFactory) {
        $scope.certifications = certificationsFactory;

        $scope.questions = {};

        $scope.questions.init = function() {
          $scope.questions.loading = false;

          if (!$scope.certifications.data) {
            $location.path('/certifications/' + $routeParams.id + '/start');
          }
        };

        $scope.questions.go_to_generate = function() {
          $scope.questions.loading = true;

          var bfkey = $scope.certifications.data.info.bfkey;
          var request = $http.post('/api/certifications/generate/' + bfkey, {fields: $scope.certifications.data.fields});

          request.success(function(resp) {
            $scope.certifications.data.info.bf41stat = resp.bf41stat;
            $scope.certifications.data.info.file_name = resp.file_name;

            $location.path('/certifications/' + bfkey + '/generate');
          });

          request.error(function() {
            alert("Sorry, Something has gone wrong!");
          });

          request.finally(function() {
            $scope.questions.loading = false;
          });

        };
      }]);
})();
