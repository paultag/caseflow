/* global angular */

(function() {
  "use strict";

  angular.module('controllers').controller('CertificationsQuestionsController',
    ['$controller', '$scope', '$location', '$routeParams', 'certificationFactory',
      function ($controller, $scope, $location, $routeParams, certificationFactory) {

        $controller('CertificationsController', {$scope: $scope});

        $scope.questions = {};

        $scope.questions.init = function() {
          if (certificationFactory.data) {
            $scope.cert = certificationFactory.data;
          }
          else {
            $location.path('/certifications/' + $routeParams.id + '/start');
          }
        };
      }]);
})();
