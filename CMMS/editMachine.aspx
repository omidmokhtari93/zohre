<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="editMachine.aspx.cs" Inherits="CMMS.editMachine" %>

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
        label {
            margin: 0;
        }

        #gridDailyCM td:nth-child(0) {
            display: none;
        }

        #gridEnergy tr td a,
        #gridRepairRecord tr td a,
        #gridRepairRequest tr td a{
            cursor: pointer;
        }

        #gridMachines table {
            text-align: center;
            border: 1px solid #c6cdd5;
        }

            #gridMachines table tr td {
                padding: 0 3px !important;
            }

        #gridMachines tr td {
            padding: 2px 0 !important;
        }

        .fa-trash {
            color: red;
        }
        .boxx {
            color: white !important;
        }
    </style>
    <div class="card sans" runat="server" id="pnlMachineInfo">
        <div class="card-header bg-primary text-white">ویرایش شناسنامه تجهیزات</div>
        <div class="card-body">
            <div style="width: 100%; padding: 2px 15px 2px 15px; text-align: center;">
                <div class="row" style="margin: 0; border: 1px solid rgb(190, 190, 190); border-radius: 5px; background-color: #dfecfe;">
                    <div class="col-lg-4" style="padding: 5px;">
                        <label style="display: block; text-align: right;">: محل استقرار</label>
                        <div style="border: 1px solid darkgray; border-radius: 5px; position: relative;">
                            <asp:DropDownList runat="server" CssClass="form-control" AppendDataBoundItems="True" Style="border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 500; height: 26px; padding: 1px;"
                                DataSourceID="Sqlunits" DataTextField="unit_name" DataValueField="unit_code" ID="drUnits" OnSelectedIndexChanged="drUnits_OnSelectedIndexChanged" AutoPostBack="True">
                                <asp:ListItem Value="0">همه واحدها</asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="Sqlunits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_code, unit_name FROM i_units"></asp:SqlDataSource>
                        </div>
                    </div>
                    <div class="col-lg-4" style="padding: 5px;">
                        <asp:Panel runat="server" DefaultButton="btnSearchCode">
                            <label style="display: block; text-align: right;">: کد ماشین</label>
                            <div style="border: 1px solid darkgray; border-radius: 5px; position: relative;">
                                <input type="text" runat="server" id="txtCodeSearch" style="border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800; padding-right: 4px;" />
                                <asp:Button ToolTip="جستجو" runat="server" CssClass="searchButton" ID="btnSearchCode" OnClick="btnSearchCode_OnClick" />
                            </div>
                        </asp:Panel>
                    </div>
                    <div class="col-lg-4" style="padding: 5px;">
                        <asp:Panel runat="server" DefaultButton="btnSearch">
                            <label style="display: block; text-align: right;">: نام ماشین</label>
                            <div style="border: 1px solid darkgray; border-radius: 5px; position: relative;">
                                <input type="text" runat="server" id="txtSearch" style="border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800; padding-right: 4px;" />
                                <asp:Button ToolTip="جستجو" runat="server" CssClass="searchButton" ID="btnSearch" OnClick="btnSearch_OnClick" />
                            </div>
                        </asp:Panel>
                    </div>
                </div>
                <asp:GridView runat="server" dir="rtl" ID="gridMachines" CssClass="table" AutoGenerateColumns="False" ClientIDMode="Static"
                    DataKeyNames="id" DataSourceID="SqlMachine" OnRowCommand="gridMachines_OnRowCommand" AllowPaging="True" PageSize="15">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <input type="hidden" id="machineId" value='<%# Eval("id") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="name" HeaderText="نام ماشین" SortExpression="name" />
                        <asp:BoundField DataField="code" HeaderText="کد" SortExpression="code" />
                        <asp:BoundField DataField="loc" HeaderText="واحد" SortExpression="loc" />
                        <asp:BoundField DataField="faz_name" HeaderText="فاز" SortExpression="faz_name" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <a style="cursor: pointer" class="bg-light pr-1 pl-1 sans-small rounded" id="RepiarRequest">درخواست های تعمیر</a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <a style="cursor: pointer" class="bg-light pr-1 pl-1 sans-small rounded" id="RepairRecord">سوابق تعمیر</a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <a style="cursor: pointer" class="bg-light pr-1 pl-1 sans-small rounded" id="energy">ثبت موارد انرژی</a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:ButtonField CommandName="Ed">
                            <ControlStyle CssClass="fa fa-pencil text-primary"></ControlStyle>
                        </asp:ButtonField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <a class="fa fa-print text-primary" style="cursor: pointer;" title="پرینت" id="print"></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:ButtonField CommandName="del">
                            <ControlStyle CssClass="fa fa-trash text-danger"></ControlStyle>
                        </asp:ButtonField>
                    </Columns>
                    <PagerStyle HorizontalAlign="Center" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlMachine" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="
SELECT dbo.m_machine.name, dbo.m_machine.loc AS location, dbo.m_machine.code,
 CAST(dbo.m_machine.code AS nvarchar(8)) AS vcode, dbo.m_machine.id, dbo.i_units.unit_name AS loc, 
 dbo.m_machine.maModel, dbo.m_machine.insDate, dbo.m_machine.creator, dbo.i_faz.faz_name
FROM dbo.m_machine INNER JOIN dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code left JOIN
 dbo.i_faz ON dbo.m_machine.faz = dbo.i_faz.id ORDER BY dbo.m_machine.code, dbo.m_machine.name, dbo.m_machine.id"></asp:SqlDataSource>
            </div>
        </div>
    </div>

    <div class="card m-auto" style="width: 50%;" runat="server" id="pnlDeleteMachine" visible="False">
        <div class="card-header bg-danger text-white" style="text-align: center;">حذف ماشین</div>
        <div class="card-body">
            <asp:Label runat="server" ID="lblMachineName" CssClass="bg-primary sans text-white p-1"></asp:Label>
            <label style="text-align: center; display: block; color: black; margin-top: 15px;">
                کاربر گرامی در صورت حذف دستگاه / ماشین کلیه موارد مرتبط با این دستگاه از قبیل
            سوابق تعمیرات , برنامه کنترلی , موارد انرژی و ... حذف خواهند شد
            <br>
                آیا مایل به حذف هستید؟
            </label>
            <div class="row" style="margin: 0; margin-top: 15px;">
                <div class="col-lg-6">
                    <asp:Button runat="server" Width="100%" CssClass="greenbutton" Text="انصراف" ID="no" OnClick="no_OnClick" />
                </div>
                <div class="col-lg-6">
                    <asp:Button runat="server" Width="100%" CssClass="redbutton" Text="حذف ماشین" ID="yes" OnClick="yes_OnClick" />
                </div>
            </div>
        </div>
    </div>

    <div id="EnergyModal" class="modal fade rtl" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="card">
                    <div class="card-header bg-primary text-white">ثبت موارد انرژی</div>
                    <div class="card-body">
                        <label class="bg-primary text-white p-1 rtl" id="lblMachineInfo"></label>
                        <div id="pnlModiriatEnergy" style="border: 2px solid darkgray; border-radius: 5px; padding-bottom: 0; margin-top: 15px;">
                            <div class="row text-right p-3">
                                <div class="col-md-6"></div>
                                <div class="col-md-6 rtl">
                                    <label style="display: block;">تاریخ مراجعه : </label>
                                    <input type="text" tabindex="50" id="txtDastoorTarikh" class="form-control text-center" />
                                </div>
                            </div>
                            <div class="row text-right p-3" >
                                <div class="col-md-6"></div>
                                <div class="col-md-6 rtl">
                                    <label>نوع دستگاه :</label>
                                    <input id="txtDastoorMachineType" tabindex="51" class="form-control" />
                                </div>
                            </div>
                            <hr />
                            <div style="display: block; padding: 5px 15px;">
                                <label>ارزیابی عملکرد موتور</label>
                            </div>
                            <div class="row text-right p-3" >
                                <div class="col-md-3"></div>
                                <div class="col-md-3 rtl">
                                    <label>آمپرفاز3 :</label>
                                    <input id="txtDastoorAmper3" tabindex="54" class="form-control" />
                                </div>
                                <div class="col-md-3 rtl">
                                    <label>آمپرفاز2 :</label>
                                    <input id="txtDastoorAmper2" tabindex="53" class="form-control" />
                                </div>
                                <div class="col-md-3 rtl">
                                    <label>آمپرفاز1 :</label>
                                    <input id="txtDastoorAmper1" tabindex="52" class="form-control" />
                                </div>
                            </div>
                            <div class="row text-right p-3" >
                                <div class="col-md-3 rtl">
                                    <label>PF :</label>
                                    <input id="txtDastoorPF" tabindex="58" class="form-control" />
                                </div>
                                <div class="col-md-3 rtl">
                                    <label>ولتاژفاز3 :</label>
                                    <input id="txtDastoorVP3" tabindex="57" class="form-control" />
                                </div>
                                <div class="col-md-3 rtl">
                                    <label>ولتاژفاز2 :</label>
                                    <input id="txtDastoorVP2" tabindex="56" class="form-control" />
                                </div>
                                <div class="col-md-3 rtl">
                                    <label>ولتاژفاز1 :</label>
                                    <input id="txtDastoorVP1" tabindex="55" class="form-control" />
                                </div>
                            </div>
                            <div style="position: relative; margin: 15px;" class="alert alert-warning sans">
                                <div class="rtl text-right mb-2">
                                    <span class="fa fa-circle text-danger"></span>
                                    با زدن دکمه + موارد خود را در جدول ثبت کنید و سپس با دکمه ثبت نهایی تغییرات خود را ذخیره نمایید.
                                </div>
                                <div class="rtl text-right">
                                    <span class="fa fa-circle text-danger"></span>
                                    دقت فرمایید بعد از هر تغییر عملیات ثبت نهایی را انجام دهید در غیر این صورت تغییرات ذخیره نمی شوند.
                                </div>
                            </div>
                            <div class="card-footer">
                                <button type="button" class="button" onclick="createEnergyTable();">+</button>
                                <button type="button" class="button" id="btnFianlSaveEnergy" onclick="sendInstr();">ثبت نهایی</button>
                            </div>
                            <div class="card-footer">
                                <table class="table" id="gridEnergy"></table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div id="RepairRecordModal" class="modal fade rtl" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="card" style="margin-bottom: 0;">
                    <div class="card-header bg-primary text-white">سوابق تعمیر</div>
                    <div class="card-body">
                        <label class="bg-primary text-white p-1 rtl" style="font-size: 10pt;" id="lblRepairRecordMN"></label>
                        <div style="margin-top: 15px">
                            <table id="gridRepairRecord" class="table">
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="RepairRequestModal" class="modal fade rtl" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="card">
                    <div class="card-header bg-primary text-white">درخواست های تعمیر</div>
                    <div class="card-body">
                        <label class="bg-primary text-white p-1" style="font-size: 10pt;" id="lblRepairRequestMN"></label>
                        <div style="margin-top: 15px">
                            <table id="gridRepairRequest" class="table">
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="assets/js/EditMachine.js"></script>
</asp:Content>
