$.fn.search = function (options) {
  var div = this;
  $(div).empty();
  var allOpt;
  div.css('width', options.width).addClass('search-input');
  var resultArea = $('<div name="result-area" style="width:' + this.outerWidth() + 'px;"></div>');
  var searchLodaing = $('<img src="assets/Images/loading.png"/>');
  var input = $('<input type="text" name="search-field" autocomplete="off" placeholder="' + options.placeholder + '"/>');
  searchInit();

  function searchInit() {
    div.append(input);
    div.append(searchLodaing.hide());
  }

  var typingTimer;
  var doneTypingInterval = 1000;
  var $searchinput = $('#' + div.attr('id') + ' [name=search-field]');
  $searchinput.on('keyup', function () {
    searchLodaing.show();
    resultArea.empty();
    clearTimeout(typingTimer);
    typingTimer = setTimeout(doneTyping, doneTypingInterval);
  });
  $searchinput.on('keydown', function () {
    clearTimeout(typingTimer);
  });
  function doneTyping() {
    if ($searchinput.val().length <= 1) {
      resultArea.empty();
      searchLodaing.hide();
      return;
    }
    var par = '{"' + options.arg + '\" : \"' + $searchinput.val() + '\"}';
    callWebApi({
      url: options.url,
      param: par,
      func: appendControls
    });

    function appendControls(e) {
      var d = JSON.parse(e.d);
      if (!d.length) {
        return;
      }
      var opt = [];
      div.append(resultArea);
      resultArea.append('<input name="filter-items" placeholder="فیلتر ..."/>');
      $.each(d, function (x, y) {
        opt.push('<li ' + options.id + '="' + y[options.id] + '">' + y[options.text] + '</li>');
      })
      resultArea.append('<ul>' + opt.join('') + '</ul>');
      allOpt = $('#' + div.attr('id') + ' ul li').clone();
      searchLodaing.hide();
    }
  }

  $('#' + div.attr('id')).on('click', 'li', function (x) {
    div.attr('value', $(this).attr(options.id));
    createBadge($(this).attr(options.id), $(this).text());
    resultArea.empty();
  });

  function createBadge(id, text) {
    div.append('<span id="' + id + '">' + text + '</span>');
    input.val('');
    input.removeAttr('placeholder');
    if (options.func !== undefined) {
      options.func(id, text);
    }
  }

  $('#' + div.attr('id')).on('click', 'span', function (x) {
    $(this).remove()
    div.removeAttr('value');
    input.attr('placeholder', options.placeholder);
  });


  $('#' + div.attr('id')).on('keyup', 'input[name=filter-items]', function () {
    var val = $(this).val();
    $('#' + div.attr('id') + ' ul').empty();
    allOpt.filter(function (idx, el) {
      return val === '' || $(el).text().indexOf(val) >= 0;
    }).appendTo('#' + div.attr('id') + ' ul');
  });

  function callWebApi(e) {
    $.ajax({
      type: 'POST',
      url: e.url,
      data: e.param,
      contentType: 'application/json;',
      dataType: 'json',
      success: e.func,
      error: function () {
        console.log('error');
      }
    });
  }

};