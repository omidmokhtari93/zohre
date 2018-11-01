<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DailyReportPrint.aspx.cs" Inherits="CMMS.DailyReportPrint" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="Scripts/jquery-3.3.1.min.js"></script>
    <title></title>
    <style>
        @media print {
            .print {
                -webkit-print-color-adjust: exact;
            }
        }
        @font-face {
            font-family: 'myfont';
            src: url('/fonts/BYekan.eot'), 
                 url('/fonts/BYekan.eot?#FooAnything') format('embedded-opentype');
            src: local('☺'), url('/fonts/BYekan.woff') format('woff'), 
                 url('/fonts/BYekan.ttf') format('truetype'),
                 url('/fonts/BYekan.svg') format('svg');
            font-weight: 800;
        }
        input{ margin: 0;padding: 0;vertical-align: middle;}
        .rightText{ position: absolute;right: -30px;}
        .rotate {
            -moz-transform: rotate(-90.0deg);
            -o-transform: rotate(-90.0deg);
            -webkit-transform: rotate(-90.0deg);
            -ms-filter: "progid:DXImageTransform.Microsoft.BasicImage(rotation=0.083)";
            transform: rotate(-90.0deg);
        }
        table{ width: 100%;direction: rtl;position: relative;font-family: myfont;margin-right: 0;padding: 0;margin-bottom: -2px;}
        table tr{ position: relative;}
        table td{ border: 1px solid #625f5f;padding: 3px;position: relative !important;font-size: 10pt;}
        img{ width: auto;height: 60px;}
        .tbl th {
            text-align: center !important;
            border: 1px solid #625f5f;
        }
        .tbl {
            font-family: myfont;
            text-align: center;
            font-size: 10pt;
            font-weight: 800;
            border: 1px solid black;
            overflow: hidden;
            margin-bottom: 0!important;
        }
        .tbl tr th { padding: 0 !important;}
        .tbl td {
            padding: 0 !important;
            vertical-align: middle !important;
            border: 1px solid #625f5f;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField runat="server" ClientIDMode="Static" ID="dailyId"/>
        <div style="padding: 5px 12px 5px 5px;width: 148mm; min-height: 210mm;" class="print">
            <div style="border: 1px solid #625f5f; padding-bottom: 2px; min-height: 210mm; position: relative;">
                <table>
                    <tr style="height: 100px; text-align: center;">
                        <td><img src="Images/zohre1.png" /></td>
                        <td colspan="2"><h2 style="margin: 0;">گزارش کار</h2></td>
                        <td style="width: 150px;">
                            <span style="position: absolute; top: 5px; right: 5px;">تاریخ :</span>
                            <label id="lblDate" runat="server"></label>
                        </td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td colspan="2">نام تهیه کننده : <label id="txtProducer"></label></td>
                        <td colspan="3">تاریخ تهیه گزارش : <label id="txtTarikh"></label></td>
                    </tr>
                    <tr>
                        <td colspan="5">شرح گزارش : <p id="txtReportExplain" style="margin:5px 0"></p></td>
                    </tr>
                    <tr>
                        <td colspan="5">نکات گزارش : <p id="txtReportTips" style="margin:5px 0"></p></td>
                    </tr>
                    <tr>
                        <td colspan="2">موضوع : <label id="txtSubject"></label></td>
                        <td colspan="3">تاریخ یادآوری : <label id="txtRemind"></label></td>
                    </tr>
                </table>
            </div>
        </div>
        <script>
            $(document).ready(function() {
                if ($('#dailyId').val() !== '') {
                    $.ajax({
                        type: "POST",
                        url: "WebService.asmx/GetDailyForPrint",
                        data: JSON.stringify({ 'id': $('#dailyId').val() }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (e) {
                            var data = JSON.parse(e.d);
                            $('#txtProducer').text(data[0].ReportProducer);
                            $('#txtTarikh').text(data[0].Date);
                            $('#txtReportExplain').text(data[0].ReportExplain);
                            $('#txtReportTips').text(data[0].ReportTips);
                            $('#txtSubject').text(data[0].Subject);
                            $('#txtRemind').text(data[0].RemindTime);
                        },
                        error: function () {
                           
                        }
                    });   
                }
            });
        </script>
    </form>
</body>
</html>
