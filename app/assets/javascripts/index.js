$(function () {
  $('.select.nav-over__center__content__left__searchselect').hover(function() {
    $(this).next('select.nav-over__center__content__left__searchselect').show();
  }, function(){
    $(this).next('.select.nav-over__center__content__left__searchselect').hide();
  });
});
