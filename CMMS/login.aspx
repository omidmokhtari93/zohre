<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="CMMS.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="Content/bootstrap.min.css"/>
    <link rel="stylesheet" href="Content/bootstrap-theme.min.css"/>
    <script src="Scripts/jquery-3.3.1.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script src="Scripts/jquery.easing.1.3.js"></script>
    <script src="Scripts/jquery.easing.compatibility.js"></script>
    <link href="Scripts/loginStyles.css" rel="stylesheet" />
    <link href="Scripts/font-awesome.min.css" rel="stylesheet" />
    <script src="Scripts/notify.min.js"></script>
    <link href="Images/icon.ico" rel="shortcut icon"/>
    <title>سامانه تعمیر و نگهداری تجهیزات برنا</title>
    <style>
    </style>
</head>
<body class="backgroundpattern">
    <form id="form1" runat="server">
        <div class="unselectable headerArea">
            <img src="Images/1.png" class="headerLogo"/>
        </div>
        <div id="pnl_login">
            <div class="loginstyle">
                <div class="panel panel-primary" style="width: 350px; position: relative;">
                    <div class="panel-heading unselectable"><label>ورود به سیستم</label></div>
                    <div class="panel-body">
                        <br/>
                        <div class="input-container">
                            <input type="text" tabindex="1" id="UserName" />
                            <label class="unselectable userNameLabel">نام کاربری</label>
                        </div>
                        <br/>
                        <div class="input-container">
                            <button class="fa fa-eye" title="نمایش رمز عبور" type="button" id="showPassword" ></button>
                            <input type="password" tabindex="2" id="Password"/>
                            <label class="unselectable PassLabel">رمز عبور</label>
                        </div>
                        <div style=" width: 100%;">
                            <div class="forgetPassButton">
                                <a id="btnForgetPasword" onclick="RememberPassword();">رمز عبورم را فراموش کرده ام</a>
                                <div class="fa fa-lock"></div>
                            </div>
                        </div>
                        <br/><br/><br/><br/>
                        <button type="button" class="EnterButton" tabindex="3" onclick="auth($('.loginstyle'));" id="btnLogin">ورود</button>
                    </div>
                    <div id="loginloading">
                        <img class="loading-image" src="Images/loading.gif"/>
                    </div>
                </div>
            </div>
        </div> 
        
        <div class="panel panel-primary forgetstyle" id="pnlForgetPassword">
            <div class="panel-heading">بازیابی رمز عبور</div>
            <div class="panel-body">
                <label class="text"><span class="spn">*</span> لطفا شماره تلفن همراه و آدرس ایمیل خود را وارد نمایید. </label>
                <label class="text"><span class="spn">*</span> شماره تلفن همراه و ایمیل وارد شده می بایست شماره و ایمیل ثبت شده در سامانه باشد. </label>
                <label class="text"><span class="spn">*</span> درصورتی که هر یک از فیلدهای زیر را فراموش کرده اید با پشتیبان برنامه تماس بگیرید. </label>
                <div class="linesep"></div>
                <h5>تلفن همراه</h5>
                <div class="forget_pass">
                    <label id="phoneValidation"></label>
                    <input type="text" tabindex="1" id="txtPhoneNumber"/>
                </div>
                <h5>آدرس ایمیل</h5>
                <div class="forget_pass">
                    <label id="emailValidation"></label>
                    <input type="text" tabindex="2" id="txtEmailAddress" autocomplete="off"/>
                </div>
                
                <div class="emailButtons">
                    <button type="button" class="cancelEmailButton" id="btn_cancel" onclick="login();">برگشت</button>
                    <button type="button" class="sendEmailButton" id="btn_sendEmail" onclick="SendMail($('#pnlForgetPassword'));">ارسال ایمیل</button>
                </div>
            </div>
            <div id="Emailloading">
                <img class="loading-image" src="Images/loading.gif"/>
            </div>
        </div>

        <div class="unselectable footerArea">
            <label class="footerCompany">طراحی و اجرا توسط شرکت برنا گستر طوس</label>
            <label class="footerTel">تلفن پشتیبانی : 57257048 - 051</label>
        </div>
    </form>
<script src="Scripts/loginJS.js"></script>
</body>
</html>
