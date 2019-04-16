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
            direction: rtl;
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
    <div style="padding: 5px 14px 0px 5px;width: 210mm; min-height: 297mm;" class="print">
        <table>
            <tr style="height: 100px; text-align: center;">
                <td style="width: 220px;">
                    <span style="position: absolute; top: 5px; right: 5px;">شماره سند :FO-PM-394</span>
                   
                    <span style="position: absolute; top: 55px; right: 5px;">شماره بازنگری :00</span>
                   
                </td>
                <td colspan="2"><h2 style="margin: 0;"> دستور کار نگهداری و تعمیرات </h2></td>
                <td><img src="Images/zohre1.png" /></td>
               
               </tr>
        </table>
       
        <table>
            <tr style="height: 100px; text-align: center;">
               
                  <td colspan="3" style="width:100%; height: 10px;text-align: center">
                      <span style="position: absolute; top: 5px">موضوع دستور کار</span> 
                  </td>  
                
            </tr>
            <tr style="height: 100px; text-align: center; height: 20px;">
                <td >مورد تعمیر : <label id="lblMachineName"></label></td>
                <td >کد ماشین : <label id="lblRequestCode"></label></td>
                <td >تجهیز مورد تعمیر : <label id="lblSubName"></label></td>
            </tr>
            <tr style="height: 100px; text-align: center; height: 20px;">
                
                <td >تاریخ درخواست : <label id="lblRequestTime"></label></td>
                <td >واحد تعمیر  <label ></label></td>
                <td >شماره درخواست : <label id="lblRequestNumber"></label></td>
            </tr>
        </table>
        <table>
            <tr>
                <td>نام درخواست کننده : <label id="lblNameRequest"></label></td>
                <td colspan="2">واحد : <label id="lblUnitRequest"></label></td>
            </tr>
            <tr>
               
            </tr>
            <tr>
                <td>زمان شروع تعمیر : <label id="lblRepStartTimeDate"></label></td>
                <td colspan="2">زمان پایان تعمیر : <label id="lblRepEndTimeDate"></label></td>
            </tr>
            <tr>
                <td>مدت زمان توقف : <label id="lblStopTime"></label></td>
                <td colspan="2">مدت زمان تعمیر : <label id="lblRepairTime"></label></td>
            </tr>
            <tr>
                <td>مدت زمان توقف الکتریکی : <label id="lbleleTime"></label> دقیقه</td>
                <td colspan="2">مدت زمان توقف مکانیکی : <label id="lblMechTime"></label> دقیقه</td>
            </tr>
            <tr>
                <td colspan="5">روند تعمیر در حالت : <label id="lblRavandTamir"></label></td>
            </tr>
            <tr>
                <td colspan="5">
                    <span style="position: absolute; top: 5px; right: 5px;">شرح تعمیر : </span>
                    <p style="margin: 0;margin-top:25px;" id="lblRepairComment" ></p>
                </td>
            </tr>
        </table>
        <table>
            <tr>
                <td style="padding:0;width:60%; vertical-align: top;" id="PartChangeArea"></td>
                <td id="PartsArea" colspan="3" style="padding:0; vertical-align: top;"></td>
            </tr>
            <tr>
                <td id="FailArea" style="padding: 0; vertical-align: top;"></td>
                <td id="DelayArea"style="padding: 0; vertical-align: top;"></td>
                <td id="ActionArea" style="padding: 0; vertical-align: top;"></td>
            </tr>
        </table>
        <table id="bottomTables">
            <tr>
                <td id="PersonelArea" style="padding: 0; vertical-align: top;"></td>
                <td id="ContArea" style="padding: 0; vertical-align: top;"></td>
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