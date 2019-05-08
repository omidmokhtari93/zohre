<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="Tag.aspx.cs" Inherits="CMMS.Tag" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .PartsBadge{
            position: absolute;
            top: 5px;
            right: 5px;
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
        .PartsBadge *:hover{ cursor: pointer;}
        #PartsSearchResulat {
            display: none;
            position: absolute;
            width: 273px;
            padding-left: 0px;
            z-index: 999;
            max-height: 200px;
            left: 0px;
            text-align: right;
        }
        .costBadge{
            display: inline-block;
            direction: rtl!important;
            border-radius: 10px;
            font-size: 9pt;
            background-color: darkblue;
            color: white;
            padding: 2px 5px;
            vertical-align: middle;
            margin:2px 1px;
        }
        table tr a:hover{ cursor: pointer;}
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
            top: 3px;
            z-index: 900;
            outline: none;
        }
        .SubBadge{
            position: absolute;
            top: 5px;
            right: 5px;
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
        .HeaderLabel {
            width: 100%; text-align: right; direction: rtl;padding: 10px;
        }
        .HeaderLabel > *{ font-size: 10pt;}
        label{ margin: 0;}
        .SubBadge *:hover{ cursor: pointer;}
        .SubSystemTable tr:hover{ cursor: pointer;}
        .PartsTable tr:hover{ cursor: pointer;}
        .nav-tabs >li{ float: right!important;}
        #txtSubSearchPart{ width: 100%;outline: none;padding: 0px 3px 0 0;font-weight: 800;border: none;border-radius: 3px;direction: rtl;}
        .imgfilter{ position: absolute;top: 7px;right: 6px;width: 17px;height: 17px;}
        #subsystemLoading{width: 20px; height: 20px; position: absolute; top: 27px; left: 23px; display: none;}
        #gridTags tr td:first-child{ display: none;}
        #gridTags tr th:first-child{ display: none;}
    </style>
<asp:HiddenField runat="server" ClientIDMode="Static" ID="TagID"/>
    <div class="card" id="pnlMachineTag" runat="server">
        <div class="card-header bg-primary text-white">سابقه تعمیراتی قطعات</div>

        <div class="card-footer">
          
        </div>
        <div class="card-footer">
            <div class="row" style="margin: 0; border: 1px solid rgb(190, 190, 190);border-radius: 5px; background-color: #dfecfe;">
                <div class="col-lg-4" style="padding: 5px;">
                    <asp:Panel runat="server" DefaultButton="btnSearchTag">
                    <label style="display: block; text-align: right;">شماره پلاک :</label>
                    <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                        <input type="text" runat="server" id="txtSearchTag" style="border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800;"/>
                        <asp:Button ToolTip="جستجو" runat="server" CssClass="searchButton" ID="btnSearchTag" OnClick="btnSearchTag_OnClick"/>
                    </div>
                    </asp:Panel>
                </div>
                <div class="col-lg-4" style="padding: 5px;">
                    <asp:Panel runat="server" DefaultButton="btnSearchCode">
                        <label style="display: block; text-align: right;">کد قطعه :</label>
                        <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                            <input type="text" runat="server" id="txtSearchCode" style="border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800;"/>
                            <asp:Button ToolTip="جستجو" runat="server" CssClass="searchButton" ID="btnSearchCode" OnClick="btnSearchCode_OnClick"/>
                        </div>
                    </asp:Panel>
                </div>
                <div class="col-lg-4" style="padding: 5px;">
                    <asp:Panel runat="server" DefaultButton="btnSearchName">
                        <label style="display: block; text-align: right;">نام قطعه :</label>
                        <div style="border: 1px solid darkgray; border-radius:5px; position: relative;">
                            <input type="text" runat="server" id="txtSearchName" style="border: none; border-radius: 5px; width: 100%; direction: rtl; outline: none; font-weight: 800;"/>
                            <asp:Button ToolTip="جستجو" runat="server" CssClass="searchButton" ID="btnSearchName" OnClick="btnSearchName_OnClick"/>
                        </div>
                    </asp:Panel>
                </div>
            </div>
            <asp:GridView runat="server" ClientIDMode="Static" CssClass="table" ID="gridTags" DataKeyNames="id" AutoGenerateColumns="False" DataSourceID="SqlTags" OnRowCommand="gridTags_OnRowCommand">
                <Columns>
                   
                    <asp:BoundField DataField="row" HeaderText="ردیف" SortExpression="row" />
                    <asp:BoundField DataField="subname" HeaderText="نام قطعه" SortExpression="subname" />
                    <asp:BoundField DataField="name" HeaderText="نام ماشین" SortExpression="name"/>
                    <asp:BoundField DataField="code" HeaderText="شماره پلاک" SortExpression="code"/>
                    <asp:ButtonField CommandName="show" Text="مشاهده سوابق"/>
                    <asp:ButtonField CommandName="sabt" Text="ثبت سوابق"/>
                    
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlTags" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT ROW_NUMBER() OVER(ORDER BY dbo.m_subsystem.code) as row,  m_subsystem.id, dbo.m_subsystem.code, dbo.m_machine.name, dbo.subsystem.name AS subname
FROM dbo.m_subsystem INNER JOIN
                         dbo.subsystem ON dbo.m_subsystem.subId = dbo.subsystem.id INNER JOIN
                         dbo.m_machine ON dbo.m_subsystem.Mid = dbo.m_machine.id
WHERE (dbo.m_subsystem.code IS NOT NULL)
ORDER BY dbo.m_subsystem.code ">
               
            </asp:SqlDataSource>
        </div>
    </div>

<div class="card" runat="server" Visible="False" id="pnlShowRepairRecord">
    <div class="card-header bg-primary text-white">مشاهده سوابق تعمیر / تعویض قطعه</div>
    <div class="card-body">
        <div class="HeaderLabel">
            <label>سوابق تعمیر </label> 
            <label style="display: inline-block;" id="lblSubtagName" runat="server" class="label label-info"></label>
            <label> به شماره پلاک </label> 
            <label style="display: inline-block;" id="lblSubtagPelak" runat="server" class="label label-info"></label>
        </div>
        <asp:GridView runat="server" dir="rtl" EmptyDataText="**بدون سابقه تعمیر**" ID="gridRepairRecords" CssClass="table" 
                      AutoGenerateColumns="False" DataKeyNames="subid" DataSourceID="SqlRepairRecords" OnRowCommand="gridRepairRecords_OnRowCommand">
            <Columns>
                <asp:BoundField DataField="rn" HeaderText="ردیف" ReadOnly="True" SortExpression="rn" />
                <asp:BoundField DataField="rep_num" HeaderText="شماره تعمیر" InsertVisible="False" ReadOnly="True" SortExpression="rep_num" />
                <asp:BoundField DataField="runit" HeaderText="واحد قبل" SortExpression="runit"/>
                <asp:BoundField DataField="rline" HeaderText="خط قبل" SortExpression="runit"/>
                <asp:BoundField DataField="nunit" HeaderText="واحد فعلی" SortExpression="runit"/>
                <asp:BoundField DataField="nline" HeaderText="خط فعلی" SortExpression="runit"/>
                <asp:BoundField DataField="rc" HeaderText="تعمیر / تعویض" SortExpression="rc" />
                <asp:BoundField DataField="tarikh" HeaderText="تاریخ تعمیر / تعویض" SortExpression="tarikh" />
                <asp:ButtonField CommandName="show" Text="مشاهده"/>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlRepairRecords" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="
SELECT  ROW_NUMBER()over(order by(select null))as rn,dbo.m_subsystem.code,
CASE WHEN s_subhistory.CR = 1 THEN 'تعمیر' ELSE 'تعویض' END AS rc,
dbo.s_subhistory.rep_num, dbo.s_subhistory.tarikh, dbo.s_subhistory.id AS subid, dbo.i_units.unit_name AS nunit, 
dbo.i_lines.line_name AS nline, i_units_1.unit_name AS runit, i_lines_1.line_name AS rline FROM dbo.m_subsystem INNER JOIN
dbo.s_subhistory ON dbo.m_subsystem.id = dbo.s_subhistory.tagid INNER JOIN
dbo.i_units ON dbo.s_subhistory.new_unit = dbo.i_units.id INNER JOIN
dbo.i_lines ON dbo.s_subhistory.new_line = dbo.i_lines.id INNER JOIN
dbo.i_units AS i_units_1 ON dbo.s_subhistory.rec_unit = i_units_1.id INNER JOIN
dbo.i_lines AS i_lines_1 ON dbo.s_subhistory.rec_line = i_lines_1.id
where m_subsystem.id = @id">
            <SelectParameters>
                <asp:SessionParameter Name="id" SessionField="subtagId" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    <div class="card-footer">
        <asp:Button runat="server" ID="btnBackToSubtag" CssClass="button" Text="بازگشت" OnClick="btnBackToSubtag_OnClick"/>
    </div>
</div>
<div class="card sans" runat="server" Visible="False" id="pnlRepairRecord">
    <div class="card-header bg-primary text-white">ثبت سابقه تعمیر قطعه</div>
    <div class="card-body">
        <div style="display: block; text-align: left; padding-left: 15px;">
            <input runat="server" id="txtRepairNumber" ClientIDMode="Static" class="form-control text-center" readonly style="display: inline-block; width: 150px;"/>
            شماره تعمیر قطعه
        </div>
        <hr/>
        <div class="row">
            <div class="col-sm-4">
                تاریخ تعمیر / تعویض
                <input id="txtRepairDate" class="form-control text-center" readonly style="cursor: pointer;"/>
            </div>
            <div class="col-sm-4">
                شماره پلاک
                <input id="txtTagNumber" runat="server" readonly class="form-control text-center"/>
            </div>
            <div class="col-sm-4">
                مورد تعمیر
                <input id="txtRepairedSub" runat="server" readonly class="form-control text-center"/>
            </div>
        </div>
        <hr/>
        
        <ul class="nav nav-tabs sans-small mt-1 rtl" role="tablist">
            <li class="nav-item">
                <a class="nav-link active" data-toggle="tab" href="#Change" role="tab" aria-controls="home"
                   aria-selected="true">تعویض</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-toggle="tab" href="#Repair" role="tab" aria-controls="profile"
                   aria-selected="false">تعمیر</a>
            </li>
        </ul>

        <div class="tab-content" id="inputsArea">
            <div id="Change" class="tab-pane fade show active sans">
                <div class="row">
                    <div class="col-md-12" style="text-align: right;margin-top: 0px;">
                        توضیحات
                        <textarea class="form-control text-right" id="txtChangeComment" rows="3" style="resize: none; direction: rtl;"></textarea>
                    </div>
                </div>
                <asp:SqlDataSource ID="Sqlunit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                <div class="row mt-3">
                    <div class="col-sm-6" style="margin-top: 0px; text-align: center;">
                        <div style="border: 1px solid darkgray; padding: 5px; border-radius: 5px; height: 74px;">
                            <div style="display: inline-block; width: 48%; text-align: right;">
                                خط جدید
                                <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drAfterLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                                <asp:SqlDataSource ID="Sqlline" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [id],[line_name] FROM [dbo].[i_lines]">
                                </asp:SqlDataSource>
                            </div>
                            <div style="display: inline-block;width: 48%; text-align: right;">
                                واحد جدید
                                <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drAfterUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6" style="margin-top: 0px; text-align: center;">
                        <div style="border: 1px solid darkgray; padding: 5px; border-radius: 5px; height: 74px;">
                            <div style="display: inline-block; width: 48%; text-align: right;">
                                خط فعلی
                                <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drNowLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                            </div>
                            <div style="display: inline-block;width: 48%; text-align: right;">
                                واحد فعلی
                                <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drNowunit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="Repair" class="tab-pane fade">
                <div class="row">
                    <div class="col-sm-12" style="margin-top: 15px;">
                        شرح تعمیر
                        <textarea class="form-control" id="txtRepairExplain" rows="3" style="resize: none; direction: rtl;"></textarea>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-sm-6">
                        <div style="border: 1px solid darkgray; padding: 5px 0px 0 0px; border-radius: 5px;" id="PersonelArea">
                           <div class="card-body pt-0 pb-0">
                               <div class="row">
                                   <div class="col-md-6" >ساعت کارکرد</div>
                                   <div class="col-md-6" >نام تعمیرکاران</div>
                               </div>
                               <button class="button" type="button" onclick="AddRepairers();">+</button>
                               <input type="text" id="txtWorkTime" class="form-control text-center" readonly="readonly" style="width: 32%; display: inline-block; cursor: pointer;"/>
                               <asp:DropDownList Dir="rtl" class="form-control" ClientIDMode="Static" ID="drRepairers" runat="server" style="width: 50%; display: inline-block;" DataSourceID="SqlRepairers" DataTextField="per_name" DataValueField="id"/>
                               <asp:SqlDataSource ID="SqlRepairers" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, per_name FROM i_personel"></asp:SqlDataSource>
                           </div>
                            <div class="card-footer" style="margin-top: 10px;">
                                <table id="gridRepairers" class="table">
                                    <thead></thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div style="border: 1px solid darkgray; padding: 5px 0px 0 0px; border-radius: 5px;">
                            <div class="card-body pt-0 pb-0">
                                <div style="display: block; text-align: right;">مواد و لوازم مصرفی</div>
                                <button class="button" type="button" onclick="AddParts();">+</button>
                                <input class="form-control text-center" id="txtPartsCount" style="width: 20%; display: inline-block;" placeholder="تعداد"/>
                                <div id="PartBadgeArea" style="position: relative;width: 65%;display: inline-block;">
                                    <input type="text" autocomplete="off" dir="rtl" tabindex="41" class="form-control" style="width: 100%;" id="txtPartsSearch" placeholder="جستجوی قطعه ..."/>
                                    <img src="assets/Images/loading.png" id="partsLoading" style="width: 20px; height: 20px; position: absolute;top: 7px; left:7px; display: none;"/>
                                    <div id="PartsSearchResulat">
                                        <div style="padding: 5px 28px 5px 5px;background-color: #dfecfe">
                                            <input type="text" id="txtSubSearchPart" autocomplete="off"/>
                                            <img src="assets/Images/funnel.png" class="imgfilter"/>
                                        </div>
                                        <div style="overflow: auto; width: 100%; max-height: 200px;">
                                            <table id="gridPartsResault" class="PartsTable">
                                                <tbody></tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer" style="margin-top: 10px;">
                                <table id="gridParts" class="table">
                                    <thead></thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-sm-6" style="margin-top: 0px; text-align: center;">
                        <div style="border: 1px solid darkgray; padding: 5px; border-radius: 5px; height: 74px;">
                            <div style="display: inline-block; width: 48%; text-align: right;">
                                خط جدید
                                <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drNewLocLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                            </div>
                            <div style="display: inline-block;width: 48%; text-align: right;">
                                واحد جدید
                                <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drNewLocUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6" style="margin-top: 0px; text-align: center;">
                        <div style="border: 1px solid darkgray; padding: 5px; border-radius: 5px; height: 74px;">
                            <div style="display: inline-block; width: 48%; text-align: right;">
                                خط فعلی
                                <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drRecLocLine" CssClass="form-control" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id"><asp:ListItem Value="-1">خط را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                            </div>
                            <div style="display: inline-block;width: 48%; text-align: right;">
                                واحد فعلی
                                <asp:DropDownList runat="server" AppendDataBoundItems="True" ClientIDMode="Static" ID="drRecLocUnit" CssClass="form-control" DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code"><asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-6" style="margin-top: 15px; text-align: center;">
                    </div>
                    <div class="col-sm-6" style="margin-top: 15px; text-align: center;">
                        <div style="border: 1px solid darkgray; padding: 5px 0px 0px 0px; border-radius: 5px;" id="ContractorArea">
                            <div class="row pr-2">
                                <div class="col-sm-5" style="text-align: right;">دستمزد</div>
                                <div class="col-sm-7" style="text-align: right;">پیمانکاران</div>
                            </div>
                            <button class="button" type="button" onclick="AddContractor();">+</button>
                            <input type="number" id="txtContCost" class="form-control" style="width: 30%; display: inline-block; text-align: center;" placeholder="ریال"/>
                            <asp:DropDownList Dir="rtl" ID="drContractor" runat="server" ClientIDMode="Static" Width="55%" style="display: inline-block;" CssClass="form-control" DataSourceID="SqlContractor" DataTextField="name" DataValueField="id"/>
                            <asp:SqlDataSource ID="SqlContractor" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT name, id FROM i_contractor"></asp:SqlDataSource>
                            <div class="card-footer" style="margin-top: 10px;">
                                <table class="table" id="gridContractors">
                                    <thead></thead>
                                    <tbody></tbody>
                                </table>
                                <div id="TotalCostArea" class="costBadge" style="margin-top: 5px; display: none;">
                                    جمع کل : 
                                    <label id="lblTotalCost">150</label>&nbsp;
                                    ریال
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-sm-12" style="text-align: right">
                        توضیحات
                        <input id="txtcomment" class="form-control text-right"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="card-footer">
        <button class="button" type="button"  onclick="PassDataToDB();">ثبت</button>
        <asp:Button runat="server" CssClass="button" ID="btnBack" Text="بازگشت" OnClick="btnBack_OnClick"/>
    </div>
</div>
    <script src="assets/js/Tags.js"></script>
</asp:Content>