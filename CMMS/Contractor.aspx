<%@ Page Title="پیمانکاران" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="Contractor.aspx.cs" Inherits="CMMS.Contractor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField runat="server" ClientIDMode="Static" ID="userState" />
    <style>
        label {
            margin: 0;
            margin-right: 5px;
        }
    </style>
    <div class="card">
        <div class="card-header bg-primary text-white">ثبت پیمانکاران</div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <label>سایت /ایمیل : </label>
                    <asp:TextBox ID="txtemail" CssClass="form-control" runat="server" TabIndex="2"></asp:TextBox>
                </div>
                <div class="col-md-6">
                    <label>نام تعمیرکار / پیمانکار : </label>
                    <asp:TextBox ID="txtcontractor" CssClass="form-control" runat="server" TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <label>همراه : </label>
                    <asp:TextBox ID="txtphone" CssClass="form-control" runat="server" TabIndex="5"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label>فاکس : </label>
                    <asp:TextBox ID="txtfax" CssClass="form-control" runat="server" TabIndex="4"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label>تلفن : </label>
                    <asp:TextBox ID="txttell" CssClass="form-control" runat="server" TabIndex="3" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label>وضعیت : </label>
                    <div class="switch-field">
                        <input type="radio" id="active" tabindex="7" name="switch_2" value="yes" checked />
                        <label for="active">فعال</label>
                        <input type="radio" id="deactive" tabindex="8" name="switch_2" value="no" />
                        <label for="deactive">غیرفعال</label>
                    </div>
                </div>
                <div class="col-md-8">
                    <label>آدرس : </label>
                    <asp:TextBox ID="txtaddress" CssClass="form-control" runat="server" TabIndex="6" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <label>توضیحات : </label>
                    <asp:TextBox ID="txtcomment" CssClass="form-control" runat="server" placeholder="شرح تخصص و مهارت پیمانکار" TabIndex="9" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
        </div>
        <div class="card-footer">
            <asp:Button ID="btninsert" runat="server" CssClass="button" Text="ثبت" TabIndex="10" OnClick="btninsert_Click" OnClientClick="getRadio();" />
            <asp:Button ID="btnedit" runat="server" CssClass="button" Visible="False" Text="ویرایش" TabIndex="11" OnClick="btnedit_Click" OnClientClick="getRadio();" />
            <asp:Button ID="btncancel" runat="server" CssClass="button" Visible="False" Text="انصراف" TabIndex="12" OnClick="btncancel_Click" />
        </div>
        <div class="card-footer">
            <asp:GridView runat="server" CssClass="table" ID="gridcontrac" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="sqlcontractor" OnRowCommand="gridcontrac_OnRowCommand">
                <Columns>
                    <asp:BoundField DataField="rownum" HeaderText="ردیف" SortExpression="rownum" />
                    <asp:BoundField DataField="name" HeaderText="پیمانکار" SortExpression="name" />
                    <asp:BoundField DataField="address" HeaderText="آدرس" SortExpression="address" />
                    <asp:BoundField DataField="webmail" HeaderText="وبسایت/ایمیل" SortExpression="webmail" />
                    <asp:BoundField DataField="phone" HeaderText="همراه" SortExpression="phone" />
                    <asp:BoundField DataField="tell" HeaderText="تلفن" SortExpression="tell" />
                    <asp:BoundField DataField="fax" HeaderText="فاکس" SortExpression="fax" />
                    <asp:CheckBoxField DataField="permit" HeaderText="وضعیت" SortExpression="permit" />
                    <asp:ButtonField Text="ویرایش" CommandName="ed" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CssClass="fa fa-print" ToolTip="پرینت" CommandName="Print" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="sqlcontractor" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT ROW_NUMBER()over (order by id) as rownum,[id], [name], [webmail], [address], [phone], [tell], [fax],[permit] FROM [i_contractor]"></asp:SqlDataSource>
        </div>

    </div>
    <script>
        function Err() {
            if ($('#txtcontractor').val() == '') {
                $('#txtcontractor').addClass('form-controlError');
                setTimeout(function () { $('#txtcontractor').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا نام پیمانکار را وارد نمایید", { globalPosition: 'top left' });
            }
            if ($('#txttell').val() == '') {
                $('#txttell').addClass('form-controlError');
                setTimeout(function () { $('#txttell').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا تلفن  را وارد نمایید", { globalPosition: 'top left' });
            }
            if ($('#txtaddress').val() == '') {
                $('#txtaddress').addClass('form-controlError');
                setTimeout(function () { $('#txtaddress').removeClass('form-controlError'); }, 4000);
                $.notify("!!لطفا آدرس پیمانکار را وارد نمایید", { globalPosition: 'top left' });
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
            if (hiddenfield == 'True') {
                active.checked = true;
            } else {
                deactive.checked = true;
            }
        }
    </script>
</asp:Content>
