<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="ShowDailyReport.aspx.cs" Inherits="CMMS.ShowDailyReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .searchButton {
            position: absolute;
            background-image: url(assets/Images/Search_Dark.png);
            background-repeat: no-repeat;
            background-size: 15px;
            background-color: transparent;
            width: 15px;
            height: 15px;
            border: none;
            left: 3px;
            top: 5px;
            z-index: 900;
            outline: none;
        }
         .dr{border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800; height: 22px; padding: 1px;}
        .txt{border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800;}
        label{ margin: 0;}
    </style>
    <div class="card sans">
        <div class="card-header bg-primary text-white">مشاهده گزارش کارها</div>
        <div class="card-body">
            <div style="width: 100%; padding: 2px 15px 2px 15px; text-align: center;">
                <div class="row" style="border: 1px solid rgb(190, 190, 190);border-radius: 5px; background-color: #dfecfe;">
                    <div class="col-lg-3" style="padding: 5px; padding-left: 30px;">
                        <label style="display: block; text-align: right;"> : تا تاریخ</label>
                        <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                            <input id="txtEndDate" class="txt text-center" runat="server" ClientIDMode="Static"/>
                        </div>
                        <asp:Button ToolTip="جستجو" style="top: 35px; left: 10px;" runat="server" CssClass="searchButton" ID="btnSearchTarikh" OnClick="btnSearchTarikh_OnClick"/>
                    </div>
                    <div class="col-lg-3" style="padding: 5px;">
                        <label style="display: block; text-align: right;"> : از تاریخ</label>
                        <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                            <input class="txt text-center" id="txtStartDate" runat="server" ClientIDMode="Static"/>
                        </div>
                    </div>
                    <div class="col-lg-3" style="padding: 5px;">
                        <label style="display: block; text-align: right;"> : شرح گزارش</label>
                        <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                            <input class="txt text-right" dir="rtl" id="txtReport" runat="server" ClientIDMode="Static"/>
                            <asp:Button ToolTip="جستجو" runat="server" CssClass="searchButton" ID="btnSearchExplain" OnClick="btnSearchExplain_OnClick"/>
                        </div>
                    </div>
                    <div class="col-lg-3" style="padding: 5px;">
                        <label style="display: block; text-align: right;"> : نام تهیه کننده</label>
                        <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                            <input class="txt text-right" dir="rtl" id="txtProducer" runat="server" ClientIDMode="Static"/>
                            <asp:Button ToolTip="جستجو" runat="server" CssClass="searchButton" ID="btnSearchProducer" OnClick="btnSearchProducer_OnClick"/>
                        </div>
                    </div>
                </div>
                <asp:GridView runat="server" dir="rtl" ID="gridDailyReport" CssClass="table" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="SqlDailyReports" OnRowCommand="gridDailyReport_OnRowCommand">
                    <Columns>
                        <asp:BoundField DataField="rn" HeaderText="ردیف" SortExpression="rn" />
                        <asp:BoundField DataField="tarikh" HeaderText="تاریخ" SortExpression="tarikh" />
                        <asp:BoundField DataField="rp" HeaderText="تهیه کننده" SortExpression="rp" />
                        <asp:BoundField DataField="report" HeaderText="شرح گزارش" ReadOnly="True" SortExpression="report" />
                        <asp:BoundField DataField="tips" HeaderText="نکات گزارش" ReadOnly="True" SortExpression="tips" />
                        <asp:BoundField DataField="subject" HeaderText="موضوع" ReadOnly="True" SortExpression="subject" />
                        <asp:BoundField DataField="date_remind" HeaderText="تاریخ یادآوری" SortExpression="date_remind" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CssClass="fa fa-print" style="color: #2461be;" ToolTip="پرینت" CommandName="Print" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDailyReports" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT ROW_NUMBER()over(order by id) as rn, id,tarikh,rp , reportexp
,SUBSTRING(reportexp, 1, 20)+' ...' AS report
,SUBSTRING(tips, 1, 15)+' ...' AS tips
,SUBSTRING(subject, 1, 15)+' ...' AS subject
,date_remind
,check_remind
FROM dbo.daily_report"></asp:SqlDataSource>
            </div>
        </div>
    </div>
    <script>
        $(document).ready(function () {
            kamaDatepicker('txtStartDate', customOptions);
            kamaDatepicker('txtEndDate', customOptions);
        });
        $('#txtEndDate').change(function () {
            if (CheckPastTime($('#txtStartDate').val(), '12:00', $('#txtEndDate').val(), '12:00') === false) {
                $('#btnSearchTarikh').attr('disabled', 'disabled');
                RedAlert('no', '!!لطفا تاریخ وارد شده را کنترل نمایید');
            } else {
                $('#btnSearchTarikh').removeAttr('disabled');
            }
        });
    </script>
</asp:Content>
