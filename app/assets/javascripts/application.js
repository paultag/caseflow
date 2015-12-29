/*
 * = require jquery
 * = require clipboard
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
Reusable open/close Item methods
 -------------------------------- */

$.fn.extend({
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
        //
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
        var $linked = $(e.currentTarget).find('[data-linkedto]');

        if($linked.length && $linked.data('linkedto') ) {
            var reqSelector = $linked.data('linkedto'),
                $reqParent = $(reqSelector).parent();

            if( (/\w/).test($linked.val()) ) {
                $(reqSelector).attr('required','required');
                $reqParent.addClass('required');
                $reqParent.removeAttr('hidden');
            } else {
                $(reqSelector).removeAttr('required');
                $reqParent.removeClass('required');
                $reqParent.attr('hidden', 'hidden');
            }
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

    $('.cf-form-cond-req').on('input', $.fn.showLinkedTextField);
});

$(document).on('ready', function() {
    $('.cf-form-cond-req').trigger('input');
})
