<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="RepairHistory.aspx.cs" Inherits="CMMS.RepairHistory" %>
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
            top: 8px;
            z-index: 900;
            outline: none;
        }
         #gridRepiarHistory table { text-align: center;border: 1px solid #c6cdd5;}
    </style>
    <div class="card">
        <div class="card-header bg-primary text-white">تعمیرات انجام شده</div>
        <div class="card-body">
            <div class="row" style="margin: 0; border: 1px solid rgb(190, 190, 190);border-radius: 5px; background-color: #dfecfe;">
                <div class="col-lg-4" style="padding: 5px;">
                    <asp:Panel runat="server" DefaultButton="btnSearch">
                        <label style="display: block; text-align: right;" class="sans-small"> : وضعیت دستگاه در زمان تعمیر/سرویسکاری</label>
                        <asp:DropDownList dir="rtl" runat="server" ID="drFailLevel" AutoPostBack="True" ClientIDMode="Static"  CssClass="form-control" OnSelectedIndexChanged="drFailLevel_OnSelectedIndexChanged">
                            <asp:ListItem Value="-1">انتخاب نمایید</asp:ListItem>
                            <asp:ListItem Value="1"> بدون توقف دستگاه</asp:ListItem>
                            <asp:ListItem Value="2"> حالت خواب دستگاه</asp:ListItem>
                            <asp:ListItem Value="3">توقف دستگاه</asp:ListItem>
                            <asp:ListItem Value="4">ادامه فعالیت دستگاه تا رسیدن قطعه یا تامین نیرو</asp:ListItem>
                        </asp:DropDownList>
                   
                    </asp:Panel>
                </div>
                <div class="col-lg-4" style="padding: 5px;">
                    <asp:Panel runat="server" DefaultButton="btnSearchCode">
                        <label style="display: block; text-align: right;" class="sans-small"> : کد ماشین</label>
                        <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                            <input type="text" runat="server" id="txtCodeSearch" style="border: none; border-radius: 5px;height: 32px; width: 100%; direction: rtl; outline: none; font-weight: 800;"/>
                            <asp:Button ToolTip="جستجو" runat="server" CssClass="searchButton" ID="btnSearchCode" OnClick="btnSearchCode_OnClick"/>
                        </div>
                    </asp:Panel>
                </div>
                
                <div class="col-lg-4" style="padding: 5px;">
                    <asp:Panel runat="server" DefaultButton="btnSearch">
                        <label style="display: block; text-align: right;" class="sans-small"> : نام ماشین</label>
                        <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                            <input type="text" runat="server" id="txtSearch" style="border: none; border-radius: 5px; width: 100%; direction: rtl; height: 32px; outline: none; font-weight: 800;"/>
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
SELECT dbo.r_reply.idreq, dbo.m_machine.name, dbo.m_machine.code, dbo.r_reply.stop_time, dbo.r_reply.rep_time,dbo.r_reply.start_repdate,dbo.r_reply.rep_state ,cast (dbo.m_machine.code as nvarchar(8)) as vcode 
FROM dbo.r_request INNER JOIN dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN 
dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id 
union all
SELECT distinct( dbo.r_reply.idreq), dbo.r_request.other_machine, '----', dbo.r_reply.stop_time, dbo.r_reply.rep_time,dbo.r_reply.start_repdate,dbo.r_reply.rep_state ,'----' 
FROM dbo.r_request INNER JOIN dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq 
where dbo.r_reply.idreq not in  (SELECT dbo.r_reply.idreq 
FROM dbo.r_request INNER JOIN dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN 
dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id ) order by idreq desc"></asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
