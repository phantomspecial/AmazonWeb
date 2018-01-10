$(function(){

//   $("#periodselecter").change( function(){
//     var selectterm = $("#periodselecter").val();

//     $.ajax({
//       url: "/orders",
//       type: "GET",
//       data: {period : selectterm},
//       datatype: "html",
//       success: function(data){
//         debugger;
//         location.reload();
//         $("#periodselecter").val() = selectterm
//       },
//       error: function(data){
//         //失敗時の処理
//       }
//     });
//   });


  window.onload = function(){
    period = $('.returnperiod').val();
    document.getElementById("periodselecter").selectedIndex = period;
  }

});
