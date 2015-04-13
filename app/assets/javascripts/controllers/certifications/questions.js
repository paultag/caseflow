/* global angular */

(function() {
  "use strict";

  angular.module('controllers').controller('CertificationsQuestionsController',
    ['$scope', '$location', '$routeParams', 'certificationFactory',
      function ($scope, $location, $routeParams, certificationFactory) {

        $scope.questions = {};

        $scope.questions.init = function() {
          if (certificationFactory.data) {
            $scope.certification = certificationFactory.data;
          }
          else {
            $location.path('/certifications/' + $routeParams.id + '/start');
          }
        };
      }]);
})();
