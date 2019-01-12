<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UnitPrint.aspx.cs" Inherits="CMMS.UnitPrint" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>واحد های شرکت</title>
</head>
<body>
<form id="form1" runat="server">
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
            background-color: #ededed;
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
        #gridPersonel tr td:nth-child(2){ text-align: right;padding-right: 5px !important;}
    </style>
    <div style="padding: 5px 12px 5px 5px;width: 210mm; min-height: 297mm;" class="print">
        <div style="border: 1px solid #625f5f; padding-bottom: 2px; min-height: 297mm; position: relative;">
            <table>
                <tr style="height: 100px; text-align: center;">
                    <td><img src="Images/zohre1.png" /></td>
                    <td colspan="2"><h2 style="margin: 0;">لیست واحدها</h2></td>
                    <td style="width: 150px;">
                        <span style="position: absolute; top: 5px; right: 5px;">تاریخ :</span>
                        <label id="lbldate" runat="server"></label>
                    </td>
                </tr>
            </table>
            <table>
                <tr style="text-align: center;">
                    <td colspan="2" style=" background: #d6d5d5;">لیست بخش ها و واحد ها</td>
                </tr>
                <tr>
                    <td colspan="2" style="border: none; padding: 0;"> 
                        <asp:GridView runat="server" Width="100%" CssClass="tbl" ID="gridPersonel" ClientIDMode="Static" AutoGenerateColumns="False" DataSourceID="sqlunit">
                            <Columns>
                                <asp:BoundField DataField="rownum" HeaderText="ردیف" ReadOnly="True" SortExpression="rownum" />
                                <asp:BoundField DataField="unit_name" HeaderText="نام واحد" SortExpression="unit_name" />
                                <asp:BoundField DataField="unit_manager" HeaderText="مسئول واحد" SortExpression="unit_manager" />
                                <asp:BoundField DataField="unit_code" HeaderText="کد واحد" SortExpression="unit_code" />
                                
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="sqlunit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT ROW_NUMBER()over (order by unit_name) as rownum ,unit_name, unit_manager, unit_code FROM i_units"></asp:SqlDataSource>
                    </td>
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
</form>
</body>
</html>
