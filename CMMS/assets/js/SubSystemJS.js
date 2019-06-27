var subData = [];


$('#searchSubsystem').search({
  width: '100%',
  placeholder: 'جستجو',
  url: 'WebService.asmx/FilteredGridSubSystem',
  arg: 'subSystemName',
  text: 'ToolName',
  id: 'ToolId',
  func: consolelog
});

function consolelog(id, text) {
  subData.push({ Name: text, Id: id });
  console.log(id + ' ' + text);
}

function CreateSubTable() {
  var j = 1;
  var rn = 0;
  var i, a, b, c;
  var array = [];
  var pelak = $('#txtSubPelak').val();
  if (pelak.length !== 12) {
    RedAlert('txtSubPelak', "!!شماره پلاک نامعتبر");
    return;
  }
  if (subData.length === 0) {
    RedAlert('searchSubsystem', "!!حداقل یک مورد را انتخاب نمایید");
    return;
  }

  if ($('#subSystemTable tr td:contains(' + $('#txtSubPelak').val() + ')').length > 0) {
    RedAlert('no', '!!این پلاک قبلا ثبت شده است');
    return;
  }
  if ($('#subSystemTable tr').length !== 0) {
    array.push('<tr>' +
      '<td style="display:none;">' + subData[0].Id + '</td>' +
      '<td>' + j + '</td>' +
      '<td>' + subData[0].Name + '</td>' +
      '<td>' + $('#txtSubPelak').val() + '</td>' +
      '<td><a id="edit">ویرایش</a></td>' +
      '<td><a id="delete">حذف</a></td>' +
      '</tr>');
    $('#subSystemTable tbody').append(array.join(''));
    $('#subSystemTable tr').each(function () {
      $(this).closest('tr').find('td:eq(1)').text(rn);
      rn++;
    });
  } else {
    $('#subSystemTable ').append('<thead><th>ردیف</th><th>نام تجهیز</th><th>شماره پلاک</th><th></th></thead>');
    $('#subSystemTable ').append('<tbody></tbody>');
    for (i = 0; i < subData.length; i++) {
      array.push('<tr>' +
        '<td style="display:none;">' + subData[i].Id + '</td>' +
        '<td>' + j + '</td>' +
        '<td>' + subData[i].Name + '</td>' +
        '<td>' + subData[i].SubP + '</td>' +
        '<td><a id="edit">ویرایش</a></td>' +
        '<td><a id="delete">حذف</a></td>' +
        '</tr>');
      j++;
    }
    $('#subSystemTable tbody').append(array.join(''));
  }
  subData = [];
  $('.Subsystembadge').remove();
  $('#txtSubPelak').val($('#txtSubPelak').val().substr(0, $('#txtSubPelak').val().indexOf('-') + 1));
}

$("#subSystemTable").on("click", "tr td a#delete", function (e) {
  var row = $('#subSystemTable tr').length;
  var i = 0;
  if (row == 2) {
    $("#subSystemTable thead").remove();
    $("#subSystemTable tbody").remove();
  } else {
    $(this).parent().parent().remove();
    $('#subSystemTable tr').each(function () {
      $(this).closest('tr').find('td:eq(1)').text(i);
      i++;
    });
  }
});

var element = '<a onclick="editsubsystempelak(this);">ثبت</a> ' +
  '<input type="text" id="txtEditSubsyemPelak" dir="ltr" />';
$('#subSystemTable').on('click', 'tr td a#edit', function () {
  $(this).parent().parent().find('td:eq(3)').text('').append($(element).val($('#txtSubPelak').val()));
});

function editsubsystempelak(e) {
  var check = false;
  var pelak = $('#txtEditSubsyemPelak').val();
  if (pelak.length > 12) {
    RedAlert('n', "!!شماره پلاک نامعتبر");
    return;
  }
  $('#subSystemTable tr td').each(function (x, el) {
    if ($(el).text() == $('#txtEditSubsyemPelak').val()) {
      RedAlert('n', 'این مورد قبلا ثبت شده است');
      check = true;
    }
  });
  if (check) return;
  $(e).parent().text($('#txtEditSubsyemPelak').val());
}




var flag = 0;
var typingTimerName;
var doneTypingIntervalName = 500;
var $Nameinput = $('#txtToolName');
$Nameinput.on('keyup', function () {
  clearTimeout(typingTimerName);
  typingTimerName = setTimeout(doneTypingName, doneTypingIntervalName);
});
$Nameinput.on('keydown', function () {
  clearTimeout(typingTimerName);
});
function doneTypingName() {
  if (($Nameinput).val().length > 1) {
    $.ajax({
      type: "POST",
      url: "WebService.asmx/CheckDuplicateToolName",
      contentType: "application/json; charset=utf-8",
      data: JSON.stringify({ 'subSystemName': $Nameinput.val(), 'editCode': 0 }),
      dataType: "json",
      success: function (e) {
        var array = [];
        var toolnames = JSON.parse(e.d);
        if (toolnames.length > 0) {
          $('#nameTooltip').empty();
          $('#nameTooltip').append('<p style="display: block; text-align: right;padding-right:3px;margin-bottom:5px;">: موارد مشابه ثبت شده</p>');
          for (var i = 0; i < toolnames.length; i++) {
            array.push('<div>' + toolnames[i] + '</div>');
          }
          $('#nameTooltip').append(array.join(''));
          $("#nameTooltip").show();
        } else {
          $("#nameTooltip").hide();
        }
      },
      error: function () {
      }
    });
  }
  if (($Nameinput).val().length <= 1 && ($Nameinput).val().length != 0) {
    $.notify("!!حداقل دو حرف را وارد کنید", { globalPosition: 'top left' });
  }
  if (($Nameinput).val().length === 0) {
    $("#nameTooltip").hide();
  }
}

var duplicateFlag = 0;
var typingTimerCode;
var doneTypingIntervalCode = 500;
var $Codeinput = $('#txtToolCode');
$Codeinput.on('keyup', function () {
  clearTimeout(typingTimerCode);
  typingTimerCode = setTimeout(doneTypingCode, doneTypingIntervalCode);
});
$Codeinput.on('keydown', function () {
  clearTimeout(typingTimerCode);
});
function doneTypingCode() {
  if (($Codeinput).val().length === 3) {
    $.ajax({
      type: "POST",
      url: "WebService.asmx/CheckDuplicateToolCode",
      contentType: "application/json; charset=utf-8",
      data: JSON.stringify({ 'subSystemCode': $Codeinput.val(), 'editCode': 0 }),
      dataType: "json",
      success: function (e) {
        var code = JSON.parse(e.d);
        if (code[0] == '1') {
          $("#codeTooltip").show();
          duplicateFlag = 1;
        } else {
          $("#codeTooltip").hide();
          duplicateFlag = 0;
        }
      },
      error: function () {
      }
    });
  } if (($Codeinput).val().length != 3 && ($Codeinput).val().length != 0) {
    RedAlert('no', "!!طول کد باید سه رقم باشد");
  }
  if (($Codeinput).val().length === 0) {
    $("#codeTooltip").hide();
  }
}

function AddSubSystems() {
  var flag = 0;
  if ($('#txtToolCode').val() == '' || $('#txtToolName').val() == '') {
    RedAlert('txtToolCode', "!!لطفا ورودی ها را کنترل کنید");
    RedAlert('txtToolName', '');
    flag = 1;
  }
  if ($('#txtToolCode').val().length !== 3 && $('#txtToolCode').val() !== '') {
    RedAlert('no', "!!طول کد باید سه رقم باشد");
    flag = 1;
  }
  if (duplicateFlag === 1 && $('#txtToolCode').val() !== '') {
    RedAlert('no', "!!لطفا کد قطعه دیگری را انتخاب نمایید");
  }
  if (flag === 0 && duplicateFlag === 0) {
    var toolName = $('#txtToolName').val();
    var toolCode = $('#txtToolCode').val();
    $.ajax({
      type: "POST",
      url: "WebService.asmx/NewTool",
      data: JSON.stringify({ 'toolName': toolName, 'toolCode': toolCode }),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function (e) {
        GreenAlert('no', "✔ با موفقیت ثبت شد");
        $('#txtToolName').val('');
        $('#txtToolCode').val('');
        $("#nameTooltip").hide();
        $("#codeTooltip").hide();
        FillPopUpToolsTable();
      }
    });
  }
}

function FillPopUpToolsTable() {
  $.ajax({
    type: "POST",
    url: "WebService.asmx/FillToolTable",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (toolsDrItems) {
      var items = JSON.parse(toolsDrItems.d);
      var array = [];
      if (items.length > 0) {
        $('#gridPopupSubsystem tbody').empty();
        array.push('<tr><th>نام تجهیز</th><th>کد تجهیز</th></tr>');
        for (var i = 0; i < items.length; i++) {
          array.push('<tr><td>' + items[i].ToolName + '</td><td>' + items[i].ToolCode + '</td></tr>');
        }
        $('#gridPopupSubsystem tbody').append(array.join(''));
      }
    },
    error: function () {
    }
  });
}