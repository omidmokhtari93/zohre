<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="MttReport.aspx.cs" Inherits="CMMS.MttReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        table tr a { cursor: pointer;}
    </style>
    <div class="panel panel-primary" style="text-align: center;">
        <div class="panel-heading">
             MTTR / MTBF گزارش
        </div>
    </div>
    <ul class="nav nav-tabs" style="padding: 0px 15px 0 15px; margin-top: 10px;">
        <li class="active"><a data-toggle="tab" href="#Mtbf">گزارش فاصله بین خرابی ها</a></li>
        <li><a data-toggle="tab" href="#MttrPerRepiar">گزارش مدت زمان تعمیر_بر مبنای تعمیر</a></li>
        <li><a data-toggle="tab" href="#MttrPerStop">گزارش مدت زمان تعمیر_بر مبنای توقف</a></li>
        <li><a data-toggle="tab" href="#MttrReport">مشاهده گزارشات و تحلیل ها</a></li>
    </ul>
    <div class="tab-content">
    <div id="Mtbf" class="tab-pane fade in active">
        <div class="menubody">
            <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                <div class="col-md-3">
                    <label style="display: block;"> : خط</label>
                    
                    <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMTBFLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                    <asp:SqlDataSource ID="Sqlline" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id,line_name FROM i_lines"></asp:SqlDataSource>
                </div>
                <div class="col-md-3">
                    <label style="display: block;"> : واحد</label>
                    <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMTBFUnits" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                    <asp:SqlDataSource ID="Sqlunit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                </div>
                <div class="col-md-3">
                    <label style="display: block;"> : تا تاریخ</label>
                    <input class="form-control text-center" autocomplete="off" id="txtMtbfEndDate"/>
                </div>
                <div class="col-md-3">
                    <label style="display: block;"> : از تاریخ</label>
                    <input class="form-control text-center" autocomplete="off" id="txtMtbfStartDate"/>
                </div>
               
            </div>
            <div style="padding: 15px;">
                <button type="button" class="btn btn-info" style="width: 100%;" onclick="Mtbf();">MTBF_دریافت گزارش</button>
            </div>
            <a onclick="printDiv();" class="fa fa-print print" title="پرینت"></a>
            <div id="MtbfChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>  
            <div id="MtbfReportArea"></div>
            <script>
                function printDiv() {
                    var divToPrint = document.getElementById('MtbfChart');
                    var newWin = window.open('', 'Print-Window');
                    newWin.document.open();
                    newWin.document.write('<html><body onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
                    newWin.document.close();
                    setTimeout(function () { newWin.close(); }, 10);
                }
            </script>
        </div>
    </div>
        <div id="MttrPerRepiar" class="tab-pane fade">
            <div class="menubody">
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-3">
                        <label style="display: block;"> : خط</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMTTRRLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                       
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMttrPerRepiar" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                        
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtrepEndDate"/>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtrepStartDate"/>
                    </div>
                    
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="MttrPerRepiar();">بر مبنای تعمیر  MTTR دریافت گزارش</button>
                </div>
                <div id="MttrPerRepiarChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>  
                <div id="MttrPerRepiarReport"></div>
            </div>
        </div>
        <div id="MttrPerStop" class="tab-pane fade">
            <div class="menubody">
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-3">
                        <label style="display: block;"> : خط</label> 
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMTTRSLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : واحد</label>
                        <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drMttrPerStop" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                        
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtstopEndDate"/>
                    </div>
                    <div class="col-md-3">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtstopStartDate"/>
                    </div>
                   
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="MttrPerStop();"> بر مبنای توقف  MTTR دریافت گزارش</button>
                </div>
                <div id="MttrPerstopChart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 10px auto;"></div>  
                <div id="MttrPerStopReport"></div>
            </div>
        </div>
        <div id="MttrReport" class="tab-pane fade">
            <div class="menubody">
                <div class="row" style="margin: 0; text-align: right; direction: ltr;">
                    <div class="col-md-4">
                        <label style="display: block;"> : تا تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtReportEndDate"/>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : از تاریخ</label>
                        <input class="form-control text-center" autocomplete="off" id="txtReportStartDate"/>
                    </div>
                    <div class="col-md-4">
                        <label style="display: block;"> : انتخاب نوع گزارش</label>
                        <select class="form-control" dir="rtl" id="drRepiarTime">
                            <option value="1">فاصله بین خرابی ها MTBF </option>
                            <option value="2">مدت زمان تعمیرات بر مبنای تعمیر MTTR</option>
                            <option value="3">مدت زمان تعمیرات بر مبنای توقف MTTR</option>
                            
                        </select>
                    </div>
                    
                </div>
                <div style="padding: 15px;">
                    <button type="button" class="btn btn-info" style="width: 100%;" onclick="GetFilteredReportTable('txtReportStartDate','txtReportEndDate','drRepiarTime');"> مشاهده گزارشات و تحلیل ها </button>
                </div>
                <div id="MttrReportGrid" style="width: 100%; height: 400px; margin: 10px auto; overflow: auto;">
                    <table class="table" dir="rtl" id="gridReports">
                        <tbody></tbody>
                    </table>
                </div>  
            </div>
        </div>
   </div>
    <div id="reportModal" class="modal" style="direction: rtl;">
        <div class="modal-content" style="width: 60%;">
            <span class="fa fa-remove" onclick="$(this).parent().parent().hide();"
                  style="position: absolute; top: 10px; left: 10px; color: black; cursor: pointer; font-size: 15pt;"></span>
            <div class="panel panel-primary" style="margin-bottom: 0;" id="modalBody">
            </div>
        </div>
    </div>
    
<div id="deletereportModal" class="modal" style="direction: rtl;">
    <div class="modal-content" style="width: 200px;">
        <div class="panel panel-danger" style="margin-bottom: 0;">
            <div class="panel-heading">حذف گزارش</div>
            <div class="panel-body">
                <label style="padding: 5px; display: block;">آیا مایل به حذف هستید؟</label>
                <button class="button" type="button" onclick="$(this).parent().parent().parent().parent().hide();">خیر</button>
                <button class="button" type="button" onclick="DeleteReport();">بله</button>
            </div>
        </div>
    </div>
</div>
    <script src="Scripts/MttReport.js"></script>
</asp:Content>
