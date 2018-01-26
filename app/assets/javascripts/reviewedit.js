$(function(){
// $(document).on('turbolinks:load', function() {

  $('[id^=editreview]').click(function(){

    var revid = ($(this).attr("id"));

    var html = revid.replace(/editreview/, "#editrev");

    var appendhtml = '<div id="' + html+ '"></div>'

    var reviewid = revid.replace(/editreview/, "");
    var selectrate = $("#selectedstar" + reviewid ).val();

    var element = document.getElementById("target" + reviewid);
    var elements = element.rate;

    switch (selectrate){
      case "1":
        elements[4].checked = true;
        break;
      case "2":
        elements[3].checked = true;
        break;
      case "3":
        elements[2].checked = true;
        break;
      case "4":
        elements[1].checked = true;
        break;
      case "5":
        elements[0].checked = true;
        break;
    }

    $(html).css({
      "z-index": "10"
    });

    $("body").append(appendhtml);
    modalResize();
    $("appendhtml, .edit-modal").fadeIn("slow");
    $(".modal-bg").click(function(){
      $("appendhtml,.modal-bg").fadeOut("slow",function(){
        $('.modal-bg').remove() ;
      });
    });
    $(window).resize(modalResize);
    function modalResize(){
      var w = $(window).width();
      var h = $(window).height();
      var cw = $("appendhtml").outerWidth();
      var ch = $("appendhtml").outerHeight();
      $("appendhtml").css({
        "padding-left": ((w - cw)/2) + "px",
        "padding-top": ((h - ch)/2) + "px"
      });
    }
  });
});
