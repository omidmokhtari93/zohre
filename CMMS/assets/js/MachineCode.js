function GetMachineTooltipData() {
    $.ajax({
        type: "POST",
        url: "WebService.asmx/GetMachineTooltipData",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (e) {
            var unitHeader = '<tr><td colspan="4" style="background-color: darkblue; color: white;">لیست واحدها</td></tr>';
            var machineHeader = '<tr><td colspan="4" style="background-color: darkblue; color: white;">لیست دستگاه ها</td></tr>';
            var tr = '', td = '', k = 0, c = 0;
            var data = JSON.parse(e.d);
            var machineRows = Math.ceil(data.MachineData.length / 4);
            var unitRows = Math.ceil(data.UnitData.length / 4);
            $('#gridMachines').append(machineHeader);
            for (var i = 0; i < machineRows; i++) {
                tr = '<tr></tr>';
                td = '';
                for (var j = 0; j < 4; j++) {
                    if (k < data.MachineData.length) {
                        td += '<td style="cursor:pointer;">' +
                            '<i hidden>' + data.MachineData[k].MachineCode + '</i>' + data.MachineData[k].MachineName + '</td>';
                        k++;
                    } else {
                        break;
                    }
                }
                $('#gridMachines tbody').append(tr);
                $('#gridMachines  tbody tr:last-child').append(td);
            }
            $('#gridUnits').append(unitHeader);
            for (var a = 0; a < unitRows; a++) {
                tr = '<tr></tr>';
                td = '';
                for (var b = 0; b < 4; b++) {
                    if (c < data.UnitData.length) {
                        td += '<td style="cursor:pointer;">' +
                            '<i hidden>' + data.UnitData[c].UnitCode + '</i>' + data.UnitData[c].UnitName + '</td>';
                        c++;
                    } else {
                        break;
                    }
                }
                $('#gridUnits tbody').append(tr);
                $('#gridUnits  tbody tr:last-child').append(td);
            }
        },
        error: function () {
        }
    });
}
$('#btnVahed').on('click', function () {
    $('#vahedTooltip').css('visibility', 'visible');
    $('#vahedTooltip').css('opacity', '1');
});
$('#btnMachine').on('click', function () {
    $('#machineTooltip').css('visibility', 'visible');
    $('#machineTooltip').css('opacity', '1');
});
$(document).click(function (e) {
    if ($(e.target).closest('#vahed').length === 0) {
        $('#vahedTooltip').css('visibility', 'hidden');
        $('#vahedTooltip').css('opacity', '0');
    }
});
$(document).click(function (e) {
    if ($(e.target).closest('#machine').length === 0) {
        $('#machineTooltip').css('visibility', 'hidden');
        $('#machineTooltip').css('opacity', '0');
    }
});
$('#gridMachines').on("click", "td", function () {
    var tdData = $(this).find('i').text();
    if ($('#txtmachineCode').val() !== '' && $('#txtmachineCode').val().length == 2) {
        $('#txtmachineCode').val($('#txtmachineCode').val() + tdData);
        $.ajax({
            type: "POST",
            url: "WebService.asmx/GetLatestMachineCode",
            data: JSON.stringify({ 'machineCode': $('#txtmachineCode').val() }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (e) {
                var code = JSON.parse(e.d);
                if (code !== '') {
                    $('#txtmachineCode').val(code);
                    $('#txtSubPelak').val(code + '-');
                }
                $('#machineTooltip').css('visibility', 'hidden');
                $('#machineTooltip').css('opacity', '0');
            },
            error: function () {
            }
        });
    } else if ($('#txtmachineCode').val() === '') {
        $.notify("!!ابتدا نام واحد را انتخاب کنید", { globalPosition: 'top left' });
    }
});
$('#gridUnits').on("click", "td", function () {
    var tdData = $(this).find('i').text();
    $('#drMAchineLocateion').val(tdData);
    if ($('#txtmachineCode').val() === '') {
        $('#txtmachineCode').val(tdData);
        $('#vahedTooltip').css('visibility', 'hidden');
        $('#vahedTooltip').css('opacity', '0');
    }
});