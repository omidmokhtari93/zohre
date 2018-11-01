$('#drunitMachineCopy').change(function () {
    if ($('#drUnits :selected').val() === '-1') {
        $('#drMachinesCopy').empty();
    } else {
        var data = [];
        data.push({
            url: "WebService.asmx/FilterMachineOrderByLocation",
            parameters: [{ loc: $('#drunitMachineCopy :selected').val() }],
            func: createDrmachineCopy
        });
        AjaxCall(data);
        function createDrmachineCopy(e) {
            var data = JSON.parse(e.d);
            $('#drMachinesCopy').empty();
            $('#drMachinesCopy').append($("<option></option>").attr("value", -1).text('انتخاب کنید'));
            for (var i = 0; i < data.length; i++) {
                $('#drMachinesCopy').append($("<option></option>").attr("value", data[i].MachineId).text(data[i].MachineName));
            }
        }
    }
});

function CopyData() {
    var machineId = $('#drMachinesCopy :selected').val();
    var unit = $('#drunitMachineCopy :selected').val();
    if (unit == '-1') {
        RedAlert('drunitMachineCopy', 'لطفا واحد را مشخص نمایید');
        return;
    }
    if (machineId == '-1') {
        RedAlert('drMachinesCopy', 'لطفا دستگاه را مشخص نمایید');
        return;
    }
    var data = [];
    $('#copyModal').hide();
    $('#loadingPage').show();
    getMachineInfo();
    function getMachineInfo() {
        data.push({
            url: "WebService.asmx/GetMachineTbl",
            parameters: [{ mid: machineId }],
            func: copyMachineInfo
        });
        AjaxCall(data);
        function copyMachineInfo(e) {
            var mInfo = JSON.parse(e.d);
            //var havecatalog = document.getElementById('haveCatalog');
            var gheyrkelidi = document.getElementById('gheyrkelidi');
            var deact = document.getElementById('deact');
            var fail = document.getElementById('fail');
            $('#txtmachineName').val(mInfo[0].Name);
            //$('#txtmachineCode').val(mInfo[0].Code);
            $('#txtMachineManufacturer').val(mInfo[0].Creator);
            $('#txtMachineNasbDate').val(mInfo[0].InsDate);
            $('#txtMachineModel').val(mInfo[0].Model);
            $('#txtmachineTarikh').val(mInfo[0].Tarikh);
            $('#drLine').val(mInfo[0].Line);
            $('#drMAchineLocateion').val(mInfo[0].Location);
            $('#txtMachinePower').val(mInfo[0].Power);
            $('#drCatGroup').val(mInfo[0].CatGroup);
            $('#txttargetMTBF').val(mInfo[0].MtbfH);
            $('#txtAdmissionperiodMTBF').val(mInfo[0].MtbfD);
            $('#txttargetMTTR').val(mInfo[0].MttrH);
            $('#txtAdmissionperiodMTTR').val(mInfo[0].MttrD);
            $('#txtSelInfo').val(mInfo[0].SellInfo);
            $('#txtSupInfo').val(mInfo[0].SuppInfo);
            //if (mInfo[0].Catalog == 1) { havecatalog.checked = true; }
            if (mInfo[0].Ahamiyat == "False") { gheyrkelidi.checked = true; }
            if (mInfo[0].VaziatTajhiz == 2) { fail.checked = true; }
            if (mInfo[0].VaziatTajhiz == 0) { deact.checked = true; }
            getMachineMasrafi();
        }
    }

    function getMachineMasrafi() {
        data = [];
        data.push({
            url: "WebService.asmx/GetMasrafiTbl",
            parameters: [{ mid: machineId }],
            func: copyMasrafi
        });
        AjaxCall(data);
        function copyMasrafi(e) {
            var masrafiData = JSON.parse(e.d);
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
            getMachineControli();
        }
    }

    function getMachineControli() {
        data = [];
        data.push({
            url: "WebService.asmx/GetC",
            parameters: [{ mid: machineId }],
            func: copyControli
        });
        AjaxCall(data);
        function copyControli(e) {
            $('#gridMavaredControli').empty();
            var controliData = JSON.parse(e.d);
            if (controliData.length > 0) {
                var tblHead = '<thead><tr><th>مورد کنترلی</th><th>دوره تکرار</th>' +
                    '<th>روز پیش بینی شده</th><th>نمایش برای سرویس کاری</th>' +
                    '<th>شروع سرویسکاری</th><th>ملاحظات</th><th></th><th></th></tr></thead>';
                var tblBody = "<tbody></tbody>";
                $('#gridMavaredControli').append(tblHead);
                $('#gridMavaredControli').append(tblBody);
                var period, rooz, mdSer, mdserValue;
                for (var i = 0; i < controliData.length; i++) {
                    if (controliData[i].Time == '0') { period = "روزانه"; rooz = '----' }
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
                    if (controliData[i].Time == "1") { period = "ماهیانه"; rooz = controliData[i].Day; }
                    if (controliData[i].Time == "2") { period = "سه ماهه"; rooz = controliData[i].Day; }
                    if (controliData[i].Time == "3") { period = "شش ماهه"; rooz = controliData[i].Day; }
                    if (controliData[i].Time == "4") { period = "یکساله"; rooz = controliData[i].Day; }
                    if (controliData[i].Time == "5") {
                        period = "غیره";
                        rooz = 'هر ' + controliData[i].Day + ' روز';
                    }
                    if (controliData[i].MDservice == "1") { mdSer = "بله"; mdserValue = 1; }
                    if (controliData[i].MDservice == "0") { mdSer = "خیر"; mdserValue = 0; }
                    if (controliData[i].Comment == null) { controliData[i].Comment = " "; }
                    tblBody = '<tr>' +
                        '<td style="display:none;">0</td>' +
                        '<td style="display:none;">' + controliData[i].Control + '</td>' +
                        '<td style="display:none;">' + controliData[i].Time + '</td>' +
                        '<td style="display:none;">' + controliData[i].Day + '</td>' +
                        '<td style="display:none;">' + mdserValue + '</td>' +
                        '<td style="display:none;">' + controliData[i].PmDate + '</td>' +
                        '<td style="display:none;">' + controliData[i].Comment + '</td>' +
                        '<td>' + controliData[i].Control + '</td>'
                        + '<td>' + period + '</td>'
                        + '<td>' + rooz + '</td>'
                        + '<td>' + mdSer + '</td>'
                        + '<td>' + controliData[i].PmDate + '</td>'
                        + '<td>' + controliData[i].Comment + '</td>'
                        + '<td><a id="edit">ویرایش</a></td><td><a id="delete">حذف</a></td></tr>';
                    $('#gridMavaredControli tbody').append(tblBody);
                }
            }
            getMachineSubsystem();
        } 
    }

    function getMachineSubsystem() {
        data = [];
        data.push({
            url: "WebService.asmx/GetSubSystems",
            parameters: [{ mid: machineId }],
            func: copySubSystem
        });
        AjaxCall(data);
        function copySubSystem(e) {
            $('#subSystemTable').empty();
            var subData = JSON.parse(e.d);
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
            getMachineParts();
        }
    }

    function getMachineParts() {
        data = [];
        data.push({
            url: "WebService.asmx/GetG",
            parameters: [{ mid: machineId }],
            func: copyParts
        });
        AjaxCall(data);
        function copyParts(e) {
            $('#gridGhataatMasrafi').empty();
            var partsData = JSON.parse(e.d);
            if (partsData.length > 0) {
                var tblHead = '<thead><tr><th>نام قطعه</th><th>مصرف در سال</th>' +
                    '<th>حداقل</th><th>حداکثر</th><th>پریود تعویض</th><th>ملاحظات</th>' +
                    '<th></th><th></th></tr></thead>';
                var tblBody = "<tbody></tbody>";
                $('#gridGhataatMasrafi').append(tblHead);
                $('#gridGhataatMasrafi').append(tblBody);
                for (var i = 0; i < partsData.length; i++) {
                    tblBody = '<tr>' +
                        '<td style="display: none;">0</td>' +
                        '<td style="display: none;">' + partsData[i].PartId + '</td>'
                        + '<td>' + partsData[i].PartName + '</td>'
                        + '<td>' + partsData[i].UsePerYear + '</td>'
                        + '<td>' + partsData[i].Min + '</td>'
                        + '<td>' + partsData[i].Max + '</td>'
                        + '<td>' + partsData[i].ChangePeriod + '</td>'
                        + '<td>' + partsData[i].Comment + '</td>'
                        + '<td><a id="editPart">ویرایش</a></td>' +
                        '<td><a id="deletePart">حذف</a></td></tr>';
                    $('#gridGhataatMasrafi tbody').append(tblBody);
                }
            }
            $('#loadingPage').hide();
        } 
    }
}