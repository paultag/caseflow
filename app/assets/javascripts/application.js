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

// For IE9
if (typeof String.prototype.trim !== 'function') {
    String.prototype.trim = function () {
        return this.replace(/^\s+|\s+$/g, '');
    }
}


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


// --- START: JS for questions.html.erb ---

/**
* Show a linked text field when a particular checkbox or radio input is selected
*
* 1. Requires inputs and related text fields to be grouped within the same fieldset.
* 2. Requires the revealed item to have a data-showwhen attribute. The value for this
*    attribute should match that of the item that triggers the reveal.
*/

/* Change event bubbles up, so we can wait until it hits fieldset */
$('fieldset').on('change', function(e){
    /*
    If this is a checkbox, toggle the visibility of
    its sibling.
    */

    // TODO: Refactor this to use openItem/closeItem/toggleItem

    if( $(e.target).attr('type') == 'checkbox' ) {
        $(this).find('[data-showwhen]').toggleClass('hidden');
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
        $(this).find('[data-showwhen]').removeClass('hidden');
    } else {
        $(this).find('[data-showwhen]').addClass('hidden');
    }

});

// --- END: JS for questions.html.erb ---

$(function(){
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
