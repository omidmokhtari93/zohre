var machineId, machineName, machineCode;
$(document).ready(function () {
    kamaDatepicker('txtDastoorTarikh', customOptions);
});

$("table").on("click", "tr a#energy", function () {
    machineId = $(this).closest('tr').find("input[type=hidden][id=machineId]").val();
    machineName = $(this).closest('tr').find('td:eq(1)').text();
    machineCode = $(this).closest('tr').find('td:eq(2)').text();
    $('#lblMachineInfo').text(machineName + ' به شماره فنی ' + machineCode);
    GetEnergy(machineId);
    $('#EnergyModal').modal('show');
});
$("#gridEnergy").on("click", "tr a", function () {
    var row = $('#gridEnergy tr').length;
    if (row == 2) {
        $("#gridEnergy thead").remove();
        $("#gridEnergy tbody").remove();
    } else {
        $(this).parent().parent().remove();
    }
});
function GetEnergy(mid) {
    $.ajax({
        type: "POST",
        url: "WebService.asmx/GetEnergy",
        data: "{ mid : " + mid + "}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            $("#gridEnergy tbody").remove();
            $("#gridEnergy thead").remove();
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
                            + '<td><a class="text-primary">حذف</a></td></tr>';
                        $('#gridEnergy tbody').append(tblBody);
                    }
                }
            }
        }
    });
}
function createEnergyTable() {
    var flag = 0;
    if ($('#txtDastoorTarikh').val() == '') {
        RedAlert('txtDastoorTarikh', "!!لطفا تاریخ مراجعه را وارد کنید");
        flag = 1;
    }
    if ($('#txtDastoorMachineType').val() == '') {
        RedAlert('txtDastoorMachineType', "!!لطفا نوع دستگاه را مشخص کنید");
        flag = 1;
    }
    if ($('#txtDastoorAmper1').val() == '') {
        RedAlert('txtDastoorAmper1', "!!لطفا آمپر فاز 1 را مشخص کنید");
        flag = 1;
    }
    if ($('#txtDastoorVP1').val() == '') {
        RedAlert('txtDastoorVP1', "!!لطفا ولتاژ فاز 1 را مشخص کنید");
        flag = 1;
    }
    if (flag === 0) {
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
            '<td><a class="text-primary">حذف</a></td>' +
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
    $.ajax({
        type: "POST",
        url: "WebService.asmx/SendInstru",
        data: JSON.stringify({ 'mid': machineId, 'instructions': energyArr, 'dastoor': '' }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function () {
            GreenAlert('no', "✔ موارد انرژی با موفقیت ثبت شد");
            setTimeout(function () { $('#EnergyModal').modal('hide'); $('#gridEnergy').empty(); }, 1000);

        }, error: function () {
            RedAlert('no', "!!خطا در ثبت موارد انرژی");
        }
    });
}

$("table").on("click", "tr a#RepiarRequest", function () {
    machineId = $(this).closest('tr').find("input[type=hidden][id=machineId]").val();
    machineName = $(this).closest('tr').find('td:eq(1)').text();
    machineCode = $(this).closest('tr').find('td:eq(2)').text();
    $('#lblRepairRequestMN').text(machineName + ' به شماره فنی ' + machineCode);
    AjaxData({
      url: 'WebService.asmx/GetRepairRequestTable',
      param: { machineId: machineId },
      func: CreateRepairRequestTable
    });
});

$("table").on("click", "tr a#RepairRecord", function () {
    machineId = $(this).closest('tr').find("input[type=hidden][id=machineId]").val();
    machineName = $(this).closest('tr').find('td:eq(1)').text();
    machineCode = $(this).closest('tr').find('td:eq(2)').text();
    $('#lblRepairRecordMN').text(machineName + ' به شماره فنی ' + machineCode);
    AjaxData({
      url: 'WebService.asmx/GetRepairRecordTable',
      param: { machineId: machineId },
      func: CreateRepairRecordTable,
    });
});

$("table").on("click", "tr a#print", function () {
    machineId = $(this).closest('tr').find("input[type=hidden][id=machineId]").val();
    window.open('MachinePrint.aspx?mid=' + machineId, '_blank');
});

function CreateRepairRequestTable(data) {
    var dataa = JSON.parse(data.d);
    $('#gridRepairRequest tbody').empty();
    if (dataa.length > 0) {
        var array = [];
        array.push('<tr><th>ردیف</th><th>نام واحد</th><th>نام درخواست کننده</th><th>کد ماشین</th>' +
            '<th>نوع درخواست</th><th>نوع خرابی</th><th>زمان درخواست</th><th></th></tr>');
        for (var i = 0; i < dataa.length; i++) {
            array.push('<tr>' +
                '<td style="display:none;">' + dataa[i].RequestId + '</td>' +
                '<td>' + parseInt(i + 1) + '</td>' +
                '<td>' + dataa[i].UnitName + '</td>' +
                '<td>' + dataa[i].Requester + '</td>' +
                '<td>' + dataa[i].Code + '</td>' +
                '<td>' + dataa[i].RequestType + '</td>' +
                '<td>' + dataa[i].FailType + '</td>' +
                '<td>' + dataa[i].Time + '</td>' +
                '<td><a id="ShowRepairRequest" class="text-primary">مشاهده</a></td>' +
                '</tr>');
        }
        $('#gridRepairRequest tbody').append(array.join(''));
    }
    $('#RepairRequestModal').modal('show');
}

function CreateRepairRecordTable(data) {
    var dataa = JSON.parse(data.d);
    $('#gridRepairRecord tbody').empty();
    if (dataa.length > 0) {
        var array = [];
        array.push('<tr><th>ردیف</th><th>نام دستگاه</th><th>کد دستگاه</th><th>تاریخ شروع تعمیر</th>' +
            '<th>مدت زمان توقف</th><th>مدت زمان تعمیر</th><th></th></tr>');
        for (var i = 0; i < dataa.length; i++) {
            array.push('<tr>' +
                '<td style="display:none;">' + dataa[i].RequestId + '</td>' +
                '<td>' + parseInt(i + 1) + '</td>' +
                '<td>' + dataa[i].MachineName + '</td>' +
                '<td>' + dataa[i].Code + '</td>' +
                '<td>' + dataa[i].RepairDate + '</td>' +
                '<td>' + dataa[i].StopTime + '</td>' +
                '<td>' + dataa[i].RepairTime + '</td>' +
                '<td><a id="ShowRepairRecord">مشاهده</a></td>' +
                '</tr>');
        }
        $('#gridRepairRecord tbody').append(array.join(''));
    }
    $('#RepairRecordModal').modal('show');
}

$("table").on("click", "tr a#ShowRepairRecord", function () {
    var requestId = $(this).closest('tr').find('td:eq(0)').text();  
    AjaxData({
      url: 'WebService.asmx/ToBase64String',
      param: { text: requestId },
      func: redirectToReplyPrint
    });
    function redirectToReplyPrint(param) {
        var code = param.d;
        window.open('ReplyPrint.aspx?reqid='+code, '_blank');
    }
});

$("table").on("click", "tr a#ShowRepairRequest", function () {
    var requestId = $(this).closest('tr').find('td:eq(0)').text();
    AjaxData({
      url: 'WebService.asmx/ToBase64String',
      param: { text: requestId },
      func: redirectToRepairRequestPrint
    });
    function redirectToRepairRequestPrint(param) {
        var code = param.d;
        window.open('RepairRequestPrint.aspx?reqid=' + code, '_blank');
    }
});