var data = [];
var body = [];
var targetTr;
var itemId;
$(function () {
  FillmeasurementTable();
    FillPartmeasurTable();
    FillmatrialTable();
});
function FillmeasurementTable() {
  $('#measurTable tbody').empty();
  data = [];
  data.push({
    url: 'WebService.asmx/GetMeasurement',
    parameters: [],
    func: fillmeasure
  });
  AjaxCall(data);
  function fillmeasure(e) {
    data = JSON.parse(e.d);
    body = [];
    if (data.length > 0) {
      body.push('<tr><th>ردیف</th><th>واحد اندازه گیری</th><th></th></tr>');
      CreateBody(data, body);
      $('#measurTable tbody').append(body.join(''));
    }
  }
}
function FillmatrialTable() {
    $('#MatrialTable tbody').empty();
    data = [];
    data.push({
        url: 'WebService.asmx/GetMatrial',
        parameters: [],
        func: fillmeasure
    });
    AjaxCall(data);
    function fillmeasure(e) {
        data = JSON.parse(e.d);
        body = [];
        if (data.length > 0) {
            body.push('<tr><th>ردیف</th><th>ماده مصرفی/روانکار</th><th></th></tr>');
            CreateBody(data, body);
            $('#MatrialTable tbody').append(body.join(''));
        }
    }
}
function FillPartmeasurTable() {
  $('#PartmeasureTable tbody').empty();
  AjaxData({
    url: 'WebService.asmx/GetMeasurementPartTable',
    param: {},
    func: filldelay
  });
  function filldelay(e) {
    data = JSON.parse(e.d);
    if (data.length > 0) {
      body = [];
      body.push('<tr><th>ردیف</th><th>نام کالا</th><th>واحد</th><th></th></tr>');
      CreateeBody(data, body);
      $('#PartmeasureTable tbody').append(body.join(''));
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
function CreateeBody(data, body) {
  for (var i = 0; i < data.length; i++) {
    body.push('<tr>' +
      '<td style="display:none;">' + data[i][0] + '</td>' +
      '<td>' + parseInt(i + 1) + '</td>' +
      '<td>' + data[i][1] + '</td>' +
      '<td>' + data[i][2] + '</td>' +
      '<td style="display:none;">' + data[i][3] + '</td>' +
      '<td><a id="edit">ویرایش</a></td></tr>');
  }
}
function insertOrUpdateData(ele, ed, add) {
  var text = $('#' + ele).val();
  if (text === '') {
    RedAlert(ele, '!!لطفا فیلد خالی را تکمیل کنید');
    return;
  }
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
    var btn = $('#' + ele).parent().parent().find('button');
    if (ele == 'txtMeasur') {
      FillmeasurementTable();
      ClearFields('opFrom');
      $('#btninsertmeasur').show();
      $('#btneditmeasur').hide();
      $('#btncanselmeasur').hide();
    }
    if (ele == 'drmeasur') {
      FillPartmeasurTable();
      ClearFields('opFrom');
      $('#btneditpart').hide();
      $('#btncanselpart').hide();
    }
  }
}
function insertOrUpdateMatrialData(ele, ed, add) {
    var text = $('#' + ele).val();
    if (text === '') {
        RedAlert(ele, '!!لطفا فیلد خالی را تکمیل کنید');
        return;
    }
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
        var btn = $('#' + ele).parent().parent().find('button');
      
            FillmatrialTable();
            ClearFields('opFrom');
            $('#btninsertMatrial').show();
            $('#btneditMatrial').hide();
            $('#btncanselMatrial').hide();
       
    }
}
$('#MatrialTable').on('click', 'tr a#edit', function () {
    $(targetTr).css('background-color', '');
    targetTr = $(this).closest('tr');
    itemId = $(this).closest('tr').find('td:eq(0)').text();
    $('#txtMatrial').val($(this).closest('tr').find('td:eq(2)').text());
    $(targetTr).css('background-color', 'lightgreen');
    $('#btninsertMatrial').hide();
    $('#btneditMatrial').show();
    $('#btncanselMatrial').show();
});
$('#measurTable').on('click', 'tr a#edit', function () {
  $(targetTr).css('background-color', '');
  targetTr = $(this).closest('tr');
  itemId = $(this).closest('tr').find('td:eq(0)').text();
  $('#txtMeasur').val($(this).closest('tr').find('td:eq(2)').text());
  $(targetTr).css('background-color', 'lightgreen');
  $('#btninsertmeasur').hide();
  $('#btneditmeasur').show();
  $('#btncanselmeasur').show();
});
$('#PartmeasureTable').on('click', 'tr a#edit', function () {
  $(targetTr).css('background-color', '');
  targetTr = $(this).closest('tr');
  itemId = $(this).closest('tr').find('td:eq(0)').text();
  $('#txtmeasurpart').val($(this).closest('tr').find('td:eq(2)').text());
  $('#drmeasur').val($(this).closest('tr').find('td:eq(4)').text());
  $(targetTr).css('background-color', 'lightgreen');
  $('#pnlPart').show();
  $('#btneditpart').show();
  $('#btncanselpart').show();
});

function CancelOperation(btni, btne, btnc) {
  $(targetTr).css('background-color', '');
  $('#' + btni).show();
  $('#' + btne).hide();
  $('#' + btnc).hide();
  ClearFields('opFrom');
}