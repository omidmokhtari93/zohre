<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="PersonelReport.aspx.cs" Inherits="CMMS.PersonelReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel panel-primary" style="text-align: center;">
        <div class="panel-heading">
           گزارشات پرسنل
        </div>
    </div>
    <ul class="nav nav-tabs" style="padding: 0px 15px 0 15px; margin-top: 10px;">
        <li class="active"><a data-toggle="tab" href="#PersonelWorkTime">میزان کارکرد پرسنل</a></li>
    </ul>
    <div class="tab-content">
        <div id="PersonelWorkTime" class="tab-pane fade in active">
            <div class="menubody">
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-4">
                        <label>: نیروی فنی</label>
                        <div class="switch-field">
                            <input type="radio" id="tasisat" name="switch_3" value="0" checked TabIndex="3"/>
                            <label for="tasisat">مکانیک</label>
                            <input type="radio" id="bargh" name="switch_3" value="1" TabIndex="3" />
                            <label for="bargh">برق</label>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtPersonelEndDate" tabindex="2"/>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtPersonelStartDate" tabindex="1"/>
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
            kamaDatepicker('txtPersonelEndDate', customOptions);
            kamaDatepicker('txtPersonelStartDate', customOptions);
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
            var data = [];
            data.push({
                url: 'Reports.asmx/Personel',
                parameters: [{ kind:kindper,dateS: sDate, dateE: eDate }],
                func: createPersonelWorkTimeTables
            });
            AjaxCall(data);

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
    </script>
</asp:Content>
