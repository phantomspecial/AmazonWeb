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
    var period = $('.returnperiod').val();
    if(period >= 0){
      document.getElementById("periodselecter").selectedIndex = period;
    }
  }

});
