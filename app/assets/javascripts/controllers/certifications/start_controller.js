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
            alert("Sorry! The BFKEY (case ID) VACOLS sent you here with does not have a corresponding record in VBMS. " +
                "Please return to VACOLS and verify the appellant ID/SSN is correct (and corresponds to the " +
                "appeallant in VBMS). After adjusting the appellant ID/SSN in VACOLS, enter the BFKEY (case ID) " +
                "on the page that will be shown after you close this error message.")
            $location.path('/certifications');
          });
        }
      };
    }]);
})();
