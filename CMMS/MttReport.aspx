<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="MttReport.aspx.cs" Inherits="CMMS.MttReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        table tr a {
            cursor: pointer;
        }
        label {
            margin-bottom: 0;
        }
    </style>
    <div class="card " style="text-align: center;">
        <div class="card-header bg-primary text-white">
            MTTR / MTBF گزارش
        </div>
    </div>

    <ul class="nav nav-tabs sans mt-1 rtl" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" id="Mtbf-tab" data-toggle="tab" href="#Mtbf" role="tab" aria-controls="home"
                aria-selected="true">گزارش فاصله بین خرابی ها</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="MttrPerRepiar-tab" data-toggle="tab" href="#MttrPerRepiar" role="tab" aria-controls="profile"
                aria-selected="false">گزارش مدت زمان تعمیر_بر مبنای تعمیر</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="MttrPerStop-tab" data-toggle="tab" href="#MttrPerStop" role="tab" aria-controls="profile"
                aria-selected="false">گزارش مدت زمان تعمیر_بر مبنای توقف</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="MttrReport-tab" data-toggle="tab" href="#MttrReport" role="tab" aria-controls="profile"
               aria-selected="false">مشاهده گزارشات و تحلیل ها</a>
        </li>
    </ul>

    <div class="tab-content">
        <div id="Mtbf" class="tab-pane fade show active">
            <div class="menubody">
                <div class="row ltr text-right" >
                    <div class="col-md-6">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtMtbfEndDate" />
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtMtbfStartDate" />
                    </div>

                </div>
                <div class="row text-right ltr mt-3">
                    <div class="col-md-4">
                        <label style="display: block;">: واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMTBFUnits" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code">
                            <asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="Sqlunit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: خط</label>
                        <asp:SqlDataSource ID="SqlFaz" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id,faz_name FROM i_faz"></asp:SqlDataSource>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMTBFLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id">
                            <asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="Sqlline" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id,line_name FROM i_lines"></asp:SqlDataSource>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: فاز</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMTBFfaz" CssClass="form-control" DataSourceID="SqlFaz" DataTextField="faz_name" DataValueField="id">
                            <asp:ListItem Value="-1">فاز را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="Mtbf();">MTBF_دریافت گزارش</button>
                </div>
                <div id="MtbfChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>
                <div>
                    <table id="gridMtbfReport" dir="rtl" class="table">
                    </table>
                </div>
                <br />
                <div id="MtbfReportArea"></div>
            </div>
        </div>
        <div id="MttrPerRepiar" class="tab-pane fade">
            <div class="menubody">
                <div class="row ltr text-right">
                    <div class="col-md-6">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtrepEndDate" />
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtrepStartDate" />
                    </div>
                </div>
                <div class="row ltr text-right mt-3">
                    <div class="col-md-4">
                        <label style="display: block;">: واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMttrPerRepiar" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code">
                            <asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>

                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: خط</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMTTRRLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id">
                            <asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>

                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: فاز</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMTTRRFaz" CssClass="form-control" DataSourceID="SqlFaz" DataTextField="faz_name" DataValueField="id">
                            <asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="MttrPerRepiar();">بر مبنای تعمیر  MTTR دریافت گزارش</button>
                </div>
                <div id="MttrPerRepiarChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>
                <div>
                    <table id="gridMttrRReport" dir="rtl" class="table">
                    </table>
                </div>
                <br />
                <div id="MttrPerRepiarReport"></div>
            </div>
        </div>

        <div id="MttrPerStop" class="tab-pane fade">
            <div class="menubody">
                <div class="row ltr text-right">
                    <div class="col-md-6">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtstopEndDate" />
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtstopStartDate" />
                    </div>
                </div>
                <div class="row ltr text-right mt-3">
                    <div class="col-md-4">
                        <label style="display: block;">: واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMttrPerStop" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code">
                            <asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>

                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: خط</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMTTRSLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id">
                            <asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: فاز</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMTTRSFaz" CssClass="form-control" DataSourceID="SqlFaz" DataTextField="faz_name" DataValueField="id">
                            <asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="MttrPerStop();">بر مبنای توقف  MTTR دریافت گزارش</button>
                </div>
                <div id="MttrPerstopChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>
                <div>
                    <table id="gridMttrSReport" dir="rtl" class="table">
                    </table>
                </div>
                <br />
                <div id="MttrPerStopReport"></div>
            </div>
        </div>
        <div id="MttrReport" class="tab-pane fade">
            <div class="menubody">
                <div class="row ltr text-right">
                    <div class="col-md-4">
                        <label style="display: block;">: تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtReportEndDate" />
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtReportStartDate" />
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;">: انتخاب نوع گزارش</label>
                        <select class="form-control" dir="rtl" id="drRepiarTime">
                            <option value="1">فاصله بین خرابی ها MTBF </option>
                            <option value="2">مدت زمان تعمیرات بر مبنای تعمیر MTTR</option>
                            <option value="3">مدت زمان تعمیرات بر مبنای توقف MTTR</option>
                        </select>
                    </div>
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" 
                            onclick="GetFilteredReportTable('txtReportStartDate','txtReportEndDate','drRepiarTime');">مشاهده گزارشات و تحلیل ها </button>
                </div>
                <div id="MttrReportGrid" style="width: 100%; height: 400px; margin: 10px auto; overflow: auto;">
                    <table class="table" dir="rtl" id="gridReports">
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="reportModal" class="modal fade" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="card sans" style="margin-bottom: 0;" id="modalBody">
                </div>
            </div>
        </div>
    </div>

    <div id="deletereportModal" class="modal fade" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm" role="document">
            <div class="modal-content">
                <div class="card">
                    <div class="card-header bg-warning text-white">حذف گزارش</div>
                    <div class="card-body text-center">
                        <label style="padding: 5px; display: block;">آیا مایل به حذف هستید؟</label>
                        <button class="button" type="button" onclick="$(this).parent().parent().parent().parent().hide();">خیر</button>
                        <button class="button" type="button" onclick="DeleteReport();">بله</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="assets/js/MttReport.js"></script>
</asp:Content>
