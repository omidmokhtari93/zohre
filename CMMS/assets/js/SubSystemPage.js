$(document).ready(function () {
  FillToolsTablePage();
});
var targetTr;
var _editName = '';
var _editCode = 0;
var typingTimerNamee;
var doneTypingIntervalNamee = 500;
var $btnSabt = $('#btnSabt');
var $btnEdit = $('#btnEdit');
var $Nameinputt = $('#txtSubName');
$Nameinputt.on('keyup', function () {
  clearTimeout(typingTimerNamee);
  typingTimerNamee = setTimeout(doneTypingNamee, doneTypingIntervalNamee);
});
$Nameinputt.on('keydown', function () {
  clearTimeout(typingTimerNamee);
});
function doneTypingNamee() {
  if (($Nameinputt).val().length > 1) {
    $.ajax({
      type: "POST",
      url: "WebService.asmx/CheckDuplicateToolName",
      contentType: "application/json; charset=utf-8",
      data: JSON.stringify({ 'subSystemName': $Nameinputt.val(), 'editCode': _editCode }),
      dataType: "json",
      success: function (e) {
        var span = '';
        var toolnames = JSON.parse(e.d);
        if (toolnames.length > 0) {
          $('#nameTooltip').empty();
          $('#nameTooltip').append('<p style="display: block; text-align: right;padding-right:3px;margin-bottom:5px;direction:ltr;">: موارد مشابه ثبت شده</p>');
          for (var i = 0; i < toolnames.length; i++) {
            span += '<div>' + toolnames[i] + '</div>';
          }
          $('#nameTooltip').append(span);
          $("#nameTooltip").show();
        } else {
          $("#nameTooltip").hide();
        }
      },
      error: function () {
      }
    });
  }
  if (($Nameinputt).val().length <= 1 && ($Nameinputt).val().length != 0) {
    RedAlert('n', "!!حداقل دو حرف را وارد کنید");
  }
  if (($Nameinputt).val().length === 0) {
    $("#nameTooltip").hide();
  }
}

var duplicateFlag = 0;
var typingTimerCodee;
var doneTypingIntervalCodee = 500;
var $Codeinputt = $('#txtDeviceCode');
$Codeinputt.on('keyup', function () {
  clearTimeout(typingTimerCodee);
  typingTimerCodee = setTimeout(doneTypingCodee, doneTypingIntervalCodee);
});
$Codeinputt.on('keydown', function () {
  clearTimeout(typingTimerCodee);
});
function doneTypingCodee() {
  if (($Codeinputt).val().length === 3) {
    $.ajax({
      type: "POST",
      url: "WebService.asmx/CheckDuplicateToolCode",
      contentType: "application/json; charset=utf-8",
      data: JSON.stringify({ 'subSystemCode': $Codeinputt.val(), 'editCode': _editCode }),
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
  } if (($Codeinputt).val().length != 3 && ($Codeinputt).val().length != 0) {
    RedAlert('nothing', "!!طول کد باید سه رقم باشد");
  }
  if (($Codeinputt).val().length === 0) {
    $("#codeTooltip").hide();
  }
}
$("table").on("click", "tr a#editSubsystem", function () {
  $(targetTr).css('background-color', '');
  targetTr = $(this).closest('tr');
  $(targetTr).css('background-color', 'lightgreen');
  _editName = $(this).closest('tr').find('td:eq(1)').text();
  _editCode = $(this).closest('tr').find('td:eq(2)').text();
  $('#txtSubName').val(_editName);
  $('#txtDeviceCode').val(_editCode);
  $('#btnSabt').hide();
  $('#btnEdit').show();
  $('#btnCancel').show();
});

function CancelEdit() {
  ClearFields('subsystemform');
  $(targetTr).css('background-color', '');
  $('#btnSabt').show();
  $('#btnEdit').hide();
  $('#btnCancel').hide();
}
function SaveSubSystem() {
  var flag = 0;
  if ($('#txtDeviceCode').val() == '' || $('#txtSubName').val() == '') {
    RedAlert('txtDeviceCode', "!!لطفا ورودی ها را کنترل کنید");
    RedAlert('txtSubName', '');
    flag = 1;
  }
  if ($('#txtDeviceCode').val().length !== 3 && $('#txtDeviceCode').val() !== '') {
    RedAlert('no', "!!طول کد باید سه رقم باشد");
    flag = 1;
  }
  if (duplicateFlag === 1 && $('#txtDeviceCode').val() !== '') {
    RedAlert('no', "!!لطفا کد قطعه دیگری را انتخاب نمایید");
  }
  if (flag === 0 && duplicateFlag === 0) {
    $.ajax({
      type: "POST",
      url: "WebService.asmx/NewTool",
      data: JSON.stringify({ 'toolName': $Nameinputt.val(), 'toolCode': $Codeinputt.val() }),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function () {
        GreenAlert('no', "✔ با موفقیت ثبت شد");
        ClearFields('subsystemform');
        FillToolsTablePage();
        $("#nameTooltip").hide();
        $("#codeTooltip").hide();
      }
    });
  }
}

function EditSubSystem() {
  var flag = 0;
  if ($('#txtDeviceCode').val() == '' || $('#txtSubName').val() == '') {
    RedAlert('txtDeviceCode', "!!لطفا ورودی ها را کنترل کنید");
    RedAlert('txtSubName', '');
    flag = 1;
  }
  if ($('#txtDeviceCode').val().length !== 3 && $('#txtDeviceCode').val() !== '') {
    RedAlert('no', "!!طول کد باید سه رقم باشد");
    flag = 1;
  }
  if (duplicateFlag === 1 && $('#txtDeviceCode').val() !== '') {
    RedAlert('no', "!!لطفا کد قطعه دیگری را انتخاب نمایید");
  }
  if (flag === 0 && duplicateFlag === 0) {
    AjaxData({
      url: 'WebService.asmx/EditSubSystem',
      param: { 'name': $Nameinputt.val(), 'code': $Codeinputt.val(), 'editCode': _editCode },
      func: editsub
    });
    function editsub(e) {
      GreenAlert('no', "✔ با موفقیت ویرایش شد");
      ClearFields('subsystemform');
      $(targetTr).css('background-color', '');
      $('#btnSabt').show();
      $('#btnEdit').hide();
      $('#btnCancel').hide();
      FillToolsTablePage();
    }
  }
}

function FillToolsTablePage() {
  $.ajax({
    type: "POST",
    url: "WebService.asmx/FillToolTable",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (toolsDrItems) {
      var items = JSON.parse(toolsDrItems.d);
      var array = [];
      if (items.length > 0) {
        $('#TableSubSystem tbody').empty();
        array.push('<tr><th>ردیف</th><th>نام تجهیز</th><th>کد تجهیز</th><th></th><th></th></tr>');
        for (var i = 0; i < items.length; i++) {
          array.push('<tr>' +
            '<td>' + parseInt(i + 1) + '</td>' +
            '<td>' + items[i].ToolName + '</td>' +
            '<td>' + items[i].ToolCode + '</td>' +
            '<td><a id="editSubsystem">ویرایش</a></td>' +
            '<td><a id="del">حذف</a></td>' +
            '</tr>');
        }
        $('#TableSubSystem tbody').append(array.join(''));
      }
    },
    error: function () {
    }
  });
}

$("table").on("click", "tr a#del", function () {
  targetTr = $(this).closest('tr');
  $('#subname').text($(this).closest('tr').find('td:eq(1)').text());
  _editCode = $(this).closest('tr').find('td:eq(2)').text();
  $('#ModalDelete').modal('show');
});

function deleteSubsystem() {
  AjaxData({
    url: 'WebService.asmx/DeleteSubSystem',
    param: { subcode: _editCode },
    func: deleteDone
  });

  function deleteDone() {
    GreenAlert('n', 'با موفقیت حذف شد');
    $('#ModalDelete').modal('hide');
    FillToolsTablePage();
  }
}