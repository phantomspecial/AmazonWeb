$(document).on('turbolinks:load', function() {

  $(".edit_review").click(function()){
     $(this).parent().siblings('#edit-modal').fadeIn();
  });
  $('.updbtn').on('click',function(){
    $(this).parent().parent().parent('#edit-modal').fadeOut();
  });

});


// $(document).on('turbolinks:load', function() {

//   $(document).on('click','.edit_review' ,function(){
//      $(this).parent().siblings('#edit-modal').fadeIn();
//    });
//   $('.updbtn').on('click',function(){
//      $(this).parent().parent().parent('#edit-modal').fadeOut();
//    });

// });


