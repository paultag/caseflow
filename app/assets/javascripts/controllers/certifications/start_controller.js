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

              // Check to see if dates are equal (VACOLS <--> VBMS)
              $scope.certifications.data.info.datesMatch =
                  certification.info.bfdnod === certification.info.efolder_nod &&
                  certification.info.bfdsoc === certification.info.efolder_soc &&
                  certification.info.bfssoc1 === certification.info.efolder_ssoc1 &&
                  certification.info.bfssoc2 === certification.info.efolder_ssoc2 &&
                  certification.info.bfssoc3 === certification.info.efolder_ssoc3 &&
                  certification.info.bfssoc4 === certification.info.efolder_ssoc4 &&
                  certification.info.bfssoc5 === certification.info.efolder_ssoc5 &&
                  certification.info.bfd19 === certification.info.efolder_form9;

              // Was going to use `datesMatch` in multiple places, but Angular will only use the variable once for ng-show, so creating two
              $scope.certifications.data.info.showInstructions = !$scope.certifications.data.info.datesMatch;
          });

          request.error(function() {
            alert("Sorry! We could not find the appellant for this case in VBMS. Please verify that the appellant ID for this case is correct in VACOLS")
            $location.path('/certifications');
          });
        }
      };
    }]);
})();
