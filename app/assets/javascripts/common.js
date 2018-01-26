$(function(){

// $(document).on('turbolinks:load', function() {
  $('.nav-below__categoly__ul').hide();
  $(".nav-below__categoly").hover(function() {
      $(this).children('ul').show();
  }, function() {
      $(this).children('ul').hide();
  });

  $('.nav-below__tools__ul').hide();
  $(".nav-below__tools__account").hover(function() {
      $(this).children('ul').show();
  }, function() {
      $(this).children('ul').hide();
  });
});
