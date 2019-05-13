<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MttReportPrint.aspx.cs" Inherits="CMMS.MttReportPrint" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="assets/js/jquery-3.3.1.min.js"></script>
    <script src="assets/js/script.js"></script>
    <title></title>
    <style>
        @media print {
            .print {
                -webkit-print-color-adjust: exact;
            }
        }
        @font-face {
            font-family: 'sans';
            src: url('assets/fonts/sans/IRANSans.woff2')
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
        table{ width: 100%;direction: rtl;position: relative;font-family: sans;margin-right: 0;padding: 0;margin-bottom: -2px;}
        table tr{ position: relative;}
        table td{ border: 1px solid #625f5f;padding: 3px;position: relative !important;font-size: 10pt;}
        img{ width: auto;height: 60px;}
        .tbl th {
            text-align: center !important;
            border: 1px solid #625f5f;
        }
        .tbl {
            font-family: sans;
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
        <div style="padding: 5px 12px 5px 5px;width: 148mm; min-height: 210mm;" class="print">
            <div style="border: 1px solid #625f5f; padding-bottom: 2px; min-height: 210mm; position: relative;">
                <table>
                    <tr style="height: 100px; text-align: center;">
                        <td><img src="assets/Images/zohre1.png" /></td>
                        <td colspan="2"><h3 style="margin: 0;" id="reportName"></h3></td>
                        <td style="width: 150px;">
                            <span style="position: absolute; top: 5px; right: 5px;">تاریخ تهیه :</span>
                            <label id="lblDate"></label>
                        </td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td colspan="5">نام گزارش : <label id="name"></label></td>
                    </tr>
                    <tr>
                        <td colspan="3">نام تهیه کننده گزارش : <label id="producer"></label></td>
                        <td colspan="2">نام مدیر فرآیند : <label id="manager"></label></td>
                    </tr>
                    <tr>
                        <td colspan="5">شرح گزارش : <p id="exp" style="margin:5px"></p></td>
                    </tr>
                    <tr>
                        <td colspan="5">تحلیل گزارش : <p id="analyse" style="margin:5px"></p></td>
                    </tr>
                </table>
                <table style="position: absolute; bottom: 2px;">
                    <tr>
                        <td colspan="2" style="width: 50%;">
                            <p style="margin: 0;">نام و امضا تهیه کننده : </p>
                            <p>&nbsp;</p>
                        </td>
                        <td colspan="3">
                            <p style="margin: 0;">نام و امضا مدیر نت تجهیزات : </p>
                            <p>&nbsp;</p>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <script>
            $(function() {
                var vars = [], hash;
                var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                for (var i = 0; i < hashes.length; i++) {
                    hash = hashes[i].split('=');
                    vars.push(hash[0]);
                    vars[hash[0]] = hash[1];
                }
                var data = [];
                data.push({
                    url: 'WebService.asmx/GetMttPrintData',
                    parameters: [{ reportIdd: vars['repid']}],
                    func: getdata
                });
                AjaxCall(data);
                function getdata(e) {
                    var d = JSON.parse(e.d);
                    var type = d[0].Type;
                    switch (type) {
                        case 1:
                            $('#reportName').text('گزارش فاصله بین خرابی ها');
                            break;
                        case 2:
                            $('#reportName').text('گزارش مدت زمان تعمیر_بر مبنای تعمیر');
                            break;
                        case 3:
                            $('#reportName').text('گزارش مدت زمان تعمیر_بر مبنای توقف');
                            break;
                    }
                    $('#lblDate').text(d[0].Tarikh);
                    $('#name').text(d[0].ReportName);
                    $('#producer').text(d[0].Producer);
                    $('#manager').text(d[0].Manager);
                    $('#exp').text(d[0].Exp);
                    $('#analyse').text(d[0].Analyse);
                }
            });
        </script>
    </form>
</body>
</html>
