//= require jquery.min
//= require jquery_ujs
//= require moment.min
//= require lodash.min
//= require bootstrap-sprockets



//= require_self

(function() {
  "use strict";

  $(document).popover({
    selector: "[data-toggle=popover]",
    trigger: "focus"
  });
})();

// --- START: JS for questions.html.erb ---

/**
 * Shows/hides an element (with a specified ID attribute) when a checked radio
 * button (with a specific name attribute) has a particular value.
 *
 * @param inputName The radio input element to check for value
 * @param divId The ID of the element to show/hide
 * @param showValue The value of the input element needed to show the element indicated by divId
 */
function display_field(inputName, divId, showValue) {
    var selectedOption = $("input[name='" + inputName + "']:checked")[0];
    var div = $('#' + divId);

    if (selectedOption && selectedOption.value === showValue) {
        div.removeClass("hidden");
    }
    else {
        div.addClass("hidden");
    }
}

function display_8b_explanation() {
    display_field("8B_POWER_OF_ATTORNEY", "8b-explanation", "8B_CERTIFICATION_THAT_VALID_POWER_OF_ATTORNEY_IS_IN_ANOTHER_VA_FILE");
}

function display_9b() {
    display_field("9A_IF_REPRESENTATIVE_IS_SERVICE_ORGANIZATION_IS_VA_FORM_646", "9b", "no");
}
function display_10c() {
    display_field("10B_IF_HELD_IS_TRANSCRIPT_IN_FILE", "10c", "no");
}
function display_11b() {
    display_field("11A_ARE_CONTESTED_CLAIMS_PROCEDURES_APPLICABLE_IN_THIS_CASE", "11b", "yes");
}

function display_13_other() {
    var isChecked = $("input[name='13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER']")[0].checked;
    var div = $('#13');
    if (isChecked) {
        div.removeClass("hidden");
    }
    else {
        div.addClass("hidden");
    }
}

// --- END: JS for questions.html.erb ---