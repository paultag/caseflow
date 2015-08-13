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

        $scope.questions.power_of_attorney = null;

        $scope.$watch('questions.power_of_attorney', function(newValue) {
          if (newValue === '8B_POWER_OF_ATTORNEY') {
            $scope.certifications.data.fields['8B_POWER_OF_ATTORNEY'] = 'yes';
            $scope.certifications.data.fields['8B_CERTIFICATION_THAT_VALID_POWER_OF_ATTORNEY_IS_IN_ANOTHER_VA_FILE'] = undefined;
          }

          if (newValue === '8B_CERTIFICATION_THAT_VALID_POWER_OF_ATTORNEY_IS_IN_ANOTHER_VA_FILE') {
            $scope.certifications.data.fields['8B_POWER_OF_ATTORNEY'] = undefined;
            $scope.certifications.data.fields['8B_CERTIFICATION_THAT_VALID_POWER_OF_ATTORNEY_IS_IN_ANOTHER_VA_FILE'] = 'yes';
          }
        });


        $scope.questions.invalid = function() {
          return _.isEmpty($scope.certifications.data.fields['17A_SIGNATURE_OF_CERTIFYING_OFFICIAL']) || _.isEmpty($scope.certifications.data.fields['17B_TITLE']);
        };

        $scope.questions.go_to_generate = function() {
          $scope.questions.loading = true;

          var bfkey = $scope.certifications.data.info.bfkey;
          var request = $http.post('/caseflow/api/certifications/generate/' + bfkey, {fields: $scope.certifications.data.fields});

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

        //function uniqueCheckboxes() {
        //  var checkboxes = _.unique($.map($('input[type="checkbox"][data-unique]'), function(x) { return $(x).data('unique'); }));
        //
        //  _.each(checkboxes, function(name) {
        //    var group = $('input[type="checkbox"][data-unique="' + name + '"]');
        //
        //    group.change(function() {
        //      if (this.checked) {
        //        group.not($(this)).prop('checked', false);
        //      }
        //    });
        //  });
        //}
      }]);
})();