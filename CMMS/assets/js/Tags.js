$(function () {
    AjaxData({
        url: 'WebService.asmx/LatestDeviceTagNumber',
        param: {},
        func: lastcode
    });
    function lastcode(e) {
        $('#txtsubCode').val(e.d);
    }
});
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
kamaDatepicker('txtRepairDate', customOptions);
$('#txtWorkTime').clockpicker({ autoclose: true, placement: 'top' });
function AddRepairers() {
    if ($('#txtWorkTime').val() == '') {
        RedAlert('txtWorkTime', "!!لطفا ساعت کاکرد را وارد کنید");
        return;
    }
    var repairText = $('#drRepairers :selected').text();
    var repairValue = $('#drRepairers :selected').val();
    var repairTime = $('#txtWorkTime').val();
    var rowsCount = $('#gridRepairers tr').length;
    var table = document.getElementById('gridRepairers');
    for (var a = 0; a < rowsCount; a++) {
        if (table.rows[a].cells[0].innerHTML == repairValue) {
            $.notify("!!این مورد قبلا ثبت شده است", { globalPosition: 'top left' });
            return;
        }
    }
    var repairTableHeader = '<th>نام تعمیرکار</th><th>ساعت کارکرد</th><th></th>';
    var repairTableBody = '<tr>' +
        '<td style="display:none;">' + repairValue + '</td>' +
        '<td>' + repairText + '</td>' +
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
            RedAlert('no', "!!این مورد قبلا ثبت شده است");
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
var rows;
var typingTimer;
var doneTypingInterval = 2000;
var $requestPartinput = $('#txtPartsSearch');
$requestPartinput.on('keyup', function () {
    clearTimeout(typingTimer);
    typingTimer = setTimeout(doneTypingPartRequest, doneTypingInterval);
    $('#partsLoading').show();
    $('#txtPartRequestSubSearch').val('');
    $('#gridPartsResault tbody').empty();
    if ($('#txtPartsSearch').val() === '') {
        $('#PartsSearchResulat').hide();
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
                $('#gridPartsResault tbody').append(tableRows);
                rows = $('#griRequestParts tr').clone();
                $('#partsLoading').hide();
                $('#PartsSearchResulat').show();
            },
            error: function () {
            }
        });
    } if (($requestPartinput).val().length <= 2 && ($requestPartinput).val() != '') {
        $.notify("!!حداقل سه حرف از نام قطعه را وارد نمایید", { globalPosition: 'top left' });
    }
    if ($('#txtPartsSearch').val() === '') {
        $('#PartsSearchResulat').hide();
        $('#partsLoading').hide();
    }
}



$('#txtSubSearchPart').keyup(function () {
    var val = $(this).val();
    $('#gridPartsResault tbody').empty();
    rowss.filter(function (idx, el) {
        return val === '' || $(el).text().indexOf(val) >= 0;
    }).appendTo('#gridPartsResault');
});

var partData = [];
$('.PartsTable').on('click', 'tr', function () {
    var $row = $(this).find("td");
    var pid = $row.attr('partid');
    var text = $row.text();
    $('#PartsSearchResulat').hide();
    $('#txtPartsSearch').val('');
    $('#txtPartsSearch').removeAttr('placeholder');
    createPartBadge(text, pid);
});
function createPartBadge(text, val) {
    var badgeHtml = '<div class="PartsBadge" ' +
        'onclick="RemovePartBadge($(this));$(this).remove();">' +
        '<label style="direction:rtl;white-space:nowrap;">' + text + '</label>' +
        '<p style="display:none;">' + val + '</p>' +
        ' <span>&times;</span>' +
        '</div>';
    $('#PartBadgeArea').append(badgeHtml);
    partData.push({ PartName: text, PartId: val });
    $('#txtPartsSearch').attr('readonly', 'readonly');
}

function RemovePartBadge(e) {
    $('#txtPartsSearch').attr('placeholder', 'جستجو کنید ...');
    $('#txtPartsSearch').removeAttr('readonly');
    for (var i = 0; i < partData.length; i++) {
        if (partData[i].PartId === e.children('p').html()) {
            partData.splice(i, 1);
        }
    }
}
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
            if (table.rows[a].cells[0].innerHTML == partData[b].PartId) {
                $.notify("!!این مورد قبلا ثبت شده است", { globalPosition: 'top left' });
                return;
            }
        }
    }
    if ($('#txtPartsCount').val() != '' && partData.length != 0) {
        var partCount = $('#txtPartsCount').val();
        var partTableHeader = '<th>قطعات</th><th>تعداد</th><th></th>';
        var partTableBody = '<tr>' +
            '<td style="display:none;">' + partData[0].PartId + '</td>' +
            '<td>' + partData[0].PartName + '</td>' +
            '<td>' + partCount + '</td>' +
            '<td><a>حذف</a></td>' +
            '</tr>';
        if ($('#gridParts tr').length !== 0) {
            $("#gridParts tbody").append(partTableBody);
        } else {
            $("#gridParts thead").append(partTableHeader);
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
    if (row === 1) {
        $("#gridParts thead").empty();
        $("#gridParts tbody").empty();
    } else {
        $(this).parent().parent().remove();
    }
});
function PassDataToDB() {
    var repairInfo = [];
    var parts = [];
    var repairers = [];
    var contractors = [];
    var obj = {};
    if ($('#Change').css('display') == 'none') {
        //Repair Section
        if ($('#txtRepairDate').val() == '') {
            RedAlert('txtRepairDate', "!!لطفا تاریخ تعمیر را مشخص نمایید");
            return;
        }
        if ($('#txtRepairExplain').val() == '') {
            RedAlert('txtRepairExplain', "!!لطفا شرح تعمیر را مشخص نمایید");
            return;
        }
        if ($('#drRecLocUnit :selected').val() == '-1') {
            RedAlert('drRecLocUnit', "!!لطفا واحد فعلی استفاده قطعه را مشخص کنید");
            return;
        }
        if ($('#drRecLocLine > option').length == 1) {
            RedAlert('drRecLocLine', "!!لطفا برای واحد مورد نظر یک خط تعریف نمایید");
            return;
        }
        if ($('#drRecLocLine :selected').val() == '-1') {
            RedAlert('drRecLocLine', "!!لطفا خط فعلی استفاده قطعه را مشخص کنید");
            return;
        }
        if ($('#drNewLocUnit :selected').val() == '-1') {
            RedAlert('drNewLocUnit', "!!لطفا واحد جدید استفاده قطعه را مشخص کنید");
            return;
        }
        if ($('#drNewLocLine > option').length == 1) {
            RedAlert('drNewLocLine', "!!لطفا برای واحد مورد نظر یک خط تعریف نمایید");
            return;
        }
        if ($('#drNewLocLine :selected').val() == '-1') {
            RedAlert('drNewLocLine', "!!لطفا خط جدید استفاده قطعه را مشخص کنید");
            return;
        }
        if ($('#gridRepairers tr').length == 0 && $('#gridContractors tr').length == 0) {
            RedAlert('ContractorArea', "!!حداقل یک مورد را تکمیل نمایید");
            RedAlert('PersonelArea', '');
            return;
        }
        repairInfo.push({
            TagId: $('#TagID').val(),
            RepairNumber: $('#txtRepairNumber').val(),
            Tarikh: $('#txtRepairDate').val(),
            RepairExplain: $('#txtRepairExplain').val(),
            Comment: $('#txtcomment').val(),
            RecentlyUnit: $('#drRecLocUnit :selected').val(),
            RecentlyLine: $('#drRecLocLine :selected').val(),
            NewUnit: $('#drNewLocUnit :selected').val(),
            NewLine: $('#drNewLocLine :selected').val(),
            Cr: 1
        });
        var table = document.getElementById('gridParts');
        for (var i = 0; i < table.rows.length; i++) {
            parts.push({
                Part: table.rows[i].cells[0].innerText,
                Count: table.rows[i].cells[2].innerText
            });
        }
        table = document.getElementById("gridRepairers");
        for (var j = 0; j < table.rows.length; j++) {
            repairers.push({
                Repairer: table.rows[j].cells[0].innerText,
                RepairTime: table.rows[j].cells[2].innerText
            });
        }
        table = document.getElementById("gridContractors");
        for (var a = 0; a < table.rows.length; a++) {
            contractors.push({
                Contractor: table.rows[a].cells[0].innerText,
                Cost: table.rows[a].cells[2].innerText
            });
        }
        obj = {
            RecordInfo: repairInfo,
            Parts: parts,
            Repairers: repairers,
            Contractors: contractors
        };
        passDataToServer(obj);
    } else {
        //Change Section
        if ($('#txtRepairDate').val() == '') {
            RedAlert('txtRepairDate', "!!لطفا تاریخ تعویض را مشخص نمایید");
            return;
        }
        if ($('#drNowunit :selected').val() == '-1') {
            RedAlert('drNowunit', "!!لطفا واحد فعلی استفاده قطعه را مشخص کنید");
            return;
        }
        if ($('#drNowLine > option').length == 1) {
            RedAlert('drNowLine', "!!لطفا برای واحد مورد نظر یک خط تعریف نمایید");
            return;
        }
        if ($('#drNowLine :selected').val() == '-1') {
            RedAlert('drNowLine', "!!لطفا خط فعلی استفاده قطعه را مشخص کنید");
            return;
        }
        if ($('#drAfterUnit :selected').val() == '-1') {
            RedAlert('drAfterUnit', "!!لطفا واحد جدید استفاده قطعه را مشخص کنید");
            return;
        }
        if ($('#drAfterLine > option').length == 1) {
            RedAlert('drAfterLine', "!!لطفا برای واحد مورد نظر یک خط تعریف نمایید");
            return;
        }
        if ($('#drAfterLine :selected').val() == '-1') {
            RedAlert('drAfterLine', "!!لطفا خط جدید استفاده قطعه را مشخص کنید");
            return;
        }
        repairInfo.push({
            TagId: $('#TagID').val(),
            RepairNumber: $('#txtRepairNumber').val(),
            Tarikh: $('#txtRepairDate').val(),
            RepairExplain: '',
            Comment: $('#txtChangeComment').val(),
            RecentlyUnit: $('#drNowunit :selected').val(),
            RecentlyLine: $('#drNowLine :selected').val(),
            NewUnit: $('#drAfterUnit :selected').val(),
            NewLine: $('#drAfterLine :selected').val(),
            NewLoaction: $('#txtChangeNewLocation').val(),
            Cr: 0
        });
        obj = {
            RecordInfo: repairInfo,
            Parts: parts,
            Repairers: repairers,
            Contractors: contractors
        };
        passDataToServer(obj);
    } 
    function passDataToServer(obj) {
        AjaxData({
            url: "WebService.asmx/PartsRepairRecord",
            param: { data: obj },
            func:successfull
        });
        function successfull(e) {
            $('#txtRepairNumber').val(e.d);
            ClearFields('inputsArea');
            $('#txtRepairDate').val('');
            $('#gridContractors thead').empty();
            $('#gridContractors tbody').empty();
            $('#gridRepairers thead').empty();
            $('#gridRepairers tbody').empty();
            $('#gridParts thead').empty();
            $('#gridParts tbody').empty();
            $('#lblTotalCost').text('');
            $('#TotalCostArea').hide();
            GreenAlert('nothing', "✔ سابقه تعمیر قطعه با موفقیت ثبت شد");
        }
    }
}