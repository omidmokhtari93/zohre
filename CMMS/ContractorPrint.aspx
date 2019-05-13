<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractorPrint.aspx.cs" Inherits="CMMS.ContractorPrint" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="assets/js/jquery-3.3.1.min.js"></script>
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
                        <td colspan="2"><h2 style="margin: 0;">پیمانکاران</h2></td>
                        <td style="width: 150px;">
                            <span style="position: absolute; top: 5px; right: 5px;">تاریخ :</span>
                            <label id="lblDate" runat="server"></label>
                        </td>
                    </tr>
                </table>
                <table>
                    <tr style="text-align: center;">
                        <td colspan="5" style=" background: #d6d5d5;">پیمانکاران</td>
                    </tr>
                    <tr>
                        <td colspan="5">نام : <label id="name"></label></td>
                    </tr>
                    <tr>
                        <td colspan="5">آدرس : <label id="address"></label></td>
                    </tr>
                    <tr>
                        <td colspan="2">تلفن ثابت : <label id="tell"></label></td>
                        <td colspan="2">همراه : <label id="mobile"></label></td>
                        <td>فکس : <label id="fax"></label></td>
                    </tr>
                    <tr>
                        <td colspan="5">ملاحظات : <p id="mem" style="margin:5px 0"></p></td>
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
            $(document).ready(function () {
                var vars = [], hash;
                var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                for (var i = 0; i < hashes.length; i++) {
                    hash = hashes[i].split('=');
                    vars.push(hash[0]);
                    vars[hash[0]] = hash[1];
                }
                var cid = vars.cid;
                if (cid != null) {
                    $.ajax({
                        type: "POST",
                        url: "WebService.asmx/ContratorInfo",
                        data: "{cid : " + cid + "}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (cInfo) {
                            var conInfo = JSON.parse(cInfo.d);
                            fillForm(conInfo);
                        },
                        error: function () {
                        }
                    });
                    function fillForm(conInfo) {
                        $('#name').text(conInfo[0].Name);
                        $('#address').text(conInfo[0].Address);
                        $('#tell').text(conInfo[0].Phone);
                        $('#mobile').text(conInfo[0].Mobile);
                        $('#fax').text(conInfo[0].Fax);
                        $('#mem').text(conInfo[0].Comment);
                    }
                }
            });
        </script>
    </form>
</body>
</html>
