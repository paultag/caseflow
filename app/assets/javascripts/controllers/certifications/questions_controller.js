/* global angular,alert,_ */

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

        $scope.questions.checks = {};

        $scope.questions.checks.show_8c = function() { return true; };
        $scope.questions.checks.show_9b = function() { return true; };

        $scope.questions.invalid = function() {
          var check = (
            $scope.certifications.data.fields['8C_IF_AGENT_DESIGNATED_IS_HE_SHE_ON_ACCREDITED_LIST_YES'] === true &&
            $scope.certifications.data.fields['8C_IF_AGENT_DESIGNATED_IS_HE_SHE_ON_ACCREDITED_LIST_NO']  !== true &&
            $scope.certifications.data.fields['11B_HAVE_THE_REQUIREMENTS_OF_38_USC_BEEN_FOLLOWED_YES']   === true &&
            $scope.certifications.data.fields['11B_HAVE_THE_REQUIREMENTS_OF_38_USC_BEEN_FOLLOWED_NO']    !== true
          );

          return !check;
        };

        //$scope.questions.checks.show_8c = function() {
        //  return _.include(
        //    ['Attorney', 'Agent'],
        //    $scope.certifications.data.fields['8A_APPELLANT_REPRESENTED_IN_THIS_APPEAL_BY']
        //  );
        //};
        //
        //$scope.questions.checks.show_9b = function() {
        //  return $scope.certifications.data.fields['9A_IF_REPRESENTATIVE_IS_SERVICE_ORGANIZATION_IS_VA_FORM_646_NO'] === true;
        //};

        //$scope.questions.invalid = function() {
        //  var valid_8c = (
        //    (
        //      $scope.questions.checks.show_8c() === false
        //    ) ||
        //    (
        //      $scope.questions.checks.show_8c() === true &&
        //      $scope.certifications.data.fields['8C_IF_AGENT_DESIGNATED_IS_HE_SHE_ON_ACCREDITED_LIST_YES'] === true &&
        //      $scope.certifications.data.fields['8C_IF_AGENT_DESIGNATED_IS_HE_SHE_ON_ACCREDITED_LIST_NO']  !== true
        //    )
        //  );
        //
        //  var valid_9b = (
        //    (
        //      $scope.questions.checks.show_9b() === false
        //    ) ||
        //    (
        //      $scope.questions.checks.show_9b() === true &&
        //      !!$scope.certifications.data.fields['9B_IF_VA_FORM_646_IS_NOT_OF_RECORD_EXPLAIN']
        //    )
        //  );
        //
        //  return !valid_8c && !valid_9b;
        //};

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
