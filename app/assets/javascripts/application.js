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
        $(this).removeAttr('hidden');
    },
    toggleItem: function() {
        $(this).toggleAttr('hidden','hidden');
    },
    closeItem: function(){
        $(this).attr('hidden', 'hidden');
    },
    clearField: function(){
        $(this).val('');
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
                $(reqSelector).removeAttr('hidden');
            } else {
                $(reqSelector).find('input').removeAttr('required');
                $(reqSelector).removeClass('required');
                $(reqSelector).attr('hidden', 'hidden');
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
        $(hideThese).find('input').val('');

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
	if( $("[type=date]")[0].type == 'text'){

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
            $(this).removeAttr('name');
            $hiddenDate.removeAttr('id');
            $hiddenDate.removeAttr('disabled');
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
