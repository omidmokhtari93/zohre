var data = [];
var body = [];
var targetTr;
var itemId;
$(function () {
  FillStopTable();
  FillDelayTable();
  FillFailTable();
  FillRepairTable();
});
function FillStopTable() {
  $('#stopTable tbody').empty();
  AjaxData({
    url: 'WebService.asmx/GetStopReasonTable',
    param: {},
    func: fillstop
  });
  function fillstop(e) {
    data = JSON.parse(e.d);
    body = [];
    if (data.length > 0) {
      body.push('<tr><th>ردیف</th><th>دلیل توقف</th><th></th></tr>');
      CreateBody(data, body);
      $('#stopTable tbody').append(body.join(''));
    }
  }
}

function FillDelayTable() {
  $('#delayTable tbody').empty();
  AjaxData({
    url: 'WebService.asmx/GetDelayReasonTable',
    param: {},
    func: filldelay
  });
  function filldelay(e) {
    data = JSON.parse(e.d);
    if (data.length > 0) {
      body = [];
      body.push('<tr><th>ردیف</th><th>دلیل تاخیر</th><th></th></tr>');
      CreateBody(data, body);
      $('#delayTable tbody').append(body.join(''));
    }
  }
}

function FillFailTable() {
  $('#failTable tbody').empty();
  AjaxData({
    url: 'WebService.asmx/GetFailReasonTable',
    param: {},
    func: fillfail
  });

  function fillfail(e) {
    data = JSON.parse(e.d);
    if (data.length > 0) {
      body = [];
      body.push('<tr><th>ردیف</th><th>دلیل خرابی</th><th></th></tr>');
      CreateBody(data, body);
      $('#failTable tbody').append(body.join(''));
    }
  }
}

function FillRepairTable() {
  $('#repairTable tbody').empty();
  AjaxData({
    url: 'WebService.asmx/GetRepairOperationTable',
    param: {},
    func: fillrepairOp
  })
  function fillrepairOp(e) {
    data = JSON.parse(e.d);
    if (data.length > 0) {
      body = [];
      body.push('<tr><th>ردیف</th><th>عملیات</th><th></th></tr>');
      CreateBody(data, body);
      $('#repairTable tbody').append(body.join(''));
    }
  }
}

function CreateBody(data, body) {
  for (var i = 0; i < data.length; i++) {
    body.push('<tr>' +
      '<td style="display:none;">' + data[i][0] + '</td>' +
      '<td>' + parseInt(i + 1) + '</td>' +
      '<td>' + data[i][1] + '</td>' +
      '<td><a id="edit">ویرایش</a></td></tr>');
  }
}

function insertOrUpdateData(ele, ed, add) {
  var text = $('#' + ele).val();
  if (text === '') { RedAlert(ele, '!!لطفا فیلد خالی را تکمیل کنید'); return; }
  AjaxData({
    url: 'WebService.asmx/' + add,
    param: { text: text, editId: ed },
    func: output
  });
  function output(e) {
    if (e.d === 'i') {
      GreenAlert('no', '.با موفقیت ثبت شد');
    } else {
      GreenAlert('no', '.با موفقیت ویرایش شد');
    }
    if (ele == 'txtStop') {
      FillStopTable();
    } if (ele == 'txtFail') {
      FillFailTable();
    } if (ele == 'txtDelay') {
      FillDelayTable();
    } if (ele == 'txtrepairlist') {
      FillRepairTable();
    }
    ClearFields('opFrom');
    var btn = $('#' + ele).parent().parent().find('button');
    $(btn[0]).show();
    $(btn[1]).hide();
    $(btn[2]).hide();
  }
}
$('#stopTable').on('click', 'tr a#edit', function () {
  $(targetTr).css('background-color', '');
  targetTr = $(this).closest('tr');
  itemId = $(this).closest('tr').find('td:eq(0)').text();
  $('#txtStop').val($(this).closest('tr').find('td:eq(2)').text());
  $(targetTr).css('background-color', 'lightgreen');
  $('#btninsertStop').hide();
  $('#btneditstop').show();
  $('#btncanselstop').show();
});
$('#delayTable').on('click', 'tr a#edit', function () {
  $(targetTr).css('background-color', '');
  targetTr = $(this).closest('tr');
  itemId = $(this).closest('tr').find('td:eq(0)').text();
  $('#txtDelay').val($(this).closest('tr').find('td:eq(2)').text());
  $(targetTr).css('background-color', 'lightgreen');
  $('#btninsertDelay').hide();
  $('#btneditdelay').show();
  $('#btncanceldelay').show();
});
$('#failTable').on('click', 'tr a#edit', function () {
  $(targetTr).css('background-color', '');
  targetTr = $(this).closest('tr');
  itemId = $(this).closest('tr').find('td:eq(0)').text();
  $('#txtFail').val($(this).closest('tr').find('td:eq(2)').text());
  $(targetTr).css('background-color', 'lightgreen');
  $('#btnInsertFail').hide();
  $('#btncanselfail').show();
  $('#btneditfail').show();
});
$('#repairTable').on('click', 'tr a#edit', function () {
  $(targetTr).css('background-color', '');
  targetTr = $(this).closest('tr');
  itemId = $(this).closest('tr').find('td:eq(0)').text();
  $('#txtrepairlist').val($(this).closest('tr').find('td:eq(2)').text());
  $(targetTr).css('background-color', 'lightgreen');
  $('#btninsertrepair').hide();
  $('#btncancelrepair').show();
  $('#btneditrepair').show();
});

function CancelOperation(btni, btne, btnc) {
  $(targetTr).css('background-color', '');
  $('#' + btni).show();
  $('#' + btne).hide();
  $('#' + btnc).hide();
  ClearFields('opFrom');
}