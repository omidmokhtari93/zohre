<%@ Page Title="شرح تعمیر" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="Reply.aspx.cs" Inherits="CMMS.Reply" %>
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
        #PartsSearchResulat ,#PartRequestSearchResult {
            display: none;
            position: absolute;
            width: 273px;
            padding-left: 0px;
            z-index: 999;
            max-height: 200px;
            left: 0px;
            text-align: right;
        }
        .PartsTable tr:hover{ cursor: pointer;}
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
        .listlable{color: #00008b}
        label{margin: 0;}
        a:hover{ text-decoration: none;}
        table tr a:hover{ cursor: pointer;}
        #txtSubSearchPart{ width: 100%;outline: none;padding: 0px 3px 0 0;font-weight: 800;border: none;border-radius: 3px;}
        .imgfilter{ position: absolute;top: 7px;right: 6px;width: 17px;height: 17px;}
        #helpPartsSearchResulat{display: none;position: absolute;width: 191px;padding-left: 0px;z-index: 999;left: 0px;}
        #PartRequestSearchResult{display: none;position: absolute;width: 100%;padding-left: 0px;z-index: 999;left: 0px;}
        #txthelpSubSearchPart ,#txtPartRequestSubSearch{ width: 100%;outline: none;padding: 0px 3px 0 0;font-weight: 800;border: none;border-radius: 3px;}
        #helpgridParts tr td{ text-align: right;}
    </style>
    <div class="panel panel-primary" id="pnlRequestDetail" style="display:none;">
        <div class="panel-heading">شرح درخواست</div>
        <div class="panel-body">
            <div style="width: 600px; min-height: 250px; background-color: #9cdffb; border-radius: 5px; margin: auto; padding: 20px; text-align: right;">
               <div class="row" style="margin: 0;">
                   <div class="col-lg-6 text-left">
                       <label class="listlable" id="lblRequestNumber"></label>
                       <label> : شماره درخواست</label>
                   </div>
                   <div class="col-lg-6">
                       <label class="listlable" id="lblRequestTime"></label>
                       <label> : زمان درخواست</label>
                   </div>
               </div>
                <hr/>
                <div class="row" style="margin: 0;">
                    <div class="col-lg-6">
                        <label class="listlable" id="lblNameRequest"></label>
                        <label> : نام درخواست کننده</label>
                    </div>
                    <div class="col-lg-6">
                        <label class="listlable" id="lblUnitRequest"></label>
                        <label> : واحد درخواست کننده</label>
                    </div>
                </div>
                <div class="row" style="margin: 0; margin-top: 15px;">
                    <div class="col-lg-4">
                        <label class="listlable" id="lblSubName"></label>
                        <label> : تجهیز</label>
                    </div>
                    <div class="col-lg-4">
                        <label class="listlable" id="lblRequestCode"></label>
                        <label> : به شماره فنی</label>
                    </div>
                    <div class="col-lg-4">
                        <label class="listlable" id="lblMachineName"></label>
                        <label> : مورد تعمیر</label>
                    </div>
                </div>
                <div class="row" style="margin: 0;margin-top: 15px;">
                    <div class="col-lg-6">
                        <label class="listlable" id="lblRequestType"></label>
                        <label> : نوع درخواست</label>
                    </div>
                    <div class="col-lg-6">
                        <label class="listlable" id="lblFailType"></label>
                        <label> : نوع خرابی</label>
                    </div>
                </div>
                <div class="row" style="margin: 0;margin-top: 15px;">
                    <div class="col-lg-12">
                        <label class="listlable" id="lblComment"></label>
                        <label> : توضیحات</label>
                    </div>
                </div>
                <div class="row" style="margin: 0;margin-top: 15px;">
                    <div class="col-lg-12">
                        <div style="background-color: white; border-radius: 5px; width: 100%;">
                            <div style="padding: 5px;">
                                <label style="display: block;">تعین وضعیت درخواست</label>
                                <asp:DropDownList runat="server" dir="rtl" ClientIDMode="Static" ID="drChangeReqState" CssClass="form-control">
                                    <asp:ListItem Value="2">انتظار برای تامین نیرو</asp:ListItem>
                                    <asp:ListItem Value="3">انتظار برای تامین قطعه</asp:ListItem>
                                    <asp:ListItem Value="4">پایان تعمیر</asp:ListItem>
                                    <asp:ListItem Value="5">لغو درخواست</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div id="pnlPartRequest" style="display: none;">
                                <hr/>
                                <div class="row" style="margin: 0;">
                                    <div class="col-lg-12">
                                        <div style="width: 100%; position: relative;">
                                            <div style="width: 100%; position: relative;" id="badgeLocation">
                                            </div>
                                            <div id="PartRequestBadgeArea" style="position: relative;">
                                                <input style="width: 100%;" class="form-control" dir="rtl" id="txtSearchRequestedPart" placeholder="جستجوی قطعه ..."/>
                                                <img src="Images/loading.png" id="PartRequestloading" style="width: 20px; height: 20px; position: absolute; top: 7px; left: 7px; display: none;"/>
                                            </div>
                                            <div id="PartRequestSearchResult">
                                                <div style="padding: 5px 28px 5px 5px;background-color: #dfecfe">
                                                    <input type="text" id="txtPartRequestSubSearch" autocomplete="off" dir="rtl"/>
                                                    <img src="Images/funnel.png" class="imgfilter"/>
                                                </div>
                                                <div style="overflow: auto; width: 100%; max-height: 200px;">
                                                    <table id="griRequestParts" class="PartsTable">
                                                        <tbody></tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" style="margin: 0; margin-bottom: 10px;">
                                    <div class="col-lg-6" style="padding-right: 0;">
                                        شرح مختصر دستور کار
                                        <textarea style="width: 100%; resize: none; height: 88px;" class="form-control" dir="rtl" id="txtPartRequestComment"></textarea>
                                    </div>
                                    <div class="col-lg-6">
                                        تاریخ درخواست خرید
                                        <input style="width: 100%; cursor: pointer;" class="form-control text-center" readonly dir="rtl" id="txtPartRequestDate"/>
                                        شماره درخواست خرید
                                        <input style="width: 100%;" class="form-control text-center" dir="rtl" id="txtPartRequestNumber"/>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-footer" id="pnlbuttons">
                                <button class="button" type="button" onclick="SubmitRepairRequest(this);">ثبت</button>
                                <a class="button" type="button" href="ShowRequests.aspx">انصراف</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="panel panel-primary" id="pnlRepairExplain" style="display: none;">
        <div class="panel-heading">شرح تعمیر</div>
        <div class="panel-body">
            <div class="row" style="padding: 0 0 0 15px;">
                <div class="col-sm-3">
                    شماره درخواست
                    <input class="form-control text-center" disabled="disabled" type="text" id="txtRequsetNumber"/>
                </div>
                <div class="col-sm-3">
                    زمان درخواست
                    <input class="form-control text-center" disabled="disabled" type="text" id="txtTimeReq"/>
                </div>
            <div class="col-sm-3"></div>
            <div class="col-sm-3"></div>
           </div>
            <hr/>
            <div class="row" style="margin: 0;">
                <div class="col-sm-3">
                   تجهیز مورد تعمیر
                    <asp:DropDownList dir="rtl" runat="server" ID="drSubSystem" ClientIDMode="Static" CssClass="form-control" DataSourceID="SqlsubSystem" DataTextField="name" DataValueField="id"/>
                    <asp:SqlDataSource ID="SqlsubSystem" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT subsystem.name, subsystem.id FROM subsystem INNER JOIN m_subsystem ON subsystem.id = m_subsystem.subId INNER JOIN r_request ON m_subsystem.Mid = r_request.machine_code WHERE (r_request.req_id = @rid)">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="ReqId" Name="rid" PropertyName="Value" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
                <div class="col-sm-3">
                    کد ماشین
                    <input class="form-control text-center" id="txtMachineCode" disabled="disabled"/>
                </div>
                <div class="col-sm-3">
                    مورد تعمیر
                    <input class="form-control text-center" id="txtMachineName" disabled="disabled"/>
                </div>
                <div class="col-sm-3">
                    نام واحد
                    <input class="form-control text-center" id="txtUnitName" disabled="disabled"/>
                </div>
            </div>
            <hr/>
            <div class="row" style="margin: 0; text-align: center!important;">
                <div class="col-sm-6">
                    <div style="border: 1px solid darkgray; padding: 5px 0px 0 0px; border-radius: 5px;">
                    <div style="display: block; text-align: right;text-align: right; padding-right: 10px;">علت تاخیر</div>
                    <button class="button" type="button" onclick="AddDelayReason();">+</button>
                    <asp:DropDownList Dir="rtl" class="form-control" ClientIDMode="Static" ID="drTakhir" runat="server" style="width: 80%; display: inline-block;" DataSourceID="sqlDelayReason" DataTextField="delay" DataValueField="id"/>
                        <asp:SqlDataSource ID="sqlDelayReason" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, delay FROM i_delay_reason"></asp:SqlDataSource>
                        <div class="panel-footer" style="margin-top: 10px;">
                            <table id="gridTakhir" class="table">
                                <thead></thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div style="border: 1px solid darkgray; padding: 5px 0px 0 0px; border-radius: 5px;">
                    <div style="display: block; text-align: right; padding-right: 10px;">علت خرابی</div>
                    <button class="button" type="button" onclick="AddFailReason();">+</button>
                    <asp:DropDownList Dir="rtl" class="form-control" ID="drFail" ClientIDMode="Static" runat="server" style="width: 80%; display: inline-block;" DataSourceID="SqlFailReason" DataTextField="fail" DataValueField="id"/>
                        <asp:SqlDataSource ID="SqlFailReason" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, fail FROM i_fail_reason"></asp:SqlDataSource>
                        <div class="panel-footer" style="margin-top: 10px;">
                            <table id="gridKharabi" class="table">
                                <thead></thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <hr/>
            <div class="row" style="margin: 0; text-align: center!important;">
                <div class="col-sm-6">
                    <div style="border: 1px solid darkgray; padding: 5px 10px 10px 10px; border-radius: 5px;">
                        <div style="display: block; text-align: right; text-align: right;">روند تعمیر در حالت</div>
                        <asp:DropDownList dir="rtl" runat="server" ID="drFailLevel" ClientIDMode="Static" CssClass="form-control">
                            <asp:ListItem Value="1">تعمیرات معمول بدون توقف دستگاه</asp:ListItem>
                            <asp:ListItem Value="2">تعمیرات در حالت خواب دستگاه</asp:ListItem>
                            <asp:ListItem Value="3">از کار افتادن خط تولید یا دستگاه در لحظه درخواست</asp:ListItem>
                            <asp:ListItem Value="4">ادامه فعالیت دستگاه تا رسیدن قطعه یا تامین نیرو</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div style="border: 1px solid darkgray; padding: 5px 0px 0 0px; border-radius: 5px;">
                        <div style="display: block; text-align: right; padding-right: 10px;">عملیات</div>
                        <button class="button" type="button" onclick="AddAction();">+</button>
                        <asp:DropDownList Dir="rtl" ClientIDMode="Static" class="form-control" ID="drAction" runat="server" style="width: 80%; display: inline-block;" DataSourceID="Sqlaction" DataTextField="operation" DataValueField="id"/>
                        <asp:SqlDataSource ID="Sqlaction" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, operation FROM i_repairs"></asp:SqlDataSource>
                        <div class="panel-footer" style="margin-top: 10px;">
                            <table id="gridAction" class="table">
                                <thead></thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row" style="margin: 0; margin-top: 15px; text-align: center!important;">
                <div class="col-sm-12">
                    <div style="border: 1px solid darkgray; padding: 5px 10px 10px 10px; border-radius: 5px;">
                        <div style="display: block; text-align: right; text-align: right;">شرح عملیات</div>
                        <textarea class="form-control" id="txtActionExplain" rows="3" style="resize: none; direction: rtl;"></textarea>
                    </div>
                </div>
            </div>
            <hr/>
        <div class="row" style="margin: 0; text-align: center !important;">
            <div class="col-lg-12">
                <div style="border: 1px solid darkgray; padding: 5px 0px 0 0px; border-radius: 5px;">
                    <div class="col-lg-12" style="text-align: right; color: #00008b;">قطعات یدکی / تعویضی</div>
                    <hr/>
                    <div class="col-sm-3" style="text-align: right;">نام قطعه</div>
                    <div class="col-sm-3" style="text-align: right;">نام تجهیز</div>
                    <div class="col-sm-3" style="text-align: right;">نام ماشین</div>
                    <div class="col-sm-3" style="text-align: right;">نام واحد</div>
                    <button class="button" type="button" onclick="Helppart();">+</button>
                    
                    <div style="position: relative; display: inline-block; width: 22%;">
                        <div id="helpPartBadgeArea" style="position: relative;">
                            <input type="text" dir="rtl" autocomplete="off" tabindex="41" class="form-control" id="txthelpPartsSearch" placeholder="جستجوی قطعه ..."/>
                            <img src="Images/loading.png" id="helppartsLoading" style="width: 20px; height: 20px; position: absolute; top: 7px; left: 7px; display: none;"/>
                        </div>
                        <div id="helpPartsSearchResulat">
                            <div style="padding: 5px 28px 5px 5px;background-color: #dfecfe">
                                <input type="text" id="txthelpSubSearchPart" autocomplete="off" dir="rtl"/>
                                <img src="Images/funnel.png" class="imgfilter"/>
                            </div>
                            <div style="overflow: auto; width: 191px; max-height: 200px;">
                                <table id="helpgridParts" class="PartsTable">
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <select dir="rtl" class="form-control" id="drhelpsub" style="width: 22%; display: inline-block; padding: 0;"></select>
                    <select dir="rtl" class="form-control" id="drhelpmachine" style="width: 22%; display: inline-block; padding: 0;"></select>
                    <asp:DropDownList Dir="rtl" class="form-control" ClientIDMode="Static" AppendDataBoundItems="True" ID="drhelpunit" runat="server" style="width: 22%; display: inline-block; padding: 0;" DataSourceID="sqlhelpunit" DataTextField="unit_name" DataValueField="unit_code">
                        <asp:ListItem Value="-1">انتخاب کنید</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="sqlhelpunit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    <div class="panel-footer" style="margin-top: 10px;">
                        <table id="gridHelppart" class="table">
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" style="margin:0;margin-top: 10px; text-align: center!important;">
            <div class="col-sm-5"></div>
                <div class="col-sm-7">
                    <div style="border: 1px solid darkgray; padding: 5px 0px 0px 0px; border-radius: 5px;">
                        <div style="display: block; text-align: right; padding-right: 10px;">قطعات و لوازم مصرفی</div>
                        <button class="button" type="button" onclick="AddParts();">+</button>
                        <asp:DropDownList Dir="rtl" class="form-control" ClientIDMode="Static"  ID="Drmeasurement" runat="server" style="width: 15%; display: inline-block; padding: 0;" DataSourceID="SqlMeasurement" DataTextField="measurement" DataValueField="id">
                        </asp:DropDownList>
                        <input class="form-control text-center" id="txtPartsCount" style="width: 20%; display: inline-block;" placeholder="تعداد"/>                     
                        <asp:SqlDataSource ID="SqlMeasurement" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, measurement FROM i_measurement"></asp:SqlDataSource>
                        <div id="PartBadgeArea" style="position: relative;width: 50%;display: inline-block;">
                            <div style="position: relative; direction: rtl;">
                                <input type="text" autocomplete="off" tabindex="41" class="form-control" id="txtPartsSearch" placeholder="جستجوی قطعه ..."/>
                                <img src="Images/loading.png" id="partsLoading" style="width: 20px; height: 20px; position: absolute; top: 7px; left: 7px; display: none;"/>
                            </div>
                            <div id="PartsSearchResulat">
                                <div style="padding: 5px 28px 5px 5px;background-color: #dfecfe">
                                    <input type="text" id="txtSubSearchPart" dir="rtl" autocomplete="off"/>
                                    <img src="Images/funnel.png" class="imgfilter"/>
                                </div>
                                <div style="overflow: auto; width: 100%; max-height: 200px;">
                                    <table id="gridPartsResault" class="PartsTable">
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="panel-footer" style="margin-top: 10px;">
                            <table id="gridParts" class="table">
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            
            </div>
            <hr/>
            <div class="row" style="margin: 0; text-align: center!important;">
                <div class="col-sm-6">
                    <div style="border: 1px solid darkgray; padding: 5px 0px 10px 0px; border-radius: 5px;">
                        <div style="display: block; text-align: right; padding-right: 12px;">زمان پایان تعمیر</div>
                        <div style="width: 47%; display: inline-block;">
                            <input type="text" id="EndRepairTime" readonly="readonly" class="form-control text-center" style="direction: rtl;cursor: pointer;"/>
                        </div>
                        <div style="width: 47%; display: inline-block;">
                            <input type="text" id="EndRepairDate" autocomplete="off" class="form-control text-center" style="direction: rtl;"/>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div style="border: 1px solid darkgray; padding: 5px 0px 10px 0px; border-radius: 5px;">
                        <div style="display: block;text-align: right; padding-right: 12px;">زمان شروع تعمیر</div>
                        <div style="width: 47%; display: inline-block;">
                            <input type="text" id="StartRepiarTime" readonly="readonly" class="form-control text-center" style="direction: rtl; cursor: pointer;"/>
                        </div>
                        <div style="width: 47%; display: inline-block;">
                            <input type="text" id="StartRepairDate" autocomplete="off" class="form-control text-center" style="direction: rtl;"/>
                        </div>
                    </div>
                </div>
            </div>
            <hr/>
            <div class="row" style="margin: 0; text-align: center!important;">
                <div class="col-sm-6">
                    <div style="border: 1px solid darkgray; padding: 5px 0px 0 0px; border-radius: 5px;">
                        <div class="col-sm-4" style="text-align: right;">ساعت کارکرد</div>
                        <div class="col-sm-4" style="text-align: right;">نیروی فنی برق</div>
                        <div class="col-sm-4" style="text-align: right;">نیروی فنی مکانیک</div>
                        <button class="button" type="button" onclick="AddRepairers();">+</button>
                        <input type="text" id="txtWorkTime" class="form-control text-center" readonly="readonly" style="width: 20%; display: inline-block; cursor: pointer;"/>
                        <asp:DropDownList Dir="rtl" class="form-control" ClientIDMode="Static" AppendDataBoundItems="True" ID="drelec" runat="server" style="width: 33%; display: inline-block;" DataSourceID="SqlPerElec" DataTextField="per_name" DataValueField="id" ><asp:ListItem Value="-1">انتخاب کنید</asp:ListItem></asp:DropDownList>
                        <asp:DropDownList Dir="rtl" class="form-control" ClientIDMode="Static" AppendDataBoundItems="True" ID="drRepairers" runat="server" style="width: 33%; display: inline-block;" DataSourceID="SqlPerMech" DataTextField="per_name" DataValueField="id"><asp:ListItem Value="-1">انتخاب کنید</asp:ListItem></asp:DropDownList>
                        <asp:SqlDataSource ID="SqlPerMech" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, per_name FROM i_personel where unit=0"></asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlPerElec" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, per_name FROM i_personel where unit=1"></asp:SqlDataSource>
                        <div class="panel-footer" style="margin-top: 10px;">
                            <table id="gridRepairers" class="table">
                                <thead></thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div style="border: 1px solid darkgray; padding: 5px 10px 10px 10px; border-radius: 5px;">
                        <div class="col-sm-6" style="text-align: right;">میزان توقف الکتریکی</div>
                        <div class="col-sm-6" style="text-align: right;">میزان توقف مکانیکی</div>
                        <div style="width: 47%; display: inline-block;">
                            <input type="text" id="txtelectime"  class="form-control text-center" style="direction: rtl"; placeholder="دقیقه"/>
                        </div>
                        <div style="width: 47%; display: inline-block;">
                            <input type="text" id="txtmechtime" class="form-control text-center" style="direction: rtl"; placeholder="دقیقه"/>
                        </div>
                        
                    </div>
                </div>
            </div>
        <hr/>
            <div class="row" style="margin: 0; text-align: center!important;">
                <div class="col-sm-6">
                   
                </div>
                <div class="col-sm-6">
                 <div style="border: 1px solid darkgray; padding: 5px 0px 0px 0px; border-radius: 5px;">
                    <div class="col-sm-5" style="text-align: right;">دستمزد</div>
                    <div class="col-sm-7" style="text-align: right;">پیمانکاران</div>
                    <button class="button" type="button" onclick="AddContractor();">+</button>
                    <input type="text" id="txtContCost" class="form-control" style="width: 30%; display: inline-block; text-align: center;" placeholder="ریال"/>
                    <asp:DropDownList Dir="rtl" ID="drContractor" runat="server" ClientIDMode="Static" Width="55%" style="display: inline-block;" CssClass="form-control" DataSourceID="SqlContractor" DataTextField="name" DataValueField="id"/>
                    <asp:SqlDataSource ID="SqlContractor" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT name, id FROM i_contractor"></asp:SqlDataSource>
                    <div class="panel-footer" style="margin-top: 10px;">
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
        </div>
         <div class="panel-footer">
             <button type="button" class="button" onclick="SendDataToDB(this);">ثبت</button>
             <button type="button" class="button" onclick="BackToPreviousPage();">انصراف</button>
         </div>
    </div>
    
<div id="PartChangeModal" class="modal" style="direction: rtl;">
    <div class="modal-content" style="width: 40%;">
        <div class="panel panel-danger" style="margin-bottom: 0;font-weight: 800;">
            <div class="panel-heading">هشدار</div>
            <div class="panel-body" style="text-align: right;">
                <label class="alert alert-warning" style="margin-bottom: 0; width: 100%;">
                    قطعات زیر زودتر از برنامه پیش بینی شده خراب شده اند.
                    در صورت اهمیت موضوع علت خرابی را ذکر نمایید!
                </label>
                <div class="row" style="margin: 0; margin-top: 10px;">
                    <div class="col-lg-12" style="padding: 0;">
                        نام قطعه
                        <select class="form-control" id="drPartChangeParts"></select>
                    </div>
                </div>
                <div class="row" style="margin: 0; text-align: center;">
                    <div class="col-lg-12" style="padding: 10px 0;">
                        <div style="border: 1px solid darkgray; padding: 5px 0px 0 0px; border-radius: 5px; direction: ltr;">
                            <div style="display: block; text-align: right; padding-right: 10px; font-weight: 800;">علت خرابی</div>
                            <button class="button" type="button" onclick="PartChangeFailReason();">+</button>
                            <asp:DropDownList Dir="rtl" class="form-control" ID="drpartChangeFailReason" ClientIDMode="Static" runat="server" style="width: 80%; display: inline-block;" DataSourceID="SqlFailReason" DataTextField="fail" DataValueField="id"/>
                            <div class="panel-footer" style="margin-top: 10px;">
                                <table id="gridPartChangeFailReason" class="table">
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row" style="margin: 0;">
                    <div class="col-lg-6" style="padding-left: 0;">
                        تاریخ تعویض بعدی
                        <input class="form-control text-center" id="txttarikhPartChange" style="cursor: pointer;" readonly/>
                    </div>
                    <div class="col-lg-6" style="padding: 0;">
                        نکات مهم و ضروری
                        <textarea rows="2" class="form-control" dir="rtl" id="txtCommentPartChange" style="resize: none;"></textarea>
                    </div>
                </div>
            </div>
            <div class="panel-footer">
                <button type="button" class="button" onclick="SubmitPartChange(this);">ثبت</button>
            </div>
        </div>
    </div>
</div>

<div id="effectModal" class="modal" style="direction: rtl;">
    <div class="modal-content">
        <div class="panel panel-primary" style="margin-bottom: 0;">
            <div class="panel-heading" style="font-weight: 800;">لیست توقفات فنی منجر به تولید</div>
            <div class="panel-body" style="text-align: center;">
                <p style="font-weight: 800;">
                    آیا دستگاه <span id="effectMachinName"></span> منجر به توقف دستگاه های زیر شده است؟
                </p>
                <table class="table" id="gridAffectedMachines">
                    <tbody></tbody>
                </table>
            </div>
            <div class="panel-footer">
                <button id="btnAffectedMachines" type="button" class="button" onclick="SaveAffectedMachines(this);">ثبت</button>
            </div>
        </div>
    </div>
</div>

<asp:HiddenField runat="server" ClientIDMode="Static" ID="ReqId"/>
<asp:HiddenField runat="server" ClientIDMode="Static" ID="RequestTime"/>
<asp:HiddenField runat="server" ClientIDMode="Static" ID="RequestDate"/>
    <script src="Scripts/Reply.js"></script>
</asp:Content>
