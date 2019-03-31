<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="Program.aspx.cs" Inherits="CMMS.Program" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .dr{border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800; height: 22px; padding: 1px;}
        .txt{border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800;}
        label{ margin: 0;}
    </style>
    <div class="panel panel-primary">
        <div class="panel-heading">برنامه نت پیشگیرانه</div>
        <div class="panel-body">
            <div class="row" style="margin: 0; border: 1px solid rgb(190, 190, 190);border-radius: 5px; background-color: #dfecfe;">
                <div class="col-lg-2" style="padding: 5px;">
                    <label style="display: block; text-align: right;"> : تا تاریخ</label>
                    <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                        <input id="txtEndDate" class="txt text-center" autocomplete="off"/>
                    </div>
                </div>
                <div class="col-lg-2" style="padding: 5px;">
                    <label style="display: block; text-align: right;"> : از تاریخ</label>
                    <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                      <input class="txt text-center" id="txtStartDate" autocomplete="off"/>
                    </div>
                </div>
                <div class="col-lg-2" style="padding: 5px;">
                    <label style="display: block; text-align: right;"> : عملیات</label>
                    <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                        <select class="form-control dr" id="drOpr">
                            <option value="1">برق</option>
                            <option value="2">چک و بازدید</option>
                            <option value="3">روانکاری</option>
                        </select>
                    </div>
                </div>
                <div class="col-lg-2" style="padding: 5px;">
                    <label style="display: block; text-align: right;"> : دوره</label>
                    <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                        <select class="form-control dr" id="drType">
                            <option value="0">روزانه</option>
                            <option value="1">هفتگی / متفرقه</option>
                            <option value="2">ماهیانه / سالیانه</option>
                        </select>
                    </div>
                </div>
                <div class="col-lg-2" style="padding: 5px;">
                    <label style="display: block; text-align: right;"> : نام ماشین</label>
                    <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                        <select class="form-control dr" id="drMachines"></select>
                    </div>
                </div>
                <div class="col-lg-2" style="padding: 5px;">
                    <label style="display: block; text-align: right;"> : نام واحد</label>
                    <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                        <asp:DropDownList runat="server" ID="drUnits" CssClass="form-control dr" ClientIDMode="Static" AppendDataBoundItems="True" 
                            DataSourceID="SqlUnits" DataTextField="unit_name" DataValueField="unit_code" >
                            <asp:ListItem Value="-1">انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                </div>
                <div style="padding: 10px;">
                <button type="button" class="btn btn-info" style="width: 100%; margin-top: 10px;" onclick="GetProgram();">دریافت برنامه</button>
                </div>
            </div>
            <%-- -------------   Report Area ---------------------  --%>
            <div id="pnlReportArea" style="display: none;">
                <div style="width: 100%; text-align: center;">
                    <a style="cursor: pointer; text-decoration: none;" onclick="printDiv();">
                        <span class="fa fa-print" style="vertical-align: middle;"></span> پرینت
                    </a>
                </div>
                <div id="ReportArea" style="margin-top: 15px; text-align: center;">
                    <style>
                        @font-face {
                            font-family: 'myfont';
                            src: url('/fonts/BYekan.eot'), 
                                 url('/fonts/BYekan.eot?#FooAnything') format('embedded-opentype');
                            src: local('☺'), url('/fonts/BYekan.woff') format('woff'), 
                                 url('/fonts/BYekan.ttf') format('truetype'),
                                 url('/fonts/BYekan.svg') format('svg');
                        }
                        .square {
                            height: 13px;
                            width: 13px;
                            border: 1px solid black;
                            vertical-align: middle;
                            display: inline-block;
                        }
                        table{ font-family: myfont;}
                        img{ width: auto;height: 60px;}
                        #tblcontrols td,#tbldates td ,#tblsubheader td{border: 1px solid #625f5f;padding: 3px;position: relative !important;font-size: 10pt;}
                        #tblcontrols,#tbldates ,#tblsubheader{width: 100%;direction: rtl;position: relative;margin-right: 0;padding: 0;border-collapse: collapse;}
                        #HeaderTable td *{font-family: myfont;}
                        #HeaderTable { width: 100%;direction: rtl;position: relative;margin-right: 0;padding: 0;border-collapse: collapse;}
                        #HeaderTable  tr{ position: relative;}
                        #HeaderTable  td{ border: 1px solid #625f5f;padding: 3px;position: relative !important;font-size: 10pt;}
                        #lblRequestTime{position: absolute; top: 30px; left: 15px;}
                        #lblRequestNumber{position: absolute; top: 75px; left: 15px;}
                        .spn1{position: absolute; top: 5px; right: 5px;}
                        .sDate{position: absolute; top: 25px; right: 80px;}
                        .eDate{position: absolute; top: 70px; right: 80px;}
                        .spn2{position: absolute; top: 55px; right: 5px;}
                        @media print 
                        {
                            body { -webkit-print-color-adjust: exact; }
                            #program{padding: 0;}
                        }
                        @page {
                            size: A4;
                            margin: 5mm 5mm 0mm 4mm;
                        }
                    </style>
                    <div style="width: 211mm; height: 300mm; margin: auto; border: 1px solid black;" id="program">
                        <table id="HeaderTable">
                            <tr style="height: 100px; text-align: center;">
                                <td><img src="Images/zohre1.png" /></td>
                                <td colspan="2">
                                    <h3 style="margin: 0;">برنامه نگهداری و تعمیر پیشگیرانه</h3>
                                    <h4 style="display: block;" id="lblUnitName"></h4>
                                </td>
                                <td style="width: 220px;">
                                    <span class="spn1">از تاریخ :</span>
                                    <label class="sDate" id="pStartDate"></label>
                                    <span class="spn2">تا تاریخ :</span>
                                    <label id="pEndDate" class="eDate"></label>
                                </td>
                            </tr>
                        </table>
                        <table id="tblsubheader">
                            <tbody></tbody>
                        </table>
                        <table id="tblcontrols">
                            <tbody></tbody>
                        </table>
                        <table id="tbldates">
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="Scripts/program.js"></script>
</asp:Content>
