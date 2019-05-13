$('#partsearch').search({
    width: '50%',
    placeholder: 'جستجوی قطعه ...',
    url: 'WebService.asmx/PartsFilter',
    arg: 'partName',
    text: 'PartName',
    id: 'PartId',
    func: getMojoodi
});

function getMojoodi(id,text) {
    $('#partloading').show();
    AjaxData({
        url: 'WebService.asmx/MojoodiAnbar',
        param: { partid: id },
        func: mojoodiAnbar
    });
    function mojoodiAnbar(e) {
        var mojoodi = JSON.parse(e.d);
        $('#partname').text(mojoodi[0][0]);
        $('#partcode').text(mojoodi[0][1]);
        $('#partremain').text(mojoodi[0][2]);
        $('#partloading').hide();
    }
}

$('#drUnits').change(function () {
    FilterMachineByUnit('drUnits', 'drMachines');
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