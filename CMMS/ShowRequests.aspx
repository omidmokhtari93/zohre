<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="ShowRequests.aspx.cs" Inherits="CMMS.ShowRequests" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        table tr a{ cursor: pointer;}
        .reqPartBadge{
            z-index: 999;
            display: inline-block;
            border-radius: 10px;
            font-size: 9pt;
            background-color: darkblue;
            color: white;
            padding: 2px 5px;
            vertical-align: middle;
            margin:2px 1px;
            direction: ltr!important;
        }
        .reqPartBadge:hover *{ cursor: pointer;}
    </style>
    <div class="panel panel-primary">
        <div class="panel-heading">درخواست های تعمیر</div>
        <div class="panel-body">
             <asp:GridView runat="server" ID="gridRequests" CssClass="table" dir="rtl" AutoGenerateColumns="False" ClientIDMode="Static"
                           DataKeyNames="req_id" DataSourceID="SqlRequests" OnRowCommand="gridRequests_OnRowCommand">
        <Columns>
            <asp:BoundField DataField="req_id" HeaderText="شماره درخواست" SortExpression="req_id" />
            <asp:BoundField DataField="unit_name" HeaderText="واحد درخواست کننده" SortExpression="unit_name" />
            <asp:BoundField DataField="req_name" HeaderText="نام درخواست کننده" SortExpression="req_name" />
            <asp:BoundField DataField="code" HeaderText="کد تجهیز" ReadOnly="True" SortExpression="code" />
            <asp:BoundField DataField="Treq" HeaderText="نوع درخواست" ReadOnly="True" SortExpression="Treq" />
            <asp:BoundField DataField="Tfail" HeaderText="نوع خرابی" ReadOnly="True" SortExpression="Tfail" />
            <asp:TemplateField HeaderText="وضعیت درخواست">
                <ItemTemplate>
                    <a reqid="<%# Eval("req_id") %>" state="<%# Eval("statee") %>"><%# Eval("state") %></a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="time" HeaderText="زمان درخواست" ReadOnly="True" SortExpression="time" />
            <asp:TemplateField>
                <ItemTemplate>
                    <a class="fa fa-print" target="_blank" href="/RequestPrint.aspx?reqid=<%#  Eval("req_id") %>"></a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:ButtonField Text="مشاهده" CommandName="show"/>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SqlRequests" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="
SELECT dbo.r_request.id,dbo.r_request.req_id, dbo.i_units.unit_name, dbo.r_request.req_name,
CASE WHEN r_request.type_fail = 1 THEN 'مکانیکی' WHEN r_request.type_fail = 2 THEN 'تاسیساتی-الکتریکی' 
WHEN r_request.type_fail = 3 THEN 'الکتریکی واحد برق' ELSE 'غیره' END AS Tfail, 
CASE WHEN r_request.type_req = 1 THEN 'اضطراری' WHEN r_request.type_req = 2 THEN 'پیش بینانه' ELSE 'پیش گیرانه' END AS Treq,
case when m_machine.code is null then cast('___' as nvarchar(10)) else cast(m_machine.code as nvarchar(10)) 
end as code, dbo.r_request.date_req +'_'+ dbo.r_request.time_req as time,r_request.state as statee ,
case when r_request.state = 1 then 'باز' when r_request.state = 2 then 'انتظار برای تامین نیرو' 
when r_request.state = 3 then 'انتظار برای تامین قطعه' End as state
FROM dbo.r_request left JOIN
dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id left JOIN
dbo.i_units ON dbo.r_request.unit_id = dbo.i_units.unit_code left JOIN
dbo.subsystem ON dbo.r_request.subid = dbo.subsystem.id
where r_request.state <> 4"></asp:SqlDataSource>
        </div>
    </div>
    
    <div id="partRequestModal" class="modal" style="direction: rtl;">
        <div class="modal-content" style="width: 35%;">
            <span class="fa fa-remove" onclick="$(this).parent().parent().hide();removefields();"
                  style="position: absolute; top: 10px; left: 10px; color: black; cursor: pointer; font-size: 15pt;"></span>
            <div class="panel panel-primary" style="margin-bottom: 0;">
                <div class="panel-heading" style="font-weight: 800;">قطعات</div>
                <div class="panel-body" style="text-align: right;">
                    <div id="badgeLocation" style="width: 100%; padding: 0 10px;"></div>
                    <div class="row" style="margin: 0;">
                        <div class="col-lg-6">
                            تاریخ درخواست
                            <input class="form-control text-center" id="txtPartRequestDate"/>
                        </div>
                        <div class="col-lg-6">
                            شماره درخواست
                            <input class="form-control text-center" id="txtPartRequestNumber"/>
                        </div>
                        <div class="col-lg-12">
                            شرح درخواست
                            <textarea rows="2" class="form-control" style="width: 100%; resize: none;" id="txtPartRequestComment"></textarea>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $('#gridRequests').on('click', 'tr a', function() {
            var reqid = $(this).attr('reqid');
            var state = $(this).attr('state');
            if (state !== '3') {
                return;
            }
            var data = [];
            data.push({
                url: 'WebService.asmx/GetRequestedParts',
                parameters: [{requestId : reqid}],
                func:modalOpen
            });
            AjaxCall(data);
            function modalOpen(e) {
                var d = JSON.parse(e.d);
                $('#txtPartRequestComment').val(d.info.Info);
                $('#txtPartRequestNumber').val(d.info.BuyRequestNumber);
                $('#txtPartRequestDate').val(d.info.BuyRequestDate);
                var partsArr = [];
                for (var i = 0; i < d.parts.length; i++) {
                    partsArr.push('<div class="reqPartBadge">' +
                        '<label style="direction:rtl;white-space:nowrap;margin:0;">' + d.parts[i].PartName + '</label></div>');
                }
                $('#badgeLocation').append(partsArr.join(''));
            }
            $('#partRequestModal').show();
        });

        function removefields() {
            ClearFields('partRequestModal');
            $('#badgeLocation').empty();
        }
    </script>
</asp:Content>
