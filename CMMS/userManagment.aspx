 <%@ Page Title="مدیریت کاربران" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="userManagment.aspx.cs" Inherits="CMMS.userManagment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField runat="server" ClientIDMode="Static" ID="userState"/>
    <style>
        label {
            margin: 0;
            margin-right: 5px;
        }
    </style>
    <div class="panel panel-primary">
        <div class="panel-heading">ثبت کاربر جدید</div>
        <div class="panel-body">
            <div class="row" style="margin: 0; direction: rtl; text-align: right;">
                <div class="col-md-6">
                    <label>نام و نام خانوادگی : </label>
                    <asp:TextBox ClientIDMode="Static" ID="txtName" TabIndex="2" CssClass="form-control" runat="server"></asp:TextBox>  
                </div>
                <div class="col-md-6">
                    <label>نام واحد : </label>
                    <asp:DropDownList runat="server" TabIndex="1" ClientIDMode="Static" CssClass="form-control" ID="drUnitname" AppendDataBoundItems="True" DataSourceID="SqlUnitName" DataTextField="unit_name" DataValueField="unit_code">
                        <asp:ListItem Value="-1">انتخاب کنید</asp:ListItem>
                    </asp:DropDownList>        
                    <asp:SqlDataSource ID="SqlUnitName" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                </div>
            </div>
            <div class="row" style="margin: 0; direction: rtl; text-align: right; margin-top: 15px;">
                <div class="col-md-4">
                    <label>تکرار رمز عبور : </label>
                    <asp:TextBox ClientIDMode="Static" TabIndex="5" placeholder="اعداد و حروف انگلیسی" ID="txtPasswordRep" CssClass="form-control" runat="server"></asp:TextBox>        
                </div>
                <div class="col-md-4">
                    <label>رمز عبور : </label>
                    <asp:TextBox ClientIDMode="Static" TabIndex="4" placeholder="اعداد و حروف انگلیسی" ID="txtPassword" CssClass="form-control" runat="server"></asp:TextBox>        
                </div>
                <div class="col-md-4">
                    <label>نام کاربری : </label>
                    <asp:TextBox ClientIDMode="Static" TabIndex="3" placeholder="اعداد و حروف انگلیسی" ID="txtUserName" runat="server" CssClass="form-control"></asp:TextBox>        
                </div>
            </div>
            <div class="row" style="margin: 0; direction: rtl; text-align: right; margin-top: 15px;">
                <div class="col-md-6">
                    <label>آدرس آیمیل : </label>
                    <asp:TextBox ClientIDMode="Static" TabIndex="7" ID="txtEmail" CssClass="form-control" runat="server"></asp:TextBox>        
                </div>
                <div class="col-md-6">
                    <label>شماره تماس : </label>
                    <asp:TextBox ClientIDMode="Static" TabIndex="6" ID="txtTell" runat="server" CssClass="form-control"></asp:TextBox>        
                </div>
            </div>
            <div class="row" style="margin: 0; direction: rtl; text-align: right; margin-top: 15px;">
                <div class="col-md-6">
                    <label>وضعیت : </label>
                    <div class="switch-field">
                        <input type="radio" id="active" TabIndex="9" name="switch_2" value="yes" checked/>
                        <label for="active">فعال</label>
                        <input type="radio" id="deactive" TabIndex="10" name="switch_2" value="no" />
                        <label for="deactive">غیرفعال</label>
                    </div>
                </div>
                <div class="col-md-6">
                    <label>سطح دسترسی : </label>
                    <asp:DropDownList ClientIDMode="Static" TabIndex="8" runat="server" CssClass="form-control" ID="draccessLevel">
                        <asp:ListItem Value="0">فنی و مهندسی</asp:ListItem>
                        <asp:ListItem Value="1">مدیریت</asp:ListItem>
                        <asp:ListItem Value="2" Selected="True">کاربر عادی</asp:ListItem>
                    </asp:DropDownList>        
                </div>
            </div>
        </div>
        <div class="panel-footer">
            <asp:Button runat="server" CssClass="button" Text="ثبت" ID="btnSabt" OnClientClick="getRadio();" OnClick="btnSabt_OnClick"/>
            <asp:Button runat="server" CssClass="button" Text="ویرایش" Visible="False" ID="btnEdit" OnClientClick="getRadio();" OnClick="btnEdit_OnClick"/>
            <asp:Button runat="server" CssClass="button" Text="انصراف" Visible="False" ID="btnCancel" OnClick="btnCancel_OnClick"/>
        </div>
        <div class="panel-footer">
            
            <asp:GridView runat="server" CssClass="table" AutoGenerateColumns="False" DataSourceID="SqlUsers" DataKeyNames="uid" ID="gridUsers" OnRowDataBound="gridUsers_OnRowDataBound" OnRowCommand="gridUsers_OnRowCommand">
                <Columns>
                    <asp:BoundField DataField="name" HeaderText="نام" SortExpression="name" />
                    <asp:BoundField DataField="username" HeaderText="نام کاربری" SortExpression="username" />
                    <asp:BoundField DataField="password" HeaderText="رمز عبور" SortExpression="password" />
                    <asp:BoundField DataField="usrlevel" HeaderText="سطح دسترسی" SortExpression="usrlevel" />
                    <asp:CheckBoxField DataField="permit" HeaderText="وضعیت" SortExpression="permit" />
                    <asp:BoundField DataField="tell" HeaderText="تلفن" SortExpression="tell" />
                    <asp:BoundField DataField="email" HeaderText="ایمیل" SortExpression="email" />
                    <asp:BoundField DataField="unit" HeaderText="واحد" SortExpression="unit" />
                    <asp:ButtonField Text="ویرایش" CommandName="ed"/>
                    
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlUsers" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT users.id as uid,users.name,
 users.username,
  users.password, 
  case when users.usrlevel = 0 then 'فنی و مهندسی'
   when users.usrlevel = 1 then 'مدیریت' when users.usrlevel = 2 then 'کاربر عادی' end as usrlevel,
   users.permit,
    users.tell,
	 users.email,
	  i_units.unit_name AS unit
	   FROM users INNER JOIN i_units ON users.unit = i_units.unit_code"></asp:SqlDataSource>
        </div>
    </div>
    <script>
        function Err() {
            if ($('#txtUserName').val() == '') {
                $('#txtUserName').addClass('form-controlError');
                setTimeout(function () { $('#txtUserName').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا نام کاربری را وارد نمایید", { globalPosition: 'top left' });
            }
            if ($('#txtName').val() == '') {
                $('#txtName').addClass('form-controlError');
                setTimeout(function () { $('#txtName').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا نام و نام خانوادگی را وارد نمایید", { globalPosition: 'top left' });
            }
            if ($('#txtPassword').val() == '') {
                $('#txtPassword').addClass('form-controlError');
                setTimeout(function () { $('#txtPassword').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا پسورد را وارد نمایید", { globalPosition: 'top left' });
            }
            if ($('#txtPasswordRep').val() == '') {
                $('#txtPasswordRep').addClass('form-controlError');
                setTimeout(function () { $('#txtPasswordRep').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا تکرار پسورد را وارد نمایید", { globalPosition: 'top left' });
            }
            if ($('#txtTell').val() == '') {
                $('#txtTell').addClass('form-controlError');
                setTimeout(function () { $('#txtTell').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا شماره تماس را وارد نمایید", { globalPosition: 'top left' });
            }
            if ($('#drUnitname :selected').val() == "-1") {
                $('#drUnitname').addClass('form-controlError');
                setTimeout(function () { $('#drUnitname').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا واحد انتخاب نمایید", { globalPosition: 'top left' });
            }
            if ($('#txtPassword').val() != $('#txtPasswordRep').val() ) {
                $('#txtPassword').addClass('form-controlError');
                setTimeout(function () { $('#txtPassword').removeClass('form-controlError'); }, 4000);
                $('#txtPasswordRep').addClass('form-controlError');
                setTimeout(function () { $('#txtPasswordRep').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا رمز عبور را چک نمایید", { globalPosition: 'top left' });
            }
        }

        function getRadio() {
            var hiddenfield;
            var active = document.getElementById('active');
            if (active.checked) {
                hiddenfield = $('#userState');
                hiddenfield.val("1");
            }
            else {
                hiddenfield = $('#userState');
                hiddenfield.val("0");
            }
        }
        function setRadio() {
            var hiddenfield = $('#userState').val();
            var active = document.getElementById('active');
            var deactive = document.getElementById('deactive');
            if (hiddenfield == 'False') {
                deactive.checked = true;
            } else {
                active.checked = true;
            }
        }
    </script>
</asp:Content>
