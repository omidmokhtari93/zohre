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
    kamaDatepicker('txtDastoorTarikh', customOptions);
    kamaDatepicker('txtStartPMDate', customOptions);
    kamaDatepicker('txtGhatatChangePeriod', customOptions);
    Pageload();
});
$('#btnNewMachineFor').on('click', function () {
    var flag = 0;
    var mCode = 0;
    if ($('#txtmachineCode').val() !== '' && $('#txtmachineCode').val().length == 8) {
        mCode = $('#txtmachineCode').val();
    }
    var mid = 0;
    if ($('#Mid').val() !== '') {
        mid = $('#Mid').val();
        $('[lblMCode]').text($('#txtmachineCode').val() + '___'  + $('#txtmachineName').val());
    }
    $.ajax({
        type: "POST",
        url: "WebService.asmx/CheckDuplicateMachineCode",
        data: JSON.stringify({ 'machinCode': mCode, 'mid': mid }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (e) {
            var check = JSON.parse(e.d);
            if ($('#txtmachineName').val() == '') { RedAlert('txtmachineName', "!!لطفا نام دستگاه را وارد کنید"); flag = 1; }
            if ($('#txttargetMTBF').val() == '') { RedAlert('txttargetMTBF', "!!را مشخص کنید MTBF لطفا هدف"); flag = 1; }
            if ($('#txtAdmissionperiodMTBF').val() == '') { RedAlert('txtAdmissionperiodMTBF', "!!را مشخص کنید MTBF لطفا دوره پذیرش"); flag = 1; }
            if ($('#txttargetMTTR').val() == '') { RedAlert('txttargetMTTR', "!!را مشخص کنید MTTR لطفا هدف"); flag = 1; }
            if ($('#txtAdmissionperiodMTTR').val() == '') { RedAlert('txtAdmissionperiodMTTR', "!!را مشخص کنید MTTR لطفا دوره پذیرش"); flag = 1; }
            if (check === 1) { RedAlert('txtmachineCode', "!!این کد دستگاه قبلا ثبت شده است"); flag = 1; }
            if ($('#txtmachineCode').val().length !== 8 && ($('input[name=switchCode]:checked').attr('value') === "1")) { RedAlert('txtmachineCode', "!!لطفا کد دستگاه را 8 رقمی تعیین کنید"); flag = 1; }
            if ($('#txtmachineCode').val().length !== 6 && ($('input[name=switchCode]:checked').attr('value') === "0")) { RedAlert('txtmachineCode', "!!لطفا کد دستگاه را 6 رقمی تعیین کنید"); flag = 1; }
            if ($('#Mid').val() == '') {
                if (flag === 0) { $('#pnlNewMachine').hide(); $('#pnlMavaredMasrafi').fadeIn(); }
            } else { if (flag === 0) { $('#pnlNewMachine').hide(); $('#pnlMavaredMasrafi').fadeIn(); } }
        },
        error: function () {
            $.notify("!!خطای نامشخص", { globalPosition: 'top left' });
        }
    });
});
$('input[name=switchCode]').change(function (e) {
    if ($('input[name=switchCode]:checked').attr('value') === "1") {
        $('#vahed').show();
    } else {
        $('#vahed').hide();
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
$('#drControliZaman').change(function() {
    if ($('#drControliZaman :selected').val() !== 0 &&
        $('#drControliZaman :selected').val() !== 6) {
        $('#pnlcontroliRooz').show();
        $('#pnlControliWeek').hide();
        $('#pnlcontroliRooz').find('label').text('روزپیش بینی شده در ماه :');
    }
    if ($('#drControliZaman :selected').val() == 6) {
        $('#pnlControliWeek').show();   
        $('#pnlcontroliRooz').hide();
    }
    if ($('#drControliZaman :selected').val() == 0) {
        $('#pnlControliWeek').hide();
        $('#pnlcontroliRooz').hide();
    }
    if ($('#drControliZaman :selected').val() == 5) {
        $('#pnlcontroliRooz').show();
        $('#pnlControliWeek').hide();
        $('#pnlcontroliRooz').find('label').text('دوره تکرار :');
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
function checkControliInputs() {
    var flag = 0;
    if (checkPastDate('txtStartPMDate') == false) { RedAlert('txtStartPMDate', "!!تاریخ شروع سرویسکاری باید بزرگتر از  تاریخ امروز باشد"); flag = 1; }
    if ($('#txtControliMoredControl').val() == '') { RedAlert('txtControliMoredControl', "!!لطفا مورد کنترلی را وارد نمایید"); flag = 1; }
    if ($('#txtStartPMDate').val() == '') { RedAlert('txtStartPMDate', "!!لطفا تاریخ شروع سرویسکاری را مشخص نمایید"); flag = 1; }
    if ($('#drControliZaman :selected').val() != 6 && $('#drControliZaman :selected').val() != 0 && $('#drControliZaman :selected').val() != 5 && $('#txtControliRooz').val() == '') { RedAlert('txtControliRooz', "!!لطفا مدت زمان پیش بینی شده را مشخص کنید"); flag = 1; }
    if ($('#drControliZaman :selected').val() != 6 && $('#drControliZaman :selected').val() != 0 && $('#drControliZaman :selected').val() != 5 && $('#txtControliRooz').val() === '31') { RedAlert('txtControliRooz', "!!این مقدار نمیتواند به عنون روز پیش بینی شده ثبت گردد"); flag = 1; }
    if ($('#drControliZaman :selected').val() == 5 && $('#txtControliRooz').val() == '') { RedAlert('txtControliRooz', "!!لطفا دوره تکرار را مشخص کنید"); flag = 1; }
    return flag;
}

function addControli() {
    if (checkControliInputs() === 0) {
        var mdControl = document.getElementById('servicebale');
        var mdcont = 'خیر';
        var mdCountValue = 0;
        if (mdControl.checked) {
            mdcont = 'بله';
            mdCountValue = 1;
        }
        var mored = $('#txtControliMoredControl').val();
        var zaman = $('#drControliZaman :selected').text();
        var zamanValue = $('#drControliZaman :selected').val();
        var rooz = $('#txtControliRooz').val();
        var roozValue = 0;
        if (zamanValue == 6) {
            rooz = $('#drControlWeek :selected').text();
            roozValue = $('#drControlWeek :selected').val(); 
        }
        if (zamanValue == 0) {
            rooz = '----';
        }
        if (zamanValue == 5) {
            rooz = 'هر ' + $('#txtControliRooz').val() + ' روز';
            roozValue = $('#txtControliRooz').val(); 
        }
        if (zamanValue != 6 && zamanValue != 0 && zamanValue != 5) {
            roozValue = $('#txtControliRooz').val();
            rooz = $('#txtControliRooz').val();
        }
        var comm = $('#txtMavaredComment').val();
        var head = '<thead>' +
            '<tr>' +
            '<th>مورد کنترلی</th>' +
            '<th>دوره تکرار</th>' +
            '<th>روز پیش بینی شده</th>' +
            '<th>نمایش برای سرویسکاری</th>' +
            '<th>عملیات</th>' +
            '<th>تاریخ شروع سرویسکاری</th>' +
            '<th>ملاحظات</th>' +
            '<th></th>' +
            '<th></th>' +
            '</tr>' +
            '</thead>';
        var tbody = '<tbody></tbody>';
        var row = '<tr>' +
            '<td style="display:none;">0</td>' +
            '<td style="display:none;">' + mored + '</td>' +
            '<td style="display:none;">' + zamanValue + '</td>' +
            '<td style="display:none;">' + roozValue + '</td>' +
            '<td style="display:none;">' + mdCountValue + '</td>' +
            '<td style="display:none;">' + $('#drcontroliOpr :selected').val() + '</td>' +
            '<td style="display:none;">' + $('#txtStartPMDate').val() + '</td>' +
            '<td style="display:none;">' + comm + '</td>' +
            '<td style="display:none;">0</td>' +
            '<td>' + mored + '</td>' +
            '<td>' + zaman + '</td>' +
            '<td>' + rooz + '</td>' +
            '<td>' + mdcont + '</td>' +
            '<td>' + $('#drcontroliOpr :selected').text() + '</td>' +
            '<td>' + $('#txtStartPMDate').val() + '</td>' +
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
        $('#pnlcontroliRooz').hide();
        $('#pnlControliWeek').hide();
    }
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
        Name: $(this).parent().parent().find('td:eq(1)').text(),
        Period: $(this).parent().parent().find('td:eq(2)').text(),
        Day: $(this).parent().parent().find('td:eq(3)').text(),
        Service: $(this).parent().parent().find('td:eq(4)').text(),
        Operation: $(this).parent().parent().find('td:eq(5)').text(),
        Date: $(this).parent().parent().find('td:eq(6)').text(),
        Comment: $(this).parent().parent().find('td:eq(7)').text()
    });
    FillControls(rowItems);
});
$('#gridParts').on('click', 'tr', function () {
    var $row = $(this).find("td");
    var $text = $row.text();
    var $value = $row.attr('partid');
  
    var data = [];
    data.push({
        url: 'WebService.asmx/PartsMeasur',
        parameters: [{ partid: $value }],
        func: filterMeasurement
    });
    AjaxCall(data);
    function filterMeasurement(e) {
        var dr = JSON.parse(e.d);
        $('#Drmeasurement').val(dr);

    }
});
function FillControls(items) {
    $('#txtControliMoredControl').val(items[0].Name);
    $('#drControliZaman').val(items[0].Period);
    if (items[0].Period != 0 && items[0].Period != 6) {
        $('#pnlControliWeek').hide();
        $('#pnlcontroliRooz').show();
        $('#txtControliRooz').val(items[0].Day);
    } else if (items[0].Period == 6) {
        $('#pnlControliWeek').show();
        $('#pnlcontroliRooz').hide();
        $('#drControlWeek').val(items[0].Day);
    }
    if (items[0].Service == 1) {
        document.getElementById('servicebale').checked = true;
    } else {
        document.getElementById('servicekheyr').checked = true;
    }
    $('#drcontroliOpr').val(items[0].Operation);
    $('#txtStartPMDate').val(items[0].Date);
    $('#txtMavaredComment').val(items[0].Comment);
    $('#btnEditControls').show();
    $('#btnCancelEditCotntrols').show();
}
function DeleteControls() {
    $.ajax({
        type: "POST",
        url: "WebService.asmx/DeleteControlItem",
        data: "{controlId : " + controlId + "}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function () {
            GreenAlert('nothing',"✔ مورد کنترلی با موفقیت حذف شد");
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
        $(target_tr).find('td:eq(1)').text($('#txtControliMoredControl').val());
        $(target_tr).find('td:eq(9)').text($('#txtControliMoredControl').val());
        $(target_tr).find('td:eq(2)').text($('#drControliZaman :selected').val());
        $(target_tr).find('td:eq(10)').text($('#drControliZaman :selected').text());
        var period = $('#drControliZaman :selected').val();
        if (period == 6) {
            $(target_tr).find('td:eq(3)').text($('#drControlWeek :selected').val());
            $(target_tr).find('td:eq(11)').text($('#drControlWeek :selected').text());
        }
        if (period == 0) {
            $(target_tr).find('td:eq(3)').text(0);
            $(target_tr).find('td:eq(11)').text('----');
        }
        if (period == 5) {
            $(target_tr).find('td:eq(3)').text($('#txtControliRooz').val());
            $(target_tr).find('td:eq(11)').text('هر ' + $('#txtControliRooz').val() + ' روز');
        }
        if (period != 6 && period != 0 && period != 5) {
            $(target_tr).find('td:eq(3)').text($('#txtControliRooz').val());
            $(target_tr).find('td:eq(11)').text($('#txtControliRooz').val());
        }
        if ($('#servicebale').is(':checked')) {
            $(target_tr).find('td:eq(4)').text(1);
            $(target_tr).find('td:eq(12)').text('بله');
        } else {
            $(target_tr).find('td:eq(4)').text(0);
            $(target_tr).find('td:eq(12)').text('خیر');
        }
        $(target_tr).find('td:eq(5)').text($('#drcontroliOpr :selected').val());
        $(target_tr).find('td:eq(13)').text($('#drcontroliOpr :selected').text());
        $(target_tr).find('td:eq(6)').text($('#txtStartPMDate').val());
        $(target_tr).find('td:eq(14)').text($('#txtStartPMDate').val());
        $(target_tr).find('td:eq(7)').text($('#txtMavaredComment').val());
        $(target_tr).find('td:eq(15)').text($('#txtMavaredComment').val());
        EmptyControls();
        GreenAlert(target_tr,"✔ مورد کنترلی ویرایش شد");
    }
}
function EmptyControls() {
    ClearFields('pnlMavaredControli');
    $('#pnlControliWeek').hide();
    $('#pnlcontroliRooz').hide();
    $('#btnEditControls').hide();
    $('#btnCancelEditCotntrols').hide();
    document.getElementById('servicebale').checked = true;
    rowItems = [];
}
function addParts() {
    var flag = checkPartInputs();
    var rowsCount = $('#gridGhataatMasrafi tr').length;
    var table = document.getElementById('gridGhataatMasrafi');
    for (var a = 0; a < rowsCount; a++) {
        for (var b = 0; b < partData.length; b++) {
            if (table.rows[a].cells[1].innerHTML == partData[b].PartId) {
                $.notify("!!این مورد قبلا ثبت شده است", { globalPosition: 'top left' });
                return ;
            }
        }
    }
    if (flag === 0 && partData.length === 1) {
        var head = '<thead>' +
            '<tr>' +
            '<th style="display:none;"></th>' +
            '<th>نام قطعه</th>' +
            '<th>واحد</th>' +
            '<th>مصرف در سال</th>' +
            '<th>حداقل</th>' +
            '<th>حداکثر</th>' +
            '<th>پریود تعویض</th>' +
            '<th>ملاحظات</th>' +
            '<th></th>' +
            '<th></th>' +
            '</tr>' +
            '</thead>';
        var row = '<tr>' +
            '<td style="display:none;">0</td>' +
            '<td style="display:none;">' + partData[0].PartId + '</td>' +
            '<td style="display:none;">' + $('#Drmeasurement').val() + '</td>' +
            '<td>' + partData[0].PartName + '</td>' +
            '<td>' + $('#Drmeasurement :selected').text() + '</td>'+ 
            '<td>' + $('#txtGhatatPerYear').val() + '</td>' +
            '<td>' + $('#txtGhatatMin').val() + '</td>' +
            '<td>' + $('#txtGhatatMax').val() + '</td>' +
            '<td>' + $('#txtGhatatChangePeriod').val() + '</td>' +
            '<td>' + $('#txtGhatatCom').val() + '</td>' +
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
        partData = [];
        ClearFields('pnlGhatatMasrafi');
        $('#txtPartsSearch').attr('placeholder', 'جستجو کنید ...');
        $('#txtPartsSearch').removeAttr('readonly');
        $('#PartBadgeArea').find('.PartsBadge').remove();
    }
}
function checkPartInputs() {
    var flag = 0;
    if ($('#txtGhatatChangePeriod').val() != '') {if (checkPastDate('txtGhatatChangePeriod') == false) { RedAlert('txtGhatatChangePeriod', "!!تاریخ انتخاب شده باید بزرگتر از  تاریخ امروز باشد"); flag = 1; }}
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
    var partname = $(this).parent().parent().find('td:eq(3)').text();
    createPartBadge(partname, partid);
    $('#Drmeasurement').val($(this).parent().parent().find('td:eq(2)').text());
    $('#txtPartsSearch').removeAttr('placeholder');
    $('#txtGhatatPerYear').val($(this).parent().parent().find('td:eq(5)').text());
    $('#txtGhatatMin').val($(this).parent().parent().find('td:eq(6)').text());
    $('#txtGhatatMax').val($(this).parent().parent().find('td:eq(7)').text());
    $('#txtGhatatChangePeriod').val($(this).parent().parent().find('td:eq(8)').text());
    $('#txtGhatatCom').val($(this).parent().parent().find('td:eq(9)').text());
    $('#btnEditPart').show();
    $('#btnCancelEditPart').show();
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
    var targetTrIndex = $(target_tr).index();
    var table = document.getElementById('gridGhataatMasrafi');
    for (var a = 0; a < rowsCount; a++) {
        if (targetTrIndex + 1 == a) {continue;}
        for (var b = 0; b < partData.length; b++) {
            if (table.rows[a].cells[1].innerHTML == partData[b].PartId) {
                $.notify("!!این مورد قبلا ثبت شده است", { globalPosition: 'top left' });
                return;
            }
        }
    }
    var flag = checkPartInputs();
    if (flag === 0 && partData.length === 1) {
        $(target_tr).find('td:eq(1)').text(partData[0].PartId);
        $(target_tr).find('td:eq(3)').text(partData[0].PartName);

        $(target_tr).find('td:eq(5)').text($('#txtGhatatPerYear').val());
        $(target_tr).find('td:eq(6)').text($('#txtGhatatMin').val());
        $(target_tr).find('td:eq(7)').text($('#txtGhatatMax').val());
        $(target_tr).find('td:eq(8)').text($('#txtGhatatChangePeriod').val());
        $(target_tr).find('td:eq(9)').text($('#txtGhatatCom').val());
        ClearFields('pnlGhatatMasrafi');
        $('#PartBadgeArea').find('div').remove();
        partData = [];
        $('#btnEditPart').hide();
        $('#btnCancelEditPart').hide();
        $('#txtPartsSearch').attr('placeholder', 'جستجو کنید ...');
        $('#txtPartsSearch').removeAttr('readonly');
        GreenAlert(target_tr,"✔قطعه ویرایش شد");
    }
}
function DeletePart() {
    $.ajax({
        type: "POST",
        url: "WebService.asmx/DeletePartItem",
        data: "{partId : " + partId + "}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function () {
            GreenAlert('nothing',"✔ قطعه با موفقیت حذف شد");
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
    //if (!$('#chkbargh').is(':checked') && !$('#chkgaz').is(':checked') && !$('#chkhava').is(':checked') && !$('#chksokht').is(':checked')) {
    //    $('#chkbargh').parent().addClass('checklabelError');
    //    $('#chkgaz').parent().addClass('checklabelError');
    //    $('#chkhava').parent().addClass('checklabelError');
    //    $('#chksokht').parent().addClass('checklabelError');
    //    $.notify("!!یکی از موارد را تکمیل نمایید", { globalPosition: 'top left' });
    //    setTimeout(function () {
    //        $('#chkbargh').parent().removeClass('checklabelError');
    //        $('#chkgaz').parent().removeClass('checklabelError');
    //        $('#chkhava').parent().removeClass('checklabelError');
    //        $('#chksokht').parent().removeClass('checklabelError');
    //    }, 4000);     
    //} else {
        $('#pnlMavaredMasrafi').hide();
        $('#pnlMavaredKey').fadeIn();
        $('#txtCommentKey').focus();
        $('[lblMCode]').text($('#txtmachineCode').val() + '___' + $('#txtmachineName').val());
    //}
});

$('#btnMavaredeKeyBack').on('click', function () {
    $('#pnlMavaredMasrafi').fadeIn();
    $('#pnlMavaredKey').hide();
});

$('#btnMavaredeKeyFor').on('click', function () {
    $('#pnlMavaredControli').fadeIn();
    $('#txtControliMoredControl').focus();
    $('#pnlMavaredKey').hide();
    $('[lblMCode]').text($('#txtmachineCode').val() + '___' + $('#txtmachineName').val());
});

$('#btnMavaredControlBack').on('click', function () {
    $('#pnlMavaredKey').fadeIn();
    $('#pnlMavaredControli').hide();
    $('#txtCommentKey').focus();
    $('[lblMCode]').text($('#txtmachineCode').val() + '___' + $('#txtmachineName').val());
});

$('#btnMavaredControlFor').on('click', function () {
        $('#pnlMavaredControli').hide();
        $('#pnlSubSytem').fadeIn();
        $('[lblMCode]').text($('#txtmachineCode').val() + '___' + $('#txtmachineName').val());
});

$('#btnSubsystemFor').on('click', function () {
    $('#pnlSubSytem').hide();
    $('#pnlGhatatMasrafi').fadeIn();
    $('[lblMCode]').text($('#txtmachineCode').val() + '___' + $('#txtmachineName').val());
});

$('#btnSubsystemBack').on('click', function () {
    $('#pnlSubSytem').hide();
    $('#pnlMavaredControli').fadeIn();
    $('#txtControliMoredControl').focus();
    $('[lblMCode]').text($('#txtmachineCode').val() + '___' + $('#txtmachineName').val());
});

$('#btnGhatatBack').on('click', function () {
    $('#pnlSubSytem').fadeIn();
    $('#pnlGhatatMasrafi').hide();
    $('[lblMCode]').text($('#txtmachineCode').val() + '___' + $('#txtmachineName').val());
});

$('#btnGhatatFor').on('click', function () {
        $('#pnlGhatatMasrafi').hide();
        $('#pnlDastoor').fadeIn();
        $('[lblMCode]').text($('#txtmachineCode').val() + '___' + $('#txtmachineName').val());
});

function checkModEnergy() {
    if ($('#txtDastoorTarikh').val() == '') {
        RedAlert('txtDastoorTarikh', "!!لطفا تاریخ مراجعه را وارد کنید");
    }
    if ($('#txtDastoorMachineType').val() == '') {
        RedAlert('txtDastoorMachineType', "!!لطفا نوع دستگاه را مشخص کنید");
    }
    if ($('#txtDastoorAmper1').val() == '') {
        RedAlert('txtDastoorAmper1', "!!لطفا آمپر فاز 1 را مشخص کنید");
    }
    if ($('#txtDastoorVP1').val() == '') {
        RedAlert('txtDastoorVP1', "!!لطفا ولتاژ فاز 1 را مشخص کنید");
    }
}
function insertEnergy() {
    if ($('#txtDastoorTarikh').val() == '' || $('#txtDastoorMachineType').val() == ''
        || $('#txtDastoorAmper1').val() == '' || $('#txtDastoorVP1').val() == '') {
        checkModEnergy();
    } else {
        createEnergyTable();
    }
}
$("#gridEnergy").on("click", "tr a", function () {
    var row = $('#gridEnergy tr').length;
    if (row == 2) {
        $("#gridEnergy thead").remove();
        $("#gridEnergy tbody").remove();
    } else {
        $(this).parent().parent().remove();
    }
});
function createEnergyTable() {
    var head = '<thead>' +
        '<tr>' +
        '<th>تاریخ مراجعه</th>' +
        '<th>نام دستگاه</th>' +
        '<th>آمپرفاز 1</th>' +
        '<th>آمپرفاز 2</th>' +
        '<th>آمپرفاز 3</th>' +
        '<th>ولتاژفاز 1</th>' +
        '<th>ولتاژفاز 2</th>' +
        '<th>ولتاژفاز 3</th>' +
        '<th>PF</th>' +
        '<th></th>' +
        '</tr>' +
        '</thead>';
    var body = '<tbody></tbody>';
    var row = '<tr>' +
        '<td>' + $('#txtDastoorTarikh').val() + '</td>' +
        '<td>' + $('#txtDastoorMachineType').val() + '</td>' +
        '<td>' + $('#txtDastoorAmper1').val() + '</td>' +
        '<td>' + $('#txtDastoorAmper2').val() + '</td>' +
        '<td>' + $('#txtDastoorAmper3').val() + '</td>' +
        '<td>' + $('#txtDastoorVP1').val() + '</td>' +
        '<td>' + $('#txtDastoorVP2').val() + '</td>' +
        '<td>' + $('#txtDastoorVP3').val() + '</td>' +
        '<td>' + $('#txtDastoorPF').val() + '</td>' +
        '<td><a>حذف</a></td>' +
        '</tr>';
    if ($('#gridEnergy tr').length != 0) {
        $("#gridEnergy tbody").append(row);
    } else {
        $("#gridEnergy").append(head);
        $("#gridEnergy").append(body);
        $("#gridEnergy tbody").append(row);
    }
    ClearFields('pnlModiriatEnergy');
}
$('#btnDastoorBack').on('click', function () {
    $('#pnlDastoor').hide();
    $('#pnlGhatatMasrafi').fadeIn();
    $('[lblMCode]').text($('#txtmachineCode').val() + '  ' + $('#txtmachineName').val());
});
$('#haveCatalog').change(function () {
    if (document.getElementById('haveCatalog').checked) {
        $('#pnlCatalog').show();
    }
});
$('#noCatalog').change(function () {
    if (document.getElementById('noCatalog').checked) {
        $('#pnlCatalog').hide();
        $('#file1').val('');
        $('#txtcatcode').val('');
        $('#txtcatname').val('');
    }
});
function SendTablesToDB() {
    $('#btnFinalSave').animate({ 'padding-left': '40px', 'padding-right': '10px' });
    $('#btnFinalLoading').fadeIn(20);
    var machinId;
    sendMinfo();
    function machinMainData() {
        var obj = {};
        obj.Name = $('#txtmachineName').val();
        obj.Code = $('#txtmachineCode').val();
        obj.Catalog = $(document).find('input[name=switch_1]:checked').attr('value');
        obj.CatName = $('#txtcatname').val();
        obj.CatCode = $('#txtcatcode').val();
        obj.Ahamiyat = $(document).find('input[name=switch_2]:checked').attr('value');
        obj.Creator = $('#txtMachineManufacturer').val();
        obj.InsDate = $('#txtMachineNasbDate').val();
        obj.Model = $('#txtMachineModel').val();
        obj.Tarikh = $('#txtmachineTarikh').val();
        obj.Location = $('#drMAchineLocateion :selected').val();
        obj.Line = $('#drLine :selected').val();
        obj.Faz = $('#drFaz :selected').val();
        obj.Power = $('#txtMachinePower').val();
        if ($('#txtstopperhour').val() == '') {obj.StopCostPerHour = 0;} else {obj.StopCostPerHour = $('#txtstopperhour').val();}
        obj.CatGroup = $('#drCatGroup :selected').val();
        obj.VaziatTajhiz = $(document).find('input[name=switch_21]:checked').attr('value');
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
            url: "WebService.asmx/MachineInfo",
            data: JSON.stringify({ 'mid': machineId,'minfo': machinMainData() }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (mid) {
                machinId = mid.d;
                sendMasrafi();
            },
            error: function () {
                RedAlert('n',"!!خطا در ثبت اطلاعات اولیه ماشین");
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
            url: "WebService.asmx/SendMasrafi",
            data: JSON.stringify({'mid': machinId, 'masrafiMain': masrafiDataMain()}),
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
        if (rowCount < 1) { sendControli(); return; }
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
            url: "WebService.asmx/SendKeyItems",
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
                Control: table.rows[i].cells[1].innerHTML,
                Time: table.rows[i].cells[2].innerHTML,
                Day: table.rows[i].cells[3].innerHTML,
                MDservice: table.rows[i].cells[4].innerHTML,
                Operation: table.rows[i].cells[5].innerHTML,
                PmDate: table.rows[i].cells[6].innerHTML,
                Comment: table.rows[i].cells[7].innerHTML,
                Bidcontrol: table.rows[i].cells[8].innerHTML
            });
        }
        $.ajax({
            type: "POST",
            url: "WebService.asmx/SendGridControli",
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
                SubSystemId: table.rows[i].cells[0].innerHTML,
                SubSystemCode: table.rows[i].cells[3].innerHTML
            });
        }
        $.ajax({
            type: "POST",
            url: "WebService.asmx/SendSubSystem",
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
                MeasurId: table.rows[i].cells[2].innerHTML,
                UsePerYear: table.rows[i].cells[5].innerHTML,
                Min: table.rows[i].cells[6].innerHTML,
                Max: table.rows[i].cells[7].innerHTML,
                ChangePeriod: table.rows[i].cells[8].innerHTML,
                Comment: table.rows[i].cells[9].innerHTML
            });
        }
        $.ajax({
            type: "POST",
            url: "WebService.asmx/SendGridGhataat",
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
        var table = document.getElementById("gridEnergy");
        var energyArr = [];
        for (var i = 1; i < table.rows.length; i++) {
            energyArr.push({
                Tarikh: table.rows[i].cells[0].innerHTML,
                MachineType: table.rows[i].cells[1].innerHTML,
                AP1: table.rows[i].cells[2].innerHTML,
                AP2: table.rows[i].cells[3].innerHTML,
                AP3: table.rows[i].cells[4].innerHTML,
                VP1: table.rows[i].cells[5].innerHTML,
                VP2: table.rows[i].cells[6].innerHTML,
                VP3: table.rows[i].cells[7].innerHTML,
                PF: table.rows[i].cells[8].innerHTML
            });
        }
        var dastoorText =  $('#txtInstruc').val();
        $.ajax({
            type: "POST",
            url: "WebService.asmx/SendInstru",
            data: JSON.stringify({ 'mid': machinId, 'instructions': energyArr, 'dastoor': dastoorText}),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function () {
                GreenAlert('no', "✔ دستورالعمل ماشین با موفقیت ثبت شد");
                GreenAlert('no', "✔ عملیات ثبت ماشین با موفقیت انجام شد");
                $('#btnFinalSave').animate({ 'padding-left': '15px', 'padding-right': '15px' });
                $('#btnFinalLoading').fadeOut(10);
                clearControls();
                return;
            }, error: function() {
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
            setTimeout(function () { window.location.replace("/editMachine.aspx"); }, 2000);
        }
    }
}


function Pageload() {
    FillPopUpToolsTable();
    GetMachineTooltipData();
    var mid = $('#Mid').val();
    if (mid !== '') {
        $('#loadingPage').show();
        $.ajax({
            type: "POST",
            url: "WebService.asmx/GetMachineTbl",
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
    var havecatalog = document.getElementById('haveCatalog');
    var gheyrkelidi = document.getElementById('gheyrkelidi');
    var deact = document.getElementById('deact');
    var fail = document.getElementById('fail');
    $('#txtmachineName').val(mInfo[0].Name);
    $('#txtmachineCode').val(mInfo[0].Code);
    $('#txtSubPelak').val(mInfo[0].Code+'-');
    $('#txtMachineManufacturer').val(mInfo[0].Creator);
    $('#txtMachineNasbDate').val(mInfo[0].InsDate);
    $('#txtMachineModel').val(mInfo[0].Model);
    $('#txtmachineTarikh').val(mInfo[0].Tarikh);
    $('#drLine').val(mInfo[0].Line);
    $('#drFaz').val(mInfo[0].Faz);
    $('#drMAchineLocateion').val(mInfo[0].Location);
    $('#txtMachinePower').val(mInfo[0].Power);
    $('#txtstopperhour').val(mInfo[0].StopCostPerHour);
    $('#drCatGroup').val(mInfo[0].CatGroup);
    $('#txttargetMTBF').val(mInfo[0].MtbfH);
    $('#txtAdmissionperiodMTBF').val(mInfo[0].MtbfD);
    $('#txttargetMTTR').val(mInfo[0].MttrH);
    $('#txtAdmissionperiodMTTR').val(mInfo[0].MttrD);
    $('#txtSelInfo').val(mInfo[0].SellInfo);
    $('#txtSupInfo').val(mInfo[0].SuppInfo);
    $('#txtCommentKey').val(mInfo[0].Keycomment);
    

    if (mInfo[0].Catalog == 1) {
        havecatalog.checked = true;
        $('#pnlCatalog').show();
        $('#txtcatname').val(mInfo[0].CatName);
        $('#txtcatcode').val(mInfo[0].CatCode);
    }
    if (mInfo[0].Ahamiyat == "False") { gheyrkelidi.checked = true;}
    if (mInfo[0].VaziatTajhiz == 2) { fail.checked = true; }
    if (mInfo[0].VaziatTajhiz == 0) { deact.checked = true; }
}
function getMasrafiData() {
    var Mid = $('#Mid').val();
    $.ajax({
        type: "POST",
        url: "WebService.asmx/GetMasrafiTbl",
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
        url: "WebService.asmx/GetKeyitems",
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
            GetC();
        }
    });
}
function GetC() {
    var Mid = $('#Mid').val();
    $.ajax({
        type: "POST",
        url: "WebService.asmx/GetC",
        data: "{ mid : " + Mid + "}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var controliData = JSON.parse(data.d);
            if (controliData.length > 0) {
                var tblHead = '<thead>' +
                    '<tr>' +
                    '<th>مورد کنترلی</th>' +
                    '<th>دوره تکرار</th>' +
                    '<th>روز پیش بینی شده</th>' +
                    '<th>نمایش برای سرویس کاری</th>' +
                    '<th>عملیات</th>' +
                    '<th>شروع سرویسکاری</th>' +
                    '<th>ملاحظات</th>' +
                    '<th></th>' +
                    '<th></th>' +
                    '</tr>' +
                    '</thead>';
                var tblBody = "<tbody></tbody>";
                $('#gridMavaredControli').append(tblHead);
                $('#gridMavaredControli').append(tblBody);
                var  period, rooz, mdSer ,mdserValue ,opr;
                for (var i = 0; i < controliData.length; i++) {
                    if (controliData[i].Time == '0') { period = "روزانه"; rooz = '----'}
                    if (controliData[i].Time == '6') {
                        period = "هفتگی";
                        if (controliData[i].Day == "0") { rooz = 'شنبه' }
                        if (controliData[i].Day == "1") { rooz = 'یکشنبه' }
                        if (controliData[i].Day == "2") { rooz = 'دوشنبه' }
                        if (controliData[i].Day == "3") { rooz = 'سه شنبه' }
                        if (controliData[i].Day == "4") { rooz = 'چهارشنبه' }
                        if (controliData[i].Day == "5") { rooz = 'پنجشنبه' }
                        if (controliData[i].Day == "6") { rooz = 'جمعه' }
                    }
                    if (controliData[i].Time == "1") { period = "ماهیانه"; rooz = controliData[i].Day;}
                    if (controliData[i].Time == "2") { period = "سه ماهه"; rooz = controliData[i].Day;}
                    if (controliData[i].Time == "3") { period = "شش ماهه"; rooz = controliData[i].Day;}
                    if (controliData[i].Time == "4") { period = "یکساله"; rooz = controliData[i].Day;}
                    if (controliData[i].Time == "5") {
                        period = "غیره";
                        rooz = 'هر ' + controliData[i].Day + ' روز';
                    }
                    if (controliData[i].Operation == 1) { opr = 'برق' }
                    if (controliData[i].Operation == 2) { opr = 'چک و بازدید' }
                    if (controliData[i].Operation == 3) { opr = 'روانکاری' }
                    if (controliData[i].MDservice == "1") { mdSer = "بله"; mdserValue = 1;}
                    if (controliData[i].MDservice == "0") { mdSer = "خیر"; mdserValue = 0;}
                    if (controliData[i].Comment == null) { controliData[i].Comment = " "; }
                    tblBody = '<tr>' +
                        '<td style="display:none;">' + controliData[i].Idcontrol + '</td>' +
                        '<td style="display:none;">' + controliData[i].Control + '</td>' +
                        '<td style="display:none;">' + controliData[i].Time + '</td>' +
                        '<td style="display:none;">' + controliData[i].Day + '</td>' +
                        '<td style="display:none;">' + mdserValue + '</td>' +
                        '<td style="display:none;">' + controliData[i].Operation + '</td>' +
                        '<td style="display:none;">' + controliData[i].PmDate + '</td>' +
                        '<td style="display:none;">' + controliData[i].Comment + '</td>' +
                        '<td style="display:none;">' + controliData[i].Bidcontrol + '</td>' +
                        '<td>' + controliData[i].Control + '</td>'
                        + '<td>' + period + '</td>'
                        + '<td>' + rooz + '</td>'
                        + '<td>' + mdSer + '</td>'
                        + '<td>' + opr + '</td>'
                        + '<td>' + controliData[i].PmDate + '</td>'
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
    var Mid = $('#Mid').val();
    $.ajax({
        type: "POST",
        url: "WebService.asmx/GetSubSystems",
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
                    '<th>شماره پلاک</th>' +
                    '<th></th>' +
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
                        '<td>' + subData[i].SubSystemCode + '</td>' +
                        '<td><a id="edit">ویرایش</a></td>' +
                      '<td><a id="delete">حذف</a></td>' +
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
    var Mid = $('#Mid').val();
    $.ajax({
        type: "POST",
        url: "WebService.asmx/GetG",
        data: "{ mid : " + Mid + "}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var partsData = JSON.parse(data.d);
            if (partsData.length > 0) {
                var tblHead = '<thead>' +
                    '<tr>' +
                    
                    '<th>نام قطعه</th>' +
                    '<th>واحد</th>'+
                    '<th>مصرف در سال</th>' +
                    '<th>حداقل</th>' +
                    '<th>حداکثر</th>' +
                    '<th>پریود تعویض</th>' +
                    '<th>ملاحظات</th>' +
                    '<th></th>' +
                    '<th></th>' +
                    '</tr>' +
                    '</thead>';
                var tblBody = "<tbody></tbody>";
                $('#gridGhataatMasrafi').append(tblHead);
                $('#gridGhataatMasrafi').append(tblBody);
                for (var i = 0; i < partsData.length ; i++) {
                    tblBody = '<tr>'
                        + '<td style="display: none;">' + partsData[i].Id + "</td>"
                        + '<td style="display: none;">' + partsData[i].PartId + "</td>"
                        + '<td style="display: none;">' + partsData[i].MeasurId + "</td>"
                        + "<td>" + partsData[i].PartName + "</td>"
                        + "<td>" + partsData[i].Measurement + "</td>"
                        + "<td>" + partsData[i].UsePerYear + "</td>"
                        + "<td>" + partsData[i].Min + "</td>"
                        + "<td>" + partsData[i].Max + "</td>"
                        + "<td>" + partsData[i].ChangePeriod + "</td>"
                        + "<td>" + partsData[i].Comment + "</td>"
                        + '<td><a id="editPart">ویرایش</a></td>' +
                        '<td><a id="deletePart">حذف</a></td></tr>';
                    $('#gridGhataatMasrafi tbody').append(tblBody);
                }
            }
            GetEnergy();
        }
    });
}
function GetEnergy() {
    var Mid = $('#Mid').val();
    $.ajax({
        type: "POST",
        url: "WebService.asmx/GetEnergy",
        data: "{ mid : " + Mid + "}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var energyData = JSON.parse(data.d);
            if (energyData[0].Dastoor !== null) {
                $('#txtInstruc').val(energyData[0].Dastoor);   
            }
            if (energyData.length > 1) {
                if (energyData[1].Tarikh != null) {
                    var tblHead = '<thead>' +
                        '<tr>' +
                        '<th>تاریخ مراجعه</th>' +
                        '<th>نوع دستگاه</th>' +
                        '<th>آمپرفاز 1</th>' +
                        '<th>آمپرفاز 2</th>' +
                        '<th>آمپرفاز 3</th>' +
                        '<th>ولتاژفاز 1</th>' +
                        '<th>ولتاژفاز 2</th>' +
                        '<th>ولتاژفاز 3</th>' +
                        '<th>PF</th>' +
                        '<th></th>' +
                        '</tr>' +
                        '</thead>';
                    var tblBody = "<tbody></tbody>";
                    $('#gridEnergy').append(tblHead);
                    $('#gridEnergy').append(tblBody);
                    for (var i = 1; i < energyData.length; i++) {
                        tblBody = '<tr>'
                            + "<td>" + energyData[i].Tarikh + "</td>"
                            + "<td>" + energyData[i].MachineType + "</td>"
                            + "<td>" + energyData[i].AP1 + "</td>"
                            + "<td>" + energyData[i].AP2 + "</td>"
                            + "<td>" + energyData[i].AP3 + "</td>"
                            + "<td>" + energyData[i].VP1 + "</td>"
                            + "<td>" + energyData[i].VP2 + "</td>"
                            + "<td>" + energyData[i].VP3 + "</td>"
                            + "<td>" + energyData[i].PF + "</td>"
                            + '<td><a>حذف</a></td></tr>';
                        $('#gridEnergy tbody').append(tblBody);
                    }
                } 
            }
            $('#loadingPage').hide();
        }
    });
}
