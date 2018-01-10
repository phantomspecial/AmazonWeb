$(document).on('turbolinks:load', function() {
  // $("#editreview").click(function()){
  //    $(this).parent().siblings('#edit-modal').fadeIn();
  // });
  // $('.updbtn').on('click',function(){
  //   $(this).parent().parent().parent('#edit-modal').fadeOut();
  // });



 $(".editreview").click(function(){
    alert("AAA");
      $("body").append('<div id="edit-modal"></div>');
      modalResize();
        $("#modal-bg,#edit-modal").fadeIn("slow");
        $("#modal-bg").click(function(){
          $("#edit-modal,#modal-bg").fadeOut("slow",function(){
              $('#modal-bg').remove() ;
          });
        });
      $(window).resize(modalResize);
      function modalResize(){
        var w = $(window).width();
        var h = $(window).height();
        var cw = $("#edit-modal").outerWidth();
        var ch = $("#edit-modal").outerHeight();
        $("#edit-modal").css({
          "left": ((w - cw)/2) + "px",
          "top": ((h - ch)/2) + "px"
        });
      }
   });














});


// $(document).on('turbolinks:load', function() {

//   $(document).on('click','.edit_review' ,function(){
//      $(this).parent().siblings('#edit-modal').fadeIn();
//    });,
//   $('.updbtn').on('click',function(){
//      $(this).parent().parent().parent('#edit-modal').fadeOut();
//    });

// });


