<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="SubSystem.aspx.cs" Inherits="CMMS.SubSystem" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .tooltipp{
            direction: ltr;
            display: none;
            position: absolute;
            cursor: pointer;
            right: 20px;
            min-width: 100px;
            max-width: 300px;
            font-family: tahoma;
            font-weight: 200;
            font-size: 8pt;
            top: 65px;
            border: solid 1px #e3e3e3;
            border-radius: 5px;
            background-color: #ffffdd;
            padding:2px 2px 1px 2px;
            z-index: 1000;
        }
        .tooltipp div {
            padding: 3px;
            background-color: #e3e3e3;
            border-radius: 3px;
            margin: 1px;
            display: inline-block;
            white-space: nowrap;
            direction: rtl;
        }
        .tooltipp::after {
            content: "";
            position: absolute;
            top:-10px;
            right: 65px;
            margin-left: -5px;
            border-width: 5px;
            border-style: solid;
            border-color: transparent transparent #e3e3e3 transparent;
        }
        table tr a { cursor: pointer;}
    </style>
    <div class="card">
        <div class="card-header bg-primary text-white">ثبت اجزا ماشین آلات</div>
        <div id="subsystemform" class="card-body">
            <p class="sans ltr">.لطفا در ثبت اجزا ماشین دقت فرمایید و از ثبت اجزا تکراری خودداری فرمایید <span class="fa fa-circle" style="color: red;"></span></p>
            <div class="row sans ltr text-right" >
                <div class="col-md-6 bold-sans">
                    کد تجهیز     
                    <input class="form-control" type="number" dir="rtl" tabindex="1" id="txtDeviceCode" autocomplete="off"/>
                    <div id="codeTooltip" class="tooltipp" style="width: 140px;">
                        .این کد قبلا ثبت شده است
                    </div>
                </div>
                <div class="col-md-6 bold-sans">
                    نام تجهیز
                    <input class="form-control" autocomplete="off" tabindex="2" id="txtSubName" />
                    <div id="nameTooltip" class="tooltipp">
                    </div>
                </div>
            </div>
        </div>
        <div class="card-footer">
            <button type="button" id="btnSabt" class="button" onclick="SaveSubSystem();">ثبت</button>
            <button type="button" id="btnEdit" style="display: none;" class="button" onclick="EditSubSystem();">ویرایش</button>
            <button type="button" id="btnCancel" style="display: none;" class="button" 
                onclick="CancelEdit();">انصراف</button>
        </div>
        <div class="card-footer">
            <div class="tablescroll">
                <table class="table" dir="rtl" id="TableSubSystem">
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
    
    <div id="ModalDelete" class="modal fade rtl" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content" style="width: 400px;">
                <div class="card sans" style="margin-bottom: 0;">
                    <div class="card-header bg-danger text-white" style="font-weight: 800;">حذف تجهیز</div>
                    <div class="card-body" style="text-align: center;">
                        <label id="subname" class="bg-primary text-white p-2 rtl"></label>
                        <p class="p-2 text-center">آیا مایل به حذف هستید؟</p>
                        <div style="text-align: center;">
                            <button class="btn btn-light" type="button" onclick="deleteSubsystem();">حذف</button>
                            <button class="btn btn-success" type="button" onclick="$('#ModalDelete').modal('hide');">انصراف</button>
                        </div>
                    </div>
                </div>
            </div>    
        </div>
    </div>
    <script src="assets/js/SubSystemPage.js"></script>
</asp:Content>
