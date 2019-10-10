//variables
var todayGorgian;
var todayJalali;;
var today;
var selectedDate;
var controlId;
var target_tr;
var partId;
var rowItems = [];
//
$(document).ready(function () {
  var customOptions = {
    placeholder: "روز / ماه / سال"
    , twodigit: true
    , closeAfterSelect: true
    , nextButtonIcon: "fa fa-arrow-circle-right"
    , previousButtonIcon: "fa fa-arrow-circle-left"
    , buttonsColor: "blue"
    , forceFarsiDigits: true
    , markToday: true
    , markHolidays: true
    , highlightSelectedDay: true
    , sync: true
    , gotoToday: true
  }
  kamaDatepicker('txtDastoorTarikh', customOptions);
});
$('#btnNewMachineFor').on('click', function () {

  if ($('#txtmachineName').val() === '') {
    RedAlert('txtmachineName', "!!لطفا نام ماشین را وارد نمایید");
  }
  if ($('#txtMachineManufacturer').val() === '') {
    RedAlert('txtMachineManufacturer', "!!لطفا مشخصات سازنده را وارد نمایید");
  }
  if ($('#txtSelInfo').val() === '') {
    RedAlert('txtSelInfo', "!!لطفا مشخصات فروشنده را وارد نمایید");
  }
  if ($('#txtmachineName').val() !== '' && $('#txtMachineManufacturer').val() !== '' && $('#txtSelInfo').val() !== '') {
    $('#pnlNewMachine').hide();
    $('#pnlMavaredMasrafi').fadeIn();
  }

});

$('#chkbargh').change(function () {
  if (this.checked) {
    $('#chkbargh').parent().addClass("isSelected");
    $("#pnlBargh").fadeIn();
  } else {
    $('#chkbargh').parent().removeClass("isSelected");
    $("#pnlBargh").fadeOut();
  }
});
$('#chkgaz').change(function () {
  if (this.checked) {
    $('#chkgaz').parent().addClass("isSelected");
    $("#pnlGaz").fadeIn();
  } else {
    $('#chkgaz').parent().removeClass("isSelected");
    $("#pnlGaz").fadeOut();
  }
});
$('#chkhava').change(function () {
  if (this.checked) {
    $('#chkhava').parent().addClass("isSelected");
    $("#pnlHava").fadeIn();
  } else {
    $('#chkhava').parent().removeClass("isSelected");
    $("#pnlHava").fadeOut();
  }
});
$('#chksokht').change(function () {
  if (this.checked) {
    $('#chksokht').parent().addClass("isSelected");
    $("#pnlSookht").fadeIn();
  } else {
    $('#chksokht').parent().removeClass("isSelected");
    $("#pnlSookht").fadeOut();
  }
});
$('#chkModiriatEnergy').change(function () {
  if (this.checked) {
    $('#chkModiriatEnergy').parent().addClass("isSelected");
    $("#pnlModiriatEnergy").fadeIn();
  } else {
    $('#chkModiriatEnergy').parent().removeClass("isSelected");
    $("#pnlModiriatEnergy").fadeOut();
  }
});


var keycom = '';
function addKey() {
  keycom = $('#txtCommentKey').val();
  var keyname = $('#txtKeyName').val();
  var rpm = $('#txtrpm').val();
  var kw = $('#txtKw').val();
  var flow = $('#txtFlow').val();
  var volt = $('#txtvolt').val();
  var country = $('#txtcountry').val();
  var commentKey = $('#txtcomment').val();
  if (keyname !== '' &&
    (rpm !== '' || kw !== '' || flow !== '' || volt !== '' || country !== '' || commentKey !== '')) {
    var head = '<thead>' +
      '<tr>' +
      '<th>نام/شرح</th>' +
      '<th>KW</th>' +
      '<th>RPM</th>' +
      '<th>سازنده</th>' +
      '<th>ولتاژ</th>' +
      '<th>جریان</th>' +
      '<th>ملاحضات</th>' +
      '<th></th>' +
      '<th></th>' +
      '</tr>' +
      '</thead>';
    var tbody = '<tbody></tbody>';
    var row = '<tr>' +
      '<td>' +
      keyname +
      '</td>' +
      '<td >' +
      kw +
      '</td>' +
      '<td >' +
      rpm +
      '</td>' +
      '<td >' +
      country +
      '</td>' +
      '<td >' +
      volt +
      '</td>' +
      '<td >' +
      flow +
      '</td>' +
      '<td >' +
      commentKey +
      '</td>' +
      '<td><a id="edit">ویرایش</a></td>' +
      '<td><a id="delete">حذف</a></td>' +
      '</tr>';
    if ($('#gridMavaredKey tr').length != 0) {
      $("#gridMavaredKey tbody").append(row);
    } else {
      $("#gridMavaredKey").append(head);
      $("#gridMavaredKey").append(tbody);
      $("#gridMavaredKey tbody").append(row);
    }
    ClearFields('pnlMavaredKey');
    $('#txtCommentKey').val(keycom);
  }
  else
    RedAlert('txtKeyName', "!!لطفا موارد کلیدی را وارد نمایید");
}
$("#gridMavaredKey").on("click", "tr a#delete", function () {
  target_tr = $(this).parent().parent();
  controlId = $(this).parent().parent().find('td:eq(0)').text();
  var row = $('#gridMavaredKey tr').length;
  if (row === 2) {
    $("#gridMavaredKey").empty();
  } else {
    $(target_tr).remove();
  }
});
$("#gridMavaredKey").on("click", "tr a#edit", function () {
  keycom = $('#txtCommentKey').val();
  target_tr = $(this).parent().parent();

  $('#txtKeyName').val($(this).parent().parent().find('td:eq(0)').text());
  $('#txtKw').val($(this).parent().parent().find('td:eq(1)').text());
  $('#txtrpm').val($(this).parent().parent().find('td:eq(2)').text());
  $('#txtcountry').val($(this).parent().parent().find('td:eq(3)').text());
  $('#txtvolt').val($(this).parent().parent().find('td:eq(4)').text());
  $('#txtFlow').val($(this).parent().parent().find('td:eq(5)').text());
  $('#txtcomment').val($(this).parent().parent().find('td:eq(6)').text());
  $('#btnAddKey').hide();
  $('#btnEditKey').show();
  $('#btnCancelEditKey').show();
});
function EditKeyItems() {
  $(target_tr).find('td:eq(0)').text($('#txtKeyName').val());
  $(target_tr).find('td:eq(1)').text($('#txtKw').val());
  $(target_tr).find('td:eq(2)').text($('#txtrpm').val());
  $(target_tr).find('td:eq(3)').text($('#txtcountry').val());
  $(target_tr).find('td:eq(4)').text($('#txtvolt').val());
  $(target_tr).find('td:eq(5)').text($('#txtFlow').val());
  $(target_tr).find('td:eq(6)').text($('#txtcomment').val());
  GreenAlert(target_tr, "✔ ویرایش  انجام شد");
  $('#btnAddKey').show();
  $('#btnEditKey').hide();
  $('#btnCancelEditKey').hide();

  ClearFields('pnlMavaredKey');
  $('#txtCommentKey').val(keycom);
}
function EmptyKey() {

  $('#btnAddKey').show();
  $('#btnEditKey').hide();
  $('#btnCancelEditKey').hide();

  ClearFields('pnlMavaredKey');
  $('#txtCommentKey').val(keycom);
}
//===================  contoroli  ======================//

function checkControliPart() {
  var flag = 0;

  if ($('#txtPartControli').val() === '') { RedAlert('txtPartControli', "!!لطفا نام بخش کنترلی را وارد نمایید"); flag = 1; }

  return flag;
}
function addPartControli() {
  if (checkControliPart() === 0) {

    var Mid = $('#Mid').val();
    //===================send grid to database=======================//
    var mored = $('#txtPartControli').val();

    AjaxData({
      url: "WebService.asmx/BSendPartControl",
      param: { 'mid': Mid, 'control': mored },
      func: createPartTable
    });

    function createPartTable(e) {
      GreenAlert('n', "✔ موارد کنترلی با موفقیت ثبت شد");
      GetPartControl();
      ClearFields('pnlPartControli');
    }
  }
}

$("#gridPartControli").on("click", "tr a#delete", function () {
  target_tr = $(this).parent().parent();
  controlId = $(this).parent().parent().find('td:eq(0)').text();
  $('#ModalDeletePartControl').modal('show');
});

$("#gridPartControli").on("click", "tr a#edit", function () {
  EmptyControls();
  target_tr = $(this).parent().parent();
  controlId = $(this).parent().parent().find('td:eq(0)').text();
  rowItems.push({
    Name: $(this).parent().parent().find('td:eq(1)').text()

  });
  FillpartControls(rowItems);

});


function FillpartControls(items) {

  $('#txtPartControli').val(items[0].Name);
  $('#btnAddPartControli').hide();
  $('#btnEditPartControls').show();
  $('#btnCancelPartCotntrols').show();
}
function DeletePartControls() {
  $.ajax({
    type: "POST",
    url: "WebService.asmx/BDeletePartControli",
    data: "{controlId : " + controlId + "}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function () {
      GreenAlert('nothing', "✔ بخش کنترلی با موفقیت حذف شد");
      $('#ModalDeletePartControl').modal('hide');
      var row = $('#gridPartControli tr').length;
      if (row === 2) {
        $("#gridPartControli").empty();
      } else {
        $(target_tr).remove();
      }
    },
    error: function () {
      $.notify("!!خطا در حذف بخش کنترلی", { globalPosition: 'top left' });
    }
  });
}

function EditPartControliItems() {
  if ($('#txtPartControli').val() === '') { RedAlert('txtPartControli', "!!لطفا بخش کنترلی را وارد نمایید"); }
  else {

    AjaxData({
      url: "WebService.asmx/BEditPartControl",
      param: { 'id': controlId, 'control': $('#txtPartControli').val() },
      func: createPartTable
    });

    function createPartTable(e) {
      GreenAlert('n', "✔ موارد کنترلی ویرایش شد");
      GetPartControl();
      EmptypartControls();
    }

  }
}
function EmptypartControls() {

  ClearFields('pnlPartControli');

  $('#btnEditPartControls').hide();
  $('#btnCancelPartCotntrols').hide();
  $('#btnAddPartControli').show();

  rowItems = [];
}
//======================Second Part ======================//
function checkControliInputs() {
  var flag = 0;

  if ($('#txtControliMoredControl').val() === '') { RedAlert('txtControliMoredControl', "!!لطفا مورد کنترلی را وارد نمایید"); flag = 1; }

  return flag;
}
function addControli() {
  if (checkControliInputs() === 0) {

    var mored = $('#txtControliMoredControl').val();
    var idpart = $('#Drpartcontrol :selected').val();

    var comm = $('#txtMavaredComment').val();
    var head = '<thead>' +
      '<tr>' +
      '<th>بخش کنترلی</th>' +
      '<th>مورد کنترلی</th>' +
      '<th>عملیات</th>' +
      '<th>اعمال برای همه</th>' +
      '<th>ماده مصرفی</th>' +
      '<th>میزان مصرف</th>' +
      '<th>ملاحظات</th>' +
      '<th></th>' +
      '<th></th>' +
      '</tr>' +
      '</thead>';
    var tbody = '<tbody></tbody>';
    var row = '<tr>' +
      '<td style="display:none;">0</td>' +
      '<td style="display:none;">' + idpart + '</td>' +
      '<td style="display:none;">' + mored + '</td>' +
      '<td style="display:none;">' + $('#drcontroliOpr :selected').val() + '</td>' +
      '<td style="display:none;">' + $('#drMatrial :selected').val() + '</td>' +
      '<td style="display:none;">' + $('#txtmizanmasraf').val() + '</td>' +
      '<td style="display:none;">' + comm + '</td>' +
      '<td style="display:none;">' + $("#chkbroadcast").is(':checked') + '</td>' +
      '<td>' + $('#Drpartcontrol :selected').text() + '</td>' +
      '<td>' + mored + '</td>' +

      '<td>' + $('#drcontroliOpr :selected').text() + '</td>' +
      '<td><input type="checkbox" ' + ($('#chkbroadcast').is(':checked') ? 'checked' : '') + ' disabled/></td>' +
      '<td>' + $('#drMatrial :selected').text() + '</td>' +
      '<td>' + $('#txtmizanmasraf').val() + '</td>' +
      '<td>' + comm + '</td>' +


      '<td><a id="edit">ویرایش</a></td>' +
      '<td><a id="delete">حذف</a></td>' +
      '</tr>';
    if ($('#gridMavaredControli tr').length != 0) {
      $("#gridMavaredControli tbody").append(row);
    } else {
      $("#gridMavaredControli").append(head);
      $("#gridMavaredControli").append(tbody);
      $("#gridMavaredControli tbody").append(row);
    }
    ClearFields('pnlMavaredControli');
    $('#chkbroadcast').prop("checked", false);
    $('#pnlcontroliRooz').hide();
    $('#pnlControliWeek').hide();
  }
  $("#drMatrial").chosen('destroy');
  $("#drMatrial").chosen({ width: "100%", rtl: true });
}

$("#gridMavaredControli").on("click", "tr a#delete", function () {
  target_tr = $(this).parent().parent();
  controlId = $(this).parent().parent().find('td:eq(0)').text();
  $('#ModalDeleteControl').modal('show');
});
$("#gridMavaredControli").on("click", "tr a#edit", function () {
  EmptyControls();
  target_tr = $(this).parent().parent();
  controlId = $(this).parent().parent().find('td:eq(0)').text();
  rowItems.push({
    PartControl: $(this).parent().parent().find('td:eq(1)').text(),
    Name: $(this).parent().parent().find('td:eq(2)').text(),
    Operation: $(this).parent().parent().find('td:eq(3)').text(),
    Matial: $(this).parent().parent().find('td:eq(4)').text(),
    Dosage: $(this).parent().parent().find('td:eq(5)').text(),
    Comment: $(this).parent().parent().find('td:eq(6)').text(),
    Broadcast: $(this).parent().parent().find('td:eq(7)').text()
  });
  FillControls(rowItems);
});

function FillControls(items) {
  $('#Drpartcontrol').val(items[0].PartControl);
  $('#txtControliMoredControl').val(items[0].Name);
  $('#drcontroliOpr').val(items[0].Operation);
  $('#drMatrial').val(items[0].Matial).trigger('chosen:updated');
  $('#txtmizanmasraf').val(items[0].Dosage);
  $('#txtMavaredComment').val(items[0].Comment);
  if (items[0].Broadcast == "true") { $('#chkbroadcast').prop('checked', true); }
  else {
    $('#chkbroadcast').prop('checked', false);
  }

  $('#btnEditControls').show();
  $('#btnCancelEditCotntrols').show();
}
function DeleteControls() {
  $.ajax({
    type: "POST",
    url: "WebService.asmx/BDeleteControlItem",
    data: "{controlId : " + controlId + "}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function () {
      GreenAlert('nothing', "✔ مورد کنترلی با موفقیت حذف شد");
      $('#ModalDeleteControl').modal('hide');
      var row = $('#gridMavaredControli tr').length;
      if (row === 2) {
        $("#gridMavaredControli").empty();
      } else {
        $(target_tr).remove();
      }
    },
    error: function () {
      $.notify("!!خطا در حذف مورد کنترلی", { globalPosition: 'top left' });
    }
  });
}

function EditControliItems() {
  if (checkControliInputs() === 0) {
    $(target_tr).find('td:eq(1)').text($('#Drpartcontrol :selected').val());
    $(target_tr).find('td:eq(8)').text($('#Drpartcontrol :selected').text());

    $(target_tr).find('td:eq(2)').text($('#txtControliMoredControl').val());
    $(target_tr).find('td:eq(9)').text($('#txtControliMoredControl').val());


    $(target_tr).find('td:eq(3)').text($('#drcontroliOpr :selected').val());
    $(target_tr).find('td:eq(10)').text($('#drcontroliOpr :selected').text());

    $(target_tr).find('td:eq(7)').text($("#chkbroadcast").is(':checked'));

    $(target_tr).find('td:eq(11)').html('<input type="checkbox" ' + ($('#chkbroadcast').is(':checked') ? 'checked' : '') + ' disabled/>');
    $(target_tr).find('td:eq(4)').text($('#drMatrial :selected').val());
    $(target_tr).find('td:eq(12)').text($('#drMatrial :selected').text());
    $(target_tr).find('td:eq(5)').text($('#txtmizanmasraf').val());
    $(target_tr).find('td:eq(13)').text($('#txtmizanmasraf').val());
    $(target_tr).find('td:eq(6)').text($('#txtMavaredComment').val());
    $(target_tr).find('td:eq(14)').text($('#txtMavaredComment').val());


    EmptyControls();
    $("#drMatrial").chosen('destroy');
    $("#drMatrial").chosen({ width: "100%", rtl: true });

    GreenAlert(target_tr, "✔ مورد کنترلی ویرایش شد");
  }
}
function EmptyControls() {
  $('#chkbroadcast').prop('checked', false);
  ClearFields('pnlMavaredControli');

  $('#btnEditControls').hide();
  $('#btnCancelEditCotntrols').hide();

  rowItems = [];
}
//===================  add Parts  ======================//
function addParts() {
  var flag = checkPartInputs();
  var rowsCount = $('#gridGhataatMasrafi tr').length;
  var table = document.getElementById('gridGhataatMasrafi');
  for (var a = 0; a < rowsCount; a++) {
    if (table.rows[a].cells[1].innerHTML == partData.PartId) {
      $.notify("!!این مورد قبلا ثبت شده است", { globalPosition: 'top left' });
      return;
    }
  }
  if (flag === 0 && partData.PartName !== null) {
    var head = '<thead>' +
      '<tr>' +

      '<th>نام قطعه</th>' +
      '<th>مصرف در سال</th>' +
      '<th>حداقل</th>' +
      '<th>حداکثر</th>' +
      '<th></th>' +
      '<th></th>' +
      '</tr>' +
      '</thead>';
    var row = '<tr>' +

      '<td style="display:none;">' + partData.PartId + '</td>' +
      '<td style="display:none;">' + $('#Drmeasurement').val() + '</td>' +
      '<td>' + partData.PartName + '</td>' +
      '<td>' + $('#txtGhatatPerYear').val() + '</td>' +
      '<td>' + $('#txtGhatatMin').val() + '</td>' +
      '<td>' + $('#txtGhatatMax').val() + '</td>' +

      '<td><a id="editPart">ویرایش</a></td>' +
      '<td><a id="deletePart">حذف</a></td>' +
      '</tr>';
    var body = '<tbody></tbody>';
    if ($('#gridGhataatMasrafi tr').length != 0) {
      $("#gridGhataatMasrafi tbody").append(row);
    } else {
      $("#gridGhataatMasrafi").append(head);
      $("#gridGhataatMasrafi").append(body);
      $("#gridGhataatMasrafi tbody").append(row);
    }
    partData = { PartName: null, PartId: null };
    ClearFields('pnlGhatatMasrafi');
    newMachinePartSearchInit();
  }
  $("#drMatrial").chosen('destroy');
  $("#drMatrial").chosen({ width: "100%", rtl: true });
}
function checkPartInputs() {
  var flag = 0;

  if ($('#txtGhatatMax').val() == '') { RedAlert('txtGhatatMax', "!!لطفا حداکثر قطعه مصرفی در سال را مشخص کنید"); flag = 1; }
  if ($('#txtGhatatMin').val() == '') { RedAlert('txtGhatatMin', "!!لطفا حداقل قطعه مصرفی در سال را مشخص کنید"); flag = 1; }
  if ($('#txtGhatatPerYear').val() == '') { RedAlert('txtGhatatPerYear', "!!لطفا میزان مصرف در سال را مشخص کنید"); flag = 1; }
  if (partData.length === 0) { RedAlert('txtPartsSearch', "!!لطفا قطعه را انتخاب نمایید"); flag = 1; }
  return flag;
}
$("#gridGhataatMasrafi").on("click", "tr a#deletePart", function () {
  target_tr = $(this).parent().parent();
  partId = $(this).parent().parent().find('td:eq(0)').text();
  $('#ModalDeletePart').modal('show');
});
$("#gridGhataatMasrafi").on("click", "tr a#editPart", function () {
  if (partData.length > 0) {
    RedAlert('nothing', '!!ابتدا ویرایش در حال انجام را کامل کنید');
    return;
  }
  target_tr = $(this).parent().parent();
  var partid = $(this).parent().parent().find('td:eq(1)').text();
  var partname = $(this).parent().parent().find('td:eq(2)').text();
  newMachinePartSearchCreate(partname, partid);
  $('#txtPartsSearch').removeAttr('placeholder');
  $('#txtGhatatPerYear').val($(this).parent().parent().find('td:eq(3)').text());
  $('#txtGhatatMin').val($(this).parent().parent().find('td:eq(4)').text());
  $('#txtGhatatMax').val($(this).parent().parent().find('td:eq(5)').text());
  $('#btnEditPart').show();
  $('#btnCancelEditPart').show();
  $('#btnAddMasrafi').hide();
});

function CancelDeletePart() {
  $('#PartBadgeArea').find('div').remove();
  $('#btnEditPart').hide();
  $('#btnCancelEditPart').hide();
  $('#txtPartsSearch').attr('placeholder', 'جستجو کنید ...');
  $('#txtPartsSearch').removeAttr('readonly');
  partData = [];
}

function editParts() {
  var rowsCount = $('#gridGhataatMasrafi tr').length;
  var targetRow = $(target_tr).index() + 1;
  var table = document.getElementById('gridGhataatMasrafi');
  for (var a = 0; a < rowsCount; a++) {
    if (table.rows[a].cells[1].innerHTML == partData.PartId && targetRow !== a) {
      $.notify("!!این مورد قبلا ثبت شده است", { globalPosition: 'top left' });
      return;
    }
  }
  var flag = checkPartInputs();
  if (flag === 0 && partData.PartName !== null) {
    $(target_tr).find('td:eq(1)').text(partData.PartId);
    $(target_tr).find('td:eq(2)').text(partData.PartName);
    $(target_tr).find('td:eq(3)').text($('#txtGhatatPerYear').val());
    $(target_tr).find('td:eq(4)').text($('#txtGhatatMin').val());
    $(target_tr).find('td:eq(5)').text($('#txtGhatatMax').val());
    ClearFields('pnlGhatatMasrafi');
    partData = { PartName: null, PartId: null };
    $('#btnEditPart').hide();
    $('#btnCancelEditPart').hide();
    $('#btnAddMasrafi').show();
    GreenAlert(target_tr, "✔قطعه ویرایش شد");
    newMachinePartSearchInit();
  }
}
function DeletePart() {
  $.ajax({
    type: "POST",
    url: "WebService.asmx/BDeletePartItem",
    data: "{partId : " + partId + "}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function () {
      GreenAlert('nothing', "✔ قطعه با موفقیت حذف شد");
      $('#ModalDeletePart').modal('hide');
      var row = $('#gridGhataatMasrafi tr').length;
      if (row === 2) {
        $("#gridGhataatMasrafi").empty();
      } else {
        $(target_tr).remove();
      }
    },
    error: function () {
      $.notify("!!خطا در حذف قطعه", { globalPosition: 'top left' });
    }
  });
}
$('#btnMavaredeMasrafiBack').on('click', function () {
  $('#pnlNewMachine').fadeIn();
  $('#pnlMavaredMasrafi').hide();
});
$('#btnMavaredeMasrafiFor').on('click', function () {
  $('#pnlMavaredMasrafi').hide();
  $('#pnlMavaredKey').fadeIn();
});
//==================
$('#btnMavaredeKeyBack').on('click', function () {
  $('#pnlMavaredMasrafi').fadeIn();
  $('#pnlMavaredKey').hide();
});

$('#btnMavaredeKeyFor').on('click', function () {
  $('#pnlPartControli').fadeIn();
  $('#pnlMavaredKey').hide();
});
//===================
$('#btnPartControlBack').on('click', function () {
  $('#pnlMavaredKey').fadeIn();
  $('#pnlPartControli').hide();
});
$('#btnPartControlFor').on('click', function () {
  $('#pnlPartControli').hide();
  $('#pnlMavaredControli').fadeIn();
  setTimeout(function () {
    $("#drMatrial").chosen({ width: "100%", rtl: true });
  }, 200);

});
//=====================
$('#btnMavaredControlBack').on('click', function () {
  $('#pnlPartControli').fadeIn();
  $('#pnlMavaredControli').hide();
});
$('#btnMavaredControlFor').on('click', function () {
  $('#pnlMavaredControli').hide();
  $('#pnlSubSytem').fadeIn();
  setTimeout(function () {
    subsystemsearchInit();
  }, 200);
});
//====================
$('#btnSubsystemFor').on('click', function () {
  $('#pnlSubSytem').hide();
  $('#pnlGhatatMasrafi').fadeIn();
  setTimeout(function () {
    newMachinePartSearchInit();
  }, 200);
});
$('#btnSubsystemBack').on('click', function () {
  $('#pnlSubSytem').hide();
  $('#pnlMavaredControli').fadeIn();
});
$('#btnGhatatBack').on('click', function () {
  $('#pnlSubSytem').fadeIn();
  $('#pnlGhatatMasrafi').hide();
});
$('#btnGhatatFor').on('click', function () {
  $('#pnlGhatatMasrafi').hide();
  $('#pnlDastoor').fadeIn();
});




$('#btnDastoorBack').on('click', function () {
  $('#pnlDastoor').hide();
  $('#pnlGhatatMasrafi').fadeIn();
});

function SendTablesToDB() {
  $('#btnFinalSave').animate({ 'padding-left': '40px', 'padding-right': '10px' });
  $('#btnFinalLoading').fadeIn(20);
  var machinId;
  sendMinfo();
  function machinMainData() {
    var obj = {};
    obj.Name = $('#txtmachineName').val();


    obj.Ahamiyat = $(document).find('input[name=switch_2]:checked').attr('value');
    obj.Creator = $('#txtMachineManufacturer').val();
    obj.Model = $('#txtMachineModel').val();
    obj.CatGroup = $('#drCatGroup :selected').val();
    obj.VaziatTajhiz = $(document).find('input[name=switch_21]:checked').attr('value');
    obj.Power = $('#txtMachinePower').val();
    if ($('#txtstopperhour').val() == '') { obj.StopCostPerHour = 0; } else { obj.StopCostPerHour = $('#txtstopperhour').val(); }
    obj.MtbfH = $('#txttargetMTBF').val();
    obj.MtbfD = $('#txtAdmissionperiodMTBF').val();
    obj.MttrH = $('#txttargetMTTR').val();
    obj.MttrD = $('#txtAdmissionperiodMTTR').val();
    obj.SellInfo = $('#txtSelInfo').val();
    obj.SuppInfo = $('#txtSupInfo').val();
    obj.Keycomment = $('#txtCommentKey').val();
    return obj;
  }
  function sendMinfo() {
    var machineId = '';
    if ($('#Mid').val() == '') {
      machineId = '0';
    } else {
      machineId = $('#Mid').val();
    }
    $.ajax({
      type: "POST",
      url: "WebService.asmx/BaseMachineInfo",
      data: JSON.stringify({ 'mid': machineId, 'minfo': machinMainData() }),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function (mid) {
        machinId = mid.d;
        sendMasrafi();
      },
      error: function () {
        RedAlert('n', "!!خطا در ثبت اطلاعات اولیه ماشین");
      }
    });
  }

  function masrafiDataMain() {
    var obj = {};
    obj.Length = $('#txtMavaredTool').val();
    obj.Width = $('#txtMavaredArz').val();
    obj.Height = $('#txtMavaredErtefa').val();
    obj.Weight = $('#txtMavaredVazn').val();
    if ($('#chkbargh').is(':checked')) {
      obj.BarghChecked = 1;
      obj.Masraf = $('#txtMavaredMasraf').val();
      obj.Voltage = $('#txtMavaredVoltage').val();
      obj.Phase = $('#txtMavaredPhaze').val();
      obj.Cycle = $('#txtMavaredCycle').val();
    } else {
      obj.BarghChecked = 0;
      obj.Masraf = '';
      obj.Voltage = '';
      obj.Phase = '';
      obj.Cycle = '';
    }
    if ($('#chkgaz').is(':checked')) {
      obj.GasChecked = 1;
      obj.GasPressure = $('#txtMavaredGazPressure').val();
    } else {
      obj.GasChecked = 0;
      obj.GasPressure = '';
    }
    if ($('#chkhava').is(':checked')) {
      obj.AirChecked = 1;
      obj.AirPressure = $('#txtMavaredAirPressure').val();
    } else {
      obj.AirChecked = 0;
      obj.AirPressure = '';
    }
    if ($('#chksokht').is(':checked')) {
      obj.FuelChecked = 1;
      obj.FuelType = $('#txtMavaredSookhtType').val();
      obj.FuelMasraf = $('#txtMavaredSookhtMasraf').val();
    } else {
      obj.FuelChecked = 0;
      obj.FuelType = '';
      obj.FuelMasraf = '';
    }
    return obj;
  }
  function sendMasrafi() {
    $.ajax({
      type: "POST",
      url: "WebService.asmx/BSendMasrafi",
      data: JSON.stringify({ 'mid': machinId, 'masrafiMain': masrafiDataMain() }),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function () {
        GreenAlert('n', "✔ موارد مصرفی با موفقیت ثبت شد");
        sendKeyItems();
      },
      error: function () {
        RedAlert('n', "!!خطا در ثبت موارد مصرفی");
        sendKeyItems();
      }
    });
  }

  function sendKeyItems() {
    var rowCount = $('#gridMavaredKey tr').length - 1;

    var table = document.getElementById("gridMavaredKey");
    var keyArr = [];
    for (var i = 1; i < table.rows.length; i++) {
      keyArr.push({
        Keyname: table.rows[i].cells[0].innerHTML,
        Kw: table.rows[i].cells[1].innerHTML,
        Rpm: table.rows[i].cells[2].innerHTML,
        Country: table.rows[i].cells[3].innerHTML,
        Volt: table.rows[i].cells[4].innerHTML,
        Flow: table.rows[i].cells[5].innerHTML,
        CommentKey: table.rows[i].cells[6].innerHTML
      });
    }
    $.ajax({
      type: "POST",
      url: "WebService.asmx/BSendKeyItems",
      data: JSON.stringify({ 'mid': machinId, 'keyItemsMain': keyArr }),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function () {
        GreenAlert('n', "✔ موارد کلیدی با موفقیت ثبت شد");
        sendControli();
      },
      error: function () {
        RedAlert('n', "!!خطا در ثبت موارد کلیدی");

        sendControli();
      }
    });
  }

  function sendControli() {
    var rowCount = $('#gridMavaredControli tr').length - 1;
    if (rowCount < 1) { sendSubsystems(); return; }
    var table = document.getElementById("gridMavaredControli");
    var controliArr = [];
    for (var i = 1; i < table.rows.length; i++) {
      controliArr.push({
        Idcontrol: table.rows[i].cells[0].innerHTML,
        IdPartControl: table.rows[i].cells[1].innerHTML,
        Control: table.rows[i].cells[2].innerHTML,
        Operation: table.rows[i].cells[3].innerHTML,
        Matrial: table.rows[i].cells[4].innerHTML,
        Dosage: table.rows[i].cells[5].innerHTML,
        Comment: table.rows[i].cells[6].innerHTML,
        Broadcast: table.rows[i].cells[7].innerHTML
      });
    }
    $.ajax({
      type: "POST",
      url: "WebService.asmx/BSendGridControli",
      data: JSON.stringify({ 'mid': machinId, 'controls': controliArr }),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function () {
        GreenAlert('n', "✔ موارد کنترلی با موفقیت ثبت شد");
        sendSubsystems();
      },
      error: function () {
        RedAlert('n', "!!خطا در ثبت موارد کنترلی");
        sendSubsystems();
      }
    });
  }

  function sendSubsystems() {
    var subSystem = [];
    var table = document.getElementById("subSystemTable");
    for (var i = 1; i < table.rows.length; i++) {
      subSystem.push({
        SubSystemId: table.rows[i].cells[0].innerHTML
      });
    }
    $.ajax({
      type: "POST",
      url: "WebService.asmx/BSendSubSystem",
      data: JSON.stringify({ 'mid': machinId, 'subSystem': subSystem }),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function () {
        GreenAlert('n', "✔ اجزا ماشین با موفقیت ثبت شد");
        sendGhataat();
      },
      error: function () {
        RedAlert('n', "!!خطا در ثبت اجزا سیستم");
        sendGhataat();
      }
    });
  }
  function sendGhataat() {
    var rowCount = $('#gridGhataatMasrafi tr').length - 1;
    if (rowCount < 1) {
      sendInstr();
      return;
    }
    var table = document.getElementById("gridGhataatMasrafi");
    var partsArr = [];
    for (var i = 1; i < table.rows.length; i++) {
      partsArr.push({
        Id: table.rows[i].cells[0].innerHTML,
        PartId: table.rows[i].cells[1].innerHTML,
        UsePerYear: table.rows[i].cells[3].innerHTML,
        Min: table.rows[i].cells[4].innerHTML,
        Max: table.rows[i].cells[5].innerHTML

      });
    }
    $.ajax({
      type: "POST",
      url: "WebService.asmx/BSendGridGhataat",
      data: JSON.stringify({ 'mid': machinId, 'parts': partsArr }),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function () {
        GreenAlert('n', "✔ قطعات دستگاه با موفقیت ثبت شد");
        sendInstr();
      },
      error: function () {
        RedAlert('n', "!!خطا در ثبت قطعات");
        sendInstr();
      }
    });
  }
  function sendInstr() {

    var dastoorText = $('#txtInstruc').val();
    $.ajax({
      type: "POST",
      url: "WebService.asmx/BSendInstru",
      data: JSON.stringify({ 'mid': machinId, 'dastoor': dastoorText }),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function () {
        GreenAlert('no', "✔ دستورالعمل ماشین با موفقیت ثبت شد");
        GreenAlert('no', "✔ عملیات ثبت ماشین با موفقیت انجام شد");
        $('#btnFinalSave').animate({ 'padding-left': '15px', 'padding-right': '15px' });
        $('#btnFinalLoading').fadeOut(10);
        clearControls();
        return;
      }, error: function () {
        RedAlert('no', "!!خطا در ثبت دستورالعمل ها");
        $('#btnFinalSave').animate({ 'padding-left': '15px', 'padding-right': '15px' });
        clearControls();
      }
    });
  }
  function clearControls() {
    ClearFields('machineform');
    $('#pnlcontroliRooz').css('display', 'none');
    $('#pnlControliWeek').css('display', 'none');
    $("#gridGhataatMasrafi thead").remove();
    $("#gridGhataatMasrafi tbody").remove();
    $("#gridMavaredControli thead").remove();
    $("#gridMavaredControli tbody").remove();
    $('#gridSubsystem tbody').empty();
    $('#gridSubsystem thead').empty();
    $("#gridEnergy thead").remove();
    $("#gridEnergy tbody").remove();
    $('#txtInstruc').val('1-استفاده از لوازم حفاظت فردی متناسب با نوع کار الزامی می باشد. \n' +
      '2-ایمنی را همواره سرلوحه کار خود قرار دهید و درهنگام کار با ابزار برنده از شوخی کردن پرهیز کنید،یادتان باشد اول ایمنی،دوم ایمنی،سوم ایمنی...وبعد از برقراری شرایط ایمن انجام هرکاری صحیح و مجاز می باشد. \n' +
      '3-حتما از خوب و مناسب بسته شدن قطعات و گیره به میز و به همدیگر مطمئن شوید. \n' +
      '4-هنگام جابجایی محورها دقت بفرمائید بر خوردی بین ابزار و دیگر متعلقات دستگاه به وجود نیاید. \n' +
      '5-از انباشتن هر وسیله غیر ضروری در محدوده کار جلوگیری کنید. \n' +
      '6-از ابزار مناسب و ترجیحا استاندارد استفاده کنید. \n' +
      '7-دستگاه روشن را هرگز با دست لمس نکنید و هنگام نظافت و گریس کاری حتما دستگاه خاموش باشد. \n' +
      '8-سعی کنید دمای محیط کار همواره حدود بیست درجه سانتی گراد باشد. \n' +
      '9-از ولتاژ مناسب برق دستگاه هنگام کار مطمئن باشید. \n' +
      '10-سیستم اتصال برق بایستی مناسب باشد. \n' +
      '11-هنگام کار حتما دقت کافی را هم به مانیتور و هم به ابزار و قطعه داشته باشید. \n' +
      '12-هنگام کار حتما دستهایتان نزدیک به کلیدهای  سلکتور و خاموش اضطراری باشد و در صورت بروز حادثه در عین خونسردی سریع العمل باشید. \n' +
      '13-ترجیحا از باد خصوصا در جهت ریل های دستگاه استفاده نکنید. \n' +
      '14-وارد منوهای تخصصی و پارامترهای ثابت دستگاه و درایوها و متعلقات الکترونیکی بردهای دستگاه نشوید چون علاوه بر احتمال خرابی بخش های گران قیمت احتمال برق گرفتگی نیز وجود دارد. \n' +
      '15-دقت کنید فن های خنک کننده در حال کار باشند. \n' +
      '16-اپراتور باید فردی آموزش دیده ، دارای حکم کارگزینی به همراه شرح وظایف ، و ملزم به رعایت آن باشد. \n' +
      '17-اپراتور باید از پوشیدن لباسهای گشاد خودداری کند. \n' +
      '18-دقت کنید که دستگاه روغنریزی نداشته و هنگام کار درب دستگاه بسته باشد.\n');
    $('#kelidi').prop('checked');
    $('#act').prop('checked');
    $('#chkbargh').parent().removeClass("isSelected");
    $("#pnlBargh").fadeOut();
    $('#chkbargh').prop('unchecked');
    $('#chkgaz').parent().removeClass("isSelected");
    $("#pnlGaz").fadeOut();
    $('#chkgaz').prop('unchecked');
    $('#chkhava').parent().removeClass("isSelected");
    $("#pnlHava").fadeOut();
    $('#chkhava').prop('unchecked');
    $('#chksokht').parent().removeClass("isSelected");
    $("#pnlSookht").fadeOut();
    $('#chksokht').prop('unchecked');
    $('#servicebale').prop('checked');
    $('#pnlCatalog').css('display', 'none');
    $('#pnlDastoor').hide();
    $('#pnlNewMachine').fadeIn();
    var uri = window.location.href.toString();
    if (uri.indexOf("?") > 0) {
      var cleanUri = uri.substring(0, uri.indexOf("?"));
      window.history.replaceState({}, document.title, cleanUri);
      setTimeout(function () { window.location.replace("/Device.aspx"); }, 2000);
    }
  }
}

Pageload();
function Pageload() {
  FillPopUpToolsTable();
  GetMachineTooltipData();
  var mid = $('#Mid').val();
  if (mid !== '') {
    $('#loadingPage').show();
    $.ajax({
      type: "POST",
      url: "WebService.asmx/GetMachineBaseTbl",
      data: "{mid : " + mid + "}",
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function (minfo) {
        var machineInfo = JSON.parse(minfo.d);
        fillMachineControls(machineInfo);
        getMasrafiData();
      },
      error: function () {
      }
    });
  }
}
function fillMachineControls(mInfo) {
  //var havecatalog = document.getElementById('haveCatalog');
  var gheyrkelidi = document.getElementById('gheyrkelidi');
  var deact = document.getElementById('deact');
  var fail = document.getElementById('fail');
  $('#txtmachineName').val(mInfo[0].Name);

  $('#txtMachineManufacturer').val(mInfo[0].Creator);
  $('#txtMachineModel').val(mInfo[0].Model);
  $('#drCatGroup').val(mInfo[0].CatGroup);
  $('#txtMachinePower').val(mInfo[0].Power);
  $('#txtstopperhour').val(mInfo[0].StopCostPerHour);
  $('#txttargetMTBF').val(mInfo[0].MtbfH);
  $('#txtAdmissionperiodMTBF').val(mInfo[0].MtbfD);
  $('#txttargetMTTR').val(mInfo[0].MttrH);
  $('#txtAdmissionperiodMTTR').val(mInfo[0].MttrD);
  $('#txtSelInfo').val(mInfo[0].SellInfo);
  $('#txtSupInfo').val(mInfo[0].SuppInfo);
  $('#txtCommentKey').val(mInfo[0].Keycomment);

  if (mInfo[0].Ahamiyat == "False") { gheyrkelidi.checked = true; }
  if (mInfo[0].VaziatTajhiz == 2) { fail.checked = true; }
  if (mInfo[0].VaziatTajhiz == 0) { deact.checked = true; }

}
function getMasrafiData() {
  var Mid = $('#Mid').val();
  $.ajax({
    type: "POST",
    url: "WebService.asmx/BGetMasrafiTbl",
    data: "{mid : " + Mid + "}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (masrafi) {
      var masrafiData = JSON.parse(masrafi.d);
      fillMasrafiControls(masrafiData);
      GetKeyitems();
    },
    error: function () {
    }
  });
}
function fillMasrafiControls(masrafiData) {
  var bargh = document.getElementById('chkbargh');
  var gas = document.getElementById('chkgaz');
  var hava = document.getElementById('chkhava');
  var sookht = document.getElementById('chksokht');
  $('#txtMavaredTool').val(masrafiData[0].Length);
  $('#txtMavaredArz').val(masrafiData[0].Width);
  $('#txtMavaredErtefa').val(masrafiData[0].Height);
  $('#txtMavaredVazn').val(masrafiData[0].Weight);
  if (masrafiData[0].BarghChecked == 1) {
    bargh.checked = true;
    $('#pnlBargh').show();
    $('#chkbargh').parent().addClass("isSelected");
    $('#txtMavaredMasraf').val(masrafiData[0].Masraf);
    $('#txtMavaredVoltage').val(masrafiData[0].Voltage);
    $('#txtMavaredPhaze').val(masrafiData[0].Phase);
    $('#txtMavaredCycle').val(masrafiData[0].Cycle);
  }
  if (masrafiData[0].GasChecked == 1) {
    gas.checked = true;
    $('#pnlGaz').show();
    $('#chkgaz').parent().addClass("isSelected");
    $('#txtMavaredGazPressure').val(masrafiData[0].GasPressure);
  }
  if (masrafiData[0].AirChecked == 1) {
    hava.checked = true;
    $('#pnlHava').show();
    $('#chkhava').parent().addClass("isSelected");
    $('#txtMavaredAirPressure').val(masrafiData[0].AirPressure);
  }
  if (masrafiData[0].FuelChecked == 1) {
    sookht.checked = true;
    $('#pnlSookht').show();
    $('#chksokht').parent().addClass("isSelected");
    $('#txtMavaredSookhtType').val(masrafiData[0].FuelType);
    $('#txtMavaredSookhtMasraf').val(masrafiData[0].FuelMasraf);
  }
}
function GetKeyitems() {
  var Mid = $('#Mid').val();
  $.ajax({
    type: "POST",
    url: "WebService.asmx/BGetKeyitems",
    data: "{ mid : " + Mid + "}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (data) {
      var keyData = JSON.parse(data.d);
      var j = 1;
      if (keyData.length > 0) {
        var tblHead = '<thead><tr>' +
          '<th>نام/شرح</th>' +
          '<th>KW</th>' +
          '<th>RPM</th>' +
          '<th>سازنده</th>' +
          '<th>ولتاژ</th>' +
          '<th>جریان</th>' +
          '<th>ملاحضات</th>' +
          '<th></th>' +
          '<th></th>' +
          '</tr></thead>';
        var tblBody = "<tbody></tbody>";
        $('#gridMavaredKey').append(tblHead);
        $('#gridMavaredKey').append(tblBody);
        for (var i = 0; i < keyData.length; i++) {
          tblBody = '<tr>' +
            '<td>' + keyData[i].Keyname + '</td>' +
            '<td>' + keyData[i].Kw + '</td>' +
            '<td>' + keyData[i].Rpm + '</td>' +
            '<td>' + keyData[i].Country + '</td>' +
            '<td>' + keyData[i].Volt + '</td>' +
            '<td>' + keyData[i].Flow + '</td>' +
            '<td>' + keyData[i].CommentKey + '</td>' +
            '<td><a id="edit">ویرایش</a></td>' +
            '<td><a id="delete">حذف</a></td>' +
            '</tr>';
          $('#gridMavaredKey tbody').append(tblBody);
          j++;
        }
      }
      GetPartControl();
    }
  });
}
function GetPartControl() {
  var Mid = $('#Mid').val();
  $('#gridPartControli').empty();
  $.ajax({
    type: "POST",
    url: "WebService.asmx/BGetPartControl",
    data: "{ mid : " + Mid + "}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (data) {
      var partc = JSON.parse(data.d);
      var drPartControlOptions = [];
      var j = 1;
      if (partc.length > 0) {
        $('#gridPartControli').empty();

        var tblHead = '<thead><tr>' +
          '<th>بخش کنترلی</th>' +
          '<th></th>' +
          '<th></th>' +
          '</tr></thead>';
        var tblBody = "<tbody></tbody>";
        $('#gridPartControli').append(tblHead);
        $('#gridPartControli').append(tblBody);
        for (var i = 0; i < partc.length; i++) {
          tblBody = '<tr>' +
            '<td style="display:none;">' + partc[i].Idcontrol + '</td>' +
            '<td>' + partc[i].Control + '</td>' +
            '<td><a id="edit">ویرایش</a></td>' +
            '<td><a id="delete">حذف</a></td>' +
            '</tr>';
          $('#gridPartControli tbody').append(tblBody);
          drPartControlOptions.push('<option value="' + partc[i].Idcontrol + '">' + partc[i].Control + '</option>');
        }
        $('#Drpartcontrol').empty().append(drPartControlOptions);
      }
      GetC();
    }
  });
}
function GetC() {

  $('#gridMavaredControli').empty();
  var Mid = $('#Mid').val();
  $.ajax({
    type: "POST",
    url: "WebService.asmx/BGetC",
    data: "{ mid : " + Mid + "}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (data) {
      var controliData = JSON.parse(data.d);
      if (controliData.length > 0) {
        var tblHead = '<thead>' +
          '<tr>' +
          '<th>بخش کنترلی</th>' +
          '<th>مورد کنترلی</th>' +
          '<th>عملیات</th>' +
          '<th>اعمال برای همه</th>' +
          '<th>ماده مصرفی</th>' +
          '<th>میزان مصرف</th>' +
          '<th>ملاحظات</th>' +
          '<th></th>' +
          '<th></th>' +
          '</tr>' +
          '</thead>';
        var tblBody = "<tbody></tbody>";
        $('#gridMavaredControli').append(tblHead);
        $('#gridMavaredControli').append(tblBody);
        var period, rooz, mdSer, mdserValue, opr, cname;
        for (var i = 0; i < controliData.length; i++) {

          if (controliData[i].Operation == 1) { opr = 'برق' }
          if (controliData[i].Operation == 2) { opr = 'چک و بازدید' }
          if (controliData[i].Operation == 3) { opr = 'روانکاری' }
          if (controliData[i].Comment == null) { controliData[i].Comment = " "; }
          if (controliData[i].Control.length > 15) {
            cname = controliData[i].Control.substring(0, 15) + "...";
          } else {
            cname = controliData[i].Control;
          }
          tblBody = '<tr>' +
            '<td style="display:none;">' + controliData[i].Idcontrol + '</td>' +
            '<td style="display:none;">' + controliData[i].IdPartControl + '</td>' +
            '<td style="display:none;">' + controliData[i].Control + '</td>' +
            '<td style="display:none;">' + controliData[i].Operation + '</td>' +
            '<td style="display:none;">' + controliData[i].Matrial + '</td>' +
            '<td style="display:none;">' + controliData[i].Dosage + '</td>' +
            '<td style="display:none;">' + controliData[i].Comment + '</td>' +
            '<td style="display:none;">' + controliData[i].Broadcast + '</td>' +
            '<td>' + controliData[i].PartControl + '</td>' +
            '<td>' + cname + '</td>'
            + '<td>' + opr + '</td>'
            + '<td> <input type="checkbox" ' + (controliData[i].Broadcast ? 'checked' : '') + ' disabled />  </td>'
            + '<td>' + controliData[i].Smatrial + '</td>'
            + '<td>' + controliData[i].Dosage + '</td>'
            + '<td>' + controliData[i].Comment + '</td>'
            + '<td><a id="edit">ویرایش</a></td><td><a id="delete">حذف</a></td></tr>';
          $('#gridMavaredControli tbody').append(tblBody);
        }
      }
      GetSubSystems();
    }
  });
}

function GetSubSystems() {
  $('#subSystemTable tbody').empty();
  var Mid = $('#Mid').val();
  $.ajax({
    type: "POST",
    url: "WebService.asmx/BGetSubSystems",
    data: "{ mid : " + Mid + "}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (data) {
      var subData = JSON.parse(data.d);
      var j = 1;
      if (subData.length > 0) {
        var tblHead = '<thead><tr>' +
          '<th>ردیف</th>' +
          '<th>نام تجهیز</th>' +
          '<th></th>' +
          '</tr></thead>';
        var tblBody = "<tbody></tbody>";
        $('#subSystemTable').append(tblHead);
        $('#subSystemTable').append(tblBody);
        for (var i = 0; i < subData.length; i++) {
          tblBody = '<tr>' +
            '<td style="display:none;">' + subData[i].SubSystemId + '</td>' +
            '<td>' + j + '</td>' +
            '<td>' + subData[i].SubSystemName + '</td>' +
            '<td><a>حذف</a></td>' +
            '</tr>';
          $('#subSystemTable tbody').append(tblBody);
          j++;
        }
      }
      GetG();
    }
  });
}
function GetG() {
  $('#gridGhataatMasrafi').empty();
  var Mid = $('#Mid').val();
  $.ajax({
    type: "POST",
    url: "WebService.asmx/BGetG",
    data: "{ mid : " + Mid + "}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (data) {
      var partsData = JSON.parse(data.d);
      if (partsData.length > 0) {
        var tblHead = '<thead>' +
          '<tr>' +
          '<th>نام قطعه</th>' +
          '<th>مصرف در سال</th>' +
          '<th>حداقل</th>' +
          '<th>حداکثر</th>' +

          '<th></th>' +
          '<th></th>' +
          '</tr>' +
          '</thead>';
        var tblBody = "<tbody></tbody>";
        $('#gridGhataatMasrafi').append(tblHead);
        $('#gridGhataatMasrafi').append(tblBody);
        for (var i = 0; i < partsData.length; i++) {
          tblBody = '<tr>'
            + '<td style="display: none;">' + partsData[i].Id + "</td>"
            + '<td style="display: none;">' + partsData[i].PartId + "</td>"
            + "<td>" + partsData[i].PartName + "</td>"
            + "<td>" + partsData[i].UsePerYear + "</td>"
            + "<td>" + partsData[i].Min + "</td>"
            + "<td>" + partsData[i].Max + "</td>"

            + '<td><a id="editPart">ویرایش</a></td>' +
            '<td><a id="deletePart">حذف</a></td></tr>';
          $('#gridGhataatMasrafi tbody').append(tblBody);
        }
      }
    }
  });
}

