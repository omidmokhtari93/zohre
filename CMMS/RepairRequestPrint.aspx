<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RepairRequestPrint.aspx.cs" Inherits="CMMS.RepairRequestPrint" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="assets/js/jquery-3.3.1.min.js"></script>
    <script src="assets/js/script.js"></script>
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
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="RequestId"/>
            <div style="border: 1px solid #625f5f; padding-bottom: 2px; min-height: 210mm; position: relative;">
                <table>
                    <tr style="height: 100px; text-align: center;">
                        <td><img src="assets/Images/zohre1.png" /></td>
                        <td colspan="2"><h2 style="margin: 0;">درخواست تعمیر</h2></td>
                        <td style="width: 200px;">
                            <span style="position: absolute; top: 5px; right: 5px;">زمان درخواست :</span>
                            <label id="lblRequestTime" style="position: absolute; top: 30px; left: 15px;"></label>
                            <span style="position: absolute; top: 55px; right: 5px;">شماره درخواست :</span>
                            <label id="lblRequestNumber" style="position: absolute; top: 75px; left: 15px;"></label>
                        </td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td colspan="2">نام درخواست کننده : <label id="txtRequester"></label></td>
                        <td colspan="3">واحد درخواست کننده : <label id="txtUnit"></label></td>
                    </tr>
                    <tr>
                        <td >مورد تعمیر : <label id="txtMachine"></label></td>
                        <td >به شماره فنی : <label id="txtCode"></label></td>
                        <td colspan="3">تجهیز : <label id="txtSub"></label></td>
                    </tr>
                    <tr>
                        <td colspan="2">نوع خرابی : <label id="txtFailType"></label></td>
                        <td colspan="3">نوع درخواست : <label id="txtReqType"></label></td>
                    </tr>
                    <tr>
                        <td colspan="5">توضیحات : <p id="txtComment" style="margin:5px 0"></p></td>
                    </tr>
                </table>
            </div>
        </div>
        <script>
            $(document).ready(function() {
                var ajaxParams = [];
                ajaxParams.push({
                    url: 'WebService.asmx/GetRequestDetails',
                    parameters: [{ reqId:$('#RequestId').val()}],
                    func : FillRepairPrintForm
                });
                AjaxCall(ajaxParams);
            });
            function FillRepairPrintForm(e) {
                var data = JSON.parse(e.d);
                $('#lblRequestNumber').text(data[0].RequestNumber);
                $('#txtMachine').text(data[0].MachineName);
                $('#txtCode').text(data[0].MachineCode);
                $('#lblRequestTime').text(data[0].Time);
                $('#txtRequester').text(data[0].NameRequest);
                $('#txtUnit').text(data[0].UnitName);
                $('#txtSub').text(data[0].SubName);
                $('#txtFailType').text(data[0].FailType);
                $('#txtReqType').text(data[0].RequestType);
                $('#txtComment').text(data[0].Comment);
            }
        </script>
    </form>
</body>
</html>
