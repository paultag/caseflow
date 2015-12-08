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

    $('#13_Specify_Other').on('input', function(e) {
        /*
         Replaces white space with '' so we don't get
         blank responses
        */
        $other = $('#CHECK__13_RECORDS_TO_BE_FORWARDED_TO_BOARD_OF_VETERANS_APPEALS_OTHER');
        $other.prop('checked', (/\w/).test( $(e.target).val() ));
    });
});
