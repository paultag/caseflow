/*
 * = require jquery
 * = require clipboard
 */
 //= require_self

 (function () {
     "use strict";
     /* Copies appeals ID to clipboard */
     new Clipboard('[data-clipboard-text]');
 })();

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

$(function(){

    // --- START: JS for questions.html.erb ---

    /**
    * Show a linked text field when a particular checkbox or radio input is selected
    *
    * 1. Requires inputs and related text fields to be grouped within the same fieldset
         (which is the best way to mark it up anyway).
    * 2. Requires the revealed item to have a data-showwhen attribute. The value for this
    *    attribute should match that of the item that triggers the reveal. I.e., if the
    *    element should be triggered on when 'Yes' is selected, use data-showwhen="yes".
    */

    /* Change event bubbles up, so we can wait until it hits fieldset */
    $('fieldset').on('change', function(e){
        /*
        If this is a checkbox, toggle the visibility of
        its sibling.
        */

        if( $(e.target).attr('type') == 'checkbox' ) {
            $(this).find('[data-showwhen]').toggleItem();
        }

        /*
        Otherwise, assume it's a radio button. Find the element that should be
        triggered when that value is selected. If the value of showwhen matches
        the value of the selected item, show that item.
        */

        else if(
            $(this).find('[data-showwhen]').length &&
            $(this).find('[data-showwhen]').data('showwhen') == $(e.target).attr('value')
        ) {
            $(this).find('[data-showwhen]').openItem('hidden');
        } else {
            $(this).find('[data-showwhen]').closeItem('hidden', 'hidden');
        }

    });

    // --- END: JS for questions.html.erb ---

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
