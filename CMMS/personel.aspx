<%@ Page Title="ثبت نیروی فنی" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="personel.aspx.cs" Inherits="CMMS.personel" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField runat="server" ClientIDMode="Static" ID="userState"/>
    <asp:HiddenField runat="server" ClientIDMode="Static" ID="userActive"/>
    <style>
        label{ margin: 0;margin-right: 5px;}
        .print{display: block; text-align: center; font-size: 15pt; color: black; padding: 5px;}
        .dr{border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800; height: 22px; padding: 1px;}
        .txt{border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800;}
        label{ margin: 0;}
    </style>
    <div class="panel panel-primary">
    <div class="panel-heading">ثبت نیروی فنی </div>
    <div class="panel-body">
        <div class="row" style="margin: 0; direction: rtl; text-align: right;">
            <div class="col-md-6">
                <label>شماره پرسنلی : </label>
                <asp:TextBox id="txtper" CssClass="form-control" runat="server" TabIndex="2" ClientIDMode="Static"></asp:TextBox>        
            </div>
            <div class="col-md-6">
                <label>نام و نام خانوادگی : </label>
                <asp:TextBox id="txtname" CssClass="form-control" runat="server" TabIndex="1" ClientIDMode="Static"></asp:TextBox>        
            </div>
        </div>
        <div class="row" style="margin: 0; direction: rtl; text-align: right;margin-top: 15px;">
            <div class="col-md-4">
                <label>وضعیت : </label>
                <div class="switch-field">
                    <input type="radio" id="active" TabIndex="9" name="switch_2" value="yes" checked/>
                    <label for="active">فعال</label>
                    <input type="radio" id="deactive" TabIndex="10" name="switch_2" value="no" />
                    <label for="deactive">غیرفعال</label>
                </div>
            </div>
            <div class="col-md-4">
                <label>نیروی فنی : </label>
                <div class="switch-field">
                    <input type="radio" id="tasisat" name="switch_3" value="0" checked TabIndex="3"/>
                    <label for="tasisat">تاسیسات</label>
                    <input type="radio" id="bargh" name="switch_3" value="1" TabIndex="4" />
                    <label for="bargh">برق</label>
                </div>
            </div>
            <div class="col-md-4">
                <label>سمت : </label>
                <asp:DropDownList id="drsemat" CssClass="form-control" runat="server" TabIndex="5">
                    <asp:ListItem Value="0">نیروی معمولی</asp:ListItem>
                    <asp:ListItem Value="1">نیروی ماهر</asp:ListItem>
                    <asp:ListItem Value="2">سرشیفت</asp:ListItem>
                    <asp:ListItem Value="3">سرپرست</asp:ListItem>
                    <asp:ListItem Value="4">مدیر فنی</asp:ListItem>
                </asp:DropDownList>        
            </div>
        </div>
    </div>
        <div class="panel-footer">
            <asp:Button id="btninsert" runat="server" CssClass="button" Text="ثبت" TabIndex="5" OnClick="btninsert_Click" OnClientClick="getRadio();getactRadio();"/>
            <asp:Button id="btnedit" runat="server" Visible="False" CssClass="button" Text="ویرایش" TabIndex="6" OnClick="btnedit_Click" OnClientClick="getRadio();getactRadio();"/>
            <asp:Button id="btncancel" runat="server" Visible="False" CssClass="button" Text="انصراف" TabIndex="7" OnClick="btncancel_Click"/>
            <asp:SqlDataSource ID="sqlpersonel" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT ROW_NUMBER()over (order by per_id) as rownum,id,per_id,per_name,case when unit = 0 then 'تاسیسات' when unit = 1 then 'برق' end as unitt,case when task = 0 then 'نیروی معمولی' when task = 1 then 'نیروی ماهر' when task = 2 then 'سرشیفت' when task = 3 then 'سرپرست' when task = 4 then 'مدیر فنی' end as task,unit as vahed , task as semat ,permit FROM i_personel order by unit,per_id"></asp:SqlDataSource>
        </div>
        <div class="panel-footer">
            <a href="PersonelPrint.aspx" class="fa fa-print print" target="_blank" title="پرینت"></a>
            <div class="row" style="margin: 0; border: 1px solid rgb(190, 190, 190);border-radius: 5px; background-color: #dfecfe;">
                <div class="col-lg-6" style="padding: 5px;">
                    <label style="display: block; text-align: right;">سمت</label>
                    <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                        <asp:DropDownList id="drtaskFilter" CssClass="dr" runat="server" TabIndex="5" AutoPostBack="True" OnSelectedIndexChanged="drtaskFilter_OnSelectedIndexChanged">
                            <asp:ListItem Value="-1">همه</asp:ListItem>
                            <asp:ListItem Value="0">نیروی معمولی</asp:ListItem>
                            <asp:ListItem Value="1">نیروی ماهر</asp:ListItem>
                            <asp:ListItem Value="2">سرشیفت</asp:ListItem>
                            <asp:ListItem Value="3">سرپرست</asp:ListItem>
                            <asp:ListItem Value="4">مدیر فنی</asp:ListItem>
                        </asp:DropDownList>     
                    </div>
                </div>
                <div class="col-lg-6" style="padding: 5px;">
                    <label style="display: block; text-align: right;">نام واحد</label>
                    <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                        <asp:DropDownList id="drunitFilter" CssClass="dr" runat="server" TabIndex="5" AutoPostBack="True" OnSelectedIndexChanged="drunitFilter_OnSelectedIndexChanged">
                            <asp:ListItem Value="-1">همه</asp:ListItem>
                            <asp:ListItem Value="1">برق</asp:ListItem>
                            <asp:ListItem Value="0">تاسیسات</asp:ListItem>
                        </asp:DropDownList>     
                    </div>
                </div>
            </div>
            <asp:GridView runat="server" CssClass="table" AutoGenerateColumns="False" DataSourceID="sqlpersonel" DataKeyNames="id" ID="gridpersonel" OnRowCommand="gridpersonel_OnRowCommand">
                <Columns>
                    <asp:BoundField DataField="rownum" HeaderText="ردیف" SortExpression="rownum" />
                    <asp:BoundField DataField="per_id" HeaderText="شماره پرسنلی" SortExpression="per_id" />
                    <asp:BoundField DataField="per_name" HeaderText="نام و نام خانوادگی" SortExpression="per_name" />
                    <asp:BoundField DataField="unitt" HeaderText="واحد" SortExpression="unitt" />
                    <asp:BoundField DataField="task" HeaderText="سمت" SortExpression="task" />
                    <asp:CheckBoxField DataField="permit" HeaderText="وضعیت" SortExpression="permit" />
                    <asp:ButtonField Text="ویرایش" CommandName="ed"/>
                </Columns>
            </asp:GridView>
        </div>
  </div>
    <script>
        function Err() {
            if ($('#txtper').val() == '') {
                $('#txtper').addClass('form-controlError');
                setTimeout(function () { $('#txtper').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا شماره پرسنلی را وارد نمایید", { globalPosition: 'top left' });
            }
            if ($('#txtname').val() == '') {
                $('#txtname').addClass('form-controlError');
                setTimeout(function () { $('#txtname').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا نام و نام خانوادگی را وارد نمایید", { globalPosition: 'top left' });
            }
            
        }

        function getRadio() {
            var hiddenfield;
            var active = document.getElementById('tasisat');
            if (active.checked) {
                hiddenfield = $('#userState');
                hiddenfield.val("0");
            }
            else {
                hiddenfield = $('#userState');
                hiddenfield.val("1");
            }
        }

        function setRadio() {
            var hiddenfield = $('#userState').val();
            var deactive = document.getElementById('tasisat');
            var active = document.getElementById('bargh');
            if (hiddenfield == 'True') {
                active.checked = true;
            } else {
                deactive.checked = true;
            }
        }
        function getactRadio() {
            var hiddenfield;
            var active = document.getElementById('active');
            if (active.checked) {
                hiddenfield = $('#userActive');
                hiddenfield.val("1");
            }
            else {
                hiddenfield = $('#userActive');
                hiddenfield.val("0");
            }
        }

        function setactRadio() {
            var hiddenfield = $('#userActive').val();
            var active = document.getElementById('active');
            var deactive = document.getElementById('deactive');
            if (hiddenfield == 'True') {
                active.checked = true;
            } else {
                deactive.checked = true;
            }
        }
    </script>
</asp:Content>
