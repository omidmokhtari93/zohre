$('#StartRepiarTime').clockpicker({ autoclose: true, placement: 'top' });
$('#EndRepairTime').clockpicker({ autoclose: true, placement: 'top' });
$('#txtWorkTime').clockpicker({ autoclose: true, placement: 'top' });
var requestPart = [];
var reqId = $('#ReqId').val();
if (reqId !== '') {
  $.ajax({
    type: "POST",
    url: "WebService.asmx/GetRequestDetails",
    data: "{reqId : " + reqId + "}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (e) {
      var reqDetails = JSON.parse(e.d);
      $('#RequestTime').val(reqDetails[0].RequestTime);
      $('#RequestDate').val(reqDetails[0].RequestDate);
      $('#lblRequestNumber').text(reqDetails[0].RequestNumber);
      $('#lblMachineName').text(reqDetails[0].MachineName);
      $('#lblfaz').text(reqDetails[0].Faz);
      $('#lblline').text(reqDetails[0].Line);
      $('#lblRequestCode').text(reqDetails[0].MachineCode);
      $('#lblRequestTime').text(reqDetails[0].Time);
      $('#lblNameRequest').text(reqDetails[0].NameRequest);
      $('#lblUnitRequest').text(reqDetails[0].UnitName);
      $('#lblSubName').text(reqDetails[0].SubName);
      $('#drSubSystem').val(reqDetails[0].SubId);
      $('#lblFailType').text(reqDetails[0].FailType);
      $('#lblRequestType').text(reqDetails[0].RequestType);
      $('#lblComment').text(reqDetails[0].Comment);
      $('#pnlRequestDetail').show();
    },
    error: function () {
    }
  });
}
function BackToPreviousPage() {
  $('#pnlRepairExplain').hide();
  $('#pnlRequestDetail').fadeIn();
}

$('#drChangeReqState').change(function () {
  if ($('#drChangeReqState :selected').val() == '3') {
    var data = [];
    data.push({
      url: 'WebService.asmx/GetRequestedParts',
      parameters: [{ requestId: $('#ReqId').val() }],
      func: createBadges
    });
    AjaxCall(data);
    function createBadges(e) {
      var d = JSON.parse(e.d);
      $('#txtPartRequestComment').val(d.info.Info);
      $('#txtPartRequestNumber').val(d.info.BuyRequestNumber);
      $('#txtPartRequestDate').val(d.info.BuyRequestDate);
      var partsArr = [];
      for (var i = 0; i < d.parts.length; i++) {
        requestPart.push({ PartName: d.parts[i].PartName, PartId: d.parts[i].PartId });
        partsArr.push('<div class="reqPartBadge" ' +
          'onclick="RemoveRequestPartpBadge($(this));$(this).remove();">' +
          '<label style="direction:rtl;white-space:nowrap;" partid="' + d.parts[i].PartId + '">' + d.parts[i].PartName + '</label> ' +
          '<span>&times;</span>' +
          '</div>');
      }
      $('#badgeLocation').append(partsArr.join(''));
    }
    $('#pnlPartRequest').fadeIn();
  } else {
    $('#pnlPartRequest').hide();
    requestPart = [];
    $('#badgeLocation').empty();
    ClearFields('pnlPartRequest');
  }
});

var rows;
var typingTimer;
var doneTypingInterval = 2000;
var $requestPartinput = $('#txtSearchRequestedPart');
$requestPartinput.on('keyup', function () {
  clearTimeout(typingTimer);
  typingTimer = setTimeout(doneTypingPartRequest, doneTypingInterval);
  $('#PartRequestloading').show();
  $('#txtPartRequestSubSearch').val('');
  $('#griRequestParts tbody').empty();
  if ($('#txtSearchRequestedPart').val() === '') {
    $('#PartRequestSearchResult').hide();
  }
});
$requestPartinput.on('keydown', function () {
  clearTimeout(typingTimer);
});
function doneTypingPartRequest() {
  if (($requestPartinput).val().length > 2) {
    $.ajax({
      type: "POST",
      url: "WebService.asmx/PartsFilter",
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      data: JSON.stringify({ 'partName': $requestPartinput.val() }),
      success: function (e) {
        var tableRows = '';
        var filteredParts = JSON.parse(e.d);
        for (var i = 0; i < filteredParts.length; i++) {
          tableRows += '<tr id="sel"><td partid="' + filteredParts[i].PartId + '",>' + filteredParts[i].PartName + '</td></tr>';
        }
        $('#griRequestParts tbody').append(tableRows);
        rows = $('#griRequestParts tr').clone();
        $('#PartRequestloading').hide();
        $('#PartRequestSearchResult').show();
      },
      error: function () {
      }
    });
  } if (($requestPartinput).val().length <= 2 && ($requestPartinput).val() != '') {
    $.notify("!!حداقل سه حرف از نام قطعه را وارد نمایید", { globalPosition: 'top left' });
  }
  if ($('#txtSearchRequestedPart').val() === '') {
    $('#PartRequestSearchResult').hide();
    $('#PartRequestloading').hide();
  }
}

$('#griRequestParts').on('click', 'tr#sel', function () {
  var $row = $(this).find("td");
  var $text = $row.text();
  var $value = $row.attr('partid');

  for (var i = 0; i < requestPart.length; i++) {
    if (requestPart[i].PartId == parseInt($value)) {
      RedAlert('no', 'این قطعه قبلا انتخاب شده است');
      return;
    }
  }
  $('#Drmeasurement').val();
  $('#PartRequestSearchResult').hide();
  $('#txtSearchRequestedPart').val('');
  createRequestPartBadge($text, $value);
});
function createRequestPartBadge(text, val) {
  var badgeHtml = '<div class="reqPartBadge" ' +
    'onclick="RemoveRequestPartpBadge($(this));$(this).remove();">' +
    '<label style="direction:rtl;white-space:nowrap;" partid="' + val + '">' + text + '</label> ' +
    '<span>&times;</span>' +
    '</div>';
  $('#badgeLocation').append(badgeHtml);
  requestPart.push({ PartName: text, PartId: parseInt(val) });
}

function RemoveRequestPartpBadge(e) {
  for (var i = 0; i < requestPart.length; i++) {
    if (requestPart[i].PartId === parseInt(e.children('label').attr('partid'))) {
      requestPart.splice(i, 1);
    }
  }
}

$('#txtPartRequestSubSearch').keyup(function () {
  var val = $(this).val();
  $('#griRequestParts tbody').empty();
  rows.filter(function (idx, el) {
    return val === '' || $(el).text().indexOf(val) >= 0;
  }).appendTo('#griRequestParts');
});

var ele = $('#no');
$('#griRequestParts').on('mouseenter', 'tr', function () {
  ele.css({ 'background-color': '', 'color': '' });
  ele = $(this);
  ele.css({ 'background-color': '#5186d7', 'color': 'white' });
});

function SubmitRepairRequest(btn) {
  if ($('#drChangeReqState :selected').val() === "4") {
    $('#txtMachineName').val($('#lblMachineName').text());
    $('#txtMachineCode').val($('#lblRequestCode').text());
    $('#txtRequsetNumber').val($('#lblRequestNumber').text());
    $('#txtTimeReq').val($('#lblRequestTime').text());
    $('#txtUnitName').val($('#lblUnitRequest').text());
    $('#pnlRepairExplain').fadeIn();
    $('#pnlRequestDetail').hide();
    searchjsInit();
  } else {
    if ($('#drChangeReqState :selected').val() === "3") {
      if ($('#txtPartRequestComment').val() == '') {
        RedAlert('txtPartRequestComment', 'لطفا فیلد خالی را تکمیل نمایید');
        return;
      }
    }
    var partObj = [];
    for (var i = 0; i < requestPart.length; i++) {
      partObj.push(requestPart[i].PartId);
    }
    var reqId = $('#ReqId').val();
    var state = $('#drChangeReqState :selected').val();
    var obj = {
      RequestId: reqId,
      State: state,
      Info: $('#txtPartRequestComment').val(),
      BuyRequestDate: $('#txtPartRequestDate').val(),
      BuyRequestNumber: $('#txtPartRequestNumber').val()
    };
    AjaxData({
      url: "WebService.asmx/RequestStateDifinition",
      param: { d: obj, parts: partObj },
      func: stateDifinition
    })
    function stateDifinition(e) {
      if (state === "2" || state === "3") {
        GreenAlert('n', "✔ وضعیت درخواست با موفقیت بروزرسانی شد");
        setTimeout(function () { window.location.replace("/ShowRequests.aspx"); }, 2000);
        $('#pnlbuttons').children().hide();
      } else {
        GreenAlert('n', "✔ درخواست لغو شد");
        setTimeout(function () { window.location.replace("/ShowRequests.aspx"); }, 2000);
        $('#pnlbuttons').children().hide();
      }
    }
  }
}

function searchjsInit() {
  $('#helpPartsSearch').search({
    width: '22%',
    placeholder: 'جستجو کنید ...',
    url: 'WebService.asmx/PartsFilter',
    arg: 'partName',
    text: 'PartName',
    id: 'PartId',
    func: helpPart
  })
  function helpPart(id, text) {
    helppartData.push({ PartName: text, PartId: id });
  }

  $('#MasrafiPartsSearch').search({
    width: '30%',
    placeholder: 'جستجو کنید ...',
    url: 'WebService.asmx/PartsFilter',
    arg: 'partName',
    text: 'PartName',
    id: 'PartId',
    func: ghataatMasrafi
  })

  function ghataatMasrafi(id, text) {
    partData.push({ PartName: text, PartId: id });
  }
}

function AddFailReason() {
  if ($('#drFail > option').length < 1) {
    RedAlert('drFail', '!!ابتدا علت خرابی را در صفحه مربوطه تعریف نمایید');
    return;
  }
  var failText = $('#drFail :selected').text();
  var failValue = $('#drFail :selected').val();
  var rowsCount = $('#gridKharabi tr').length;
  var table = document.getElementById('gridKharabi');
  for (var a = 0; a < rowsCount; a++) {
    if (table.rows[a].cells[0].innerHTML == failValue) {
      RedAlert('n', "!!این مورد قبلا ثبت شده است");
      return;
    }
  }
  var failTableHeader = '<th>علت خرابی</th><th></th>';
  var failTableBody = '<tr>' +
    '<td style="display:none;">' + failValue + '</td>' +
    '<td>' + failText + '</td>' +
    '<td><a>حذف</a></td>' +
    '</tr>';
  if ($('#gridKharabi tr').length !== 0) {
    $("#gridKharabi tbody").append(failTableBody);
  } else {
    $("#gridKharabi thead").append(failTableHeader);
    $("#gridKharabi tbody").append(failTableBody);
  }
}
$("#gridKharabi").on("click", "tr a", function () {
  var row = $('#gridKharabi tr').length;
  if (row === 1) {
    $("#gridKharabi thead").empty();
    $("#gridKharabi tbody").empty();
  } else {
    $(this).parent().parent().remove();
  }
});
function AddDelayReason() {
  if ($('#drTakhir > option').length < 1) {
    RedAlert('drFail', '!!ابتدا علت تاخیر را در صفحه مربوطه تعریف نمایید');
    return;
  }
  var delayText = $('#drTakhir :selected').text();
  var delayValue = $('#drTakhir :selected').val();
  var rowsCount = $('#gridTakhir tr').length;
  for (var a = 0; a < rowsCount; a++) {
    if ($('#gridTakhir tr').text().indexOf(delayText) > -1) {
      RedAlert('n', "!!این مورد قبلا ثبت شده است");
      return;
    }
  }
  var delayTableHeader = '<th>علت تاخیر</th><th></th>';
  var delayTableBody = '<tr>' +
    '<td style="display:none;">' + delayValue + '</td>' +
    '<td>' + delayText + '</td>' +
    '<td><a>حذف</a></td>' +
    '</tr>';
  if ($('#gridTakhir tr').length !== 0) {
    $("#gridTakhir tbody").append(delayTableBody);
  } else {
    $("#gridTakhir thead").append(delayTableHeader);
    $("#gridTakhir tbody").append(delayTableBody);
  }
}
$("#gridTakhir").on("click", "tr a", function () {
  var row = $('#gridTakhir tr').length;
  if (row === 1) {
    $("#gridTakhir thead").empty();
    $("#gridTakhir tbody").empty();
  } else {
    $(this).parent().parent().remove();
  }
});
function AddAction() {
  if ($('#drAction > option').length < 1) {
    RedAlert('drAction', '!!ابتدا عملیات را در صفحه مربوطه تعریف نمایید');
    return;
  }
  var actionText = $('#drAction :selected').text();
  var actionValue = $('#drAction :selected').val();
  var rowsCount = $('#gridAction tr').length;
  var table = document.getElementById('gridAction');
  for (var a = 0; a < rowsCount; a++) {
    if (table.rows[a].cells[0].innerHTML == actionValue) {
      RedAlert('n', "!!این مورد قبلا ثبت شده است");
      return;
    }
  }
  var actionTableHeader = '<th>عملیات</th><th></th>';
  var actionTableBody = '<tr>' +
    '<td style="display:none;">' + actionValue + '</td>' +
    '<td>' + actionText + '</td>' +
    '<td><a>حذف</a></td>' +
    '</tr>';
  if ($('#gridAction tr').length !== 0) {
    $("#gridAction tbody").append(actionTableBody);
  } else {
    $("#gridAction thead").append(actionTableHeader);
    $("#gridAction tbody").append(actionTableBody);
  }
}
$("#gridAction").on("click", "tr a", function () {
  var row = $('#gridAction tr').length;
  if (row === 1) {
    $("#gridAction thead").empty();
    $("#gridAction tbody").empty();
  } else {
    $(this).parent().parent().remove();
  }
});
function AddStop() {
  if ($('#DrstopReason > option').length < 1) {
    RedAlert('DrstopReason', '!!ابتدا علل توقف را در صفحه مربوطه تعریف نمایید');
    return;
  }
  var stopText = $('#DrstopReason :selected').text();
  var stopValue = $('#DrstopReason :selected').val();
  var rowsCount = $('#gridStop tr').length;
  var table = document.getElementById('gridStop');
  for (var a = 0; a < rowsCount; a++) {
    if (table.rows[a].cells[0].innerHTML == stopValue) {
      RedAlert('n', "!!این مورد قبلا ثبت شده است");
      return;
    }
  }
  var actionTableHeader = '<th>علت توقف</th><th></th>';
  var actionTableBody = '<tr>' +
    '<td style="display:none;">' + stopValue + '</td>' +
    '<td>' + stopText + '</td>' +
    '<td><a>حذف</a></td>' +
    '</tr>';
  if ($('#gridStop tr').length !== 0) {
    $("#gridStop tbody").append(actionTableBody);
  } else {
    $("#gridStop thead").append(actionTableHeader);
    $("#gridStop tbody").append(actionTableBody);
  }
}
$("#gridStop").on("click", "tr a", function () {
  var row = $('#gridAction tr').length;
  if (row === 1) {
    $("#gridStop thead").empty();
    $("#gridStop tbody").empty();
  } else {
    $(this).parent().parent().remove();
  }
});
$('#drhelpunit').on('change', function () {
  $('#drhelpsub').empty();
  if ($('#drhelpunit :selected').val() === '-1') {
    $('#drhelpmachine').empty();
  } else {
    var data = [];
    data.push({
      url: 'WebService.asmx/FilterMachineOrderByLocation',
      parameters: [{ loc: $('#drhelpunit :selected').val() }],
      func: fillMachineDr
    });
    AjaxCall(data);
    function fillMachineDr(e) {
      var dr = JSON.parse(e.d);
      var body = [];
      $('#drhelpmachine').empty();
      body.push('<option value="-1">انتخاب کنید</option>');
      for (var i = 0; i < dr.length; i++) {
        body.push('<option value="' + dr[i].MachineId + '">' + dr[i].MachineName + '</option>');
      }
      $('#drhelpmachine').append(body.join(''));
    }
  }
});

$('#drhelpmachine').on('change', function () {
  if ($('#drhelpmachine :selected').val() === '-1') {
    $('#drhelpsub').empty();
  } else {
    var data = [];
    data.push({
      url: 'WebService.asmx/FilterSubSystem',
      parameters: [{ mid: $('#drhelpmachine :selected').val() }],
      func: filterSubDr
    });
    AjaxCall(data);
    function filterSubDr(e) {
      var dr = JSON.parse(e.d);
      var body = [];
      $('#drhelpsub').empty();
      body.push('<option value="-1">انتخاب کنید</option>');
      for (var i = 0; i < dr.length; i++) {
        body.push('<option value="' + dr[i].SubSystemId + '">' + dr[i].SubSystemName + '</option>');
      }
      $('#drhelpsub').append(body.join(''));
    }
  }
});

var helppartData = [];
var tr;
function Helppart() {
  if ($('#drhelpunit :selected').val() == '-1') {
    RedAlert('drhelpunit', 'لطفا واحد را مشخص کنید');
    return;
  }
  if ($('#drhelpmachine :selected').val() == '-1') {
    RedAlert('drhelpmachine', 'لطفا ماشین را مشخص کنید');
    return;
  }
  if ($('#drhelpsub :selected').val() == '-1') {
    RedAlert('drhelpsub', 'لطفا تجهیز را مشخص کنید');
    return;
  }
  var pid, pname;
  if (helppartData.length === 0) {
    pid = 0;
    pname = '----';
  } else {
    pid = helppartData[0].PartId;
    pname = helppartData[0].PartName;
  }
  var header = '<tr><th>نام ماشین</th><th>تجهیز</th><th>قطعه</th><th></th></tr>';
  var body = '<tr>' +
    '<td style="display:none;">' + $('#drhelpmachine :selected').val() + '</td>' +
    '<td style="display:none;">' + $('#drhelpsub :selected').val() + '</td>' +
    '<td style="display:none;">' + pid + '</td>' +
    '<td>' + $('#drhelpmachine :selected').text() + '</td>' +
    '<td>' + $('#drhelpsub :selected').text() + '</td>' +
    '<td>' + pname + '</td>' +
    '<td><a>حذف</a></td>' +
    '</tr>';
  if ($('#gridHelppart tr').length === 0) {
    $("#gridHelppart tbody").append(header);
    $("#gridHelppart tbody").append(body);
  } else {
    $("#gridHelppart tbody").append(body);
  }
  helppartData = [];
  $('#helpPartBadgeArea').find('.PartsBadge').remove();
  $('#txthelpPartsSearch').attr('placeholder', 'جستجو کنید ...');
  $('#txthelpPartsSearch').removeAttr('readonly');
}

$("#gridHelppart").on("click", "tr a", function () {
  var row = $('#gridHelppart tr').length;
  if (row === 2) {
    $("#gridHelppart tbody").empty();
  } else {
    $(this).parent().parent().remove();
  }
});


var partData = [];
function AddParts() {
  if ($('#txtPartsCount').val() == '') {
    RedAlert('txtPartsCount', "!!لطفا تعداد را وارد کنید");
  }
  if (partData.length == 0) {
    RedAlert('txtPartsSearch', "!!لطفا قطعه را انتخاب کنید");
  }
  var rowsCount = $('#gridParts tr').length;
  var table = document.getElementById('gridParts');
  for (var a = 0; a < rowsCount; a++) {
    for (var b = 0; b < partData.length; b++) {
      if (table.rows[a].cells[0].innerHTML == partData[b].PartId && table.rows[a].cells[6].innerHTML == '' + $("#chkrptools").is(':checked') + '') {
        RedAlert('n', "!!این مورد قبلا ثبت شده است");
        return;
      }
    }
  }
  if ($('#txtPartsCount').val() != '' && partData.length != 0) {
    var partCount = $('#txtPartsCount').val();
    var measur = $('#Drmeasurement :selected').text();
    var kind = $("#chkrptools").is(':checked');
    var kindd = '';
    if (kind === true)
      kindd = 'تعمیر';
    else
      kindd = 'تعویض';
    var partTableHeader = '<tr><th>قطعات</th><th>تعداد</th><th>واحد</th><th>عملیات</th><th></th></tr>';
    var partTableBody = '<tr>' +
      '<td style="display:none;">' + partData[0].PartId + '</td>' +
      '<td>' + partData[0].PartName + '</td>' +
      '<td>' + partCount + '</td>' +
      '<td>' + measur + '</td>' +
      '<td style="display:none;">' + $('#Drmeasurement').val() + '</td>' +
      '<td>' + kindd + '</td>' +
      '<td style="display:none;">' + $("#chkrptools").is(':checked') + '</td>' +
      '<td><a>حذف</a></td>' +
      '</tr>';
    if ($('#gridParts tr').length !== 0) {
      $("#gridParts tbody").append(partTableBody);
    } else {
      $("#gridParts tbody").append(partTableHeader);
      $("#gridParts tbody").append(partTableBody);
    }
    $('#txtPartsCount').val('');
    partData = [];
    $('#txtPartsSearch').attr('placeholder', 'جستجو کنید ...');
    $('#txtPartsSearch').removeAttr('readonly');
    $('#PartBadgeArea').find('.PartsBadge').remove();
  }
}
$("#gridParts").on("click", "tr a", function () {
  var row = $('#gridParts tr').length;
  if (row === 2) {
    $("#gridParts tbody").empty();
  } else {
    $(this).parent().parent().remove();
  }
});

$('#drRepairers').change(function () {
  if ($(this).val() !== '-1') {
    $('#drelec').val('-1');
  }
});

$('#drelec').change(function () {
  if ($(this).val() !== '-1') {
    $('#drRepairers').val('-1');
  }
});

function AddRepairers() {
  if ($('#drRepairers :selected').val() == '-1' && $('#drelec :selected').val() == '-1') {
    RedAlert('drFail', '!!ابتدا نیروی های فنی را در صفحه مربوطه تعریف نمایید');
    return;
  }
  if ($('#txtWorkTime').val() == '') {
    RedAlert('txtWorkTime', "!!لطفا ساعت کاکرد را وارد کنید");
    return;
  }
  var personel;
  var ptext;
  if ($('#drRepairers').val() == '-1') {
    personel = $('#drelec :selected').val();
    ptext = $('#drelec :selected').text();
  } else {
    personel = $('#drRepairers :selected').val();
    ptext = $('#drRepairers :selected').text();
  }
  var repairTime = $('#txtWorkTime').val();
  var rowsCount = $('#gridRepairers tr').length;
  var table = document.getElementById('gridRepairers');
  for (var a = 0; a < rowsCount; a++) {
    if (table.rows[a].cells[0].innerHTML == personel) {
      RedAlert('n', "!!این مورد قبلا ثبت شده است");
      return;
    }
  }
  var repairTableHeader = '<th>نام تعمیرکار</th><th>ساعت کارکرد</th><th></th>';
  var repairTableBody = '<tr>' +
    '<td style="display:none;">' + personel + '</td>' +
    '<td>' + ptext + '</td>' +
    '<td>' + repairTime + '</td>' +
    '<td><a>حذف</a></td>' +
    '</tr>';
  if ($('#gridRepairers tr').length !== 0) {
    $("#gridRepairers tbody").append(repairTableBody);
  } else {
    $("#gridRepairers thead").append(repairTableHeader);
    $("#gridRepairers tbody").append(repairTableBody);
  }
  $('#txtWorkTime').val('');
}
$("#gridRepairers").on("click", "tr a", function () {
  var row = $('#gridRepairers tr').length;
  if (row === 1) {
    $("#gridRepairers thead").empty();
    $("#gridRepairers tbody").empty();
  } else {
    $(this).parent().parent().remove();
  }
});
function AddContractor() {
  if ($('#drContractor > option').length < 1) {
    RedAlert('drFail', '!!ابتدا پیمانکاران را در صفحه مربوطه تعریف نمایید');
    return;
  }
  if ($('#txtContCost').val() == '') {
    RedAlert('txtContCost', "!!لطفا مقدار دستمزد را وارد کنید");
    return;
  }
  var contText = $('#drContractor :selected').text();
  var contValue = $('#drContractor :selected').val();
  var contCost = $('#txtContCost').val();
  var rowsCount = $('#gridContractors tr').length;
  var table = document.getElementById('gridContractors');
  for (var a = 0; a < rowsCount; a++) {
    if (table.rows[a].cells[0].innerHTML == contValue) {
      RedAlert('n', "!!این مورد قبلا ثبت شده است");
      return;
    }
  }
  var contTableHeader = '<th>نام پیمانکار</th><th>دستمزد(ریال)</th><th></th>';
  var contTableBody = '<tr>' +
    '<td style="display:none;">' + contValue + '</td>' +
    '<td>' + contText + '</td>' +
    '<td>' + contCost + '</td>' +
    '<td><a>حذف</a></td>' +
    '</tr>';
  if ($('#gridContractors tr').length !== 0) {
    $("#gridContractors tbody").append(contTableBody);
  } else {
    $("#gridContractors thead").append(contTableHeader);
    $("#gridContractors tbody").append(contTableBody);
  }
  CalculateCost();
  $('#TotalCostArea').show();
  $('#txtContCost').val('');
}
function CalculateCost() {
  var table = document.getElementById("gridContractors");
  var total = 0;
  for (var i = 0; i < table.rows.length; i++) {
    total += parseInt(table.rows[i].cells[2].innerHTML);
  }
  $('#lblTotalCost').text(total);
}
$('#txtContCost').on('keydown', function (e) { -1 !== $.inArray(e.keyCode, [46, 8, 9, 27, 13, 110]) || (/65|67|86|88/.test(e.keyCode) && (e.ctrlKey === true || e.metaKey === true)) && (!0 === e.ctrlKey || !0 === e.metaKey) || 35 <= e.keyCode && 40 >= e.keyCode || (e.shiftKey || 48 > e.keyCode || 57 < e.keyCode) && (96 > e.keyCode || 105 < e.keyCode) && e.preventDefault() });
$("#gridContractors").on("click", "tr a", function () {
  var row = $('#gridContractors tr').length;
  if (row === 1) {
    $("#gridContractors thead").empty();
    $("#gridContractors tbody").empty();
    $('#TotalCostArea').hide();
  } else {
    $(this).parent().parent().remove();
    CalculateCost();
  }
});

var CmParts;

function SendDataToDB(btn) {
  var flag = 0;
  if (CheckPastTime($('#StartRepairDate').val(), $('#StartRepiarTime').val(), $('#EndRepairDate').val(), $('#EndRepairTime').val()) === false) {
    RedAlert('nothing', '!!زمان پایان تعمیر باید بزرگتر از زمان شروع تعمیر باشد');
    flag = 1;
  }
  if ($('#gridKharabi tr').length < 1) {
    RedAlert('drFail', '!!لطفا علت خرابی را مشخص کنید');
    flag = 1;
  }
  if ($('#gridAction tr').length < 1) {
    RedAlert('drAction', "!!لطفا عملیات را مشخص کنید");
    flag = 1;
  }
  if ($('#StartRepairDate').val() == '') {
    RedAlert('StartRepairDate', "!!لطفا تاریخ شروع تعمیر را مشخص کنید");
    flag = 1;
  }
  if ($('#StartRepiarTime').val() == '') {
    RedAlert('StartRepiarTime', "!!لطفا زمان شروع تعمیر را مشخص کنید");
    flag = 1;
  }
  if ($('#EndRepairDate').val() == '') {
    RedAlert('EndRepairDate', "!!لطفا تاریخ پایان تعمیر را مشخص کنید");
    flag = 1;
  }
  if ($('#EndRepairTime').val() == '') {
    RedAlert('EndRepairTime', "!!لطفا زمان پایان تعمیر را مشخص کنید");
    flag = 1;
  }
  if ($('#drFailLevel').val() == '-1') {
    RedAlert('EndRepairTime', "!!لطفا وضعیت تعمیر را مشخص کنید");
    $('#drFailLevel').focus();

    flag = 1;
  }
  if (flag === 0) {
    var table;
    var obj = {};
    var replyInfo = [];
    var failReason = [];
    var stopReason = [];
    var delayReason = [];
    var action = [];
    var partChange = [];
    var parts = [];
    var personel = [];
    var contractors = [];

    replyInfo.push({
      RequestId: $('#txtRequsetNumber').val(),
      State: $('#drFailLevel :selected').val(),
      Comment: $('#txtActionExplain').val(),
      StartDate: $('#StartRepairDate').val(),
      StartTime: $('#StartRepiarTime').val(),
      EndDate: $('#EndRepairDate').val(),
      EndTime: $('#EndRepairTime').val(),
      RequestTime: $('#RequestTime').val(),
      RequestDate: $('#RequestDate').val(),
      SubSystem: $('#drSubSystem :selected').val(),
      Mechtime: $('#txtmechtime').val(),
      Electime: $('#txtelectime').val()

    });
    table = document.getElementById('gridKharabi');
    for (var a = 0; a < table.rows.length; a++) {
      failReason.push({
        FailReasonId: table.rows[a].cells[0].innerHTML
      });
    }
    table = document.getElementById('gridTakhir');
    for (var b = 0; b < table.rows.length; b++) {
      delayReason.push({
        DelayReasonId: table.rows[b].cells[0].innerHTML
      });
    }
    table = document.getElementById('gridAction');
    for (var c = 0; c < table.rows.length; c++) {
      action.push({
        ActionId: table.rows[c].cells[0].innerHTML
      });
    }
    table = document.getElementById('gridStop');
    for (var s = 0; s < table.rows.length; s++) {
      stopReason.push({
        StopReasonId: table.rows[s].cells[0].innerHTML
      });
    }
    table = document.getElementById('gridHelppart');
    for (var g = 1; g < table.rows.length; g++) {
      partChange.push({
        Machine: table.rows[g].cells[0].innerHTML,
        Sub: table.rows[g].cells[1].innerHTML,
        Part: table.rows[g].cells[2].innerHTML
      });
    }
    table = document.getElementById('gridParts');
    for (var d = 1; d < table.rows.length; d++) {
      parts.push({
        Part: table.rows[d].cells[0].innerHTML,
        Count: table.rows[d].cells[2].innerHTML,
        Measur: table.rows[d].cells[4].innerHTML,
        Rptools: table.rows[d].cells[6].innerHTML
      });
    }
    table = document.getElementById('gridRepairers');
    for (var e = 0; e < table.rows.length; e++) {
      personel.push({
        Repairer: table.rows[e].cells[0].innerHTML,
        RepairTime: table.rows[e].cells[2].innerHTML
      });
    }
    table = document.getElementById('gridContractors');
    for (var f = 0; f < table.rows.length; f++) {
      contractors.push({
        Contractor: table.rows[f].cells[0].innerHTML,
        Cost: table.rows[f].cells[2].innerHTML
      });
    }
    obj = {
      ReplyInfo: replyInfo,
      FailReason: failReason,
      DelayReason: delayReason,
      Action: action,
      StopReason: stopReason,
      PartChange: partChange,
      Parts: parts,
      Personel: personel,
      Contractors: contractors
    }
    $.ajax({
      type: "POST",
      url: "WebService.asmx/ReplyDataToDb",
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      data: JSON.stringify({ 'obj': obj }),
      success: function (e) {
        CmParts = JSON.parse(e.d);
        if (CmParts.length > 0) {
          var option = [];
          for (var i = 0; i < CmParts.length; i++) {
            option.push('<option value="' + CmParts[i].PartId + '" forecast="' + CmParts[i].ForeCastId + '"' +
              ' machinid="' + CmParts[i].MachineId + '">' + CmParts[i].PartName + '' +
              '&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp; برنامه زمانی تعویض اصلی : ' + CmParts[i].CmDate + '</option>');

          }

          $('#drPartChangeParts').append(option.join(''));
          $('#PartChangeModal').show();
          return;
        } else {
          CheckAffectedMachines();
          return;
        }
      },
      error: function () {
        RedAlert('no', 'خطا در ثبت اطلاعات');
      }
    });
  }
}

function PartChangeFailReason() {
  if ($('#drpartChangeFailReason > option').length < 1) {
    RedAlert('drFail', '!!ابتدا علت خرابی را در صفحه مربوطه تعریف نمایید');
    return;
  }
  var failText = $('#drpartChangeFailReason :selected').text();
  var failValue = $('#drpartChangeFailReason :selected').val();
  var rowsCount = $('#gridPartChangeFailReason tr').length;
  var table = document.getElementById('gridPartChangeFailReason');
  for (var a = 0; a < rowsCount; a++) {
    if (table.rows[a].cells[0].innerHTML == failValue) {
      RedAlert('n', "!!این مورد قبلا ثبت شده است");
      return;
    }
  }
  var failTableHeader = '<tr><th>علت خرابی</th><th></th></tr>';
  var failTableBody = '<tr>' +
    '<td style="display:none;">' + failValue + '</td>' +
    '<td>' + failText + '</td>' +
    '<td><a>حذف</a></td>' +
    '</tr>';
  if ($('#gridPartChangeFailReason tr').length !== 0) {
    $("#gridPartChangeFailReason tbody").append(failTableBody);
  } else {
    $("#gridPartChangeFailReason tbody").append(failTableHeader);
    $("#gridPartChangeFailReason tbody").append(failTableBody);
  }
}
$("#gridPartChangeFailReason").on("click", "tr a", function () {
  var row = $('#gridPartChangeFailReason tr').length;
  if (row === 2) {
    $("#gridPartChangeFailReason tbody").empty();
  } else {
    $(this).parent().parent().remove();
  }
});
$(".chosen-select").chosen({ width: "30%" });
function SubmitPartChange(btn) {
  if ($('#txttarikhPartChange').val() === '') {
    RedAlert('txttarikhPartChange', 'لطفا تاریخ را مشخص نمایید');
    return;
  }
  var failReasonList = [];
  var table = document.getElementById('gridPartChangeFailReason');
  for (var a = 1; a < table.rows.length; a++) {
    failReasonList.push(
      table.rows[a].cells[0].innerHTML
    );
  }
  AjaxData({
    url: 'WebService.asmx/SubmitReplyForcast',
    parameters: {
      obj: {
        FailReasonList: failReasonList,
        MachineId: $('#drPartChangeParts :selected').attr('machinid'),
        ReplyDate: CmParts[0].ReplyDate,
        Tarikh: $('#txttarikhPartChange').val(),
        PartId: $('#drPartChangeParts :selected').val(),
        Info: $('#txtCommentPartChange').val(),
        ForeCastId: $('#drPartChangeParts :selected').attr('forecast')
      } },
    func: doneSubmit
  })
  function doneSubmit(e) {
    $('#txttarikhPartChange').val('');
    $("#gridPartChangeFailReason tbody").empty();
    $('#drPartChangeParts option:selected').remove();
    $('#txtCommentPartChange').val('');
    GreenAlert('n', "ثبت شد");
    if ($('#drPartChangeParts > option').length < 1) {
      $(btn).hide();
      //GreenAlert('n', "✔ پایان تعمیر با موفقیت ثبت شد");
      $('#PartChangeModal').modal('hide');
      //setTimeout(function () { window.location.replace("/ShowRequests.aspx"); }, 2000);   
    }
    CheckAffectedMachines();
  }
}

function CheckAffectedMachines() {
  var data = [];
  var machCode = $('#txtMachineCode').val();
  $('#effectMachinName').html($('#txtMachineName').val());
  data.push({
    url: 'WebService.asmx/GetAffectedMachines',
    parameters: [{ machineCode: machCode }],
    func: createaffected
  });
  AjaxCall(data);
  function createaffected(r) {
    var e = JSON.parse(r.d);
    if (e.length > 0) {
      var body = [];
      body.push('<tr><th>ردیف</th><th>نام ماشین</th><th>مدت زمان توقف(دقیقه)</th></tr>');
      for (var i = 0; i < e.length; i++) {
        body.push('<tr>' +
          '<td mainmachid="' + e[i].MachineId + '">' + (i + 1) + '</td>' +
          '<td affectmachid="' + e[i].AfftectedMachineId + '">' + e[i].MachineName + '</td>' +
          '<td><input class="form-control text-center" placeholder="دقیقه" value="0"/></td>' +
          '</tr>');
      }
      $('#gridAffectedMachines tbody').append(body.join(''));
      $('#effectModal').show();
    } else {
      GreenAlert('n', "✔ پایان تعمیر با موفقیت ثبت شد");
      setTimeout(function () { window.location.replace("/ShowRequests.aspx"); }, 2000);
    }
  }
}

function SaveAffectedMachines(btn) {
  var table = $('#gridAffectedMachines');
  var rows = $('#gridAffectedMachines tr').length;
  var d = [];
  for (var i = 1; i < rows; i++) {
    var stoptime = table.find('tr:eq(' + i + ') input').val();
    if (stoptime != '0') {
      d.push({
        MachineId: table.find('tr:eq(' + i + ') td:eq(0)').attr('mainmachid'),
        AfftectedMachineId: table.find('tr:eq(' + i + ') td:eq(1)').attr('affectmachid'),
        StopTime: stoptime,
        RequestId: $('#txtRequsetNumber').val()
      });
    }
  }
  AjaxData({
    url: 'WebService.asmx/AffectedMachinesSave',
    parameters: { obj: d },
    func: succesfullydone
  })
  function succesfullydone() {
    $(btn).hide();
    GreenAlert('n', "✔ پایان تعمیر با موفقیت ثبت شد");
    setTimeout(function () { window.location.replace("/ShowRequests.aspx"); }, 2000);
  }
}

$(function() {
  kamaDatepicker('EndRepairDate', customOptions);
  kamaDatepicker('StartRepairDate', customOptions);
  kamaDatepicker('txtPartRequestDate', customOptions);
  kamaDatepicker('txttarikhPartChange', customOptions);
})
