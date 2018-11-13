<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="MachineReports.aspx.cs" Inherits="CMMS.MachineReports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .btns{width: 100%; font-weight: 500; margin-top: 10px; color: #323232;font-weight: 800;}
    </style>
    <div class="panel panel-primary" style="text-align: center;">
        <div class="panel-heading">
            گزارشات ماشین آلات
        </div>
    </div>
    <ul class="nav nav-tabs" style="padding: 0px 15px 0 15px; margin-top: 10px;">
        <li class="active"><a data-toggle="tab" href="#ActiveMachine">گزارش تجهیزات فعال</a></li>
        <li><a data-toggle="tab" href="#MachineTypes" onclick="machineTypes();">نوع ماشین آلات</a></li>
        <li><a data-toggle="tab" href="#machinelist">لیست دستگاه ها</a></li>
        <li><a data-toggle="tab" href="#subsystemlist">لیست تجهیزات</a></li>
        <li><a data-toggle="tab" href="#machineControls">لیست موارد کنترلی</a></li>
    </ul>
    <div class="tab-content">
        <div id="ActiveMachine" class="tab-pane fade in active">
            <div class="menubody">
                <select class="form-control" id="drCategory" dir="rtl">
                    <option value="-1">انتخاب کنید</option>
                    <option value="1">ماشین آلات تولید</option>
                    <option value="2">تاسیسات و برق</option>
                    <option value="3">ساختمان</option>
                    <option value="4">حمل و نقل</option>
                </select>
                <div id="ActiveMachineChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>  
            </div>
        </div>
        <div id="MachineTypes" class="tab-pane fade">
            <div class="menubody">
                <div id="MachineTypesChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>  
            </div>
        </div>
        <div id="machinelist" class="tab-pane fade">
            <div class="menubody">
                <asp:DropDownList dir="rtl" runat="server" ID="drmachineunits" CssClass="form-control" AppendDataBoundItems="True" ClientIDMode="Static" DataSourceID="Sqlunits" DataTextField="unit_name" DataValueField="unit_code">
                    <asp:ListItem Value="0">همه واحدها</asp:ListItem>
                </asp:DropDownList>
                <a class="btn btn-info btns" onclick="MachineReport();">مشاهده</a>
                <asp:SqlDataSource ID="Sqlunits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_code, unit_name FROM i_units"></asp:SqlDataSource>
                <div id="MachineListPrint">
                </div>
            </div>
        </div>
        <div id="subsystemlist" class="tab-pane fade">
            <div class="menubody">
                <asp:DropDownList dir="rtl" ID="drsubsystemunits" runat="server" CssClass="form-control" AppendDataBoundItems="True" ClientIDMode="Static" DataSourceID="Sqlunits" DataTextField="unit_name" DataValueField="unit_code">
                    <asp:ListItem Value="0">همه واحدها</asp:ListItem>
                </asp:DropDownList>
                <a class="btn btn-info btns" onclick="SubsystemReport();">مشاهده</a>
                <div id="SubsystemListPrint">
                </div>
            </div>
        </div>
        <div id="machineControls" class="tab-pane fade">
            <div class="menubody">
                <div class="row">
                    <div class="col-md-6">
                        <select id="drControliMachines" class="form-control" dir="rtl"></select>
                    </div>
                    <div class="col-md-6">
                        <asp:DropDownList dir="rtl" ID="drControliUnits" runat="server" CssClass="form-control" AppendDataBoundItems="True" ClientIDMode="Static" DataSourceID="Sqlunits" DataTextField="unit_name" DataValueField="unit_code">
                            <asp:ListItem Value="0">انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <a class="btn btn-info btns" onclick="MachineControliReport();">مشاهده</a>
                <div id="MachineControliPrint">
                </div>
            </div>
        </div>
    </div>
    <script src="Scripts/MachineRepor.js"></script>
    <script>
        $('#drControliUnits').change(function () {
            FilterMachineByUnit('drControliUnits', 'drControliMachines');    
        });

        function MachineControliReport() {
            if ($('#drControliUnits :selected').val() == '0') {
                RedAlert('drControliUnits', 'لطفا واحد را انتخاب نمایید');
                return;
            }
            if ($('#drControliMachines :selected').val() == '-1') {
                RedAlert('drControliMachines', 'لطفا دستگاه را انتخاب نمایید');
                return;
            }
            AjaxData({
                url: 'WebService.asmx/GetC',
                param: { mid: $('#drControliMachines :selected').val()},
                func:getControlimachineData
            });
            function getControlimachineData(r) {
                var controliData = JSON.parse(r.d);
                var mach = 'ماشین ' + $('#drControliMachines :selected').text();
                $.get("Content/A4.html", function (e) {
                    e = e.replace('#ReportArea#', 'MachineControlsPanel');
                    e = e.replace('printDiv', 'printDiv(2);');
                    e = e.replace('#RP#', 'لیست موارد کنترلی');
                    e = e.replace('#cnt#', 'machineControlsContent');
                    e = e.replace('#unit#', mach);
                    $('#MachineControliPrint').empty();
                    $('#MachineControliPrint').append(e);
                    createMachineControliReport();
                }, 'html');
                function createMachineControliReport() {
                    var body = [];
                    if (controliData.length > 0) {
                        body.push('<table>' +
                            '<tr>' +
                            '<th>ردیف</th>' +
                            '<th>مورد کنترلی</th>' +
                            '<th>دوره تکرار</th>' +
                            '<th>روز پیش بینی شده</th>' +
                            '<th>عملیات</th>' +
                            '</tr>' +
                            '</tr>');
                        var period, rooz, mdSer, mdserValue, opr;
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
                            if (controliData[i].Operation == 1) { opr = 'برق' }
                            if (controliData[i].Operation == 2) { opr = 'چک و بازدید' }
                            if (controliData[i].Operation == 3) { opr = 'روانکاری' }
                            if (controliData[i].Comment == null) { controliData[i].Comment = " "; }
                            body.push('<tr>' 
                                + '<td>' + (i+1) + '</td>'
                                + '<td>' + controliData[i].Control + '</td>'
                                + '<td>' + period + '</td>'
                                + '<td>' + rooz + '</td>'
                                + '<td>' + opr + '</td>'
                                + '</tr>');
                        }
                        body.push('</table>');
                        $('.sDate').text(JalaliDateTime);
                        $('#machineControlsContent').append(body.join(''));
                    }
                }
            }
        }
    </script>
</asp:Content>
