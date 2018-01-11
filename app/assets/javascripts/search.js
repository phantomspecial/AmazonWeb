$(document).on('turbolinks:load', function() {

  $("#stock_name_field").autocomplete({
    source: function(req, res) {
      $.ajax({
        url: "/stocks/autocomplete_stocks/" + encodeURIComponent(req.term) + ".json",
        dataType: "json",
        success: function(data) {
          return res(data);
        }
      });
    },
    autoFocus: true,
    delay: 100,
    minLength: 2
  });

  var search_list = $(".searchResult__ul");

  function buildHTML(stock) {

  var html = '<li class="searchResult__ul__li">' +
              '<div class="searchResult__ul__li__img">' +
              '<a href="/item/' + stock.id + '">' +
              '<img src="' + stock.image + '" border="0">' +
              '</a>' +
              '</div>' +
              '<div class="searchResult__ul__li__title">' +
              '<a href="/item/' + stock.id + '">' +
              '<h2>' + stock.name + '</h2>' +
              '</a>' +
              '</div>' +
              '<div class="searchResult__ul__li__brand">' +
              '<span>' + stock.maker + '</span>' +
              '</div>' +
              '<div class="searchResult__ul__li__price">' +
              '<a href="/item/' + stock.id + '">' +
              '<span>￥</span>' +
              '<span>' + stock.sell_price + '</span>' +
              '</a>' +
              '<img src="/assets/prime_search_icon.png" border="0" width="49" height="15">' +
              '<div class="searchResult__ul__li__day">' +
              '<span class="color-success">明日中</span>' +
              '<span>にお届け</span>' +
              '</div>' +
              '</div>' +
              '<div class="searchResult__ul__li__review">' +
              '<a href="/item/' + stock.id + '">' +
              '<span class="review_stars">' +
              '<span class="review_number 10">' +
              '</div>' +
              '</li>'
  search_list.append(html);
}

  $('.searchTemplate__right__searchselect').change(function() {
    var val = $(this).val();
    var val2 = JSON.stringify(val);
    $.ajax({
      url: '/stocks/search' + location.search,
      type: "GET",
      dataType: "json",
      data: $(this).serialize(),
      processData: false,
      contentType: false
    })
    .done(function(stocks){
      $('.searchResult__ul__li').remove();
      stocks.forEach(function(stock) {
      buildHTML(stock);
      });
    })
    .fail(function(){
      console.log("失敗");
    });
  });
});
