$(function(){

  $('[id^=quantityselecter]').change( function(){

    // 生id取得 ワイルドカード利用
    var strid = ($(this).attr("id"));

    // 生idから、共通文字を削除してcartidを取得
    var cartid = strid.replace(/quantityselecter/,"");

    // cartidに、#を追加
    var rep_strid = "#" + strid;

    // #を追加したcartidで、セレクトボックスの値を取得
    var quantity = $(rep_strid).val();

    // PATCHに送るURLを生成
    var targeturl = "/carts/" + cartid

    $.ajax({
      url: targeturl,
      type: "PATCH",
      data: {
        cartid : cartid,
        quantity : quantity,
        updflg : 1
      },
      datatype: "html",
      success: function(data){
        location.reload();
      },
      error: function(data){
      }
    });
  });

});
