<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="DailyPm.aspx.cs" Inherits="CMMS.welcome" %>
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
        label{ margin: 0;}
        .dr {
            border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800; height: 22px; padding: 1px;
        }
        .txtStyle{border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800;}
    </style>
    <div class="panel panel-primary">
        <div class="panel-heading">برنامه نت پیشگیرانه روزانه</div>
        <div class="panel-body">
            <div style="width: 100%; padding: 2px 15px 2px 15px; text-align: center;">
               
                <div class="row" style="margin: 0; border: 1px solid rgb(190, 190, 190);border-radius: 5px; background-color: #dfecfe;">
                    <div class="col-lg-4" style="padding: 5px;">
                        <label style="display: block; text-align: right;"> : دوره سرویسکاری</label>
                        <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                            <asp:DropDownList runat="server" CssClass="form-control dr" AppendDataBoundItems="True" ClientIDMode="Static" ID="drServicePeriod" AutoPostBack="True" OnSelectedIndexChanged="drServicePeriod_OnSelectedIndexChanged">
                                <asp:ListItem Value="-1">همه موارد</asp:ListItem>
                                <asp:ListItem Value="0">روزانه</asp:ListItem>
                                <asp:ListItem Value="6">هفتگی</asp:ListItem>
                                <asp:ListItem Value="1">ماهیانه</asp:ListItem>
                                <asp:ListItem Value="2">سه ماهه</asp:ListItem>
                                <asp:ListItem Value="3">شش ماهه</asp:ListItem>
                                <asp:ListItem Value="4">سالیانه</asp:ListItem>
                                <asp:ListItem Value="5">غیره</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-lg-4" style="padding: 5px;">
                        <asp:Panel runat="server" DefaultButton="btnSearchMachine">
                            <label style="display: block; text-align: right;"> : نام دستگاه</label>
                            <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                                <input type="text" runat="server" id="txtMachineName" class="txtStyle"/>
                                <asp:Button ToolTip="جستجو" runat="server" CssClass="searchButton" ID="btnSearchMachine" OnClick="btnSearchMachine_OnClick"/>
                            </div>
                        </asp:Panel>
                    </div>
                    <div class="col-lg-4" style="padding: 5px;">
                        <label style="display: block; text-align: right;"> : نام واحد</label>
                        <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                            <asp:DropDownList runat="server" CssClass="form-control dr" AppendDataBoundItems="True" ClientIDMode="Static" ID="drUnits" AutoPostBack="True" DataSourceID="SqlUnits" DataTextField="unit_name" DataValueField="unit_code" OnSelectedIndexChanged="drUnits_OnSelectedIndexChanged">
                                <asp:ListItem Value="-1">همه واحدها</asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [unit_name], [unit_code] FROM [i_units]"></asp:SqlDataSource>
                        </div>
                    </div>
                </div>
                <asp:HiddenField runat="server" ClientIDMode="Static" ID="TodayDateTime"/>
                <asp:GridView runat="server" dir="rtl" ID="gridDailyPM" CssClass="table" AutoGenerateColumns="False" DataSourceID="SqlDailyPM" OnRowCommand="gridDailyPM_OnRowCommand" DataKeyNames="loc,Mid,id">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <input type="hidden" id="machineId" value='<%# Eval("id") %>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="unit_name" HeaderText="نام واحد" SortExpression="unit_name" />
                        <asp:BoundField DataField="name" HeaderText="نام دستگاه" SortExpression="name" />
                        <asp:BoundField DataField="code" HeaderText="کد دستگاه" SortExpression="code" />
                        <asp:BoundField DataField="contName" HeaderText="مورد کنترلی" SortExpression="contName" />
                        <asp:BoundField DataField="priod" HeaderText="دوره سرویسکاری" ReadOnly="True" SortExpression="priod" />
                        <asp:BoundField DataField="tarikh" HeaderText="تاریخ" ReadOnly="True" SortExpression="tarikh" />
                        <asp:TemplateField HeaderText="مدت زمان توقف سرویسکاری">
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="txtTimeServcie" CssClass="form-control text-center" TextMode="Number" placeholder="دقیقه"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:ButtonField Text="بازدید شد" CommandName="done"/>
                        <asp:ButtonField Text="منجر به تعمیر" CommandName="repair"/>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <a style="cursor: pointer" id="changepriod">تنظیم برای بازدید فصلی</a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDailyPM" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT        TOP (100) PERCENT dbo.m_control.Mid, dbo.m_machine.name, dbo.m_machine.code, dbo.m_control.contName, CAST(dbo.m_control.period AS nvarchar(2)) AS searchPriod, CAST(dbo.m_machine.loc AS nvarchar(3)) AS loc, 
                         CASE WHEN dbo.m_control.period = 0 THEN 'روزانه' WHEN dbo.m_control.period = 6 THEN 'هفتگی' WHEN dbo.m_control.period = 1 THEN 'ماهیانه' WHEN dbo.m_control.period = 2 THEN 'سه ماهه' WHEN dbo.m_control.period = 3 THEN
                          'شش ماهه' WHEN dbo.m_control.period = 4 THEN 'سالیانه' WHEN dbo.m_control.period = 5 THEN 'غیره' END AS priod, dbo.p_pmcontrols.act, dbo.p_pmcontrols.tarikh, dbo.i_units.unit_name, dbo.p_pmcontrols.kind, 
                         dbo.p_pmcontrols.id
FROM            dbo.m_machine INNER JOIN
                         dbo.m_control ON dbo.m_machine.id = dbo.m_control.Mid INNER JOIN
                         dbo.p_pmcontrols ON dbo.m_control.id = dbo.p_pmcontrols.idmcontrol INNER JOIN
                         dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code
WHERE        (dbo.p_pmcontrols.tarikh <= @a) AND (dbo.p_pmcontrols.act = 0) ORDER BY dbo.p_pmcontrols.tarikh">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="TodayDateTime" PropertyName="Value" Name="a" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
        </div>
    </div>
    <div id="ModalChangeDate" class="modal" style="direction: rtl;">
        <div class="modal-content">
            <span class="fa fa-remove" onclick="$(this).parent().parent().hide();"
                  style="position: absolute; top: 10px; left: 10px; color: black; cursor: pointer; font-size: 15pt;"></span>
            <div class="panel panel-primary" style="margin-bottom: 0;">
                <div class="panel-heading" style="font-weight: 800;">تغییر تاریخ برای بازدید فصلی</div>
                <div class="panel-body" style="text-align: center;">
                    <label style="display: block; text-align: right;">تاریخ بازدید بعدی</label>
                    <div class="row" style="margin: 0;">
                        <div class="col-lg-3">
                            <button class="button" ClientIDMode="Static" disabled id="btnChangeDate" style="width: 100%;" runat="server" OnServerClick="btnChangeDate_OnServerClick">ثبت</button>
                        </div>
                        <div class="col-lg-9">
                            <input class="form-control text-center" ClientIDMode="Static" readonly runat="server"
                                   autocomplete="off" id="txtChangeDate" style="width: 100%;cursor: pointer"/>        
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField runat="server" ClientIDMode="Static" ID="PMid"/>
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
            kamaDatepicker('txtChangeDate', customOptions);
        });
        $('#txtChangeDate').change(function () {
            if (checkPastDate('txtChangeDate') == false) {
                RedAlert('txtChangeDate', '!!تاریخ انتخاب شده باید از تاریخ امروز بزرگتر باشد');
                $('#btnChangeDate').attr('disabled', 'disabled');
                return;
            }
            $('#btnChangeDate').removeAttr('disabled');
        });

        $("table").on("click", "tr a#changepriod", function () {
            $('#PMid').val($(this).closest('tr').find("input[type=hidden][id=machineId]").val());
            $('#ModalChangeDate').show();
        });
    </script>
</asp:Content>
