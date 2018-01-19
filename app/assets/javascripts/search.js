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

  function addFigure(str) {
    var num = new String(str).replace(/,/g, "");
    while(num != (num = num.replace(/^(-?\d+)(\d{3})/, "$1,$2")));
    return num;
  }

  var search_list = $(".searchResult__ul");

  function buildHTML(stock) {

  var html = '<li class="searchResult__ul__li">' +
              '<div class="searchResult__ul__li__img">' +
              '<a href="/stocks/' + stock.id + '">' +
              '<img src="' + stock.image + '" border="0">' +
              '</a>' +
              '</div>' +
              '<div class="searchResult__ul__li__title">' +
              '<a href="/stocks/' + stock.id + '">' +
              '<h2>' + stock.name + '</h2>' +
              '</a>' +
              '</div>' +
              '<div class="searchResult__ul__li__brand">' +
              '<span>' + stock.maker + '</span>' +
              '</div>' +
              '<div class="searchResult__ul__li__price">' +
              '<a href="/stocks/' + stock.id + '">' +
              '<span>￥</span>' +
              '<span>' + addFigure(stock.sell_price) + '</span>' +
              '</a>' +
              '<img src="/assets/prime_search_icon.png" border="0" width="49" height="15">' +
              '<div class="searchResult__ul__li__day">' +
              '<span class="color-success">明日中</span>' +
              '<span>にお届け</span>' +
              '</div>' +
              '</div>' +
              '<div class="searchResult__ul__li__review">' +
              '<a href="/stocks/' + stock.id + '">' +
              '<div class ="search_result_star review_stars ' + stock.id + '">' +
              '</div>' +
              '<span class="review_number">' + stock.reviews_count + '</span>' +
              '</div>' +
              '</li>'
  search_list.append(html);
}

  function review_rate_calc(data){
    var star_avg = data.reviews_stars
    var container = $('.search_result_star.review_stars.' + data.id)

    if (star_avg == null) {
      container.append('<div class="rate rate00"></div>');
    }
    else if (star_avg >= "0.0" && "0.9" >= star_avg) {
      container.append('<div class="rate rate05"></div>');
    }
    else if (star_avg >= "1.0" && "1.4" >= star_avg) {
      container.append('<div class="rate rate10"></div>');
    }
    else if (star_avg >= "1.5" && "1.9" >= star_avg) {
      container.append('<div class="rate rate15"></div>');
    }
    else if (star_avg >= "2.0" && "2.4" >= star_avg) {
      container.append('<div class="rate rate20"></div>');
    }
    else if (star_avg >= "2.5" && "2.9" >= star_avg) {
      container.append('<div class="rate rate25"></div>');
    }
    else if (star_avg >= "3.0" && "3.4" >= star_avg) {
      container.append('<div class="rate rate30"></div>');
    }
    else if (star_avg >= "3.5" && "3.9" >= star_avg) {
      container.append('<div class="rate rate35"></div>');
    }
    else if (star_avg >= "4.0" && "4.4" >= star_avg) {
      container.append('<div class="rate rate40"></div>');
    }
    else if (star_avg >= "4.5" && "4.9" >= star_avg) {
      container.append('<div class="rate rate45"></div>');
    }
    else {
      container.append('<div class="rate rate50"></div>');
    }
}


  $('.searchTemplate__right__searchselect').change(function() {
    $.ajax({
      url: '/stocks/search' + location.search,
      data: $(this).serialize(),
      dataType: 'json',
    })
    .done(function(data){
      $('.searchResult__ul__li').remove();
      data.stocks.forEach(function(stock) {
      buildHTML(stock);
      review_rate_calc(stock);
      });
    })
    .fail(function(){
      console.log("失敗");
    });
  });

});
