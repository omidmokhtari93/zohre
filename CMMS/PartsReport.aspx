<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="PartsReport.aspx.cs" Inherits="CMMS.PartsReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        #partsLoading {
            width: 20px;
            height: 20px;
            position: absolute;
            top: 7px;
            left: 7px;
            display: none;
        }

        #PartsSearchResulat {
            display: none;
            position: absolute;
            width: 872px;
            padding-left: 0px;
            z-index: 999;
            max-height: 200px;
            left: 15px;
        }

        #gridPart tr {
            cursor: pointer;
        }

        .lbl {
            display: block;
            text-align: right;
            direction: ltr;
        }

        label {
            margin: 0;
        }

        .badgelbl {
            white-space: nowrap;
            background-color: lightblue;
            padding: 2px 5px;
            border-radius: 5px;
        }

        .partcheckRes {
            display: block;
            margin-top: 10px;
            padding: 10px;
            direction: rtl;
            background-color: aliceblue;
            vertical-align: middle;
        }

        #txtSubSearchPart {
            width: 100%;
            outline: none;
            padding: 0px 3px 0 0;
            font-weight: 800;
            border: none;
            border-radius: 3px;
        }

        .imgfilter {
            position: absolute;
            top: 7px;
            right: 6px;
            width: 17px;
            height: 17px;
        }

        #nav {
            text-align: center;
        }

            #nav a {
                font-size: 12pt;
                font-weight: bolder;
            }

        #tblItems {
            margin-bottom: 0;
        }
    </style>
    <div class="card" style="text-align: center;">
        <div class="card-header text-white bg-primary">
            گزارش قطعات مصرفی
        </div>
    </div>

    <ul class="nav nav-tabs sans-small mt-1 rtl" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" id="Mtbf-tab" data-toggle="tab" href="#ConsumableParts" role="tab" aria-controls="home"
                aria-selected="true">گزارش قطعات پر مصرف</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="MttrPerRepiar-tab" data-toggle="tab" href="#UseParts" role="tab" aria-controls="profile"
                aria-selected="false">گزارش قطعات مصرفی</a>
        </li>
    </ul>

    <div class="tab-content">
        <div id="ConsumableParts" class="tab-pane fade show active">
            <div class="menubody">
                <div class="row ltr text-right">

                    <div class="col-md-6">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtEndDate" />
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtStartDate" />
                    </div>
                </div>
                <div class="row ltr text-right">
                    <div class="col-md-4">
                        <label style="display: block;">: تعداد نتایج</label>
                        <input class="form-control text-center" autocomplete="off" id="txtCount" />
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: خط</label>

                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drPartsLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id">
                            <asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="Sqlline" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id,line_name FROM i_lines"></asp:SqlDataSource>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drPartsUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code">
                            <asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="Sqlunit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreatePartsChart();">دریافت گزارش</button>
                </div>
                <div id="PartsChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>
                <div>
                    <table id="gridParts" dir="rtl" class="table">
                    </table>
                </div>
            </div>
        </div>
        <div id="UseParts" class="tab-pane fade">
            <div class="menubody">
                <div class="row  ltr text-right">
                    <div class="col-md-4">
                        <label>نام قطعه </label>
                        <div id="PartBadgeArea" style="position: relative;">
                            <input autocomplete="off" dir="rtl" class="form-control text-right" id="txtPartsSearch" placeholder="جستجوی قطعه ..." />
                            <img src="assets/Images/loading.png" id="partsLoading" />
                        </div>
                        <div style="overflow: auto; width: 100%; max-height: 200px;">
                            <table id="gridPart" class="PartsTable">
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtPartEndDate" />
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtPartStartDate" />
                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="CreateTableTools();">دریافت گزارش</button>
                </div>
                <div style="display: block; text-align: center;">
                    <a class="fa fa-print" onclick="SendParameterstoPrint()"></a>
                </div>
                <div id="ToolsTable" style="margin: 10px auto;"></div>
                <hr />
                <table dir="rtl" id="gridReportTools" class="table">
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="assets/js/PartsReports.js"></script>
</asp:Content>
