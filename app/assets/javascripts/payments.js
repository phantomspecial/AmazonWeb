$(function(){

  // クレジットカード詳細表示
  $(".credit").click(function(){
    $($(this).next(".textarea")).animate(
     {height: "toggle", opacity: "toggle"},
     "fast"
    );
  });
});
