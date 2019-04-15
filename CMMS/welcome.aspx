<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="welcome.aspx.cs" Inherits="CMMS.welcome1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .btn:hover { color: white;}
        .btns{width: 100%; font-weight: 500; margin-top: 10px; color: #323232;font-weight: 800;}
    </style>
    <div class="card">
        <div class="card-header">درخواست های تعمیر</div>
        <div class="card-body" >
            <asp:GridView runat="server" ID="gridRequests" CssClass="table" dir="rtl" AutoGenerateColumns="False" DataKeyNames="req_id" DataSourceID="SqlRequests" >
                <Columns>
                    <asp:BoundField DataField="req_id" HeaderText="شماره درخواست" SortExpression="req_id" />
                    <asp:BoundField DataField="unit_name" HeaderText="واحد درخواست کننده" SortExpression="unit_name" />
                    <asp:BoundField DataField="req_name" HeaderText="نام درخواست کننده" SortExpression="req_name" />
                    <asp:BoundField DataField="code" HeaderText="کد تجهیز" ReadOnly="True" SortExpression="code" />
                    <asp:BoundField DataField="Treq" HeaderText="نوع درخواست" ReadOnly="True" SortExpression="Treq" />
                    <asp:BoundField DataField="Tfail" HeaderText="نوع خرابی" ReadOnly="True" SortExpression="Tfail" />
                    <asp:BoundField DataField="State" HeaderText="وضعیت درخواست" ReadOnly="True" SortExpression="State" />
                    <asp:BoundField DataField="time" HeaderText="زمان درخواست" ReadOnly="True" SortExpression="time" />
                    
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlRequests" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT dbo.r_request.id,dbo.r_request.req_id, dbo.i_units.unit_name, dbo.r_request.req_name,
CASE WHEN r_request.type_fail = 1 THEN 'مکانیکی' WHEN r_request.type_fail = 2 THEN 'تاسیساتی-الکتریکی' 
WHEN r_request.type_fail = 3 THEN 'الکتریکی واحد برق' ELSE 'غیره' END AS Tfail, 
CASE WHEN r_request.type_req = 1 THEN 'اضطراری' WHEN r_request.type_req = 2 THEN 'پیش بینانه' ELSE 'پیش گیرانه' END AS Treq,
case when m_machine.code is null then cast('___' as nvarchar(10)) else cast(m_machine.code as nvarchar(10)) 
end as code, dbo.r_request.date_req +'_'+ dbo.r_request.time_req as time,
case when r_request.state = 1 then 'باز' when r_request.state = 2 then 'انتظار برای تامین نیرو' 
when r_request.state = 3 then 'انتظار برای تامین قطعه' End as state
FROM dbo.r_request left JOIN
dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id left JOIN
dbo.i_units ON dbo.r_request.unit_id = dbo.i_units.unit_code left JOIN
dbo.subsystem ON dbo.r_request.subid = dbo.subsystem.id
where r_request.state <> 4"></asp:SqlDataSource>
            <a class="btn btn-info btn-block mt-1" href="ShowRequests.aspx">مشاهده و پیگیری درخواست های تعمیر</a>
        </div>
    </div>
    <div class="card mt-2">
        <div class="card-header">(برنامه نت پیش گیرانه (موارد کنترلی</div>
        <div class="card-body">
            <asp:GridView runat="server" dir="rtl" CssClass="table" ID="gridcontrols" DataSourceID="SqlPM" AutoGenerateColumns="False" DataKeyNames="id" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="unit_name" HeaderText="نام واحد" SortExpression="unit_name" />
                    <asp:BoundField DataField="name" HeaderText="نام دستگاه" SortExpression="name" />
                    <asp:BoundField DataField="code" HeaderText="کد دستگاه" SortExpression="code" />
                    <asp:BoundField DataField="contName" HeaderText="مورد کنترلی" SortExpression="contName" />
                    <asp:BoundField DataField="priod" HeaderText="دوره سرویسکاری" ReadOnly="True" SortExpression="priod" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlPM" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT        TOP (100) PERCENT dbo.m_control.Mid, dbo.m_machine.name, dbo.m_machine.code, dbo.m_control.contName, CAST(dbo.m_control.period AS nvarchar(2)) AS searchPriod, CAST(dbo.m_machine.loc AS nvarchar(3)) AS loc, 
                         CASE WHEN dbo.m_control.period = 0 THEN 'روزانه' WHEN dbo.m_control.period = 6 THEN 'هفتگی' WHEN dbo.m_control.period = 1 THEN 'ماهیانه' WHEN dbo.m_control.period = 2 THEN 'سه ماهه' WHEN dbo.m_control.period = 3 THEN
                          'شش ماهه' WHEN dbo.m_control.period = 4 THEN 'سالیانه' WHEN dbo.m_control.period = 5 THEN 'غیره' END AS priod, dbo.p_pmcontrols.act, dbo.p_pmcontrols.tarikh, dbo.i_units.unit_name, dbo.p_pmcontrols.kind, 
                         dbo.p_pmcontrols.id
FROM            dbo.m_machine INNER JOIN
                         dbo.m_control ON dbo.m_machine.id = dbo.m_control.Mid INNER JOIN
                         dbo.p_pmcontrols ON dbo.m_control.id = dbo.p_pmcontrols.idmcontrol INNER JOIN
                         dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code
WHERE        (dbo.p_pmcontrols.tarikh <= @a) AND (dbo.p_pmcontrols.act = 0)
ORDER BY dbo.p_pmcontrols.tarikh">
                <SelectParameters>
                    <asp:ControlParameter ControlID="DateTime" Name="a" PropertyName="Value" />
                </SelectParameters>
            </asp:SqlDataSource>
            <a class="btn btn-info btn-block mt-1" href="DailyPm.aspx">مشاهده و پیگیری کامل موارد پیش گیرانه</a>
        </div>
    </div>
    <div class="card mt-2">
        <div class="card-header">(برنامه نت پیش بینانه (تعویض قطعات</div>
        <div class="card-body">
            <asp:GridView runat="server" dir="rtl" CssClass="table" ID="gridparts" AutoGenerateColumns="False" DataSourceID="SqlCM" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="rn" HeaderText="ردیف" SortExpression="rn" />
                    <asp:BoundField DataField="unit_name" HeaderText="نام واحد" SortExpression="unit_name" />
                    <asp:BoundField DataField="name" HeaderText="نام دستگاه" SortExpression="name" />
                    <asp:BoundField DataField="code" HeaderText="کد دستگاه" SortExpression="code" />
                    <asp:BoundField DataField="PartName" HeaderText="نام قطعه" SortExpression="PartName" />
                    <asp:BoundField DataField="tarikh" HeaderText="تاریخ تعویض" SortExpression="tarikh" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlCM" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT ROW_NUMBER()over(order by Forecast.id)as rn, Forecast.id, Forecast.tarikh,
                    Forecast.act, Part.PartName, dbo.i_units.unit_name, dbo.m_machine.name, dbo.m_machine.code
                    ,cast(m_machine.loc as nvarchar(3))as unitt ,m_machine.id as machineid,m_machine.id as mid,
                    Forecast.m_partId , Forecast.PartId ,Forecast.act
                    FROM dbo.m_machine INNER JOIN
                         dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code INNER JOIN
                         dbo.m_parts ON dbo.m_machine.id = dbo.m_parts.Mid INNER JOIN
                         dbo.p_forecast AS Forecast INNER JOIN
                         sgdb.inv.Part AS Part ON Forecast.PartId = Part.Serial ON dbo.m_parts.id = Forecast.m_partId
where (Forecast.tarikh <= @tarikh) and Forecast.act=0">
                <SelectParameters>
                    <asp:ControlParameter ControlID="DateTime" Name="tarikh" PropertyName="Value" />
                </SelectParameters>
            </asp:SqlDataSource>
            <a class="btn btn-info btn-block mt-1" href="DailyCM.aspx">مشاهده و پیگیری کامل موارد پیش بینانه</a>
        </div>
    </div>
    <asp:HiddenField runat="server" ID="DateTime"/>
</asp:Content>
