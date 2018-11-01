<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="RepairHistory.aspx.cs" Inherits="CMMS.RepairHistory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .searchButton {
            position: absolute;
            background-image: url(/Images/Search_Dark.png);
            background-repeat: no-repeat;
            background-size: 15px;
            background-color: transparent;
            width: 15px;
            height: 15px;
            border: none;
            left: 3px;
            top: 3px;
            z-index: 900;
            outline: none;
        }
         #gridRepiarHistory table { text-align: center;border: 1px solid #c6cdd5;}
    </style>
    <div class="panel panel-primary">
        <div class="panel-heading">تعمیرات انجام شده</div>
        <div class="panel-body">
            <div class="row" style="margin: 0; border: 1px solid rgb(190, 190, 190);border-radius: 5px; background-color: #dfecfe;">
                <div class="col-lg-6" style="padding: 5px;">
                    <asp:Panel runat="server" DefaultButton="btnSearchCode">
                        <label style="display: block; text-align: right;"> : کد ماشین</label>
                        <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                            <input type="text" runat="server" id="txtCodeSearch" style="border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800;"/>
                            <asp:Button ToolTip="جستجو" runat="server" CssClass="searchButton" ID="btnSearchCode" OnClick="btnSearchCode_OnClick"/>
                        </div>
                    </asp:Panel>
                </div>
                <div class="col-lg-6" style="padding: 5px;">
                    <asp:Panel runat="server" DefaultButton="btnSearch">
                        <label style="display: block; text-align: right;"> : نام ماشین</label>
                        <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                            <input type="text" runat="server" id="txtSearch" style="border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800;"/>
                            <asp:Button ToolTip="جستجو" runat="server" CssClass="searchButton" ID="btnSearch" OnClick="btnSearch_OnClick"/>
                        </div>
                    </asp:Panel>
                </div>
            </div>
            <asp:GridView runat="server" ID="gridRepiarHistory" CssClass="table" dir="rtl" ClientIDMode="Static"
                AutoGenerateColumns="False" DataKeyNames="idreq" DataSourceID="SqlRequests" OnRowCommand="gridRepiarHistory_OnRowCommand" PageSize="15" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="idreq" HeaderText="شماره درخواست" SortExpression="req_id" />
                    <asp:BoundField DataField="name" HeaderText="نام ماشین" SortExpression="unit_name" />
                    <asp:BoundField DataField="code" HeaderText="کد ماشین" SortExpression="req_name" />
                    <asp:BoundField DataField="stop_time" HeaderText="مدت زمان توقف" ReadOnly="True" SortExpression="code" />
                    <asp:BoundField DataField="rep_time" HeaderText="مدت زمان تعمیر" ReadOnly="True" SortExpression="Treq" />
                    <asp:BoundField DataField="start_repdate" HeaderText="تاریخ شروع تعمیر" ReadOnly="True" SortExpression="Tfail" />
                    <asp:ButtonField Text="مشاهده" CommandName="show"/>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlRequests" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="
SELECT dbo.r_reply.idreq, dbo.m_machine.name, dbo.m_machine.code, dbo.r_reply.stop_time, dbo.r_reply.rep_time,dbo.r_reply.start_repdate ,cast (dbo.m_machine.code as nvarchar(8)) as vcode 
FROM dbo.r_request INNER JOIN dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN 
dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id order by dbo.r_request.date_req desc,dbo.r_reply.idreq"></asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
