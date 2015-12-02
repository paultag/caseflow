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
