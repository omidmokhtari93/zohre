<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="PartsReport.aspx.cs" Inherits="CMMS.PartsReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel panel-primary" style="text-align: center;">
        <div class="panel-heading">
            گزارش قطعات پر مصرف
        </div>
        <div class="panel-body">
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
       
    </script>
</asp:Content>
