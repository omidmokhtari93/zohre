<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="DailyCM.aspx.cs" Inherits="CMMS.DailyCM" %>
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
        #gridDailyCM tr td:first-child{ display: none;}
        #gridDailyCM tr th:first-child{ display: none;}
        #gridDailyCM td:nth-child(3),#gridDailyCM td:nth-child(2) ,#gridDailyCM td:nth-child(4) , #gridDailyCM td:nth-child(5) ,
        #gridDailyCM th:nth-child(3),#gridDailyCM th:nth-child(2),#gridDailyCM th:nth-child(4),#gridDailyCM th:nth-child(5) {
            display: none
        }
    </style>
    <div class="panel panel-primary">
        <div class="panel-heading">برنامه نت پیش بینانه</div>
        <div class="panel-body">

            <ul class="nav nav-tabs" style="padding: 0px 15px 0 15px; margin-top: 10px;">
                <li class="active"><a data-toggle="tab" href="#TodayCm">نت پیش بینانه امروز</a></li>
                <li><a data-toggle="tab" href="#DateCm">نت پیش بینانه در محدودی تاریخ</a></li>
            </ul>

            <div class="tab-content">
                <div id="TodayCm" class="tab-pane fade in active">
                    <div class="menubody">
                        <div style="width: 100%; padding: 2px 15px 2px 15px; text-align: center;">
                            <div class="row" style="margin: 0; border: 1px solid rgb(190, 190, 190); border-radius: 5px; background-color: #dfecfe;">
                                <div class="col-lg-6" style="padding: 5px;">
                                    <asp:Panel runat="server" DefaultButton="btnSearchMachine">
                                        <label style="display: block; text-align: right;"> : نام دستگاه</label>
                                        <div style="border: 1px solid darkgray; border-radius: 5px; position: relative;">
                                            <input type="text" runat="server" id="txtMachineName" class="txtStyle"/>
                                            <asp:Button ToolTip="جستجو" runat="server" CssClass="searchButton" ID="btnSearchMachine" OnClick="btnSearchMachine_OnClick"/>
                                        </div>
                                    </asp:Panel>
                                </div>
                                <div class="col-lg-6" style="padding: 5px;">
                                    <label style="display: block; text-align: right;"> : نام واحد</label>
                                    <div style="border: 1px solid darkgray; border-radius: 5px; position: relative;">
                                        <asp:DropDownList runat="server" CssClass="form-control dr" AppendDataBoundItems="True" ClientIDMode="Static" ID="drUnits" AutoPostBack="True" DataSourceID="SqlUnits" DataTextField="unit_name" DataValueField="unit_code" OnSelectedIndexChanged="drUnits_OnSelectedIndexChanged">
                                            <asp:ListItem Value="-1">همه واحدها</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="SqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [unit_name], [unit_code] FROM [i_units]"></asp:SqlDataSource>
                                    </div>
                                </div>
                            </div>
                            <asp:HiddenField runat="server" ClientIDMode="Static" ID="M_PartId"/>
                            <asp:HiddenField runat="server" ClientIDMode="Static" ID="Part_Id"/>
                            <asp:HiddenField runat="server" ClientIDMode="Static" ID="M_id"/>
                            <asp:HiddenField runat="server" ClientIDMode="Static" ID="Unit_Code"/>
                            <asp:HiddenField runat="server" ClientIDMode="Static" ID="ForecastId"/>
                            <asp:HiddenField runat="server" ClientIDMode="Static" ID="TodayDateTime"/>
                            <asp:GridView runat="server" dir="rtl" ID="gridDailyCM" ClientIDMode="Static" CssClass="table" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="SqlDailyCM" OnRowDataBound="gridDailyCM_OnRowDataBound">
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <input type="hidden" id="id" value='<%# Eval("id") %>'/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <input type="hidden" id="mPartId" value='<%# Eval("m_partId") %>'/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <input type="hidden" id="PartId" value='<%# Eval("PartId") %>'/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <input type="hidden" id="MachineId" value='<%# Eval("mid") %>'/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <input type="hidden" id="UnitCode" value='<%# Eval("unitt") %>'/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="rn" HeaderText="ردیف" SortExpression="rn"/>
                                    <asp:BoundField DataField="unit_name" HeaderText="نام واحد" SortExpression="unit_name"/>
                                    <asp:BoundField DataField="name" HeaderText="نام دستگاه" SortExpression="name"/>
                                    <asp:BoundField DataField="code" HeaderText="کد دستگاه" SortExpression="code"/>
                                    <asp:BoundField DataField="PartName" HeaderText="نام قطعه" SortExpression="PartName"/>
                                    <asp:BoundField DataField="tarikh" HeaderText="تاریخ تعویض" SortExpression="tarikh"/>
                                    <asp:BoundField DataField="Mojodi" HeaderText="موجودی انبار" SortExpression="Mojodi"/>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <a style="cursor: pointer" id="changePart">منجر به تعویض</a>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <a style="cursor: pointer" id="changeDate">بازنگری تاریخ</a>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="SqlDailyCM" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="
                    SELECT ROW_NUMBER()over(order by Forecast.id)as rn, Forecast.id, Forecast.tarikh,Part.Mojodi,
                    Forecast.act, Part.partname, dbo.i_units.unit_name, dbo.m_machine.name, dbo.m_machine.code
                    ,cast(m_machine.loc as nvarchar(3))as unitt ,m_machine.id as machineid,m_machine.id as mid,
                    Forecast.m_partId , Forecast.PartId ,Forecast.act
                    FROM dbo.m_machine INNER JOIN
                         dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code INNER JOIN
                         dbo.m_parts ON dbo.m_machine.id = dbo.m_parts.Mid INNER JOIN
                         dbo.p_forecast AS Forecast INNER JOIN
                         sgdb.dbo.kalaMojodi AS Part ON Forecast.PartId = Part.PartRef ON dbo.m_parts.id = Forecast.m_partId
where (Forecast.tarikh <= @tarikh) and Forecast.act=0 ">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="TodayDateTime" Name="tarikh" PropertyName="Value"/>
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                    </div>
                </div>
                <div id="DateCm" class="tab-pane fade">
                    <div class="menubody">
                        <div class="row" style="margin: 0; border: 1px solid rgb(190, 190, 190); border-radius: 5px; background-color: #dfecfe; padding: 5px;">
                            <div class="col-lg-6" style="padding: 5px;">
                                <label style="display: block; text-align: right;"> : تا تاریخ</label>
                                <div style="border: 1px solid darkgray; border-radius: 5px; position: relative;">
                                    <input type="text" class="txtStyle text-center" id="txtEndDate" autocomplete="off"/>
                                </div>
                            </div>
                            <div class="col-lg-6" style="padding: 5px;">
                                <label style="display: block; text-align: right;"> : از تاریخ</label>
                                <div style="border: 1px solid darkgray; border-radius: 5px; position: relative;">
                                    <input type="text" id="txtStartDate" class="txtStyle text-center" autocomplete="off"/>
                                </div>
                            </div>
                            <button type="button" class="btn btn-info" style="width: 100%; margin: auto;" onclick="filterGridDailyCm();">مشاهده</button>
                        </div>
                        <table class="table" dir="rtl" id="gridDailyCMbyDate">
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="ModalChangeDate" class="modal" style="direction: rtl;">
        <div class="modal-content">
            <span class="fa fa-remove" onclick="$(this).parent().parent().hide();"
                  style="position: absolute; top: 10px; left: 10px; color: black; cursor: pointer; font-size: 15pt;"></span>
            <div class="panel panel-primary" style="margin-bottom: 0;">
                <div class="panel-heading" style="font-weight: 800;">تاریخ تعویض بعدی</div>
                <div class="panel-body" style="text-align: center;">
                    <label style="display: block; text-align: right;">تاریخ تعویض بعدی</label>
                    <div class="row" style="margin: 0;">
                        <div class="col-lg-3">
                            <button class="button" ClientIDMode="Static" disabled id="btnChangeDate" style="width: 100%;" runat="server" OnServerClick="btnChangeDate_OnClick">ثبت</button>
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
    
    <div id="ModalChangePart" class="modal" style="direction: rtl;">
        <div class="modal-content">
            <span class="fa fa-remove" onclick="$(this).parent().parent().hide();"
                  style="position: absolute; top: 10px; left: 10px; color: black; cursor: pointer; font-size: 15pt;"></span>
            <div class="panel panel-primary" style="margin-bottom: 0;">
                <div class="panel-heading" style="font-weight: 800;">تاریخ تعویض بعدی(منجر به تعویض)</div>
                <div class="panel-body" style="text-align: center;">
                    <label style="display: block; text-align: right;">تاریخ تعویض بعدی</label>
                    <div class="row" style="margin: 0;">
                        <div class="col-lg-3">
                            <button class="button" ClientIDMode="Static" disabled id="btnChangePart"
                                style="width: 100%;" runat="server" OnServerClick="btnChangePart_OnServerClick">ثبت و ادامه</button>
                        </div>
                        <div class="col-lg-9">
                            <input class="form-control text-center" ClientIDMode="Static" readonly runat="server" autocomplete="off"
                                id="txtPartchangeDate" style="width: 100%;cursor: pointer"/>        
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

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
            kamaDatepicker('txtPartchangeDate', customOptions);
            kamaDatepicker('txtChangeDate', customOptions);
            kamaDatepicker('txtStartDate', customOptions);
            kamaDatepicker('txtEndDate', customOptions);
        });

        $("table").on("click", "tr a#changeDate", function () {
            $('#ForecastId').val($(this).closest('tr').find("input[type=hidden][id=id]").val());
            $('#ModalChangeDate').show();
        });
        $('#txtChangeDate').change(function () {
            if (checkPastDate('txtChangeDate') == false) {
                RedAlert('txtChangeDate', '!!تاریخ انتخاب شده باید از تاریخ امروز بزرگتر باشد');
                $('#btnChangeDate').attr('disabled', 'disabled');
                return;
            }
            $('#btnChangeDate').removeAttr('disabled');
        });

        $("table").on("click", "tr a#changePart", function () {
            $('#ForecastId').val($(this).closest('tr').find("input[type=hidden][id=id]").val());
            $('#M_id').val($(this).closest('tr').find("input[type=hidden][id=MachineId]").val());
            $('#Unit_Code').val($(this).closest('tr').find("input[type=hidden][id=UnitCode]").val());
            $('#M_PartId').val($(this).closest('tr').find("input[type=hidden][id=mPartId]").val());
            $('#Part_Id').val($(this).closest('tr').find("input[type=hidden][id=PartId]").val());
            $('#ModalChangePart').show();
        });

        $('#txtPartchangeDate').change(function () {
            if (checkPastDate('txtPartchangeDate') == false) {
                RedAlert('txtPartchangeDate', '!!تاریخ انتخاب شده باید از تاریخ امروز بزرگتر باشد');
                $('#btnChangePart').attr('disabled', 'disabled');
                return;
            }
            $('#btnChangePart').removeAttr('disabled');
        });

        function filterGridDailyCm() {
            var sDate = $('#txtStartDate').val();
            var eDate = $('#txtEndDate').val();
            if (sDate === '' || eDate === '') {
                RedAlert('txtStartDate', 'لطفا فیلد خالی را تکمیل کنید');
                RedAlert('txtEndDate', '');
                return;
            }
            if (!CheckPastTime(sDate,'12:00',eDate,'12:00')) {
                RedAlert('no', 'لطفا محدودی تاریخ را چک کنید');
                return;
            }
            var data = [];
            data.push({
                url: 'WebService.asmx/FilterGridCm',
                parameters: [{ s: sDate, e: eDate }],
                func:createGrid
            });
            AjaxCall(data);
            function createGrid(e) {
                $('#gridDailyCMbyDate tbody').empty();
                var d = JSON.parse(e.d);
                if (d.length === 0) return;
                var body = [];
                body.push('<tr><th>نام واحد</th><th>نام دستگاه</th><th>کد دستگاه</th><th>نام قطعه</th><th>تاریخ تعویض</th><th>موجودی انبار</th></tr>');
                for (var i = 0; i < d.length; i++) {
                    body.push('<tr>' +
                        '<td>' + d[i][0] + '</td>' +
                        '<td>' + d[i][1] + '</td>' +
                        '<td>' + d[i][2] + '</td>' +
                        '<td>' + d[i][3] + '</td>' +
                        '<td>' + d[i][4] + '</td>' +
                        '<td>' + d[i][5] + '</td>' +
                        '</tr>');
                }
                $('#gridDailyCMbyDate tbody').append(body.join(''));
            }
        }
    </script>
</asp:Content>
