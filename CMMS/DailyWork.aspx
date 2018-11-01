<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="DailyWork.aspx.cs" Inherits="CMMS.DailyWork" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField runat="server" id="Date"/>
    <script>
    $(document).ready(function () {
        var customOptions = {
            placeholder: "روز / ماه / سال"
            , twodigit: true
            , closeAfterSelect: true
            , nextButtonIcon: "fa fa-arrow-circle-right"
            , previousButtonIcon: "fa fa-arrow-circle-left"
            , buttonsColor: "blue"
            , forceFarsiDigits: true
            , markToday: true
            , markHolidays: true
            , highlightSelectedDay: true
            , sync: true
            , gotoToday: true
        }
        kamaDatepicker('txtWorkDate', customOptions);
        });

    
        </script>
    
    <div class="panel panel-primary">
    <div class="panel-heading">تعمیرات انجام شده </div>
    <div class="panel-body">
        <div class="row" style="margin: 0; text-align: right; direction: ltr;">
            <div class="col-md-3">
               
            </div>
            <div class="col-md-3">
                
            </div>
            <div class="col-md-3">
                
            </div>
            <div class="col-md-3">
                <label style="display: block;"> : تاریخ</label>
                <input class="form-control text-center" autocomplete="on" id="txtWorkDate" runat="server" ClientIDMode="Static"/>
            </div>
        </div>
        <div style="padding: 15px;">
           
            <asp:Button runat="server" style="width: 100%;" ID="btnShow" Text="دریافت گزارش" CssClass="btn btn-primary" OnClick="btnShow_OnClick"/>
        </div> 
        <div class="alert alert-info" align="center" >مدت زمان توقف خطوط </div>
        <asp:GridView runat="server" ID="grid_LineWorks" CssClass="table" dir="rtl" ClientIDMode="Static"
                      AutoGenerateColumns="False"  DataSourceID="sqllines" >
            <Columns> 
                <asp:BoundField DataField="row" HeaderText="ردیف" SortExpression="row" />
                <asp:BoundField DataField="unit_name" HeaderText="واحد" SortExpression="unit_name" />
                <asp:BoundField DataField="line_name" HeaderText="نام خط" SortExpression="line_name" />
                <asp:BoundField DataField="mech" HeaderText="توقف مکانیکی" ReadOnly="True" SortExpression="mech" />
                <asp:BoundField DataField="elec" HeaderText="توقف برقی" ReadOnly="True" SortExpression="elec" />
               
            </Columns>
        </asp:GridView>
       
        <div class="alert alert-info" align="center" style="margin-top: 10px;">مدت زمان توقف دستگاه ها </div>
        <asp:GridView runat="server" ID="gridDailyWorks" CssClass="table" dir="rtl" ClientIDMode="Static"
                      AutoGenerateColumns="False" DataKeyNames="idreq" DataSourceID="SqlRequests" >
            <Columns> 
                <asp:BoundField DataField="idreq" HeaderText="شماره درخواست" SortExpression="idreq" />
                <asp:BoundField DataField="unit_name" HeaderText="واحد" SortExpression="unit_name" />
                <asp:BoundField DataField="name" HeaderText="نام ماشین" SortExpression="name" />
                <asp:BoundField DataField="Fail" HeaderText="علت خرابی" ReadOnly="True" SortExpression="Fail" />
                <asp:BoundField DataField="Act" HeaderText="اقدامات انجام گرفته" ReadOnly="True" SortExpression="Act" />
                <asp:BoundField DataField="mech_time" HeaderText="توقف مکانیکی" ReadOnly="True" SortExpression="mech_time" />
                <asp:BoundField DataField="elec_time" HeaderText="توقف برقی" ReadOnly="True" SortExpression="elec_time" />
               
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlRequests" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="
SELECT        dbo.r_reply.idreq, dbo.i_units.unit_name, dbo.m_machine.name, dbo.r_reply.elec_time, dbo.r_reply.mech_time, string_agg(dbo.i_fail_reason.fail, ' ,') AS Fail, string_agg(dbo.i_repairs.operation, ' ,') 
                         AS Act
FROM            dbo.i_repairs INNER JOIN
                         dbo.r_action ON dbo.i_repairs.id = dbo.r_action.act_id INNER JOIN
                         dbo.m_machine INNER JOIN
                         dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code INNER JOIN
                         dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN
                         dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN
                         dbo.r_rfail ON dbo.r_reply.id = dbo.r_rfail.id_rep INNER JOIN
                         dbo.i_fail_reason ON dbo.r_rfail.fail_id = dbo.i_fail_reason.id ON dbo.r_action.id_rep = dbo.r_reply.id
            WHERE        (dbo.r_reply.start_repdate = @date)
GROUP BY dbo.i_units.unit_name, dbo.m_machine.name, dbo.r_reply.elec_time, dbo.r_reply.mech_time, dbo.r_reply.idreq
">
            <SelectParameters>
                <asp:ControlParameter ControlID="Date" Name="date" PropertyName="Value" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqllines" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="
SELECT        ROW_NUMBER() OVER(ORDER BY dbo.i_lines.line_name ) as row, SUM(dbo.r_reply.elec_time) AS elec, SUM(dbo.r_reply.mech_time) AS mech, dbo.i_lines.line_name, dbo.m_machine.loc,dbo.i_units.unit_name
FROM            dbo.m_machine INNER JOIN
                         dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN
                         dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN
                         dbo.i_lines ON dbo.m_machine.line = dbo.i_lines.id INNER JOIN
                         dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code
WHERE        (dbo.r_reply.start_repdate =@date)
GROUP BY dbo.i_lines.line_name, dbo.m_machine.loc,dbo.i_units.unit_name
ORDER BY dbo.m_machine.loc,dbo.i_lines.line_name">
            <SelectParameters>
                <asp:ControlParameter ControlID="Date" Name="date" PropertyName="Value" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    </div>
   
</asp:Content>

