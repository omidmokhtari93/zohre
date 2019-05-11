<%@ Page Title="اثر گذاری ماشین آلات" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="Effective.aspx.cs" Inherits="CMMS.Effective" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="card">
        <div class="card-header bg-primary text-white">سیستم اثر گذاری ماشین آلات </div>
        <div class="card-body">
            <div class="row ltr">
                <div class="col-md-6 rtl">
                    <label>ماشین اثر گذار : </label>
                    <asp:DropDownList ID="drmain" AppendDataBoundItems="True" runat="server" CssClass="form-control" DataSourceID="sqlmain" DataTextField="name" DataValueField="id" TabIndex="2" AutoPostBack="True">
                        <asp:ListItem Value="-1">ماشین را انتخاب کنید</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-6 rtl">
                    <label>واحد مربوطه : </label>
                    <asp:DropDownList ID="drunitmain" AppendDataBoundItems="True" runat="server" CssClass="form-control" DataSourceID="sqlunitmain" DataTextField="unit_name" DataValueField="unit_code" TabIndex="1" AutoPostBack="True" OnSelectedIndexChanged="drunit_SelectedIndexChanged">
                        <asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <hr style="color: blue;" />
            <div class="row ltr">
                <div class="col-md-6 rtl">
                    <label>ماشین تاثیر پذیرنده : </label>
                    <asp:DropDownList ID="drsub" AppendDataBoundItems="True" runat="server" CssClass="form-control" DataSourceID="sqlsub" DataTextField="name" DataValueField="id" TabIndex="2" AutoPostBack="True">
                        <asp:ListItem Value="-1">ماشین را انتخاب کنید</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-6 rtl">
                    <label>واحد مربوطه : </label>
                    <asp:DropDownList ID="drunitsub" AppendDataBoundItems="True" runat="server" CssClass="form-control" DataSourceID="sqlunitsub" DataTextField="unit_name" DataValueField="unit_code" TabIndex="1" AutoPostBack="True" OnSelectedIndexChanged="drunitsub_OnSelectedIndexChanged">
                        <asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <asp:SqlDataSource ID="sqlunitmain" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [unit_name], [unit_code] FROM [i_units]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlunitsub" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [unit_name], [unit_code] FROM [i_units]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlmain" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT name, id FROM m_machine where loc=@loc">
                <SelectParameters>
                    <asp:ControlParameter ControlID="drunitmain" Name="loc" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlsub" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT name, id FROM m_machine where loc=@loc">
                <SelectParameters>
                    <asp:ControlParameter ControlID="drunitsub" Name="loc" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
        <div class="card-footer">
            <asp:Button ID="btninsert" runat="server" CssClass="button" Text="ثبت" TabIndex="3" OnClick="btninsert_OnClick" />
        </div>
        <div class="card-footer">

            <asp:GridView runat="server" CssClass="table" ID="grideffect" AutoGenerateColumns="False" DataSourceID="sqleffect" OnRowCommand="grideffect_OnRowCommand" DataKeyNames="id">
                <Columns>
                    <asp:BoundField DataField="rownum" HeaderText="ردیف" ReadOnly="True" SortExpression="rownum" />
                    <asp:BoundField DataField="main" HeaderText="ماشین اثر گذار" SortExpression="main" />
                    <asp:BoundField DataField="sub" HeaderText="ماشین تاثیر پذیرنده" SortExpression="sub" />
                    <asp:ButtonField Text="حذف" CommandName="del" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="sqleffect" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT      ROW_NUMBER() OVER (ORDER BY m_effect.id) AS rownum,  dbo.m_effect.id, dbo.m_machine.name AS main, m_machine_1.name AS sub
                            FROM dbo.m_effect INNER JOIN
                         dbo.m_machine ON dbo.m_effect.main_mid = dbo.m_machine.id INNER JOIN
                         dbo.m_machine AS m_machine_1 ON dbo.m_effect.sub_mid = m_machine_1.id"></asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
