var rowss;
var typingTimer;
var doneTypingInterval = 2000;
var $input = $('#txtPartsSearch');
$input.on('keyup', function () {
    clearTimeout(typingTimer);
    typingTimer = setTimeout(doneTyping, doneTypingInterval);
    $('#partsLoading').show();
    $('#gridParts tbody').empty();
    if ($('#txtPartsSearch').val() === '') {
        $('#PartsSearchResulat').hide();
    }
});
$input.on('keydown', function () {
    clearTimeout(typingTimer);
});
function doneTyping() {
    if (($input).val().length <= 2 && ($input).val() != '') {
        $.notify("!!حداقل سه حرف از نام قطعه را وارد نمایید", { globalPosition: 'top left' });
    }
    if (($input).val().length > 2) {
        AjaxData({
            url: 'WebService.asmx/PartsFilter',
            param: { partName: $input.val() },
            func: createPartTable
        });
        function createPartTable(e) {
            var tableRows = '';
            var filteredParts = JSON.parse(e.d);
            for (var i = 0; i < filteredParts.length; i++) {
                tableRows += '<tr><td partid="' + filteredParts[i].PartId + '">' + filteredParts[i].PartName + '</td></tr>';
            }
            $('#gridParts tbody').append(tableRows);
            rowss = $('#gridParts tr').clone();
        }
    }
    $('#partsLoading').hide();
    $('#PartsSearchResulat').show();
    if ($('#txtPartsSearch').val() === '') {
        $('#PartsSearchResulat').hide();
    }
}

$('#drUnits').change(function () {
    FilterMachineByUnit('drUnits', 'drMachines');
});

$('#txtSubSearchPart').keyup(function () {
    var val = $(this).val();
    $('#gridParts tbody').empty();
    rowss.filter(function (idx, el) {
        return val === '' || $(el).text().indexOf(val) >= 0;
    }).appendTo('#gridParts');
});

$('#gridParts').on('click', 'tr', function () {
    $('#partloading').show();
    var $row = $(this).find("td");
    var pid = $row.attr('partid');
    $('#PartsSearchResulat').hide();
    $('#txtPartsSearch').val('');
    var data = [];
    data.push({
        url: 'WebService.asmx/MojoodiAnbar',
        parameters: [{ partid: pid }],
        func: mojoodiAnbar
    });
    AjaxCall(data);
    function mojoodiAnbar(e) {
        var mojoodi = JSON.parse(e.d);
        $('#partname').text(mojoodi[0][0]);
        $('#partcode').text(mojoodi[0][1]);
        $('#partremain').text(mojoodi[0][2]);
        $('#partloading').hide();
    }
});

function GetMachineParts() {
    $('#machinePartloading').show();
    AjaxData({
        url: 'WebService.asmx/MojoodiMachinePart',
        param: { machineid: $('#drMachines :selected').val() },
        func: mojoodiMachineAnbar
    });
    function mojoodiMachineAnbar(e) {
        $('#machinePartMojoodi tbody').empty();
        var mojoodi = JSON.parse(e.d);
        if (mojoodi.length > 0) {
            var body = [];
            body.push('<tr><th>ردیف</th><th>نام قطعه</th><th>کد قطعه</th><th>موجودی انبار</th></tr>');
            for (var i = 0; i < mojoodi.length; i++) {
                body.push('<tr>' +
                    '<td>' + parseInt(i + 1) + '</td>' +
                    '<td>' + mojoodi[i][0] + '</td>' +
                    '<td>' + mojoodi[i][1] + '</td>' +
                    '<td style="direction:ltr;">' + mojoodi[i][2] + '</td>' +
                    '</tr>');
            }
            $('#machinePartMojoodi tbody').append(body.join(''));
        }
        $('#machinePartloading').hide();
    }
}