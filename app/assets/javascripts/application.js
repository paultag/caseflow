/*
// = require jquery
// = require clipboard
// = require jquery-ui/datepicker

*/
//= require_self

/*
Extends jQuery to add a toggleAttr method
https://gist.github.com/mathiasbynens/298591
*/
jQuery.fn.toggleAttr = function(attr) {
 return this.each(function() {
  var $this = $(this);
  $this.attr(attr) ? $this.removeAttr(attr) : $this.attr(attr, attr);
 });
};


/* --------------------------------
Reusable methods
------------------ */

$.fn.extend({
    /* Format dates in yyyy-mm-dd */
    dateYYYYMMDD: function () {
        var ts, d, dArr;

        arguments[0] ? ts = Date.parse(arguments[0]) : ts = Date.parse( $(this).val() );
        d = new Date(ts) ;
        dArr = [];

        dArr[0] = d.getFullYear();
        dArr[1] = $.fn.zeroPadLeft(d.getUTCMonth() + 1);
        dArr[2] = $.fn.zeroPadLeft(d.getUTCDate());

        return dArr.join('-');
    },
    /* Format dates in mm/mm/yyyy */
    dateMMDDYYYY: function () {
        var ts, d, dArr;

        arguments[0] ? ts = Date.parse(arguments[0]) : ts = Date.parse( $(this).val() );
        d = new Date(ts) ;
        dArr = [];

        dArr[0] = $.fn.zeroPadLeft(d.getUTCMonth()+1);
        dArr[1] = $.fn.zeroPadLeft(d.getUTCDate());
        dArr[2] = d.getFullYear();

        return dArr.join('/');
    },
    /* Left zero-pad a numeric string */
    zeroPadLeft: function () {
        var zero = '0', pad = '', len, padded, inp, extract;

        inp = arguments[0] + '';

        /* If we have a 2nd argument, use it. Default is 2 */
        arguments[1] ? len = arguments[1] : len = 2;

        /* Save the length in extract for later */
        extract = len;

        while(len--){
            pad += zero;
        }
        padded = pad + inp;
        return padded.substr(padded.length - extract);
    },
    openItem: function() {
        $(this).show(50, function(){
            $(this).removeAttr('hidden')
        });
    },
    toggleItem: function() {
        $(this).toggle(50);
    },
    closeItem: function() {
        $(this).hide(500,function(){
            $(this).attr('hidden', 'true')
        });
    },
    clearField: function() {
        $(this).val('');
    },
    showTextError: function(msg) {
        $(this).siblings('label').find('.usa-input-error-message').text(msg);
    },
    showRadioError: function (msg) {
        $(this).parents('fieldset').find('.usa-input-error-message').text(msg);
    },
    clearError: function() {
        $(this).parents('.usa-input-error').find('.usa-input-error-message').text('');
        $(this).parents('.usa-input-error').removeClass('usa-input-error');
    },
    closeModal: function(event) {
        event.stopPropagation();
        event.stopImmediatePropagation();

        if( $(event.target).hasClass('cf-modal') || $(event.target).hasClass('cf-action-closemodal') ) {
            event.preventDefault();
            $(event.currentTarget).closeItem();
        }
    },
    openModal: function(e) {
        e.preventDefault();
        var toopen = $(e.target).attr('href');
        $(toopen).openItem();
    },
    showLinkedTextField: function(e){
        var $linked = $(this).find('[data-linkedto]');


        if( !!$linked.length && $linked.data('linkedto')) {
            var reqSelector = $linked.data('linkedto');

            if( (/\w/).test($linked.val()) ) {
                $(reqSelector).find('input').attr('required','required');
                $(reqSelector).addClass('required');
                $(reqSelector).openItem();
            } else {
                $(reqSelector).find('input').removeAttr('required');
                $(reqSelector).removeClass('required');
                $(reqSelector).closeItem();
            }
        }
    },
    showFieldLinkedFromRadio: function(e){
        var showThis = $(e.target).data('show'),
            hideThese = $(e.target).data('hide');

        $(hideThese).closeItem();

        $(hideThese).find('input').removeAttr('required');
        /* Deselect radio buttons, checkboxes */
        $(hideThese).find('[type=radio], [type=checkbox]').prop('checked', false);

        /* Clear other text fields */
        $(hideThese).find('[type=text], textarea').val('');

        /* Unset radio buttons and checkboxes */
        $(hideThese).find('[type=checkbox], [type=radio]').prop('checked', false);

        $(showThis).openItem();

        if( $(showThis).data('requiredifshown') !== undefined ) {
            $(showThis).addClass('required');
            $(showThis).find('input').filter(':visible').each(function(){
                $(this).attr('required','required');
            });
        }
    }
});

/* Copies appeals ID to clipboard */
(function () {
     "use strict";
     new Clipboard('[data-clipboard-text]');
 })();

/* Reusable 'go back one page' pattern */
 $(function() {
    $('.cf-action-back').on('click', function(evt) {
        window.history.back();
    });
 });

/* Reusable 'refresh' pattern */
$(function() {
    $('.cf-action-refresh').on('click', function(evt) {
        location.reload(); return false;
    });
});

/* Reusable 'modal' pattern */
$(function() {
    $('.cf-action-openmodal').on('click', $.fn.openModal);
    $('.cf-modal').on('click', $.fn.closeModal);

    /* Triggers click event user presses Escape key */
    $(window).on('keydown', function(e){
        var escKey = (e.which == 27);
        if(escKey) {
            $('.cf-modal').trigger('click');
        }
    })
});


$(function() {
    /* Trigger for the dropdown */
    $(".cf-dropdown-trigger").on('click', function(e) {
         e.preventDefault(); // Prevent page jump
         var dropdownMenu = $(this).attr('href');
         $(dropdownMenu).toggleItem();
    });

    $(":not(.cf-dropdown)").on('click', function(e) {
        if(!$(e.target).parents('.cf-dropdown').length) {
            $('.cf-dropdown-menu').closeItem();
        }
    });

    /*
    JavaScript that toggles hidden attribute for tooltips.
    Not strictly necessary, but better accessibilty support
    than display:none/display:block alone.
    */
    $(".cf-tooltip-trigger").on('mouseenter', function() {
         $(this).siblings('.cf-tooltip-text').openItem();
    });

    $(".cf-tooltip-trigger").on('mouseleave', function(e) {
        $(this).siblings('.cf-tooltip-text').closeItem();
    });
});

$(function() {

    $('#Q13').on('change', function(e){
        if( $(e.target).attr('id') == 'CHECK__13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER') {
            if($(e.target).prop('checked')) {
                $('#13_Specify_Other').removeAttr('hidden');
            } else {
                $('#13_Specify_Other').attr('hidden','hidden');
                $('#13_Specify_Other').find('input').val('');
            }
        }
    })

    /* Adds conditional show/hide based on radio buttons. */
    $('.cf-form-showhide-radio').on('change', $.fn.showFieldLinkedFromRadio);
    $('.cf-form-cond-req').on('input', $.fn.showLinkedTextField);
});

/*
Adding date picker _only_ when the date type is
unsupported. Format of this input will be
mm/dd/yyyy, which matches browsers in which the
input[type=date] is supported.
*/
$(function() {

	if( $("<input type='date'>")[0].type == 'text'){
        /* Add the date picker UI */
        $("[type=date]").datepicker();

        /* Rewrite dates to mm/dd/yyy format*/
        $("[type=date]").each(function(){
            if( !!$(this).val() ) {
                $(this).val( $(this).dateMMDDYYYY() );
            }
        });

        /*
        Clone date type inputs and make them
        hidden so that we can send dates in yyyy-mm-dd
        format
        */
        $("[type=date]").each(function(ind,inp){
            var $hiddenDate = $(this).clone(true);
            $hiddenDate.attr('type','hidden');
            $hiddenDate.insertAfter(this);
            /*
            Remove the name from the original item so
            Only the hidden value gets sent. Also remove
            the id attribute from the hidden field so
            there's no label confusion.
            */
            $hiddenDate.removeAttr('id');
            $hiddenDate.removeAttr('disabled');
            $hiddenDate.val($(this).dateYYYYMMDD());
        });

        /*
        Rewrite the format of the hidden input as yyyy-mm-dd
        whenever the date field changes.
        */
        $("[type=date]").on('change', function(e) {
            $(this).next('[type=hidden]').val($(this).dateYYYYMMDD());
        });

        /* Rewrite the value of 17C_Date to yyyy-mm-dd format */
        $("[disabled] + [type=hidden]").each(function(){
            if( !!$(this).val() ) {
                $(this).val( $(this).dateYYYYMMDD() );
            }
        });
    }
});


$(document).on('ready', function(e){
    $('.cf-form-cond-req').trigger('input');
})


/*----------------------------------
 * Error handling for questions form
 * ----------------------------------*/
$(function(){
    var ERROR_MESSAGES = {
        '3_LAST_NAME_FIRST_NAME_MIDDLE_NAME_OF_VETERAN': "Please enter the veteran's full name.",
        '5B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED':'Please enter the date of notification.',
        '6B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED':'Please enter the date of notification.',
        '7B_DATE_OF_NOTIFICATION_OF_ACTION_APPEALED':'Please enter the date of notification.',
        '8A_APPELLANT_REPRESENTED_IN_THIS_APPEAL_BY': 'Oops! Looks like you missed one! Please select one of these options.',
        '8B_POWER_OF_ATTORNEY': 'Oops! Looks like you missed one! Please select one of these options.',
        '8C_IF_AGENT_DESIGNATED_IS_HE_SHE_ON_ACCREDITED_LIST': 'Oops! Looks like you missed one! Please select one of these options.',
        '8B_REMARKS': 'Please provide the location.',
        '9B_IF_VA_FORM_646_IS_NOT_OF_RECORD_EXPLAIN': 'Oops! Looks like you missed one! Please select one of these options.',
        '9A_IF_REPRESENTATIVE_IS_SERVICE_ORGANIZATION_IS_VA_FORM_646': 'Oops! Looks like you missed one! Please select one of these options.',
        '10A_WAS_HEARING_REQUESTED': 'Oops! Looks like you missed one! Please select one of these options.',
        '10B_IF_HELD_IS_TRANSCRIPT_IN_FILE': 'Oops! Looks like you missed one! Please select one of these options.',
        '11A_ARE_CONTESTED_CLAIMS_PROCEDURES_APPLICABLE_IN_THIS_CASE': 'Oops! Looks like you missed one! Please select one of these options.',
        '11B_HAVE_THE_REQUIREMENTS_OF_38_USC_BEEN_FOLLOWED': 'Oops! Looks like you missed one! Please select one of these options.',
        '12B_SUPPLEMENTAL_STATEMENT_OF_THE_CASE': 'Oops! Looks like you missed one! Please select one of these options.',
        '13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER_REMARKS': 'Please tell us which records will be forwarded.',
        '17A_SIGNATURE_OF_CERTIFYING_OFFICIAL': 'Please enter the name of the Certifying Official (usually your name).',
        '17B_TITLE': 'Please enter the title of the Certifying Official (e.g. Decision Review Officer).'
    };

    /* Handles the invalidfield error triggered when an invalid error is. */
    $('fieldset, .form8-text-input').on('invalidfield', function(e){
        $(e.target).addClass('usa-input-error');
    });

    $('[type=radio]').on('invalid', function(e){
        e.preventDefault(); /* Prevents native error bubbles */
        $(e.target).showRadioError(ERROR_MESSAGES[e.target.name]);
        /* Dispatch an event on the parent element */
        $(e.target).parents('fieldset').trigger('invalidfield');
    });

    $('[type=text]').on('invalid', function(e){
        e.preventDefault(); /* Prevents error bubbles */
        $(e.target).showTextError(ERROR_MESSAGES[e.target.name]);
        /* Dispatch an event on the parent element */
        $(e.target).parents('fieldset, .form8-text-input').trigger('invalidfield');
        $(e.target).attr('id');
    });

    $('[type=date]').on('invalid', function(e){
        e.preventDefault();
        $(e.target).showTextError(ERROR_MESSAGES[e.target.name]);
        $(e.target).parents('.form8-text-input').trigger('invalidfield');
    });

    $('[type=radio]').on('change', function(e){
        if(e.target.validity.valid) {
            $(this).clearError();
        }
    });

    $('[type=text]').on('input', function(e){
        if(e.target.validity.valid) {
            $(this).clearError();
        }
    });

});
