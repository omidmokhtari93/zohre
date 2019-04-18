<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RequestPrint.aspx.cs" Inherits="CMMS.RequestPrint" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="Scripts/jquery-3.3.1.min.js"></script>
    <title>چاپ دستور کار</title>
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
        table{ width: 100%;direction: rtl;position: relative;font-family: myfont;margin-right: 0;padding: 0;border-collapse: collapse;}
        table tr{ position: relative;}
        table td{ border: 1px solid #625f5f;padding: 3px;position: relative !important;font-size: 10pt;}
        img{ width: auto;height: 60px;}
        .tbl1 {
            border-collapse: collapse;
        }
       .tbl1 tr:first-child td{
           text-align: right;
       }
       .tbl1 tr td p {
           margin: 5px 0;
       }
       .tbl1 tr td {
           padding: 2px 7px;
       }
        .tblparts tr td {
            text-align: center;
        }
        #bottomTables tr:first-child td{border-top: none;}
        .n-bordered tr:first-child td{border-top: none;}
        .n-bordered tr:last-child td{ border-bottom: 1px solid #625f5f;}
        .n-bordered tr td:first-child{border-left: none;}
        .n-bordered tr td:last-child{border-right: none;}
    </style>
</head>
<body>
<form id="form1" runat="server">
    <asp:HiddenField runat="server" ID="ReqId" ClientIDMode="Static"/>
<div style="padding: 5px 12px 5px 5px;width: 148mm; min-height: 210mm;" class="print">
        <table>
            <tr style="height: 100px; text-align: center;">
                <td style="width: 200px;">
                    <span style="position: absolute; top: 5px; right: 5px;">شماره سند :FO-PM-394</span>
                    <span style="position: absolute; top: 55px; right: 5px;">شماره بازنگری :00</span>
                </td>
                <td><h2 style="margin: 0;"> دستور کار نگهداری و تعمیرات </h2></td>
                <td style="width: 30%;"><img src="Images/zohre1.png" /></td>
            </tr>
        </table>
        <table class="tbl1">
            <tr style="height: 55px; text-align: center;">
                <td colspan="3" style="width:100%; height: 10px; text-align: center;vertical-align: top;">
                    <span>موضوع دستور کار</span> 
                </td>  
            </tr>
            <tr>
                <td >مورد تعمیر : <label id="lblMachineName"></label></td>
                <td >کد ماشین : <label id="lblRequestCode"></label></td>
                <td >تجهیز مورد تعمیر : <label id="lblSubName"></label></td>
            </tr>
            <tr style="height: 100px; height: 20px; text-align: center;">
                <td >تاریخ درخواست : <p id="lblRequestTime">&nbsp;</p></td>
                <td >واحد تعمیر  
                    <p>
                        <input type="checkbox"/> مکانیک
                        &nbsp;&nbsp;
                        <input type="checkbox"/> برق
                    </p>
                </td>
                <td >شماره درخواست : <p id="lblRequestNumber">&nbsp;</p></td>
            </tr>
        </table>
        <hr style="border-top: 1px dotted;"/>
        <table class="tbl1">
            <tr style="height: 55px; text-align: center;">
                <td colspan="3" style="width:100%; height: 10px; text-align: center;vertical-align: top;">
                    <span>موضوع دستور کار</span> 
                </td>  
            </tr>
            <tr>
                <td >مورد تعمیر : <label ></label></td>
                <td >کد ماشین : <label ></label></td>
                <td >تجهیز مورد تعمیر : <label ></label></td>
            </tr>
            <tr style="height: 100px; height: 20px; text-align: center;">
                <td >تاریخ درخواست : <p >&nbsp;</p></td>
                <td >واحد تعمیر  
                    <p>
                        <input type="checkbox"/> مکانیک
                        &nbsp;&nbsp;
                        <input type="checkbox"/> برق
                    </p>
                </td>
                <td >شماره درخواست : <p>&nbsp;</p></td>
            </tr>
            <tr>
                <td >تحویل گیرنده : <label ></label></td>
                <td >تاریخ تحویل : <label ></label></td>
                <td >ساعت تحویل : <label ></label></td>
            </tr>
            <tr>
                <td colspan="2">نوع توقف :
                    <input type="checkbox"/> برق
                    &nbsp;&nbsp;
                    <input type="checkbox"/> مکانیکی
                    &nbsp;&nbsp;
                    <input type="checkbox"/> تولید
                    &nbsp;&nbsp;
                    <input type="checkbox"/> در حال کار
                </td>
                <td colspan="1">مدت توقف : <label ></label></td>                    
            </tr>
        </table>
        <table>
            <tr>
                <td style="width: 70%; vertical-align: top;">
                    شرح اقدامات انجام شده :
                    <span style="position: absolute; left: 50px; bottom: 10px;">امضا مجری</span>
                </td>
                <td style="padding: 0; vertical-align: top; width: 30%;">
                    <table style="border: 0 !important;" class="tblparts">
                        <tr>
                            <td colspan="2">قطعات مصرفی</td>
                        </tr>
                        <tr>
                            <td>مشخصات</td>
                            <td>تعداد</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="width: 70%; padding: 0;">
                    <table class="tbl1">
                        <tr>
                            <td>تاریخ اقدام تعمیر :‌</td>
                            <td>تاریخ خاتمه ی تعمیر : </td>
                        </tr>
                    </table>
                </td>
                <td style="padding: 0;">
                    <table class="tbl1">
                        <tr>
                            <td>&nbsp;</td>
                            <td style="width: 50px;"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="padding: 0;" colspan="2">
                    <table class="tbl1">
                        <tr>
                            <td>تایید کننده ی واحد تولید :‌ </td>
                            <td>تاریخ تحویل : </td>
                            <td>ساعت تحویل :‌ </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="height: 80px; vertical-align: top;">توضیحات : 
                    <span style="position: absolute; left: 50px; bottom: 10px;">امضا و تایید واحد تولید</span>                    
                </td>
            </tr>
        </table>
    </div>
    <script>
        var requestId = 1027;
        if (requestId !== '') {
            $.ajax({
                type: "POST",
                url: "WebService.asmx/GetRequestDetails",
                data: "{reqId : " + requestId + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (e) {
                    var reqDetails = JSON.parse(e.d);
                    $('#lblRequestNumber').text(reqDetails[0].RequestNumber);
                    $('#lblRequestCode').text(reqDetails[0].MachineCode);
                    $('#lblRequestTime').text(reqDetails[0].Time);
                    $('#lblNameRequest').text(reqDetails[0].NameRequest);
                    $('#lblUnitRequest').text(reqDetails[0].UnitName);
                    $('#lblMachineName').text(reqDetails[0].MachineName);
                    $('#lblSubName').text(reqDetails[0].SubName);
                },
                error: function () {
                }
            });
            $.ajax({
                type: "POST",
                url: "WebService.asmx/ReplyDataFromDb",
                data: "{requestId : " + requestId + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (e) {
                    var data = JSON.parse(e.d);
                    $('#lblRepStartTimeDate').text(data.replyInfo.StartTime + ' _ ' + data.replyInfo.StartDate);
                    $('#lblRepEndTimeDate').text(data.replyInfo.EndTime + ' _ ' + data.replyInfo.EndDate);
                    $('#lblStopTime').text(data.replyInfo.StopTime);
                    $('#lblRepairTime').text(data.replyInfo.RepairTime);
                    $('#lblRavandTamir').text(data.replyInfo.StateName);
                    $('#lblRepairComment').text(data.replyInfo.Comment);
                    $('#lbleleTime').text(data.replyInfo.Electime);
                    $('#lblMechTime').text(data.replyInfo.Mechtime);
                    $('#FailArea').append('<table id="failTable" class="n-bordered"><tr><td colspan="5" style=" background: #d6d5d5; text-align: center;">دلایل خرابی</td></tr></table>');
                    for (var a = 0; a < data.failList.length; a++) {
                        $('#failTable').append('<tr><td colspan="5" style="text-align: center;">' + data.failList[a].FailReasonName + '</td></tr>');
                    }
                    $('#DelayArea').append('<table id="delayTable" class="n-bordered"><tr><td colspan="5" style=" background: #d6d5d5; text-align: center;">دلایل تاخیر</td></tr></table>');
                    for (var b = 0; b < data.delayList.length; b++) {
                        $('#delayTable').append('<tr><td colspan="5" style="text-align: center;">' + data.delayList[b].DelayReasonName + '</td></tr>');
                    }
                    $('#ActionArea').append('<table id="actionTable" class="n-bordered"><tr><td colspan="5" style=" background: #d6d5d5; text-align: center;">عملیات</td></tr></table>');
                    for (var c = 0; c < data.actionList.length; c++) {
                        $('#actionTable').append('<tr><td colspan="5" style="text-align: center;">' + data.actionList[c].ActionName + '</td></tr>');
                    }
                    $('#PartsArea').append('<table id="partTable" class="n-bordered">' +
                        '<tr>' +
                        '<td colspan="5" style=" background: #d6d5d5; text-align: center;">قطعات و لوازم مصرفی</td>' +
                        '</tr>' +
                        '<tr>' +
                        '<td  style=" background: #f3f3f3; text-align: center;">ردیف</td>' +
                        '<td  style=" background: #f3f3f3; text-align: center;">نام قطعه</td>' +
                        '<td  style=" background: #f3f3f3; text-align: center;">عملیات</td>' +
                        '<td colspan="2" style=" background: #f3f3f3; text-align: center;">تعداد</td>' +
                        '</tr>' +
                        '</table>');
                    for (var d = 0; d < data.partsList.length; d++) {

                        $('#partTable').append('<tr>' +
                            '<td  style="text-align: center;">' + parseInt(d + 1) + '</td>' +
                            '<td  style="text-align: center;">' + data.partsList[d].PartName + '</td>' +
                            '<td  style="text-align: center;">' + data.partsList[d].Rptooltip + '</td>' +
                            '<td colspan="2" style="text-align: center;">' + data.partsList[d].Count + ' ' + data.partsList[d].Measur + '</td>' +
                            '</tr>');
                    }

                    $('#PartChangeArea').append('<table id="PartChangeTable" class="n-bordered">' +
                        '<tr>' +
                        '<td colspan="5" style=" background: #d6d5d5; text-align: center;">قطعات یدکی / تعویضی</td>' +
                        '</tr>' +
                        '<tr>' +
                        '<td  style=" background: #f3f3f3; text-align: center;">ردیف</td>' +
                        '<td  style=" background: #f3f3f3; text-align: center;">نام ماشین</td>' +
                        '<td  style=" background: #f3f3f3; text-align: center;">نام تجهیز</td>' +
                        '<td  style=" background: #f3f3f3; text-align: center;">نام قطعه</td>' +
                        '</tr>' +
                        '</table>');
                    for (var h = 0; h < data.changedParts.length; h++) {

                        $('#PartChangeTable').append('<tr>' +
                            '<td  style="text-align: center;">' + parseInt(h + 1) + '</td>' +
                            '<td  style="text-align: center;">' + data.changedParts[h].MachineName + '</td>' +
                            '<td  style="text-align: center;">' + data.changedParts[h].SubName + '</td>' +
                            '<td  style="text-align: center;">' + data.changedParts[h].PartName + '</td>' +
                            '</tr>');
                    }

                    $('#PersonelArea').append('<table id="personelTable" class="n-bordered">' +
                        '<tr>' +
                        '<td colspan="5" style=" background: #d6d5d5; text-align: center;">پرسنل تعمیرکار</td>' +
                        '</tr>' +
                        '<tr>' +
                        '<td  style=" background: #f3f3f3; text-align: center;">ردیف</td>' +
                        '<td  style=" background: #f3f3f3; text-align: center;">نام</td>' +
                        '<td colspan="2" style=" background: #f3f3f3; text-align: center;">ساعت کارکرد</td>' +
                        '</tr>' +
                        '</table>');
                    for (var f = 0; f < data.personelList.length; f++) {
                        $('#personelTable').append('<tr>' +
                            '<td  style="text-align: center;">' + parseInt(f + 1) + '</td>' +
                            '<td  style="text-align: center;">' + data.personelList[f].PersonelName + '</td>' +
                            '<td colspan="2" style="text-align: center;">' + data.personelList[f].RepairTime + '</td>' +
                            '</tr>');
                    }
                    $('#ContArea').append('<table id="contTable" class="n-bordered">' +
                        '<tr>' +
                        '<td colspan="5" style=" background: #d6d5d5; text-align: center;">پیمانکاران</td>' +
                        '</tr>' +
                        '<tr>' +
                        '<td  style=" background: #f3f3f3; text-align: center;">ردیف</td>' +
                        '<td  style=" background: #f3f3f3; text-align: center;">نام پیمانکار</td>' +
                        '<td colspan="2" style=" background: #f3f3f3; text-align: center;">هزینه</td>' +
                        '</tr>' +
                        '</table>');
                    for (var g = 0; g < data.contractorList.length; g++) {
                        $('#contTable').append('<tr>' +
                            '<td  style="text-align: center;">' + parseInt(g + 1) + '</td>' +
                            '<td style="text-align: center;">' + data.contractorList[g].ContractorName + '</td>' +
                            '<td colspan="2" style="text-align: center;">' + data.contractorList[g].Cost + '</td>' +
                            '</tr>');
                    }
                },
                error: function () {
                }
            });
        }
    </script>
</form>
</body>
</html>