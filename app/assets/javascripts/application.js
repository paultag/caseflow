/*
 * = require vendor/jquery-1.11.3.min.js
 * = require components.js
 */
 //= require_self



(function () {
    "use strict";

    /* Copies appeals ID to clipboard */
    new Clipboard('[data-clipboard-text]');

})();

// For IE9
if (typeof String.prototype.trim !== 'function') {
    String.prototype.trim = function () {
        return this.replace(/^\s+|\s+$/g, '');
    }
}

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

// -- Functions for display specific fields --

var display_8b_explanation = function () {
    display_field("8B_POWER_OF_ATTORNEY", "8b-explanation", "8B_CERTIFICATION_THAT_VALID_POWER_OF_ATTORNEY_IS_IN_ANOTHER_VA_FILE");
}

var display_9b = function () {
    display_field("9A_IF_REPRESENTATIVE_IS_SERVICE_ORGANIZATION_IS_VA_FORM_646", "9b", "no");
}
var display_10c = function () {
    display_field("10B_IF_HELD_IS_TRANSCRIPT_IN_FILE", "10c", "no");
}
var display_11b = function () {
    display_field("11A_ARE_CONTESTED_CLAIMS_PROCEDURES_APPLICABLE_IN_THIS_CASE", "11b", "yes");
}

var display_13_other = function () {
    var isChecked = $("input[name='13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER']")[0].checked;
    var div = $('#13');
    if (isChecked) {
        div.removeClass("hidden");
    }
    else {
        div.addClass("hidden");
    }
}

function requiredFieldsComplete() {
    var a17Val = $('#17A_SIGNATURE_OF_CERTIFYING_OFFICIAL_input_id').val();
    var b17Val = $('#17B_TITLE_input_id').val();

    if (!a17Val.trim() || !b17Val.trim()) {
        return false;
    }

    return true;
}

var questionsSubmit = function (event) {
    if (!requiredFieldsComplete()) {
        alert("Please fill in 17A and 17B");
        return event.preventDefault();
    }
}

// -- Add listeners and other on page load behavior --

$(function () {
    $("input[name='8B_POWER_OF_ATTORNEY']").change(display_8b_explanation);
    $("input[name='9A_IF_REPRESENTATIVE_IS_SERVICE_ORGANIZATION_IS_VA_FORM_646']").change(display_9b);
    $("input[name='10B_IF_HELD_IS_TRANSCRIPT_IN_FILE']").change(display_10c);
    $("input[name='11A_ARE_CONTESTED_CLAIMS_PROCEDURES_APPLICABLE_IN_THIS_CASE']").change(display_11b);
    $("input[name='13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER']").change(display_13_other);
    $("#question-form").submit(questionsSubmit);

    // Restore the hidden fields that should be displayed, used when back button is used
    display_8b_explanation();
    display_9b();
    display_10c();
    display_11b();
    display_13_other();
});

// --- END: JS for questions.html.erb ---

/*------------------------------------
* Patterns based on Refills.bourbon.io
*------------------------------------*/

$(document).ready(function(){
  $(".dropdown-trigger").click(function(e) {
    e.preventDefault(); // Prevent page jump
    var dropdownMenu = $(this).attr('href');
    $(dropdownMenu).toggleClass("dropdown-show");
    $(".dropdown-menu > li").click(function(){
      $(".dropdown-menu").removeClass("dropdown-show");
    });
  });
});
