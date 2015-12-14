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
        if( $(event.target).hasClass('cf-modal') ) {
            $(event.target).closeItem();
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
    $('.cf-action-openmodal').on('click', function(e) {
        var toopen = $(e.target).attr('href');
        $(toopen).openItem();
    });

    $('.cf-action-close').on('click', function(e) {
        var toclose = $(e.target).data('controls');
        $(toclose).closeItem();

        /*
        Since this may be a modal shown using :target,
        we should update the hash to close it.
        */

        if(window.location.hash) {
            window.location.hash = '';
        }
    });

    $('.cf-modal').on('click', function(e){
        $(this).closeModal(e);
    });

    $(window).on('keydown', function(e){
        var escKey = (e.which == 27);
        if(escKey) {
            $('.cf-modal').trigger('click')
        }
    })
});


$(function(){
    /* Trigger for the dropdown */
    $(".dropdown-trigger").on('click', function(e) {
         e.preventDefault(); // Prevent page jump
         var dropdownMenu = $(this).attr('href');
         $(dropdownMenu).toggleItem();
    });

    $(":not(.dropdown)").on('click', function(e){
        if( !$(e.target).parents('.dropdown').length ) {
            $('.dropdown-menu').closeItem();
        }
    });
});

$(function(){
    $('fieldset').on('change', function(e) {
        e.stopPropagation();
        e.stopImmediatePropagation();

        var whichEl = $(this).data('linkedto'),
            showwhen = $(this).data('showwhen');

        if( showwhen == $(e.target).attr('id') ||
            showwhen == $(e.target).attr('name') ){
            $(whichEl).closeItem();
            $(whichEl).find('input').prop('checked', false);
        } else {
            $(whichEl).openItem();
        }
    });

    // TODO: Try to abstract this into a reusable pattern
    $('#13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER_REMARKS_input_id').on('input', function(e) {
        $other = $('#CHECK__13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER');
        /*
         Tests for presence of word characters. Spaces will never pass
        */
        $other.prop('checked', (/\w/).test( $(e.target).val() ));
    });

    $('#CHECK__13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER').on('change', function(e) {
        if ( !$(e.target).prop('checked') ) {
            $('#13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER_REMARKS_input_id').clearField();
        }
    });
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

        $("[type=date]").on('change', function(e) {
            $(this).next('[type=hidden]').val($(this).dateYYYYMMDD());
        });

        $("[type=date]").each(function(ind,inp){
            if( !!$(this).val() ) {
                console.log($(this).val());
                console.log( $(this).val( $(this).dateMMDDYYYY() ) );
            }
        })


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
        });

        /*
        Rewrite the format of the hidden input as yyyy-mm-dd
        whenever the date field changes
        */
        $("[type=date]").on('change', function(e) {
            $(this).next('[type=hidden]').val($(this).dateYYYYMMDD());
        });
    }
});
