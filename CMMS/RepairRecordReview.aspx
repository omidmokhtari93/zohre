<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RepairRecordReview.aspx.cs" Inherits="CMMS.RepairRecordReview" %>

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
        table{ width: 100%;direction: rtl;position: relative;font-family: sans;margin-right: 0;padding: 0;border-collapse: collapse;}
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
            direction: rtl;
        }
        #gridtools tr td{ text-align: center;}
        #gridtools tr th{ font-size: 12pt;background-color: #f2f2f2;}
        #gridRepairers tr td{ text-align: center;}
        #gridRepairers tr th{ font-size: 12pt;background-color: #f2f2f2;}
        #gridContractors tr td{ text-align: center;}
        #gridContractors tr th{ font-size: 12pt;background-color: #f2f2f2;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="padding: 5px 12px 5px 5px;width: 148mm; min-height: 210mm;" class="print">
            <div style="min-height: 210mm; position: relative;">
                <table>
                    <tr style="height: 100px; text-align: center;">
                        <td><img src="assets/Images/zohre1.png" /></td>
                        <td colspan="2"><h2 style="margin: 0;">سابقه تعمیر قطعه</h2></td>
                        <td style="width: 150px;">
                            <span style="position: absolute; top: 5px; right: 5px;">تاریخ تعمیر :</span>
                            <label id="lblRepairDate" runat="server" style="position: absolute; top: 30px; left: 15px;"></label>
                            <span style="position: absolute; top: 55px; right: 5px;">شماره تعمیر / تعویض :</span>
                            <label id="lblRepNumber" runat="server" style="position: absolute; top: 75px; left: 15px;"></label>
                        </td>
                    </tr>
                </table>
                <table id="information">
                    <tr>
                        <td>مورد تعمیر : <label runat="server" id="lblToolName"></label></td>
                        <td>شماره پلاک : <label runat="server" id="lblTagNumber"></label></td>
                    </tr>
                    <tr>
                        <td colspan="5">
                            تعمیر
                            <input type="checkbox" runat="server" id="chkrepiar"/>&nbsp;&nbsp;
                            تعویض
                            <input type="checkbox" id="chkchange" runat="server"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="5">
                            <p style="margin: 0;">شرح تعمیر :</p>
                            <p style="margin: 0;"><label id="repairExplain" runat="server"></label></p>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="5">
                            <p style="margin: 0;">توضیحات :</p>
                            <p style="margin: 0;"><label id="lblComment" runat="server"></label></p>
                        </td>
                    </tr>
                    <tr>
                        <td>واحد استفاده قبلی : <label runat="server" id="runit"></label></td>
                        <td>خط استفاده قبلی : <label runat="server" id="rline"></label></td>
                    </tr>
                    <tr>
                        <td>واحد استفاده جدید : <label runat="server" id="nunit"></label></td>
                        <td>خط استفاده جدید : <label runat="server" id="nline"></label></td>
                    </tr>
                    <tr>
                        <td colspan="5" style=" background: #d6d5d5; text-align: center;">مواد و لوازم مصرفی</td>
                    </tr>
                    <tr>
                        <td colspan="5" style="padding: 0px;">
                            <asp:GridView runat="server" BorderWidth="0" ID="gridtools" AutoGenerateColumns="False" DataSourceID="Sqltools">
                                <Columns>
                                    <asp:BoundField DataField="rn" HeaderText="ردیف" SortExpression="rn" />
                                    <asp:BoundField DataField="PartName" HeaderText="نام قطعه" SortExpression="PartName" />
                                    <asp:BoundField DataField="count" HeaderText="تعداد" SortExpression="count" />
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="Sqltools" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT  ROW_NUMBER()over (order by s_subtools.id_reptag) as rn,
                                Part.PartName, cast([count] as nvarchar)+ ' ' +bornatek_cmms.dbo.i_measurement.measurement  as count FROM bornatek_cmms.dbo.s_subtools inner join bornatek_sgdb.inv.Part on s_subtools.tools_id = bornatek_sgdb.inv.Part.Serial
                                inner join i_measurement_part on i_measurement_part.Serial=s_subtools.tools_id inner join i_measurement on i_measurement.id=i_measurement_part.measurement where s_subtools.id_reptag = @subtagId

">
                                <SelectParameters>
                                    <asp:QueryStringParameter Name="subtagId" QueryStringField="subTagId" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="5" style=" background: #d6d5d5; text-align: center;">تعمیرکاران</td>
                    </tr>
                    <tr>
                        <td colspan="5" style="padding: 0;">
                           <asp:GridView runat="server" BorderWidth="0" ID="gridRepairers" AutoGenerateColumns="False" DataSourceID="SqlPersonel">
                               <Columns>
                                   <asp:BoundField DataField="rn" HeaderText="ردیف" ReadOnly="True" SortExpression="rn" />
                                   <asp:BoundField DataField="per_name" HeaderText="نام پرسنل" SortExpression="per_name" />
                                   <asp:BoundField DataField="per_id" HeaderText="شماره پرسنلی" SortExpression="per_id" />
                                   <asp:BoundField DataField="time_work" HeaderText="میزان ساعت کارکرد" SortExpression="time_work" />
                               </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="SqlPersonel" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT ROW_NUMBER()over(order by s_subpersonel.id_reptag)as rn, dbo.i_personel.per_name, dbo.i_personel.per_id, dbo.s_subpersonel.time_work
FROM dbo.s_subpersonel INNER JOIN
dbo.i_personel ON dbo.s_subpersonel.per_id = dbo.i_personel.id
where s_subpersonel.id_reptag = @subtagId">
                                <SelectParameters>
                                    <asp:QueryStringParameter Name="subtagId" QueryStringField="subtagId" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="5" style=" background: #d6d5d5; text-align: center;">پیمانکاران</td>
                    </tr>
                    <tr>
                        <td colspan="5" style="padding: 0;">
                            <asp:GridView runat="server" ID="gridContractors" BorderWidth="0" ClientIDMode="Static" AutoGenerateColumns="False" DataSourceID="Sqlcontractor">
                                <Columns>
                                    <asp:BoundField DataField="rn" HeaderText="ردیف" ReadOnly="True" SortExpression="rn" />
                                    <asp:BoundField DataField="name" HeaderText="پیمانکار" SortExpression="name" />
                                    <asp:BoundField DataField="cost" HeaderText="هزینه (ریال)" SortExpression="cost" />
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="Sqlcontractor" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT ROW_NUMBER()over(order by s_subcontract.id_reptag)as rn, dbo.i_contractor.name, dbo.s_subcontract.cost
FROM dbo.s_subcontract INNER JOIN
 dbo.i_contractor ON dbo.s_subcontract.contract_id = dbo.i_contractor.id
 where s_subcontract.id_reptag = @subtagId">
                                <SelectParameters>
                                    <asp:QueryStringParameter Name="subtagId" QueryStringField="subtagId" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <script>
            $(document).ready(function () {
                var contTable = document.getElementById('gridContractors');
                var total = 0;
                for (var i = 1; i < contTable.rows.length; i++) {
                    total += parseInt(contTable.rows[i].cells[2].innerHTML);
                }
                if ($(contTable).length > 0) {
                    var totalCost ='<tr style="text-align: left;"><td colspan= "4" style= "padding-left: 65px;">جمع کل : <label>'+total+'</label> ریال</td></tr>';
                    $('#information').append(totalCost);
                }
            });
        </script>
    </form>
</body>
</html>
