/* global angular */

(function() {
  "use strict";

  angular.module('controllers').controller('CertificationsQuestionsController',
    ['$scope', '$location', '$routeParams', 'certificationsFactory',
      function ($scope, $location, $routeParams, certificationsFactory) {
        $scope.certifications = certificationsFactory;

        $scope.questions = {};

        $scope.questions.init = function() {
          if (!$scope.certifications.data) {
            $location.path('/certifications/' + $routeParams.id + '/start');
          }
        };
      }]);
})();
