<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="editMachine.aspx.cs" Inherits="CMMS.editMachine" %>
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
        .gridButton{ padding: 1px 2px;background-color: #2461be;color: white;font-weight: 500;border-radius: 2px;}
        .gridButton:hover{ color: white;text-decoration: none;background-color: #1b498e;}
        label{ margin: 0;}
        #gridDailyCM td:nth-child(0){ display: none;}
        #gridEnergy tr td a{ cursor: pointer;}
        #gridRepairRecord tr td a{ cursor: pointer;}
        #gridRepairRequest tr td a{ cursor: pointer;}
        #gridMachines table { text-align: center;border: 1px solid #c6cdd5;}
        #gridMachines tr td{ padding: 2px 0!important;}
        .fa-trash{ color: red;}
    </style>
     <div class="panel panel-primary" runat="server" ID="pnlMachineInfo">
        <div class="panel-heading">ویرایش شناسنامه تجهیزات</div>
        <div class="panel-body">
           <div style="width: 100%; padding: 2px 15px 2px 15px; text-align: center;">
                  <div class="row" style="margin: 0; border: 1px solid rgb(190, 190, 190);border-radius: 5px; background-color: #dfecfe;">
                      <div class="col-lg-4" style="padding: 5px;">
                          <label style="display: block; text-align: right;"> : محل استقرار</label>
                          <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                              <asp:DropDownList runat="server" CssClass="form-control" AppendDataBoundItems="True" style="border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800; height: 22px; padding: 1px;" DataSourceID="Sqlunits" DataTextField="unit_name" DataValueField="unit_code" ID="drUnits" OnSelectedIndexChanged="drUnits_OnSelectedIndexChanged" AutoPostBack="True">
                                  <asp:ListItem Value="0">همه واحدها</asp:ListItem>
                              </asp:DropDownList>
                              <asp:SqlDataSource ID="Sqlunits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_code, unit_name FROM i_units"></asp:SqlDataSource>
                          </div>
                      </div>
                      <div class="col-lg-4" style="padding: 5px;">
                          <asp:Panel runat="server" DefaultButton="btnSearchCode">
                          <label style="display: block; text-align: right;"> : کد ماشین</label>
                          <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                              <input type="text" runat="server" id="txtCodeSearch" style="border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800;"/>
                              <asp:Button ToolTip="جستجو" runat="server" CssClass="searchButton" ID="btnSearchCode" OnClick="btnSearchCode_OnClick"/>
                          </div>
                          </asp:Panel>
                      </div>
                      <div class="col-lg-4" style="padding: 5px;">
                          <asp:Panel runat="server" DefaultButton="btnSearch">
                          <label style="display: block; text-align: right;"> : نام ماشین</label>
                          <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                              <input type="text" runat="server" id="txtSearch" style="border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800;"/>
                              <asp:Button ToolTip="جستجو" runat="server" CssClass="searchButton" ID="btnSearch" OnClick="btnSearch_OnClick"/>
                          </div>
                          </asp:Panel>
                      </div>
                  </div>
               <asp:GridView runat="server" dir="rtl" ID="gridMachines" CssClass="table" AutoGenerateColumns="False" ClientIDMode="Static"
                             DataKeyNames="id" DataSourceID="SqlMachine" OnRowCommand="gridMachines_OnRowCommand" AllowPaging="True" PageSize="15">
                   <Columns>
                       <asp:TemplateField>
                           <ItemTemplate>
                               <input type="hidden" id="machineId" value='<%# Eval("id") %>'/>
                           </ItemTemplate>
                       </asp:TemplateField>
                       <asp:BoundField DataField="name" HeaderText="نام ماشین" SortExpression="name" />
                       <asp:BoundField DataField="code" HeaderText="کد" SortExpression="code" />
                       <asp:BoundField DataField="loc" HeaderText="واحد" SortExpression="loc" />
                       <asp:BoundField DataField="faz_name" HeaderText="فاز" SortExpression="faz_name" />
                       <asp:TemplateField>
                           <ItemTemplate>
                               <a style="cursor: pointer" class="gridButton" id="RepiarRequest">درخواست های تعمیر</a>
                           </ItemTemplate>
                       </asp:TemplateField>
                       <asp:TemplateField>
                           <ItemTemplate>
                               <a style="cursor: pointer" class="gridButton" id="RepairRecord">سوابق تعمیر</a>
                           </ItemTemplate>
                       </asp:TemplateField>
                       <asp:TemplateField>
                           <ItemTemplate>
                               <a style="cursor: pointer" class="gridButton" id="energy">ثبت موارد انرژی</a>
                           </ItemTemplate>
                       </asp:TemplateField>
                       <asp:ButtonField CommandName="Ed">
                           <ControlStyle CssClass="fa fa-pencil"></ControlStyle>
                           </asp:ButtonField>
                       <asp:TemplateField>
                           <ItemTemplate>
                               <a class="fa fa-print" style="color: #2461be; cursor: pointer;" title="پرینت" id="print"></a>
                           </ItemTemplate>
                       </asp:TemplateField>
                       <asp:ButtonField CommandName="del">
                           <ControlStyle CssClass="fa fa-trash"></ControlStyle>
                       </asp:ButtonField>
                   </Columns>
                   <PagerStyle HorizontalAlign="Center" />
               </asp:GridView>
               <asp:SqlDataSource ID="SqlMachine" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="
SELECT dbo.m_machine.name, dbo.m_machine.loc AS location, dbo.m_machine.code, 
CAST(dbo.m_machine.code AS nvarchar(8)) AS vcode, dbo.m_machine.id, dbo.i_units.unit_name AS loc, 
 dbo.m_machine.maModel, dbo.m_machine.insDate, dbo.m_machine.creator, dbo.i_faz.faz_name
FROM dbo.m_machine INNER JOIN dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code INNER JOIN
 dbo.i_faz ON dbo.m_machine.faz = dbo.i_faz.id ORDER BY dbo.m_machine.code, dbo.m_machine.name, dbo.m_machine.id"></asp:SqlDataSource>
           </div>
        </div>
    </div>
    
<div class="panel panel-danger" style="width: 50%;" runat="server" ID="pnlDeleteMachine" Visible="False">
    <div class="panel-heading" style="text-align: center;">حذف ماشین</div>
    <div class="panel-body">
        <asp:Label runat="server" ID="lblMachineName" CssClass="label label-danger"></asp:Label>
        <label style="text-align: center; display: block; color: black; margin-top: 15px;" >
            کاربر گرامی در صورت حذف دستگاه / ماشین کلیه موارد مرتبط با این دستگاه از قبیل
            سوابق تعمیرات , برنامه کنترلی , موارد انرژی و ... حذف خواهند شد
            <br>
            آیا مایل به حذف هستید؟
        </label>
        <div class="row" style="margin: 0; margin-top: 15px;">
            <div class="col-lg-6">
                <asp:Button runat="server" Width="100%" CssClass="greenbutton" Text="انصراف" ID="no" OnClick="no_OnClick"/>
            </div>
            <div class="col-lg-6">
                <asp:Button runat="server" Width="100%" CssClass="redbutton" Text="حذف ماشین" ID="yes" OnClick="yes_OnClick"/>
            </div>
        </div>
    </div>
</div>
    
    <div id="EnergyModal" class="modal" style="direction: rtl;">
        <div class="modal-content" style="width: 55%;">
            <span class="fa fa-remove" onclick="$(this).parent().parent().hide();$('#gridEnergy').empty();"
                  style="position: absolute; top: 10px; left: 10px; color: black; cursor: pointer; font-size: 15pt;"></span>
            <div class="panel panel-primary" style="margin-bottom: 0;">
                <div class="panel-heading" style="font-weight: 800;">ثبت موارد انرژی</div>
                <div class="panel-body" style="text-align: right;">
                    <label class="label label-primary" style="font-size: 10pt;" id="lblMachineInfo"></label>
                    <div id="pnlModiriatEnergy" style="border: 2px solid darkgray; border-radius: 5px; padding-bottom: 0; margin-top: 15px;">
                        <div class="row" style="margin: 0; direction: rtl; text-align: right; margin-top: 15px;">
                            <div class="col-md-6"></div>
                            <div class="col-md-6">
                                <label style="display: block;">تاریخ مراجعه : </label>
                                <input type="text" tabindex="50" id="txtDastoorTarikh" class="form-control text-center"/>
                            </div>
                        </div>
                        <div class="row" style="margin: 0; direction: rtl; text-align: right; margin-top: 15px;">
                            <div class="col-md-6"></div>
                            <div class="col-md-6">
                                <label>نوع دستگاه :</label>
                                <input id="txtDastoorMachineType" tabindex="51" class="form-control"/>
                            </div>
                        </div>
                        <hr/>
                        <div style="display: block; padding: 5px 15px;">
                            <label>ارزیابی عملکرد موتور</label>
                        </div>
                        <div class="row" style="margin: 0; direction: rtl; text-align: right; margin-top: 15px;">
                            <div class="col-md-3"></div>
                            <div class="col-md-3">
                                <label>آمپرفاز3 :</label>
                                <input id="txtDastoorAmper3" tabindex="54" class="form-control"/>
                            </div>
                            <div class="col-md-3">
                                <label>آمپرفاز2 :</label>
                                <input id="txtDastoorAmper2" tabindex="53" class="form-control"/>
                            </div>
                            <div class="col-md-3">
                                <label>آمپرفاز1 :</label>
                                <input id="txtDastoorAmper1" tabindex="52" class="form-control"/>
                            </div>
                        </div>
                        <div class="row" style="margin: 0; direction: rtl; text-align: right; margin-top: 15px;">
                            <div class="col-md-3">
                                <label>PF :</label>
                                <input id="txtDastoorPF" tabindex="58" class="form-control"/>
                            </div>
                            <div class="col-md-3">
                                <label>ولتاژفاز3 :</label>
                                <input id="txtDastoorVP3" tabindex="57" class="form-control"/>
                            </div>
                            <div class="col-md-3">
                                <label>ولتاژفاز2 :</label>
                                <input id="txtDastoorVP2" tabindex="56" class="form-control"/>
                            </div>
                            <div class="col-md-3">
                                <label>ولتاژفاز1 :</label>
                                <input id="txtDastoorVP1" tabindex="55" class="form-control"/>
                            </div>
                        </div>
                        <div style="position: relative; margin:15px; text-align: right;" class="alert alert-warning">
                            <label>
                                <span class="fa fa-circle" style="color: red;"></span>
                                با زدن دکمه + موارد خود را در جدول ثبت کنید و سپس با دکمه ثبت نهایی تغییرات خود را ذخیره نمایید.
                            </label>
                            <br/>
                            <label>
                                <span class="fa fa-circle" style="color: red;"></span>
                                دقت فرمایید بعد از هر تغییر عملیات ثبت نهایی را انجام دهید در غیر این صورت تغییرات ذخیره نمی شوند.
                            </label>
                        </div>
                        <div class="panel-footer" style="margin-top: 15px;">
                            <button type="button" class="button" onclick="createEnergyTable();">+</button>
                            <button type="button" class="button" id="btnFianlSaveEnergy" onclick="sendInstr();">ثبت نهایی</button>
                        </div>
                        <div class="panel-footer">
                            <table class="table" id="gridEnergy"></table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    
<div id="RepairRecordModal" class="modal" style="direction: rtl;">
    <div class="modal-content" style="width: 55%;">
        <span class="fa fa-remove" onclick="$(this).parent().parent().hide();$('#gridEnergy').empty();"
              style="position: absolute; top: 10px; left: 10px; color: black; cursor: pointer; font-size: 15pt;"></span>
        <div class="panel panel-primary" style="margin-bottom: 0;">
            <div class="panel-heading" style="font-weight: 800;">سوابق تعمیر</div>
            <div class="panel-body" style="text-align: right;">
                <label class="label label-primary" style="font-size: 10pt;" id="lblRepairRecordMN"></label>
                <div style="margin-top: 15px">
                    <table id="gridRepairRecord" class="table">
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
    
<div id="RepairRequestModal" class="modal" style="direction: rtl;">
    <div class="modal-content" style="width: 55%;">
        <span class="fa fa-remove" onclick="$(this).parent().parent().hide();$('#gridEnergy').empty();"
              style="position: absolute; top: 10px; left: 10px; color: black; cursor: pointer; font-size: 15pt;"></span>
        <div class="panel panel-primary" style="margin-bottom: 0;">
            <div class="panel-heading" style="font-weight: 800;">درخواست های تعمیر</div>
            <div class="panel-body" style="text-align: right;">
                <label class="label label-primary" style="font-size: 10pt;" id="lblRepairRequestMN"></label>
                <div style="margin-top: 15px">
                    <table id="gridRepairRequest" class="table">
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
    <script src="Scripts/EditMachine.js"></script>
</asp:Content>
