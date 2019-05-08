<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="PersonelReport.aspx.cs" Inherits="CMMS.PersonelReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        label{ margin-bottom: 0;}
    </style>
    <div class="card" style="text-align: center;">
        <div class="card-header bg-primary text-white">
            گزارشات پرسنل
        </div>
    </div>

    <ul class="nav nav-tabs sans-small mt-1 rtl" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" id="Mtbf-tab" data-toggle="tab" href="#PersonelWorkTime" role="tab" aria-controls="home"
                aria-selected="true">میزان کارکرد پرسنل</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="MttrPerRepiar-tab" data-toggle="tab" href="#PersonelEmPmCmTime" role="tab" aria-controls="profile"
                aria-selected="false">گزارش نفر ساعت کارکرد</a>
        </li>
    </ul>

    <div class="tab-content">
        <div id="PersonelWorkTime" class="tab-pane fade show active">
            <div class="menubody">
                <div class="row ltr text-right">
                    <div class="col-md-4">
                        <label>: نیروی فنی</label>
                        <div class="switch-field">
                            <input type="radio" id="tasisat" name="switch_3" value="0" checked tabindex="3" />
                            <label for="tasisat">مکانیک</label>
                            <input type="radio" id="bargh" name="switch_3" value="1" tabindex="3" />
                            <label for="bargh">برق</label>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtPersonelEndDate" tabindex="2" />
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtPersonelStartDate" tabindex="1" />
                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreatePersonelWorkTimeChart();">دریافت گزارش</button>
                </div>
                <table dir="rtl" id="gridPersonelWorkTime" class="table">
                    <tbody></tbody>
                </table>
            </div>
        </div>
        <div id="PersonelEmPmCmTime" class="tab-pane fade ">
            <div class="menubody">
                <div class="row ltr text-right">

                    <div class="col-md-6">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtTimeEndDate" tabindex="2" />
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtTimeStartDate" tabindex="1" />
                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="EmPmTimeChart();">دریافت گزارش</button>
                </div>
                <div id="EmPmChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>
                <div>
                    <table id="gridEmPm" dir="rtl" class="table">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script>
        $(document).ready(function () {
            kamaDatepicker('txtPersonelEndDate', customOptions);
            kamaDatepicker('txtPersonelStartDate', customOptions);
            kamaDatepicker('txtTimeEndDate', customOptions);
            kamaDatepicker('txtTimeStartDate', customOptions);
        });

        function CreatePersonelWorkTimeChart() {

            var kindper = $('body').find('input[name=switch_3]:checked').attr('value');
            var sDate = $('#txtPersonelStartDate').val();
            var eDate = $('#txtPersonelEndDate').val();
            if ($('#txtPersonelEndDate').val() == '' || $('#txtPersonelStartDate').val() == '') {
                RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
                return;
            }
            if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
                RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
                return;
            }
            AjaxData({
                url: 'Reports.asmx/Personel',
                param: { kind: kindper, dateS: sDate, dateE: eDate },
                func: createPersonelWorkTimeTables
            });

            function createPersonelWorkTimeTables(e) {
                $('#gridPersonelWorkTime tbody').empty();
                var p = JSON.parse(e.d);
                var body = [];
                body.push('<tr><th>نام پرسنل</th><th>مدت زمان کارکرد</th></tr>');
                for (var i = 0; i < p.length; i++) {
                    body.push('<tr>' +
                        '<td>' + p[i][0] + '</td>' +
                        '<td>' + p[i][1] + '</td>' +
                        '</tr>');
                }
                $('#gridPersonelWorkTime tbody').append(body.join(''));
            }
        }
        function EmPmTimeChart() {

            var sDate = $('#txtTimeStartDate').val();
            var eDate = $('#txtTimeEndDate').val();

            if ($('#txtTimeEndDate').val() == '' || $('#txtTimeStartDate').val() == '') {
                RedAlert('no', '!!فیلدهای خالی را تکمیل کنید');
                return;
            }
            if (CheckPastTime(sDate, '12:00', eDate, '12:00') === false) {
                RedAlert('no', '!!تاریخ شروع باید کوچکتر از تاریخ پایان باشد');
                return;
            }
            GetChartData({
                lblkind: 'دقیقه',
                url: 'EmPmtimePersonel',
                param: {
                    dateS: sDate,
                    dateE: eDate
                },
                element: 'EmPmChart',
                header: 'نفر ساعت کارکرد ',
                chartype: 'column'
            });
        }
        function CreateTableForChart(data) {

            $('#gridEmPm').empty();
            if (data.Strings.length > 0) {
                var body = [];
                body.push('<tr><th>ردیف</th><th>نوع کارکرد</th><th>زمان به دقیقه</th></tr>');
                for (var i = 0; i < data.Strings.length; i++) {
                    body.push('<tr>' +
                        '<td>' + (i + 1) + '</td>' +
                        '<td>' + data.Strings[i] + '</td>' +
                        '<td>' + data.Integers[i] + '</td>' +

                        '</tr>');
                }
                $('#gridEmPm').append(body.join(''));
            }
        }
    </script>
</asp:Content>
