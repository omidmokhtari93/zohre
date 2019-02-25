<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="PartsReport.aspx.cs" Inherits="CMMS.PartsReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<style>
    #partsLoading{width: 20px; height: 20px; position: absolute;top: 7px; left:7px; display: none;}
    #PartsSearchResulat {
        display: none;
        position: absolute;
        width: 872px;
        padding-left: 0px;
        z-index: 999;
        max-height: 200px;
        left: 15px;
    }
    #gridPart tr { cursor: pointer;}
    .lbl{display: block; text-align: right; direction: ltr;}
    label{ margin: 0;}
    .badgelbl{white-space: nowrap; background-color: lightblue;padding: 2px 5px;border-radius: 5px;}
    .partcheckRes{display: block; margin-top: 10px; padding: 10px; direction: rtl; background-color: aliceblue; vertical-align: middle;}
    #txtSubSearchPart{ width: 100%;outline: none;padding: 0px 3px 0 0;font-weight: 800;border: none;border-radius: 3px;}
    .imgfilter{ position: absolute;top: 7px;right: 6px;width: 17px;height: 17px;}
</style>
    <div class="panel panel-primary" style="text-align: center;">
        <div class="panel-heading">
            گزارش قطعات مصرفی
        </div>
    </div>
    <ul class="nav nav-tabs" style="padding: 0px 15px 0 15px; margin-top: 10px;">
        <li class="active"><a data-toggle="tab" href="#ConsumableParts">گزارش قطعات پر مصرف</a></li>
        <li ><a data-toggle="tab" href="#UseParts">گزارش قطعات مصرفی</a></li>
    </ul>
    <div class="tab-content">
        <div id="ConsumableParts" class="tab-pane fade in active">
            <div class="menubody">
            <div class="row" style="margin: 0; text-align: right; direction: ltr;">
               
                <div class="col-md-6">
                    <label style="display: block;"> : تا تاریخ</label>
                    <input class="form-control text-center" autocomplete="off" id="txtEndDate"/>
                </div>
                <div class="col-md-6">
                    <label style="display: block;"> : از تاریخ</label>
                    <input class="form-control text-center" autocomplete="off" id="txtStartDate"/>
                </div>
            </div>
            <div class="row" style="margin: 0; margin-top: 10px; text-align: right;direction: ltr" >
                <div class="col-md-4">
                    <label style="display: block;"> : تعداد نتایج</label>
                    <input class="form-control text-center" autocomplete="off" id="txtCount"/>
                </div>
                <div class="col-md-4">
                    <label style="display: block;"> : خط</label>
                   
                    <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drPartsLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                    <asp:SqlDataSource ID="Sqlline" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id,line_name FROM i_lines"></asp:SqlDataSource>
                </div>
                <div class="col-md-4">
                    <label style="display: block;"> : واحد</label>
                    <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drPartsUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                    <asp:SqlDataSource ID="Sqlunit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                </div>
            </div>
            <div style="padding: 15px;">
                <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreatePartsChart();">دریافت گزارش</button>
            </div>
            <div id="PartsChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>  
            <div>
                <table id="gridParts" dir="rtl" class="table">
                </table>
            </div>
        </div>
    </div>
    <div id="UseParts" class="tab-pane fade">
        <div class="menubody">
            <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                <div class="col-md-4">
                    <label>نام قطعه </label>
                    <div id="PartBadgeArea" style="position: relative;">
                        <input autocomplete="off" dir="rtl" class="form-control text-right" id="txtPartsSearch" placeholder="جستجوی قطعه ..."/>
                        <img src="Images/loading.png" id="partsLoading"/>
                    </div>
                    <div style="overflow: auto; width: 100%; max-height: 200px;">
                        <table id="gridPart" class="PartsTable">
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-4">
                    <label style="display: block;"> : تا تاریخ</label>
                    <input class="form-control text-center" autocomplete="off" id="txtPartEndDate"/>
                </div>
                <div class="col-md-4">
                    <label style="display: block;"> : از تاریخ</label>
                    <input class="form-control text-center" autocomplete="off" id="txtPartStartDate"/>
                </div>
            </div>
            <div style="padding: 15px;">
                <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreateTableTools();">دریافت گزارش</button>
            </div>
            <div style="display: block; text-align: center;">
                <a class="fa fa-print" onclick="SendParameterstoPrint()"></a>
            </div>
            <div id="ToolsTable" style=" margin: 10px auto;"></div>  
            <hr 5/>
            <table dir="rtl" id="gridReportTools" class="table">
                <tbody></tbody>
            </table>
        </div>
    </div>
</div>
<style>
    #nav{ text-align: center;}
    #nav a{ font-size: 12pt;font-weight: bolder;}
    #tblItems{ margin-bottom: 0;}
</style>
    <script>
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
            kamaDatepicker('txtStartDate', customOptions);
            kamaDatepicker('txtEndDate', customOptions);
            kamaDatepicker('txtPartStartDate', customOptions);
            kamaDatepicker('txtPartEndDate', customOptions);
        });
        $('#drPartsUnit').on('change', function () {
            if ($('#drPartsUnit :selected').val() !== '-1') {
                $('#drPartsLine').val('-1');
              
            }
        });  
        $('#drPartsLine').on('change', function () {
            if ($('#drPartsLine :selected').val() !== '-1') {
                $('#drPartsUnit').val('-1');
             
            }
        });  
      
        function CreatePartsChart() {
            var linee = $('#drPartsLine :selected').val();
            var unitt = $('#drPartsUnit :selected').val();
            var sDate = $('#txtStartDate').val();
            var eDate = $('#txtEndDate').val();
            if ($('#txtEndDate').val() == '' || $('#txtStartDate').val() == '' || $('#txtCount').val() == '') {
                RedAlert('no', '!!لطفا همه ی فیلدها را تکمیل کنید');
                return;
            }
           
            if (CheckPastTime(sDate ,'12:00',eDate,'12:00') === false) {
                RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
                return;
            }
            var obj = {
                url: 'MaxTools',
                data: [], 
                lblkind :'تعداد',
                element: 'PartsChart',
                header: 'قطعات پر مصرف',
                chartype: 'column'
            };
            obj.data.push({
                line: linee,
                unit:unitt,
                count: $('#txtCount').val(),
                dateS: $('#txtStartDate').val(),
                dateE: $('#txtEndDate').val()
            });
            GetChartData(obj);
        }
        function CreateTableForChart(data) {
           
            $('#gridParts').empty();
            if (data.Strings.length > 0) {
                    var body = [];
                    body.push('<tr><th>ردیف</th><th> نام قطعه</th><th>تعداد</th></tr>');
                    for (var i = 0; i < data.Strings.length; i++) {
                        body.push('<tr>' +
                            '<td>' + (i + 1) + '</td>' +
                            '<td>' + data.Strings[i] + '</td>' +
                            '<td>' + data.Integers[i] + '</td>' +
                            '</tr>');
                    }
                    $('#gridParts').append(body.join(''));
                }
        }
        //===========search Part ===========
        var nav;//page number
        var value;
        var rowss;
        var typingTimer;
        var doneTypingInterval = 2000;
        var $input = $('#txtPartsSearch');
        $input.on('keyup', function () {
            clearTimeout(typingTimer);
            typingTimer = setTimeout(doneTyping, doneTypingInterval);
            $('#partsLoading').show();
            $('#gridPart tbody').empty();
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
                var data = [];
                data.push({
                    url: 'WebService.asmx/PartsFilter',
                    parameters: [{ partName: $input.val() }],
                    func: createPartTable
                });
                AjaxCall(data);
                function createPartTable(e) {
                    var tableRows = '';
                    var filteredParts = JSON.parse(e.d);
                    for (var i = 0; i < filteredParts.length; i++) {
                        tableRows += '<tr><td partid="' + filteredParts[i].PartId + '">' + filteredParts[i].PartName + '</td></tr>';
                    }
                    $('#gridPart tbody').append(tableRows);
                    rowss = $('#gridPart tr').clone();
                    $('#gridPart').show();

                }
            }
            $('#partsLoading').hide();
            $('#PartsSearchResulat').show();
            
        }
        $('#txtSubSearchPart').keyup(function () {
            var val = $(this).val();
            $('#gridPart tbody').empty();
            rowss.filter(function (idx, el) {
                return val === '' || $(el).text().indexOf(val) >= 0;
            }).appendTo('#gridPart');
        });
        $('#gridPart').on('click', 'td', function () {
            var $text = this.innerText;
            value = $(this).attr('partid');
            $('#txtPartsSearch').val($text);
            $('#gridPart').hide();
        });
       //============Second Report==============
        function CreateTableTools() {

            var sDate = $('#txtPartStartDate').val();
            var eDate = $('#txtPartEndDate').val();
            if (sDate === '' || eDate === '' ) {
                RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
                return;
            }
            if ($('#txtPartsSearch').val() === '') {
                value = -1;
            }
            if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
                RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
                return;
            }

            var data = [];
            data.push({
                url: 'Reports.asmx/ToolsReport',
                parameters: [{ toolsId: value, dateS: sDate, dateE: eDate }],
                func: reportPartId
            });
            AjaxCall(data);

            function reportPartId(e) {
                $('#gridReportTools tbody').empty();
                var pc = JSON.parse(e.d);

                if (pc.length > 0) {
                    var body = [];

                    body.push(
                        '<tr><th>ردیف</th><th>واحد</th><th>ماشین</th><th>نام قطعه/کالا</th><th>تعداد مصرفی</th></tr>');
                    for (var i = 0; i < pc.length; i++) {
                        if (i % 15 === 0 && i !== 0) {
                            body.push('<tr><th>ردیف</th><th>واحد</th><th>ماشین</th><th>نام قطعه/کالا</th><th>تعداد مصرفی</th></tr>');
                        }
                        body.push('<tr>' + '<td>' + (i + 1) + '</td>' +
                                  '<td>' + pc[i][0] + '</td>' +
                                  '<td>' + pc[i][1] + '</td>' +
                                  '<td>' + pc[i][2] + '</td>' +
                            '<td>' + pc[i][3] + '  ' + pc[i][4] + '</td>' +
                                  '</tr>');
                    }

                    $('#gridReportTools tbody').append(body.join(''));
                }
                if (nav !== undefined) {
                    $('#nav').remove();
                }
                nav = $('<div id="nav"></div>');
                $('#gridReportTools').after(nav);
                var rowsShown = 16;
                var rowsTotal = $('#gridReportTools  tr').length;
                var numPages = rowsTotal / rowsShown;
                for (j = 0; j < numPages; j++) {
                    var pageNum = j + 1;
                    $('#nav').append('<a  href="#" rel="' + j + '">' + pageNum + '</a> ');
                }
                $('#gridReportTools  tr').hide();
                $('#gridReportTools  tr').slice(0, rowsShown).show();
                $('#nav a:first').addClass('active');
                $('#nav a').bind('click', function () {

                    $('#nav a').removeClass('active');
                    $(this).addClass('active');
                    var currPage = $(this).attr('rel');
                    var startItem = currPage * rowsShown;
                    var endItem = startItem + rowsShown;
                    $('#gridReportTools  tr').css('opacity', '0.0').hide().slice(startItem, endItem).
                        css('display', 'table-row').animate({ opacity: 1 }, 300);
                });

            }
           
        }
        //============Print Report =========
        function SendParameterstoPrint() {
            var sDate = $('#txtPartStartDate').val();
            var eDate = $('#txtPartEndDate').val();
            if (sDate == '' || eDate == '') {
                RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
                return;
            }
            if ($('#txtPartsSearch').val() === '') {
                value = -1;
            }
            if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
                RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
                return;
            }
            window.open('PartsReportPrint.aspx?part='+value+'&sdate='+sDate+'&edate='+eDate+'', '_blank');
        }

    </script>
</asp:Content>
