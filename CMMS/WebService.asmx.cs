using System;
using System.Activities.Expressions;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI.WebControls;
using rijndael;

namespace CMMS
{
    /// <summary>
    /// Summary description for WebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class WebService : System.Web.Services.WebService
    {
        private readonly SqlConnection _cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["CMMS"].ConnectionString);
        private readonly SqlConnection _partsConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["sgdb"].ConnectionString);
        private const string InitVector = "F4568dgbdfgtt444";
        private const string Key = "rdf48JH4";

        [WebMethod]
        public string Authentication(string username, string password)
        {
            if (AdminLogin(username, password))
            {
                return new JavaScriptSerializer().Serialize(new { flag = 1, message = "admin.aspx" });
            }
            if (CheckLicense())
            {
                return new JavaScriptSerializer().Serialize(new { flag = 0, message = "! لطفا با پشتیبان نرم افزار تماس بگیرید" });
            }
            _cnn.Open();
            var selectUser = new SqlCommand("select id ,unit, password , permit , usrlevel  from users where username = '" + username.Trim() + "' ", _cnn);
            var rd = selectUser.ExecuteReader();
            if (!rd.Read()) return new JavaScriptSerializer().Serialize(new { flag = 0, message = "! نام کاربری یا رمز عبور اشتباه است" });
            var permit = Convert.ToInt32(rd["permit"]);
            var userId = Convert.ToInt32(rd["id"]);
            var unit = Convert.ToInt32(rd["unit"]);
            var userLevel = Convert.ToInt32(rd["usrlevel"]);
            var userPassword = rd["password"].ToString();
            _cnn.Close();
            if (permit == 0)
            {
                return new JavaScriptSerializer().Serialize(new { flag = 0, message = "! حساب کاربری شما غیرفعال است" });
            }
            var re = new RijndaelEnhanced(Key, InitVector);
            var decPass = re.Decrypt(userPassword);
            if (decPass != password.Trim()) return new JavaScriptSerializer().Serialize(new { flag = 0, message = "! نام کاربری یا رمز عبور اشتباه است" });
            var ticket = new FormsAuthenticationTicket(1, username.Trim(), DateTime.Now,
                DateTime.Now.AddMinutes(60), false, userId + "," + userLevel+","+unit);
            var cookie1 = new HttpCookie(FormsAuthentication.FormsCookieName,
                FormsAuthentication.Encrypt(ticket));
            HttpContext.Current.Response.Cookies.Add(cookie1);
            return new JavaScriptSerializer().Serialize(new { flag = 1, message = "welcome.aspx" });
        }
        public bool CheckLicense()
        {
            try
            {
                var path = Server.MapPath("bin/License.bls");
                var date = File.ReadAllText(path);
                var rijn = new RijndaelEnhanced(Key, InitVector);
                var expdate = ShamsiCalendar.Shamsi2Miladi(rijn.Decrypt(date));
                var today = DateTime.Now;
                return expdate <= today;
            }
            catch
            {
                return true;
            }
        }

        public bool AdminLogin(string username, string password)
        {
            if (username.Trim() != "administrator" || password.Trim() != "Borna7257048") return false;
            var adminTicket = new FormsAuthenticationTicket(1, username.Trim(), DateTime.Now,
                DateTime.Now.AddMinutes(60), false, "administrator");
            var adminCookie = new HttpCookie(FormsAuthentication.FormsCookieName,
                FormsAuthentication.Encrypt(adminTicket));
            HttpContext.Current.Response.Cookies.Add(adminCookie);
            return true;
        }
        [WebMethod]
        public string SendUserAndPass(string email, string phone)
        {
            _cnn.Open();
            SqlCommand selectuserinfo = new SqlCommand("select username , password , name from users where " +
                                                       "tell ='" + phone + "' AND email='" + email.Trim() + "' ", _cnn);
            SqlDataReader rd = selectuserinfo.ExecuteReader();
            if (rd.Read())
            {
                var forgottenUsername = rd["username"].ToString();
                var re = new RijndaelEnhanced(Key, InitVector);
                var forgottenPassword = re.Decrypt(rd["password"].ToString());
                var nameAndFamily = rd["name"].ToString();
                try
                {
                    var mail = new MailMessage();
                    mail.To.Add(email);
                    mail.From = new MailAddress("borna.assistanse@gmail.com", "اطلاعات حساب کاربری", System.Text.Encoding.UTF8);
                    mail.Subject = "بازیابی نام کاربری و رمز عبور";
                    mail.SubjectEncoding = Encoding.UTF8;
                    var formBody = File.ReadAllText(HttpContext.Current.Server.MapPath("~/Content/forgetPasswordForm.html"));
                    formBody = formBody.Replace("#nameAndFamily#", nameAndFamily);
                    formBody = formBody.Replace("#username#", forgottenUsername);
                    formBody = formBody.Replace("#password#", forgottenPassword);
                    mail.Body = formBody;
                    mail.BodyEncoding = Encoding.UTF8;
                    mail.IsBodyHtml = true;
                    mail.Priority = MailPriority.High;
                    var client = new SmtpClient
                    {
                        Credentials = new System.Net.NetworkCredential("borna.assistanse@gmail.com", "Omid1993"),
                        Port = 587,
                        Host = "smtp.gmail.com",
                        EnableSsl = true
                    };
                    client.Send(mail);
                    return new JavaScriptSerializer().Serialize(new { flag = 1, message = ".نام کاربری و رمز عبور به ایمیل شما ارسال گردید" });
                }
                catch
                {
                    return new JavaScriptSerializer().Serialize(new { flag = 0, message = "!خطا در ارسال ایمیل" });
                }
            }
            return new JavaScriptSerializer().Serialize(new { flag = 0, message = "!هیچ کاربری با مشخصات فوق یافت نشد" });
        }

        [WebMethod]
        public string Send(string name, string phone, string email, string message)
        {
            try
            {
                var mail = new MailMessage();
                mail.To.Add("info@bornatek.ir");
                mail.From = new MailAddress("borna.assistanse@gmail.com", email, System.Text.Encoding.UTF8);
                mail.Subject = name;
                mail.SubjectEncoding = System.Text.Encoding.UTF8;
                var userMessage = File.ReadAllText(HttpContext.Current.Server.MapPath("/Content/contactus.htm"));
                userMessage = userMessage.Replace("#Name#", name);
                userMessage = userMessage.Replace("#Email#", email);
                userMessage = userMessage.Replace("#Phone#", phone);
                userMessage = userMessage.Replace("#Message#", message);
                mail.Body = userMessage;
                mail.BodyEncoding = System.Text.Encoding.UTF8;
                mail.IsBodyHtml = true;
                mail.Priority = MailPriority.High;
                var client = new SmtpClient
                {
                    Credentials = new System.Net.NetworkCredential("borna.assistanse@gmail.com", "Omid1993"),
                    Port = 587,
                    Host = "smtp.gmail.com",
                    EnableSsl = true
                };
                client.Send(mail);
                return "1";
            }
            catch
            {
                return "0";
            }
        }

        [WebMethod]
        public string ToBase64String(string text)
        {
            return Convert.ToBase64String(Encoding.Unicode.GetBytes(text));
        }

        [WebMethod]
        public string FromBase64String(string text)
        {
            return Encoding.Unicode.GetString(Convert.FromBase64String(text));
        }

        [WebMethod]
        public string CheckDuplicateMachineCode(int machinCode , int mid)
        {
            _cnn.Open();
            var checkDuplicate = new SqlCommand("select count(id) from m_machine where code = "+ machinCode + " and id <> "+mid+" ",_cnn);
            return checkDuplicate.ExecuteScalar().ToString();
        }
        [WebMethod]
        public string MachineInfo(string mid , MachineMainInfo minfo)
        {
            _cnn.Open();
            if (Convert.ToInt32(mid) == 0)
            {
                var inserMachInfo = new SqlCommand("INSERT INTO [dbo].[m_machine]([name],[code],[imp],[creator],[insDate],[maModel]," +
                                                   "[startDate],[faz],[loc],[line] ,[pow],[stopcost],[catGroup],[catState]," +
                                                   "[mtbfH],[mtbfD],[mttrH],[mttrD],[selinfo],[supinfo])VALUES " +
                                                   "('" + minfo.Name + "' , '" + minfo.Code + "' , " + minfo.Ahamiyat + " , '" + minfo.Creator +"'" +
                                                   ",'" + minfo.InsDate + "', '" + minfo.Model + "' , '" + minfo.Tarikh + "' , "+minfo.Faz+" " +
                                                   ", '" + minfo.Location +"' ,"+minfo.Line+", '" + minfo.Power + "',"+minfo.StopCostPerHour+" ,"
                                                   + minfo.CatGroup + " , " + minfo.VaziatTajhiz + " ,'" + minfo.MtbfH + "' , '" + minfo.MtbfD + "'," +
                                                   " '" + minfo.MttrH + "' , '" + minfo.MttrD + "' ," +
                                                   " '" + minfo.SellInfo + "' , '" + minfo.SuppInfo + "') SELECT CAST(scope_identity() AS int)", _cnn);
                return inserMachInfo.ExecuteScalar().ToString();
            }
            var updateMachine = new SqlCommand("UPDATE [dbo].[m_machine] " +
                                               "SET[name] = '" + minfo.Name + "' " +
                                               ",[code] = '" + minfo.Code + "' " +
                                               ",[imp] = " + minfo.Ahamiyat + " " +
                                               ",[creator] = '" + minfo.Creator + "' " +
                                               ",[insDate] = '" + minfo.InsDate + "' " +
                                               ",[maModel] = '" + minfo.Model + "' " +
                                               ",[startDate] = '" + minfo.Tarikh + "' " +
                                               ",[loc] = " + minfo.Location + " " +
                                               ",[line] = " + minfo.Line + " " +
                                               ",[faz] = " + minfo.Faz + " " +
                                               ",[pow] = '" + minfo.Power + "' " +
                                               ",[stopcost] = " + minfo.StopCostPerHour + " " +
                                               ",[catGroup] = " + minfo.CatGroup + " " +
                                               ",[catState] = " + minfo.VaziatTajhiz + " " +
                                               ",[mtbfH] = '" + minfo.MtbfH + "' " +
                                               ",[mtbfD] = '" + minfo.MtbfD + "' " +
                                               ",[mttrH] = '" + minfo.MttrH + "' " +
                                               ",[mttrD] = '" + minfo.MttrD + "' " +
                                               ",[selinfo] = '" + minfo.SellInfo + "' " +
                                               ",[supinfo] = '" + minfo.SuppInfo + "' " +
                                               "WHERE id = " + mid + " ", _cnn);
            updateMachine.ExecuteNonQuery();
            _cnn.Close();
            return mid;
        }

        [WebMethod]
        public string SendMasrafi(int mid, MasrafiMain masrafiMain)
        {
            _cnn.Open();
            var insertFuel = new SqlCommand(
                "if (select count(Mid) from m_fuel where Mid = "+mid+") <> 0  " +
                "UPDATE [dbo].[m_fuel] " +
                "SET[length] = '" + masrafiMain.Length + "' " +
                ",[width] = '" + masrafiMain.Width + "' " +
                ",[height] = '" + masrafiMain.Height + "' " +
                ",[weight] = '" + masrafiMain.Weight + "' " +
                ",[ele] = " + masrafiMain.BarghChecked + " " +
                ",[masraf] = '" + masrafiMain.Masraf + "' " +
                ",[voltage] = '" + masrafiMain.Voltage + "' " +
                ",[phase] = '"+ masrafiMain.Phase + "' " +
                ",[cycle] = '" + masrafiMain.Cycle + "' " +
                ",[gas] = " + masrafiMain.GasChecked + " " +
                ",[gasPres] = '" + masrafiMain.GasPressure + "' " +
                ",[air] = " + masrafiMain.AirChecked + " " +
                ",[airPres] = '"+ masrafiMain.AirPressure + "' " +
                ",[fuel] = " + masrafiMain.FuelChecked + " " +
                ",[fuelType] = '" + masrafiMain.FuelType + "' " +
                ",[fueltot] = '" + masrafiMain.FuelMasraf + "' " +
                "WHERE Mid = "+ mid +" " +
                " else " +
                "INSERT INTO [dbo].[m_fuel]([Mid],[length],[width],[height],[weight],[ele],[masraf] " +
                ",[voltage],[phase],[cycle],[gas],[gasPres],[air],[airPres],[fuel],[fuelType],[fueltot]) " +
                "VALUES(" + mid + ",'" + masrafiMain.Length + "','" + masrafiMain.Width + "','" +
                masrafiMain.Height + "','" + masrafiMain.Weight + "'," +
                " " + masrafiMain.BarghChecked + " , '" + masrafiMain.Masraf + "' , '" + masrafiMain.Voltage + "','" +
                masrafiMain.Phase + "','" + masrafiMain.Cycle + "'," +
                " " + masrafiMain.GasChecked + ",'" + masrafiMain.GasPressure + "'," + masrafiMain.AirChecked + ",'" +
                masrafiMain.AirPressure + "'," + masrafiMain.FuelChecked + "" +
                ",'" + masrafiMain.FuelType + "','" + masrafiMain.FuelMasraf + "')", _cnn);
            insertFuel.ExecuteNonQuery();
            _cnn.Close();
            return "";
        }

        [WebMethod]
        public string DeleteControlItem(int controlId)
        {
            _cnn.Open();
            var deleteItems = new SqlCommand("delete from m_control where id ="+controlId+" " +
                                             "delete from p_pmcontrols where idmcontrol = "+controlId+" ", _cnn);
            deleteItems.ExecuteNonQuery();
            _cnn.Close();
            return "";
        }

       
        public void InsertControli(string IdCon,string Tarikh,int Kind,string week,string other)
        {            
            var Pmcontrol =
                new SqlCommand(
                    "IF (SELECT  COUNT(idmcontrol) AS Idm FROM  dbo.p_pmcontrols WHERE  (idmcontrol = " + IdCon + "))=0 " +
                    "begin " +
                    "INSERT INTO [dbo].[p_pmcontrols]([idmcontrol],[act],[tarikh],[kind],[week],[other]) VALUES (" + IdCon + ",0,'" + Tarikh + "',"+ Kind + ","+week+","+other+") end " +
                    "Else if(SELECT  COUNT(idmcontrol) AS Idm FROM  dbo.p_pmcontrols WHERE  (idmcontrol = " + IdCon + "))=1 " +
                    "begin " +
                    " delete from p_pmcontrols where idmcontrol=" + IdCon + " " +
                    "INSERT INTO [dbo].[p_pmcontrols]([idmcontrol],[act],[tarikh],[kind],[week],[other]) VALUES (" + IdCon + ",0,'" + Tarikh + "'," + Kind + "," + week + "," + other + ") end " +
                    "Else if(SELECT  COUNT(idmcontrol) AS Idm FROM  dbo.p_pmcontrols WHERE  (idmcontrol = " + IdCon + "))>1 " +
                    "begin " +
                    " DELETE FROM [dbo].[p_pmcontrols] WHERE id in(SELECT MAX(id) AS ID FROM dbo.p_pmcontrols WHERE (idmcontrol = " + IdCon + "))" +
                    " UPDATE p_pmcontrols SET kind=0,week=NULL,other=NULL where (idmcontrol = " + IdCon + ") " +
                    " INSERT INTO [dbo].[p_pmcontrols]([idmcontrol],[act],[tarikh],[kind],[week],[other]) VALUES (" + IdCon + ",0,'" + Tarikh + "'," + Kind + "," + week + "," + other + ") end ", _cnn);
            Pmcontrol.ExecuteNonQuery();
        }
        [WebMethod]
        public string SendGridControli(int mid, List<Controls> controls)
        {
            _cnn.Open();
            foreach (var item in controls)
            {
                var selectrepeatrow = new SqlCommand(
                    "if(SELECT COUNT(id) AS idd FROM dbo.m_control WHERE (id IN (SELECT DISTINCT idmcontrol AS Idm FROM dbo.p_pmcontrols WHERE (idmcontrol = " + item.Idcontrol + "))))>0  " +
                    "begin UPDATE [dbo].[m_control] SET [contName] ='" + item.Control + "',[period] =" + item.Time + " " +
                    ",[rooz] =" + item.Day + ",[opr] = "+item.Operation+",[MDser] =" + item.MDservice + " ," +
                    "[comment] ='" + item.Comment + "' ,[pmstart] ='" + item.PmDate + "' WHERE id=" + item.Idcontrol +
                    " SELECT '" + item.Idcontrol + "' AS IDc end " +
                    "else begin  INSERT INTO [dbo].[m_control]([Mid],[contName],[period],[rooz],[opr],[pmstart],[MDser],[comment])" +
                    "VALUES(" + mid + ",'" + item.Control + "'," + item.Time + "," + item.Day + ","+item.Operation+"," +
                    "'" + item.PmDate + "'," + item.MDservice + ",'" + item.Comment +
                    "') SELECT CAST(scope_identity() AS nvarchar) end", _cnn);
                string idmcontrol = "";
                idmcontrol = selectrepeatrow.ExecuteScalar().ToString();
                DateTime Compair;
                string mdate = item.PmDate; ;
                int pos = 0;
                string day = "";
                switch (item.Time)
                {
                    case 0: //daily
                        InsertControli(idmcontrol, mdate, item.Time, "NULL", "NULL");
                        break;
                    case 1: //month 
                        if (item.Day < 10)
                        {
                            day = "0"+item.Day.ToString();
                        }
                        else
                        {
                            day = item.Day.ToString();
                        }
                        mdate = item.PmDate;
                        pos = mdate.LastIndexOf("/");
                        mdate = mdate.Substring(0, pos + 1);
                        mdate = mdate + day;
                        Compair = ShamsiCalendar.Shamsi2Miladi(mdate);
                        if (Compair < DateTime.Now)
                        {
                            Compair = Compair.AddMonths(1);
                            mdate = ShamsiCalendar.Miladi2Shamsi(Compair);
                            pos = mdate.LastIndexOf("/");
                            mdate = mdate.Substring(0, pos + 1);
                            mdate = mdate + day;
                        }
                        InsertControli(idmcontrol, mdate, item.Time, "NULL", "NULL");
                        break;
                    case 2: //3month
                        if (item.Day < 10)
                        {
                            day = "0" + item.Day.ToString();
                        }
                        else
                        {
                            day = item.Day.ToString();
                        }
                        mdate = item.PmDate;
                        pos = mdate.LastIndexOf("/");
                        mdate = mdate.Substring(0, pos + 1);
                        mdate = mdate + day;
                        Compair = ShamsiCalendar.Shamsi2Miladi(mdate);
                        if (Compair < DateTime.Now)
                        {
                            Compair = Compair.AddMonths(1);
                            mdate = ShamsiCalendar.Miladi2Shamsi(Compair);
                            pos = mdate.LastIndexOf("/");
                            mdate = mdate.Substring(0, pos + 1);
                            mdate = mdate + day;
                        }
                        InsertControli(idmcontrol, mdate, item.Time, "NULL", "NULL");
                        break;
                    case 3: //6month
                        if (item.Day < 10)
                        {
                            day = "0" + item.Day.ToString();
                        }
                        else
                        {
                            day = item.Day.ToString();
                        }
                        mdate = item.PmDate;
                        pos = mdate.LastIndexOf("/");
                        mdate = mdate.Substring(0, pos + 1);
                        mdate = mdate + day;
                        Compair = ShamsiCalendar.Shamsi2Miladi(mdate);
                        if (Compair < DateTime.Now)
                        {
                            Compair = Compair.AddMonths(1);
                            mdate = ShamsiCalendar.Miladi2Shamsi(Compair);
                            pos = mdate.LastIndexOf("/");
                            mdate = mdate.Substring(0, pos + 1);
                            mdate = mdate + day;
                        }
                        InsertControli(idmcontrol, mdate, item.Time, "NULL", "NULL");
                        break;
                    case 4: //year
                        if (item.Day < 10)
                        {
                            day = "0" + item.Day.ToString();
                        }
                        else
                        {
                            day = item.Day.ToString();
                        }
                        mdate = item.PmDate;
                        pos = mdate.LastIndexOf("/");
                        mdate = mdate.Substring(0, pos + 1);
                        mdate = mdate + day;
                        Compair = ShamsiCalendar.Shamsi2Miladi(mdate);
                        if (Compair < DateTime.Now)
                        {
                            Compair = Compair.AddMonths(1);
                            mdate = ShamsiCalendar.Miladi2Shamsi(Compair);
                            pos = mdate.LastIndexOf("/");
                            mdate = mdate.Substring(0, pos + 1);
                            mdate = mdate + day;
                        }
                        InsertControli(idmcontrol, mdate, item.Time, "NULL", "NULL");
                        break;
                    case 5: //other

                        InsertControli(idmcontrol, mdate, item.Time, "NULL", Convert.ToString(item.Day));
                        break;
                    case 6: //week
                        mdate = item.PmDate;
                        mdate = ShamsiCalendar.Changedayofweek(mdate, item.Day);
                        InsertControli(idmcontrol, mdate, item.Time, Convert.ToString(item.Day), "NULL");
                        break;
                }
            }
            _cnn.Close();
            return "";
        }

        [WebMethod]
        public string SendSubSystem(int mid, List<SubSystems> subSystem)
        {
            _cnn.Open();
            var checkExistSub = new SqlCommand("delete from m_subsystem where Mid = " + mid + " ", _cnn);
            checkExistSub.ExecuteNonQuery();
            foreach (var item in subSystem)
            {
                var insertParts = new SqlCommand(
                    "INSERT INTO [dbo].[m_subsystem](Mid , subId)" +
                    "VALUES(" + mid + "," + item.SubSystemId + ")", _cnn);
                insertParts.ExecuteNonQuery();
            }
            _cnn.Close();
            return "";
        }

        [WebMethod]
        public string DeletePartItem(int partId)
        {
            _cnn.Open();
            var deleteItems = new SqlCommand("delete from m_parts where id =" + partId + " " +
                                             "delete from p_forecast where m_partId = " + partId + " ", _cnn);
            deleteItems.ExecuteNonQuery();
            _cnn.Close();
            return "";
        }

        [WebMethod]
        public string SendGridGhataat(int mid, List<Parts> parts)
        {
            _cnn.Open();
            foreach (var item in parts)
            {
                var insertParts = new SqlCommand(
                    "if(SELECT COUNT(id) AS idd FROM dbo.m_parts WHERE (chPeriod<>'' AND id IN (SELECT DISTINCT m_partId AS Idm FROM dbo.p_forecast WHERE (m_partId = " + item.Id + "))))>0  " +
                    "begin UPDATE [dbo].[m_parts] SET [PartId] ='" + item.PartId + "',[mYear] ='" + item.UsePerYear + "' ,[min] ='" + item.Min + "',[max] ='" + item.Max + "' ," +
                    "[comment] ='" + item.Comment + "' ,[chPeriod] ='" + item.ChangePeriod + "' WHERE id=" + item.Id +
                    " SELECT '" + item.Id + "'+'0' AS IDc end " +
                    "else if(SELECT COUNT(id) AS idd FROM dbo.m_parts WHERE (chPeriod='' AND id ="+item.Id+"))>0  " +
                    "begin UPDATE [dbo].[m_parts] SET [PartId] ='" + item.PartId + "',[mYear] ='" + item.UsePerYear + "' ,[min] ='" + item.Min + "',[max] ='" + item.Max + "' ," +
                    "[comment] ='" + item.Comment + "' ,[chPeriod] ='" + item.ChangePeriod + "' WHERE id=" + item.Id +
                    " SELECT '" + item.Id + "'+'1' AS IDc end " +
                    "else begin  INSERT INTO [dbo].[m_parts]([Mid],[PartId],[mYear],[min],[max],[chPeriod],[comment]) " +
                    "VALUES(" + mid + "," + item.PartId + " ,'" + item.UsePerYear + "','" + item.Min + "'," +
                    "'" + item.Max + "','" + item.ChangePeriod + "','" + item.Comment + "') SELECT CAST(scope_identity() AS nvarchar)+'2' end", _cnn);
                string idmPart = "";
                idmPart = insertParts.ExecuteScalar().ToString();
                string check = idmPart.Substring(idmPart.Length - 1, 1);
                idmPart = idmPart.Substring(0, idmPart.Length - 1);
                switch (check)
                {
                    case "0":
                        if (item.ChangePeriod != "")
                        {
                            var cmdUpdateForeCast =
                                new SqlCommand(
                                    "UPDATE [dbo].[p_forecast] SET [tarikh] ='" + item.ChangePeriod + "' ,[PartId] =" +
                                    item.PartId + " ,[act] = 0  WHERE [m_partId]=" + item.Id + "", _cnn);
                            cmdUpdateForeCast.ExecuteNonQuery();
                        }
                        else
                        {
                            var cmdDeleteForeCast =
                                new SqlCommand(
                                    "delete from [dbo].[p_forecast] WHERE [m_partId]=" + item.Id + "", _cnn);
                            cmdDeleteForeCast.ExecuteNonQuery();
                        }
                        break;
                    case "1":
                        if (item.ChangePeriod != "")
                        {
                            var Insertforecast = new SqlCommand(
                                "INSERT INTO [dbo].[p_forecast]([m_partId],[tarikh],[PartId],[act]) VALUES (" +
                                idmPart + ",'" + item.ChangePeriod + "'," + item.PartId + ",0)", _cnn);
                            Insertforecast.ExecuteNonQuery();
                        }
                        else
                        {
                            var cmdDeleteForeCast =
                                new SqlCommand(
                                    "delete from [dbo].[p_forecast] WHERE [m_partId]=" + item.Id + "", _cnn);
                            cmdDeleteForeCast.ExecuteNonQuery();
                        }
                        break;
                    case "2":
                        if (item.ChangePeriod != "")
                        {
                            var Insertforecast =new SqlCommand(
                                    "INSERT INTO [dbo].[p_forecast]([m_partId],[tarikh],[PartId],[act]) VALUES (" +
                                    idmPart + ",'" + item.ChangePeriod + "'," + item.PartId + ",0)", _cnn);
                            Insertforecast.ExecuteNonQuery();
                        }
                        break;
                }
            }
            _cnn.Close();
            return "";
        }

        [WebMethod]
        public string SendInstru(int mid, List<Instructions> instructions, string dastoor)
        {
            _cnn.Open();
            //if (instructions.Count != 0)
            {
                var checkExistsEnergy = new SqlCommand("delete from m_energy where Mid = "+mid+" ",_cnn);
                checkExistsEnergy.ExecuteNonQuery();
                foreach (var item in instructions)
                {
                    var insertEnergy = new SqlCommand(
                        "INSERT INTO [dbo].[m_energy]([Mid],[tarikh],[mtype],[ap1],[ap2],[ap3],[vp1],[vp2],[vp3],[pf])VALUES" +
                        "(" + mid + ",'" + item.Tarikh + "','" + item.MachineType + "','" + item.AP1 + "','" + item.AP2 +
                        "','" + item.AP3 +
                        "','" + item.VP1 + "'" + ",'" + item.VP2 + "','" + item.VP3 + "','" + item.PF + "')", _cnn);
                    insertEnergy.ExecuteNonQuery();
                }
            }

            if (string.IsNullOrEmpty(dastoor))
            {
                return "";
            }
            var insertInstruct = new SqlCommand(
                "if (select count(Mid) from m_inst where Mid = " + mid + ") <> 0 " +
                "UPDATE [dbo].[m_inst] " +
                "SET[inst] = '"+ dastoor +"' " +
                "WHERE Mid = "+ mid +" " +
                " else " +
                "INSERT INTO [dbo].[m_inst]([Mid],[inst])VALUES" +
                "(" + mid + ",'" + dastoor + "')", _cnn);
            insertInstruct.ExecuteNonQuery();
            _cnn.Close();
            return "";
        }

        [WebMethod]
        public string GetMachineTbl(int mid)
        {
            var minfo = new List<MachineMainInfo>();
            _cnn.Open();
            var getMachInfo = new SqlCommand(
                "SELECT dbo.m_machine.name, dbo.m_machine.code, dbo.m_machine.imp, dbo.m_machine.creator,dbo.m_machine.stopcost, " +
                "dbo.m_machine.insDate, dbo.m_machine.maModel, dbo.m_machine.startDate, dbo.m_machine.pow, " +
                "dbo.m_machine.catGroup, dbo.m_machine.catState, dbo.m_machine.mtbfH, dbo.m_machine.mtbfD, " +
                "dbo.m_machine.mttrH, dbo.m_machine.mttrD, dbo.m_machine.selinfo, dbo.m_machine.supinfo, " +
                "dbo.i_lines.line_name, dbo.i_units.unit_name, dbo.i_faz.faz_name, dbo.m_machine.faz, " +
                "dbo.m_machine.line, dbo.m_machine.loc FROM dbo.m_machine left JOIN " +
                "dbo.i_lines ON dbo.m_machine.line = dbo.i_lines.id left JOIN " +
                "dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code left JOIN " +
                "dbo.i_faz ON dbo.m_machine.faz = dbo.i_faz.id WHERE(dbo.m_machine.id = "+mid+") ", _cnn);
            var rd = getMachInfo.ExecuteReader();
            if (rd.Read())
            {
                minfo.AddRange(new List<MachineMainInfo>
                {
                    new MachineMainInfo
                    {
                        Name = rd["name"].ToString(),
                        Code = rd["code"].ToString(),
                        Ahamiyat = rd["imp"].ToString(),
                        Creator = rd["creator"].ToString(),
                        InsDate = rd["insDate"].ToString(),
                        Model = rd["maModel"].ToString(),
                        Tarikh = rd["startDate"].ToString(),
                        Line = Convert.ToInt32(rd["line"]),
                        LineName = rd["line_name"].ToString(),
                        Faz = Convert.ToInt32(rd["faz"]),
                        FazName = rd["faz_name"].ToString(),
                        Location = rd["loc"].ToString(),
                        LocationName = rd["unit_name"].ToString(),
                        Power = rd["pow"].ToString(),
                        StopCostPerHour = Convert.ToInt32(rd["stopcost"]),
                        CatGroup = Convert.ToInt32(rd["catGroup"]),
                        VaziatTajhiz = Convert.ToInt32(rd["catState"]),
                        MtbfH = Convert.ToInt32(rd["mtbfH"].ToString()),
                        MtbfD = Convert.ToInt32(rd["mtbfD"]),
                        MttrH = Convert.ToInt32(rd["mttrH"]),
                        MttrD = Convert.ToInt32(rd["mttrD"]),
                        SellInfo = rd["selinfo"].ToString(),
                        SuppInfo = rd["supinfo"].ToString()
                    }
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(minfo);
        }

        [WebMethod]
        public string GetMasrafiTbl(int mid)
        {
            var masrafiList = new List<MasrafiMain>();
            _cnn.Open();
            var getSookht = new SqlCommand(
                "select [Mid],[length],[width],[height],[weight],[ele],[masraf],[voltage],[phase]," +
                "[cycle],[gas],[gasPres],[air],[airPres],[fuel],[fuelType],[fueltot] from m_fuel where Mid = " + mid +
                " ", _cnn);
            var rdS = getSookht.ExecuteReader();
            if (rdS.Read())
            {
                masrafiList.AddRange(new List<MasrafiMain>()
                {
                    new MasrafiMain()
                    {
                        Length = rdS["length"].ToString(),
                        Width = rdS["width"].ToString(),
                        Height = rdS["height"].ToString(),
                        Weight = rdS["weight"].ToString(),
                        BarghChecked = Convert.ToInt32(rdS["ele"]),
                        Masraf = rdS["masraf"].ToString(),
                        Voltage = rdS["voltage"].ToString(),
                        Phase = rdS["phase"].ToString(),
                        Cycle = rdS["cycle"].ToString(),
                        GasChecked = Convert.ToInt32(rdS["gas"]),
                        GasPressure = rdS["gasPres"].ToString(),
                        AirChecked = Convert.ToInt32(rdS["air"]),
                        AirPressure = rdS["airPres"].ToString(),
                        FuelChecked = Convert.ToInt32(rdS["fuel"]),
                        FuelType = rdS["fuelType"].ToString(),
                        FuelMasraf = rdS["fueltot"].ToString()
                    }
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(masrafiList);
        }

        [WebMethod]
        public string GetC(int mid)
        {
            var controliList = new List<Controls>();
            _cnn.Open();
            var getControls =
                new SqlCommand("SELECT [id],[contName],[period],[rooz],[pmstart],[opr],[MDser],[comment]FROM [dbo].[m_control] where Mid = " + mid+"", _cnn);
            var rd = getControls.ExecuteReader();
            while (rd.Read())
            {
                controliList.AddRange(new List<Controls>
                {
                    new Controls
                    {
                        Idcontrol = Convert.ToInt32(rd["id"]),
                        Control = rd["contName"].ToString(),
                        Time = Convert.ToInt32(rd["period"]),
                        Day = Convert.ToInt32(rd["rooz"]),
                        MDservice = Convert.ToInt32(rd["MDser"]),
                        Operation = Convert.ToInt32(rd["opr"]),
                        PmDate = Convert.ToString(rd["pmstart"]),
                        Comment = rd["comment"].ToString()
                    }
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(controliList);
        }

        [WebMethod]
        public string GetSubSystems(int mid)
        {
            var subSystemList = new List<SubSystems>();
            _cnn.Open();
            var subs = new SqlCommand("SELECT dbo.subsystem.name, dbo.m_subsystem.subId FROM " +
                                      "dbo.subsystem INNER JOIN dbo.m_subsystem ON dbo.subsystem.id " +
                                      "= dbo.m_subsystem.subId WHERE(dbo.m_subsystem.Mid = "+mid+")",_cnn);
            var rd = subs.ExecuteReader();
            while (rd.Read())
            {
                subSystemList.AddRange(new List<SubSystems>()
                {
                    new SubSystems(){SubSystemId = Convert.ToInt32(rd["subId"]) , SubSystemName = rd["name"].ToString()}
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(subSystemList);
        }

        [WebMethod]
        public string GetG(int mid)
        {
            _cnn.Open();
            var partsList = new List<Parts>();
            var getParts =
                new SqlCommand(
                    "SELECT id,m_parts.PartId,Part.PartName,mYear,min,max,chPeriod,m_parts.comment FROM CMMS.dbo.m_parts" +
                    " inner join sgdb.inv.Part on Part.Serial = m_parts.PartId where Mid = " + mid + " ", _cnn);
            var rd = getParts.ExecuteReader();
            while (rd.Read())
            {
                partsList.AddRange(new List<Parts>
                {
                    new Parts
                    {
                        Id = Convert.ToInt32(rd["id"]),
                        PartId = Convert.ToInt32(rd["PartId"]),
                        PartName = rd["PartName"].ToString(),
                        UsePerYear = rd["mYear"].ToString(),
                        ChangePeriod = rd["chPeriod"].ToString(),
                        Min = rd["min"].ToString(),
                        Max =rd["max"].ToString(),
                        Comment = rd["comment"].ToString()
                    }
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(partsList);
        }

        [WebMethod]
        public string GetEnergy(int mid)
        {
            var energyList = new List<Instructions>();
            _cnn.Open();
            var selectDastoor = new SqlCommand("select inst from m_inst where Mid = " + mid + " ",_cnn);
            var i = selectDastoor.ExecuteScalar();
            if (i == null)
            {
                goto NoInstruction;
            }
            energyList.Add(new Instructions(){Dastoor = i.ToString()});
            var selectEnergy = new SqlCommand("select [tarikh],[mtype],[ap1],[ap2],[ap3],[vp1],[vp2],[vp3],[pf] from m_energy where Mid = " + mid + " ", _cnn);
            var rdd = selectEnergy.ExecuteReader();
            while (rdd.Read())
            {
                energyList.AddRange(new List<Instructions>
                {
                    new Instructions
                    {
                        Tarikh = rdd["tarikh"].ToString(),MachineType = rdd["mtype"].ToString(),AP1 = rdd["ap1"].ToString(),
                        AP2 = rdd["ap2"].ToString(),AP3 = rdd["ap3"].ToString(),VP1 = rdd["vp1"].ToString(),VP2 = rdd["vp2"].ToString(),
                        VP3 = rdd["vp3"].ToString(),PF = rdd["pf"].ToString()
                    }
                });
            }
            NoInstruction:
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(energyList);
        }

        [WebMethod]
        public string ContratorInfo(int cid)
        {
            var contList = new List<ContractorInfo>();
            _cnn.Open();
            var selectCont = new SqlCommand("SELECT [name],[webmail],[address],[phone],[tell],[fax],[permit],[comment]FROM [dbo].[i_contractor] where id = "+cid+" ",_cnn);
            var rd = selectCont.ExecuteReader();
            if (rd.Read())
            {
                contList.AddRange(new List<ContractorInfo>()
                {
                    new ContractorInfo()
                    {
                        Name = rd["name"].ToString() , Mail = rd["webmail"].ToString(),Address = rd["address"].ToString(),
                        Phone = rd["tell"].ToString(),Mobile = rd["phone"].ToString(),Fax = rd["fax"].ToString(),Permit = Convert.ToInt32(rd["permit"]),
                        Comment = rd["comment"].ToString()
                    }
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(contList);
        }

        [WebMethod]
        public string FillToolTable()
        {
            var drItemsList = new List<ToolsTableItems>();
            _cnn.Open();
            var drItems = new SqlCommand("select id , code , name from subsystem",_cnn);
            var rd = drItems.ExecuteReader();
            while (rd.Read())
            {
                drItemsList.AddRange(new List<ToolsTableItems>()
                {
                    new ToolsTableItems(){ToolName = rd["name"].ToString() , ToolCode = rd["code"].ToString(),ToolId = rd["id"].ToString()}
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(drItemsList);
        }

        [WebMethod]
        public string NewTool(string toolName , string toolCode)
        {
           _cnn.Open();
            var insertTool = new SqlCommand("insert into subsystem (name,code)values('" + toolName + "' , '" + toolCode + "')", _cnn);
            insertTool.ExecuteNonQuery();
            _cnn.Close();
            return "1";
        }

        [WebMethod]
        public string EditSubSystem(string name , string code , string editCode)
        {
            _cnn.Open();
            var updateSub = new SqlCommand("UPDATE [dbo].[subsystem] SET [name] = '"+name+"',[code] ='"+code+"'  WHERE code = "+editCode+" ",_cnn);
            updateSub.ExecuteNonQuery();
            _cnn.Close();
            return "";
        }

        [WebMethod]
        public void DeleteSubSystem(int subcode)
        {
            _cnn.Open();
            var del = new SqlCommand("delete from subsystem where code = "+subcode+" ",_cnn);
            del.ExecuteNonQuery();
        }

        [WebMethod]
        public string GetRequestDetails(int reqId)
        {
            _cnn.Open();
            var reqDetList = new List<RequestDetails>();
            var reqDetails = new SqlCommand("if (select r_request.type_repair from r_request where r_request.req_id = " + reqId + ") = 1 begin " +
                                            "SELECT dbo.m_machine.name, dbo.m_machine.code, case when dbo.subsystem.name is null then '____' else dbo.subsystem.name end as subname," +
                                            "case when dbo.subsystem.id is null then -1 else dbo.subsystem.id end as subid,r_request.req_id, " +
                                            "dbo.i_units.unit_name, CASE WHEN r_request.type_fail = 1 THEN 'مکانیکی' WHEN r_request.type_fail = 2 THEN 'تاسیساتی-الکتریکی' " +
                                            "WHEN r_request.type_fail = 3 THEN 'الکتریکی واحد برق' ELSE 'غیره' END AS Tfail, r_request.req_name, " +
                                            "CASE WHEN r_request.type_req = 1 THEN 'اضطراری' WHEN r_request.type_req = 2 THEN 'پیش بینانه' ELSE 'پیش گیرانه' END AS Treq, " +
                                            "dbo.r_request.comment, dbo.r_request.date_req + '_' + dbo.r_request.time_req as time ,dbo.r_request.time_req,dbo.r_request.date_req " +
                                            "FROM dbo.r_request INNER JOIN dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id INNER JOIN " +
                                            "dbo.i_units ON dbo.r_request.unit_id = dbo.i_units.unit_code left JOIN dbo.subsystem ON dbo.r_request.subid = dbo.subsystem.id where req_id = " + reqId + " " +
                                            "end else begin SELECT dbo.i_units.unit_name,r_request.req_id, dbo.r_request.other_machine as name, '___' as code, '___' as subname,0 as subid, " +
                                            "CASE WHEN r_request.type_fail = 1 THEN 'مکانیکی' WHEN r_request.type_fail = 2 " +
                                            "THEN 'تاسیساتی-الکتریکی' WHEN r_request.type_fail = 3 THEN 'الکتریکی واحد برق' ELSE 'غیره' END AS Tfail, r_request.req_name, " +
                                            "CASE WHEN r_request.type_req = 1 THEN 'اضطراری' WHEN r_request.type_req = 2 THEN 'پیش بینانه' ELSE 'پیش گیرانه' END AS Treq, " +
                                            "dbo.r_request.comment, dbo.r_request.date_req + '_' + dbo.r_request.time_req as time,dbo.r_request.time_req,dbo.r_request.date_req FROM dbo.r_request INNER JOIN " +
                                            "dbo.i_units ON dbo.r_request.unit_id = dbo.i_units.unit_code where req_id = " + reqId + " end", _cnn);
            var rd = reqDetails.ExecuteReader();
            if (rd.Read())
            {
                reqDetList.AddRange(new List<RequestDetails>
                {
                    new RequestDetails
                    {
                        MachineName = rd["name"].ToString() , MachineCode = rd["code"].ToString(),SubName = rd["subname"].ToString(),
                        UnitName = rd["unit_name"].ToString(),FailType = rd["Tfail"].ToString(),NameRequest = rd["req_name"].ToString(),SubId = Convert.ToInt32(rd["subid"]),
                        RequestType = rd["Treq"].ToString(),Comment = rd["comment"].ToString(),Time = rd["time"].ToString(),RequestNumber = rd["req_id"].ToString(),
                        RequestDate = rd["date_req"].ToString(),RequestTime = rd["time_req"].ToString()
                    }
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(reqDetList);
        }

        [WebMethod]
        public string RequestStateDifinition(PartRequest d ,List<int> parts)
        {
            _cnn.Open();
            var stateDifinition = new SqlCommand("if (select "+d.State+ ") = 2 or (select " + d.State + ") = 3" +
                                                 "begin UPDATE[dbo].[r_request] SET[state] = " + d.State + " WHERE req_id = "+d.RequestId+" " +
                                                 "end else begin delete from r_request where req_id = " + d.RequestId+" end",_cnn);
            stateDifinition.ExecuteNonQuery();
            if (d.State != 3) return "";
            var deleteAllReq = new SqlCommand("DELETE FROM [dbo].[r_reqwaitpart] where id_wait = (select id from r_partwait where req_id = " + d.RequestId + ") " +
                                              "DELETE FROM [dbo].[r_partwait] WHERE req_id = "+d.RequestId+"", _cnn);
            deleteAllReq.ExecuteNonQuery();
            var insertPartRequest = new SqlCommand("INSERT INTO [dbo].[r_partwait]([req_id],[info],[date_reqbuy],[num_reqbuy],[delivery_date])" +
                                                   "VALUES("+d.RequestId+",'"+d.Info+"','"+d.BuyRequestDate+"','"+d.BuyRequestNumber+"',NULL)" +
                                                   "SELECT CAST(scope_identity() AS int)", _cnn);
            var id = insertPartRequest.ExecuteScalar();
            foreach (var p in parts)
            {
                var inserParts = new SqlCommand("INSERT INTO [dbo].[r_reqwaitpart]([id_wait],[part_id])" +
                                                "VALUES("+id+","+p+")",_cnn);
                inserParts.ExecuteNonQuery();
            }
            _cnn.Close();
            return "";
        }
        [WebMethod]
        public string PartsFilter(string partName)
        {
            var farsiPart1 = partName.Replace("ک", "ك").Replace("ی", "ي").Replace("ة", "ه");
            var farsiPart2 = partName.Replace("ك", "ک").Replace("ي", "ی").Replace("ه", "ة");
            _partsConnection.Open();
            var filteredPartList = new List<PartsFilter>(); 
             var parts = new SqlCommand("select Serial ,PartName from inv.Part where PartName like '%"+ farsiPart1 + "%' OR " +
                                        "PartName like '%" + farsiPart2 + "%' OR PartName like '%" + partName + "%'", _partsConnection);
            var read = parts.ExecuteReader();
            while (read.Read())
            {
                filteredPartList.Add(new PartsFilter()
                {
                    PartName = read["PartName"].ToString().Replace("ك", "ک").Replace("ي", "ی"),
                    PartId = Convert.ToInt32(read["Serial"])
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(filteredPartList);
        }

        [WebMethod]
        public string FilteredGridSubSystem(string subSystemName)
        {
            var filteredSubList = new List<ToolsTableItems>();
            var sub1 = subSystemName.Replace("ک", "ك").Replace("ی", "ي");
            var sub2 = subSystemName.Replace("ك", "ک").Replace("ي", "ی").Replace("ﯼ", "ی").Replace("ى", "ی").Replace("ة", "ه");
            _cnn.Open();
            var subsystems = new SqlCommand("select id , name from subsystem " +
                                                 "where name like N'%" + sub1 + "%'" +
                                                 " OR name like N'%" + sub2 + "%' " +
                                                 " OR name like N'%" + subSystemName + "%'", _cnn);
            var rd = subsystems.ExecuteReader();
            while (rd.Read())
            {
                filteredSubList.Add(new ToolsTableItems{ToolName = rd["name"].ToString(), ToolId = rd["id"].ToString()});
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(filteredSubList);
        }

        [WebMethod]
        public string GetMachineTooltipData()
        {
            var unitList = new List<Units>();
            var machineList = new List<Machines>();
            _cnn.Open();
            var selectUnits = new SqlCommand("select unit_code , unit_name from i_units",_cnn);
            var rd = selectUnits.ExecuteReader();
            while (rd.Read())
            {
                unitList.Add(new Units(){UnitName = rd["unit_name"].ToString(),UnitCode = rd["unit_code"].ToString()});
            }
            _cnn.Close();
            _cnn.Open();
            var selectMachines = new SqlCommand("select DeviceName , DeviceCode from i_devices ", _cnn);
            var rdd = selectMachines.ExecuteReader();
            while (rdd.Read())
            {
                machineList.Add(new Machines() { MachineName = rdd["DeviceName"].ToString(), MachineCode = rdd["DeviceCode"].ToString() });
            }
            var data = new
            {
                UnitData = unitList ,MachineData = machineList
            };
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(data);
        }

        [WebMethod]
        public string GetLatestMachineCode(int machineCode)
        {
            _cnn.Open();
            var selectCode = new SqlCommand("if (SELECT count(code) FROM [dbo].[m_machine] where code like '"+ machineCode + "%') <> 0 "+
                                            "begin SELECT max(code + 1) FROM[dbo].[m_machine] where code like '" + machineCode + "%' end else begin select '' end", _cnn);
            var code = selectCode.ExecuteScalar();
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(code);
        }

        [WebMethod]
        public string CheckDuplicateToolName(string subSystemName , int editCode)
        {
            _cnn.Open();
            var nameList = new List<string>();
            var sub1 = subSystemName.Replace("ک", "ك").Replace("ی", "ي");
            var sub2 = subSystemName.Replace("ك", "ک").Replace("ي", "ی").Replace("ﯼ", "ی").Replace("ى", "ی").Replace("ة", "ه");
            var selectName = new SqlCommand("select name from subsystem where " +
                                            "(name like N'%" + subSystemName + "%' OR " +
                                            "name like N'%" + sub1 + "%' OR " +
                                            "name like N'%" + sub2 + "%') AND code <> "+editCode+" ", _cnn);
            var rd = selectName.ExecuteReader();
            while (rd.Read())
            {
                nameList.Add(rd["name"].ToString());
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(nameList);
        }

        [WebMethod]
        public string CheckDuplicateToolCode(string subSystemCode , int editCode)
        {
            _cnn.Open();
            var selectCode = new SqlCommand("select code from subsystem where code = '"+subSystemCode+"' AND code <> '"+editCode+"' ", _cnn);
            var code = selectCode.ExecuteScalar();
            if (code != null)
            {
                return new JavaScriptSerializer().Serialize("1");
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize("");
        }

        [WebMethod]
        public string LatestSubSystemTagNumber(int subSystemId)
        {
            _cnn.Open();
            var latestSubtag = new SqlCommand("if(select count(id) from s_subtag where subid = " + subSystemId + ") = 0 begin select 101 end " +
                                              "else begin select max(tag + 1) FROM[dbo].[s_subtag] where subid = " + subSystemId + " end  ",_cnn);
            return latestSubtag.ExecuteScalar().ToString();
        }

        [WebMethod]
        public string PartsRepairRecord(RepairRecords data)
        {
            _cnn.Open();
            var historyId = 0;
            foreach (var item in data.RecordInfo)
            {
                var insertInfo = new SqlCommand("INSERT INTO [dbo].[s_subhistory]([tagid],[rep_num],[info_rep],[comment]," +
                                                "[new_unit],[new_line],[rec_unit],[rec_line],[tarikh],[CR])VALUES" +
                                                "(" + item.TagId + "," + item.RepairNumber + ",'" + item.RepairExplain + "','" + item.Comment + "'" +
                                                "," + item.NewUnit + "," + item.NewLine + "," + item.RecentlyUnit + "," + item.RecentlyLine + "," +
                                                "'" + item.Tarikh + "'," + item.Cr + ") SELECT CAST(scope_identity() AS int)", _cnn);
                historyId = Convert.ToInt32(insertInfo.ExecuteScalar());
            }
            foreach (var part in data.Parts)
            {
                var insertParts = new SqlCommand("INSERT INTO [dbo].[s_subtools]([id_reptag],[tools_id],[count])VALUES" +
                                                 "(" + historyId + ",'" + part.Part + "'," + part.Count + ")", _cnn);
                insertParts.ExecuteNonQuery();
            }
            foreach (var personel in data.Repairers)
            {
                var insertPersonel = new SqlCommand("INSERT INTO [dbo].[s_subpersonel]([id_reptag],[per_id],[time_work])VALUES" +
                                                    "(" + historyId + "," + personel.Repairer + ",'" + personel.RepairTime + "')", _cnn);
                insertPersonel.ExecuteNonQuery();
            }
            foreach (var contractor in data.Contractors)
            {
                var insertContractors = new SqlCommand("INSERT INTO [dbo].[s_subcontract]([id_reptag],[contract_id],[cost])VALUES" +
                                                       "(" + historyId + "," + contractor.Contractor + ",'" + contractor.Cost + "')", _cnn);
                insertContractors.ExecuteNonQuery();
            }
            var selectRepNum = new SqlCommand("SELECT case when COUNT(rep_num)= 0 then  100  else MAX(rep_num)+1 end as id FROM s_subhistory", _cnn);
            _cnn.Close();
            return selectRepNum.ExecuteScalar().ToString();
        }

        [WebMethod]
        public string ReplyDataToDb(ReplyData obj)
        {
            _cnn.Open();
            var replyId = 0;
            //============Request Time
            var requestTime = obj.ReplyInfo[0].RequestTime;
            var reqestDate = obj.ReplyInfo[0].RequestDate;
            reqestDate = reqestDate + " " + requestTime;
            var Rq = ShamsiCalendar.Shamsi2Miladi(reqestDate);
            //============Repair Time
            var startdate = obj.ReplyInfo[0].StartDate;
            var starttime = obj.ReplyInfo[0].StartTime;
            startdate = startdate + " " + starttime;
            var SRep = ShamsiCalendar.Shamsi2Miladi(startdate);
            //============Finish Time
            var enddate = obj.ReplyInfo[0].EndDate;
            var endtime = obj.ReplyInfo[0].EndTime;
            enddate = enddate + " " + endtime;
            var Erep = ShamsiCalendar.Shamsi2Miladi(enddate);

            //Define varieble
            int Cday = 0;
            int point = 0;

            //Calcute Delay Time
            TimeSpan delayTime;
            delayTime = SRep.Subtract(Rq);
            DateTime help_delay = Convert.ToDateTime("1900/01/01");
            help_delay = help_delay.Add(delayTime);
            //===========Calcute Repair Time
            TimeSpan Repair_time;

            Repair_time = Erep.Subtract(SRep);//End-Start Repair
            DateTime helprepair = Convert.ToDateTime("1900/01/01");
            helprepair = helprepair.Add(Repair_time);
            var TRep = Convert.ToString(Repair_time);
            point = TRep.IndexOf(".");
            if (point != -1)
            {
                Cday = Convert.ToInt32(TRep.Substring(0, point));
                Cday *= 24;
                Cday += Convert.ToInt32(TRep.Substring(point + 1, 2));
                TRep = Convert.ToString(Cday) + TRep.Substring(point + 3, 3);
            }
            else
            {
                TRep = TRep.Substring(0, 5);
            }
            //==========Calcute Stop Time
            TimeSpan Stop_time;
            Stop_time = Erep.Subtract(Rq);//End-Request time
            DateTime helpStop = Convert.ToDateTime("1900/01/01");
            helpStop = helpStop.Add(Stop_time);
            var StopR = Convert.ToString(Stop_time);
            point = StopR.IndexOf(".");
            if (point != -1)
            {
                Cday = Convert.ToInt32(StopR.Substring(0, point));
                Cday *= 24;
                Cday += Convert.ToInt32(StopR.Substring(point + 1, 2));
                StopR = Convert.ToString(Cday) + StopR.Substring(point + 3, 3);
            }
            else
            {
                StopR = StopR.Substring(0, 5);
            }
            //=============decide to state
            switch (obj.ReplyInfo[0].State)
            {
                case 1:
                    StopR = "00:00";
                    //TRep without change
                    break;
                case 2:
                    StopR = "00:00";
                    //TRep without change 
                    break;
                case 3:
                    //Trep and StopR without change
                    break;
                case 4:
                    {
                        StopR = TRep;
                        //TRep without change 
                        break;
                    }
                    
            }
            //Calcute MTBF 
            var selectpreviousrep = new SqlCommand("SELECT        MAX(end_repdate) AS Tmax" +
                                                   " FROM(SELECT        dbo.m_machine.name, dbo.m_machine.code, dbo.r_reply.start_repdate, dbo.r_reply.end_repdate" +
                                                   " FROM            dbo.r_request INNER JOIN" +
                                                   " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id INNER JOIN" +
                                                   " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq" +
                                                   " WHERE(dbo.r_request.machine_code =(SELECT        m_machine_1.id" +
                                                   " FROM            dbo.r_request AS r_request_1 INNER JOIN" +
                                                   " dbo.m_machine AS m_machine_1 ON r_request_1.machine_code = m_machine_1.id" +
                                                   " WHERE(r_request_1.req_id = " + obj.ReplyInfo[0].RequestId + "))) AND(dbo.r_reply.stop_time <> '00:00')) AS i", _cnn);
            string lastRep = selectpreviousrep.ExecuteScalar().ToString();
            int MTBF = 0;
            if (StopR != "00:00" && lastRep!="")
            {
                var calcuteMttr = new SqlCommand("select  DATEDIFF(day, '" + lastRep + "', '" + obj.ReplyInfo[0].StartDate + "') AS MTBF", _cnn);
                MTBF = Convert.ToInt32(calcuteMttr.ExecuteScalar());
            }
            else
            {
                MTBF = 0;
            }
            //=============insert
            var ElecT = "0";
            var MechT = "0";
            if (obj.ReplyInfo[0].Electime != "")
            {
                ElecT = obj.ReplyInfo[0].Electime;
            }
            
            if (obj.ReplyInfo[0].Mechtime != "")
            {
                MechT = obj.ReplyInfo[0].Mechtime;
            }

            var insertInfo = new SqlCommand("INSERT INTO [dbo].[r_reply]([idreq],[rep_state],[info_rep],[start_repdate]" +
                                            ",[start_reptime],[end_repdate],[end_reptime],[rep_time],[stop_time],[mtbf],[subsystem],[rep_time_help],[stop_time_help],[elec_time],[mech_time],[delay_time])VALUES" +
                                            "("+obj.ReplyInfo[0].RequestId+","+ obj.ReplyInfo[0].State+ ",'"+ obj.ReplyInfo[0].Comment+ "'" +
                                            ",'"+ obj.ReplyInfo[0].StartDate+ "','"+ obj.ReplyInfo[0].StartTime+ "','"+ obj.ReplyInfo[0].EndDate+ "'" +
                                            ",'"+ obj.ReplyInfo[0].EndTime+ "','"+TRep+"','"+StopR+"',"+MTBF+","+ obj.ReplyInfo[0].SubSystem+ ",'"+helprepair+"','"+helpStop+"',"+ ElecT + "," + MechT + ",'"+help_delay+"') SELECT CAST(scope_identity() AS int)", _cnn);
            replyId = Convert.ToInt32(insertInfo.ExecuteScalar());

            foreach (var fail in obj.FailReason)
            {
                var insertFails = new SqlCommand("INSERT INTO [dbo].[r_rfail]([id_rep],[fail_id])VALUES" +
                                                 "("+replyId+","+fail.FailReasonId+")",_cnn);
                insertFails.ExecuteNonQuery();
            }

            foreach (var delay in obj.DelayReason)
            {
                var insertDelay = new SqlCommand("INSERT INTO [dbo].[r_rdelay]([id_rep],[delay_id])VALUES" +
                                                 "("+replyId+","+delay.DelayReasonId+")",_cnn);
                insertDelay.ExecuteNonQuery();
            }

            foreach (var action in obj.Action)
            {
                var insertAction = new SqlCommand("INSERT INTO [dbo].[r_action]([id_rep],[act_id])VALUES" +
                                                  "("+replyId+","+action.ActionId+")",_cnn);
                insertAction.ExecuteNonQuery();
            }

            foreach (var prt in obj.PartChange)
            {
                var insertpart =new SqlCommand("INSERT INTO [dbo].[r_helppart]([rep_id],[mid],[sub_id],[part_id])" +
                                               "VALUES(" + replyId + ","+prt.Machine+","+prt.Sub+","+prt.Part+")", _cnn);
                insertpart.ExecuteNonQuery();
            }

            foreach (var part in obj.Parts)
            {
                var insertParts = new SqlCommand("INSERT INTO [dbo].[r_tools]([id_rep],[tools_id],[count])VALUES" +
                                                 "("+replyId+","+part.Part+","+part.Count+")",_cnn);
                insertParts.ExecuteNonQuery();
            }

            foreach (var person in obj.Personel)
            {
                var insertPersonel = new SqlCommand("INSERT INTO [dbo].[r_personel]([id_rep],[per_id],[time_work])VALUES" +
                                                    "("+replyId+","+person.Repairer+",'"+person.RepairTime+"')",_cnn);
                insertPersonel.ExecuteNonQuery();
            }

            foreach (var cont in obj.Contractors)
            {
                var insertCont = new SqlCommand("INSERT INTO [dbo].[r_contract]([id_rep],[contract_id],[cost])VALUES" +
                                                "("+replyId+","+cont.Contractor+",'"+cont.Cost+"')",_cnn);
                insertCont.ExecuteNonQuery();
            }
            var updateRequestState = new SqlCommand("UPDATE [dbo].[r_request] SET [state] = 4 where req_id = "+obj.ReplyInfo[0].RequestId+" ", _cnn);
            updateRequestState.ExecuteNonQuery();

            var listforecast = new List<ForeCastList>();
            var cmdsearchpartCm = new SqlCommand(" SELECT dbo.p_forecast.PartId, dbo.p_forecast.tarikh, dbo.p_forecast.m_partId, dbo.p_forecast.id, sgdb.inv.Part.PartName " +
                                                 " FROM dbo.p_forecast INNER JOIN sgdb.inv.Part ON dbo.p_forecast.PartId = sgdb.inv.Part.Serial " +
                                                 " WHERE (dbo.p_forecast.act = 0) AND (dbo.p_forecast.tarikh <> '" + obj.ReplyInfo[0].StartDate + "') AND (dbo.p_forecast.PartId IN " +
                                                 " (SELECT tools_id FROM dbo.r_tools WHERE (id_rep = " + replyId + "))) AND (dbo.p_forecast.m_partId IN " +
                                                 " (SELECT dbo.m_parts.id FROM dbo.m_machine INNER JOIN dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code " +
                                                 " INNER JOIN dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN dbo.m_parts ON dbo.m_machine.id = dbo.m_parts.Mid WHERE " +
                                                 " (dbo.r_reply.id = " + replyId + ")))", _cnn);
            var r = cmdsearchpartCm.ExecuteReader();
            while (r.Read())
            {
                listforecast.Add(new ForeCastList()
                {
                    ForeCastId = Convert.ToInt32(r["id"]),PartId = Convert.ToInt32(r["PartId"]),PartName = r["PartName"].ToString(),
                    CmDate = r["tarikh"].ToString(),MachineId = Convert.ToInt32(r["m_partId"]),ReplyDate = obj.ReplyInfo[0].StartDate
                });
            }
            _cnn.Close();
            _cnn.Open();
            var uppartwait=new SqlCommand(" UPDATE [dbo].[r_partwait] SET [r_partwait].[delivery_date] = dbo.r_reply.start_repdate "+
                                          " FROM            dbo.r_reply INNER JOIN "+
                                          " dbo.r_partwait ON dbo.r_reply.idreq = dbo.r_partwait.req_id "+
                                          " WHERE(dbo.r_reply.idreq = " + obj.ReplyInfo[0].RequestId + ")", _cnn);
            uppartwait.ExecuteNonQuery();
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(listforecast);
        }

        [WebMethod]
        public string SubmitReplyForcast(PartForeCastChange obj)
        {
            _cnn.Open();
            foreach (var fail in obj.FailReasonList)
            {
                var insertfails = new SqlCommand("INSERT INTO [dbo].[p_forcastFail]([id_forecast],[fail_id])VALUES" +
                                                 "("+obj.ForeCastId+","+fail+")", _cnn);
                insertfails.ExecuteNonQuery();
            }
            var inserPforecast = new SqlCommand("INSERT INTO [dbo].[p_forecast]([m_partId],[tarikh],[PartId],[act])VALUES" +
                                                "("+obj.MachineId+",'"+obj.Tarikh+"',"+obj.PartId+",0)", _cnn);
            inserPforecast.ExecuteNonQuery();
            var updatePforecast = new SqlCommand("UPDATE [dbo].[p_forecast]SET [tarikh] = '"+obj.ReplyDate+"'" +
                                                 ",[act] = 1 ,[inforeason] = '"+obj.Info+"' WHERE id = "+obj.ForeCastId+" ", _cnn);
            updatePforecast.ExecuteNonQuery();
            _cnn.Close();
            return "";
        }

        [WebMethod]
        public string ReplyDataFromDb(int requestId)
        {
            _cnn.Open();
            var replyInfo = new ReplyInfo();
            var failList = new List<FailReason>();
            var delayList = new List<DelayReason>();
            var actionList = new List<Action>();
            var partsList = new List<PartsRepairRecords>();
            var changedParts=  new List<PartChanges>();
            var personelList = new List<RepairerOfRepairRedords>();
            var contractorList = new List<ContractorsOfRepairRecords>();
            var replyId = 0;
            var selectReplyInfo = new SqlCommand("SELECT r_reply.id,[idreq]," +
                                                 " case when rep_state = 1 then 'تعمیرات معمول بدون توقف دستگاه'" +
                                                 " when rep_state = 2 then 'تعمیرات در حالت خواب دستگاه'" +
                                                 " when rep_state = 3 then 'از کار افتادن خط تولید یا دستگاه در لحظه درخواست' " +
                                                 "when rep_state = 4 then 'ادامه فعالیت دستگاه تا رسیدن قطعه یا تامین نیرو'" +
                                                 " end as rep_state ,[info_rep],[start_repdate],[start_reptime], [end_repdate],[end_reptime]," +
                                                 "[elec_time],[mech_time],[rep_time],[stop_time],subsystem.name as subsystem FROM [dbo].[r_reply]" +
                                                 " left join subsystem on subsystem.id = r_reply.subsystem where idreq= "+requestId+" ", _cnn);
            var rd = selectReplyInfo.ExecuteReader(); 
            if (rd.Read())
            {
                replyId = Convert.ToInt32(rd["id"]);
                replyInfo.StateName = rd["rep_state"].ToString();
                replyInfo.Comment = rd["info_rep"].ToString();
                replyInfo.StartDate = rd["start_repdate"].ToString();
                replyInfo.StartTime = rd["start_reptime"].ToString();
                replyInfo.EndDate = rd["end_repdate"].ToString();
                replyInfo.EndTime = rd["end_reptime"].ToString();
                replyInfo.RepairTime = rd["rep_time"].ToString();
                replyInfo.StopTime = rd["stop_time"].ToString();
                replyInfo.SubsystemName = rd["subsystem"].ToString();
                replyInfo.Mechtime = rd["mech_time"].ToString();
                replyInfo.Electime = rd["elec_time"].ToString();
            }
            _cnn.Close();
            _cnn.Open();
            var selectFails = new SqlCommand("select i_fail_reason.fail from r_rfail inner join i_fail_reason on r_rfail.fail_id = i_fail_reason.id where r_rfail.id_rep = " + replyId+" ",_cnn);
            var readFail = selectFails.ExecuteReader();
            while (readFail.Read())
            {
                failList.Add(new FailReason(){FailReasonName = readFail["fail"].ToString()});
            }
            _cnn.Close();
            _cnn.Open();
            var selectDelays = new SqlCommand("select i_delay_reason.delay from r_rdelay inner join i_delay_reason on r_rdelay.delay_id = i_delay_reason.id where r_rdelay.id_rep = " + replyId+" ",_cnn);
            var readDelay = selectDelays.ExecuteReader();
            while (readDelay.Read())
            {
                delayList.Add(new DelayReason(){DelayReasonName = readDelay["delay"].ToString()});
            }
            _cnn.Close();
            _cnn.Open();
            var selectAction = new SqlCommand("SELECT i_repairs.operation FROM [dbo].[r_action] inner join i_repairs on r_action.act_id = i_repairs.id where id_rep = " + replyId+" ",_cnn);
            var readAction = selectAction.ExecuteReader();
            while (readAction.Read())
            {
                actionList.Add(new Action(){ActionName = readAction["operation"].ToString()});
            }
            _cnn.Close();
            _cnn.Open();
            var selectParts = new SqlCommand("select Part.PartName,r_tools.count from CMMS.dbo.r_tools inner join sgdb.inv.Part on r_tools.tools_id = Part.Serial where r_tools.id_rep = " + replyId+" ",_cnn);
            var readParts = selectParts.ExecuteReader();
            while (readParts.Read())
            {
                partsList.Add(new PartsRepairRecords(){PartName = readParts["PartName"].ToString(),Count = Convert.ToInt32(readParts["count"])});
            }
            _cnn.Close();
            _cnn.Open();
            var selecchangedParts = new SqlCommand("SELECT dbo.subsystem.name as subname,Part.PartName as partname, m_machine.name as machname "+
                                                   "FROM dbo.r_helppart inner join m_machine on r_helppart.mid = m_machine.id " +
                                                   "INNER JOIN dbo.subsystem ON dbo.r_helppart.sub_id = dbo.subsystem.id " +
                                                   "inner join sgdb.inv.Part on dbo.r_helppart.part_id = Part.Serial " +
                                                   "WHERE(dbo.r_helppart.rep_id = " + replyId + " )", _cnn);
            var rcParts = selecchangedParts.ExecuteReader();
            while (rcParts.Read())
            {
                changedParts.Add(new PartChanges()
                {
                    MachineName = rcParts["machname"].ToString(),PartName = rcParts["partname"].ToString(),SubName = rcParts["subname"].ToString()
                });
            }
            _cnn.Close();
            _cnn.Open();
            var selectPersonel = new SqlCommand("select i_personel.per_name,r_personel.time_work from r_personel inner join i_personel on r_personel.per_id = i_personel.id where r_personel.id_rep = "+replyId+" ", _cnn);
            var readPersonel = selectPersonel.ExecuteReader();
            while (readPersonel.Read())
            {
                personelList.Add(new RepairerOfRepairRedords{PersonelName = readPersonel["per_name"].ToString(),RepairTime = readPersonel["time_work"].ToString()});
            }
            _cnn.Close();
            _cnn.Open();
            var selectCont = new SqlCommand("select i_contractor.name,r_contract.cost from r_contract inner join i_contractor on r_contract.contract_id = i_contractor.id where r_contract.id_rep ="+replyId+" ", _cnn);
            var readCont = selectCont.ExecuteReader();
            while (readCont.Read())
            {
                contractorList.Add(new ContractorsOfRepairRecords(){ContractorName = readCont["name"].ToString(),Cost = readCont["cost"].ToString()});
            }
            var obj = new
            {
                replyInfo,
                failList,
                delayList,
                actionList,
                partsList,
                changedParts,
                personelList,
                contractorList
            };
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(obj);
        }
        [WebMethod]
        public string FilterMachineOrderByLocation(int loc)
        {
            _cnn.Open();
            var listMachines = new List<Machines>();
            var filter = new SqlCommand("SELECT dbo.m_machine.id, dbo.m_machine.name FROM dbo.m_machine INNER JOIN " +
                                        "dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code where i_units.unit_code = "+loc+" ",_cnn);
            var rd = filter.ExecuteReader();
            while (rd.Read())
            {
                listMachines.Add(new Machines(){MachineId = rd["id"].ToString(),MachineName = rd["name"].ToString()});
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(listMachines);
        }
        
        [WebMethod]
        public string FilterSubSystem(int mid)
        {
            _cnn.Open();
            var list = new List<SubSystems>();
            var filter = new SqlCommand("SELECT dbo.m_subsystem.subId, dbo.subsystem.name FROM dbo.m_subsystem INNER JOIN "+
                                        "dbo.subsystem ON dbo.m_subsystem.subId = dbo.subsystem.id where m_subsystem.Mid = "+mid+" ", _cnn);
            var r = filter.ExecuteReader();
            while (r.Read())
            {
                list.Add(new SubSystems()
                {
                    SubSystemName = r["name"].ToString() , SubSystemId = Convert.ToInt32(r["subId"])
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(list);
        }

        [WebMethod]
        public string SaveDailyReport(List<DailyReport> dailyDate, int editFlag)
        {
            _cnn.Open();
            if (editFlag == 0)
            {
                var insertDailyReport = new SqlCommand("INSERT INTO [dbo].[daily_report]([tarikh],[rp],[reportexp],[tips],[subject],[date_remind],[check_remind])" +
                                                       "VALUES('" + dailyDate[0].Date + "','"+dailyDate[0].ReportProducer+"','" + dailyDate[0].ReportExplain + "','" + dailyDate[0].ReportTips + "','" + dailyDate[0].Subject + "'" +
                                                       ",'" + dailyDate[0].RemindTime + "',0)", _cnn);
                insertDailyReport.ExecuteNonQuery();
            }
            else
            {
             var updateDaily = new SqlCommand("UPDATE [dbo].[daily_report]" +
                                              "SET [tarikh] = '" + dailyDate[0].Date + "',[rp] = '"+dailyDate[0].ReportProducer+"',[reportexp] = '" + dailyDate[0].ReportExplain + "',[tips] = '" + dailyDate[0].ReportTips + "'," +
                                              "[subject] = '" + dailyDate[0].Subject + "',[date_remind] ='" + dailyDate[0].RemindTime + "' ,[check_remind] = 0  WHERE id = "+editFlag+" ", _cnn);
                updateDaily.ExecuteNonQuery();
            }
            _cnn.Close();
            return "";
        }

        [WebMethod]
        public string GetDailyReport()
        {
            _cnn.Open();
            var dailyList = new List<DailyReport>();
            var getDailyReport = new SqlCommand("SELECT [id],[tarikh],[rp],[reportexp],[tips],[subject],[date_remind]FROM [dbo].[daily_report] order by id desc", _cnn);
            var rd = getDailyReport.ExecuteReader();
            while (rd.Read())
            {
                dailyList.Add(new DailyReport()
                {
                    Date = rd["tarikh"].ToString(),Id = rd["id"].ToString(),ReportProducer = rd["rp"].ToString(),ReportExplain = rd["reportexp"].ToString()
                    ,ReportTips = rd["tips"].ToString(),RemindTime = rd["date_remind"].ToString(),Subject = rd["subject"].ToString()
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(dailyList);
        }

        [WebMethod]
        public string GetDailyForPrint(int id)
        {
            _cnn.Open();
            var dailyList = new List<DailyReport>();
            var getDailyReport = new SqlCommand("SELECT [id],[tarikh],[rp],[reportexp],[tips],[subject],[date_remind]FROM [dbo].[daily_report] where id = "+id+" ", _cnn);
            var rd = getDailyReport.ExecuteReader();
            while (rd.Read())
            {
                dailyList.Add(new DailyReport()
                {
                    Date = rd["tarikh"].ToString(),
                    Id = rd["id"].ToString(),
                    ReportProducer = rd["rp"].ToString(),
                    ReportExplain = rd["reportexp"].ToString()
                    ,
                    ReportTips = rd["tips"].ToString(),
                    RemindTime = rd["date_remind"].ToString(),
                    Subject = rd["subject"].ToString()
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(dailyList);
        }

        [WebMethod]
        public string GetRepairRequestTable(int machineId)
        {
            var list = new List<RepairRequest>();
           _cnn.Open();
            var cmd = new SqlCommand("SELECT dbo.r_request.id, dbo.r_request.req_id, dbo.i_units.unit_name, dbo.r_request.req_name, "+
                                     "CASE WHEN r_request.type_fail = 1 THEN 'مکانیکی' WHEN r_request.type_fail = 2 THEN 'تاسیساتی-الکتریکی' WHEN r_request.type_fail = 3 THEN 'الکتریکی واحد برق' ELSE 'غیره' END AS Tfail, " +
                                     "CASE WHEN r_request.type_req = 1 THEN 'اضطراری' WHEN r_request.type_req = 2 THEN 'پیش بینانه' ELSE 'پیش گیرانه' END AS Treq, CASE WHEN m_machine.code IS NULL THEN CAST('___' AS nvarchar(10)) " +
                                     "ELSE CAST(m_machine.code AS nvarchar(10)) END AS code, dbo.r_request.date_req + '_' + dbo.r_request.time_req AS time " +
                                     "FROM dbo.r_request LEFT OUTER JOIN " +
                                     "dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id LEFT OUTER JOIN " +
                                     "dbo.i_units ON dbo.r_request.unit_id = dbo.i_units.unit_code LEFT OUTER JOIN " +
                                     "dbo.subsystem ON dbo.r_request.subid = dbo.subsystem.id " +
                                     "WHERE(dbo.m_machine.id = "+machineId+") " +
                                     "ORDER BY dbo.r_request.date_req, dbo.r_request.time_req DESC", _cnn);
            var rd = cmd.ExecuteReader();
            while (rd.Read())
            {
                list.Add(new RepairRequest()
                {
                    Id = Convert.ToInt32(rd["id"]),UnitName = rd["unit_name"].ToString(),RequestId = rd["req_id"].ToString(),
                    Requester = rd["req_name"].ToString(),FailType = rd["Tfail"].ToString(),RequestType = rd["Treq"].ToString(),
                    Code = rd["code"].ToString(),Time = rd["time"].ToString()
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(list);
        }

        [WebMethod]
        public string GetRepairRecordTable(int machineId)
        {
            var list = new List<RepairRecord>();
            _cnn.Open();
            var cmd = new SqlCommand("SELECT dbo.r_reply.idreq, dbo.m_machine.name, dbo.m_machine.code, dbo.r_reply.stop_time, dbo.r_reply.rep_time,dbo.r_reply.start_repdate " +
                                     "FROM dbo.r_request INNER JOIN dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN " +
                                     "dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                     "WHERE(dbo.m_machine.id = "+machineId+")", _cnn);
            var rd = cmd.ExecuteReader();
            while (rd.Read())
            {
                list.Add(new RepairRecord()
                {
                    RequestId = Convert.ToInt32(rd["idreq"]),MachineName = rd["name"].ToString(),Code = rd["code"].ToString()
                    ,RepairTime = rd["rep_time"].ToString(),StopTime = rd["stop_time"].ToString(),RepairDate = rd["start_repdate"].ToString()
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(list);
        }

        [WebMethod]
        public string GetStopReasonTable()
        {
            _cnn.Open();
            var list = new List<string[]>();
            var array = new List<string[]>();
            var selectAllStop = new SqlCommand("SELECT [id],[stop]FROM [dbo].[i_stop_reason]",_cnn);
            var rd = selectAllStop.ExecuteReader();
            while (rd.Read())
            {
                array.Add(new []{rd["id"].ToString(),rd["stop"].ToString()});
            }
            list.AddRange(array);
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(list);
        }

        [WebMethod]
        public string GetFazTable()
        {
            _cnn.Open();
            var list = new List<string[]>();
            var array = new List<string[]>();
            var selectAll = new SqlCommand("SELECT [id],[faz_name]FROM [dbo].[i_faz]", _cnn);
            var rd = selectAll.ExecuteReader();
            while (rd.Read())
            {
                array.Add(new[] { rd["id"].ToString(), rd["faz_name"].ToString() });
            }
            list.AddRange(array);
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(list);
        }
        [WebMethod]
        public string GetLineTable()
        {
            _cnn.Open();
            var list = new List<string[]>();
            var array = new List<string[]>();
            var selectAll = new SqlCommand("SELECT [id],[line_name]FROM [dbo].[i_lines]", _cnn);
            var rd = selectAll.ExecuteReader();
            while (rd.Read())
            {
                array.Add(new[] { rd["id"].ToString(), rd["line_name"].ToString() });
            }
            list.AddRange(array);
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(list);
        }
        [WebMethod]
        public string GetDelayReasonTable()
        {
            _cnn.Open();
            var list = new List<string[]>();
            var array = new List<string[]>();
            var selectAll = new SqlCommand("SELECT [id],[delay]FROM [dbo].[i_delay_reason]", _cnn);
            var rd = selectAll.ExecuteReader();
            while (rd.Read())
            {
                array.Add(new[] { rd["id"].ToString(), rd["delay"].ToString() });
            }
            list.AddRange(array);
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(list);
        }

        [WebMethod]
        public string GetFailReasonTable()
        {
            _cnn.Open();
            var list = new List<string[]>();
            var array = new List<string[]>();
            var selectAll = new SqlCommand("SELECT [id],[fail]FROM [dbo].[i_fail_reason]", _cnn);
            var rd = selectAll.ExecuteReader();
            while (rd.Read())
            {
                array.Add(new[] { rd["id"].ToString(), rd["fail"].ToString() });
            }
            list.AddRange(array);
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(list);
        }

        [WebMethod]
        public string GetRepairOperationTable()
        {
            _cnn.Open();
            var list = new List<string[]>();
            var array = new List<string[]>();
            var selectAll = new SqlCommand("SELECT [id],[operation]FROM [dbo].[i_repairs]", _cnn);
            var rd = selectAll.ExecuteReader();
            while (rd.Read())
            {
                array.Add(new[] { rd["id"].ToString(), rd["operation"].ToString() });
            }
            list.AddRange(array);
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(list);
        }

        [WebMethod]
        public string InsertAndUpdateStopReason(string text , int editId)
        {
            _cnn.Open();
            if (editId == 0)
            {
                var cmdinsertstop = new SqlCommand("insert into i_stop_reason (stop) values ('" + text + "')", _cnn);
                cmdinsertstop.ExecuteNonQuery();
                return "i";
            }
            var cmdUpstop = new SqlCommand("update i_stop_reason set stop='" + text + "' where id=" + editId + " ", _cnn);
            cmdUpstop.ExecuteNonQuery();
            _cnn.Close();
            return "e";
        }

        [WebMethod]
        public string InsertAndUpdateFailReason(string text, int editId)
        {
            _cnn.Open();
            if (editId == 0)
            {
                var cmdinsertfail = new SqlCommand("insert into i_fail_reason (fail) values ('" + text + "')", _cnn);
                cmdinsertfail.ExecuteNonQuery();
                return "i";
            }
            var cmdUpfail = new SqlCommand("update i_fail_reason set fail='" + text + "' where id=" + editId + " ", _cnn);
            cmdUpfail.ExecuteNonQuery();
            _cnn.Close();
            return "e";
        }

        [WebMethod]
        public string InsertAndUpdateDelayReason(string text, int editId)
        {
            _cnn.Open();
            if (editId == 0)
            {
                var cmdinsertdelay = new SqlCommand("insert into i_delay_reason (delay) values ('" + text + "')", _cnn);
                cmdinsertdelay.ExecuteNonQuery();
                return "i";
            }
            var cmdUpdelay = new SqlCommand("update i_delay_reason set delay='" + text + "' where id=" + editId + " ", _cnn);
            cmdUpdelay.ExecuteNonQuery();
            _cnn.Close();
            return "e";
        }

        [WebMethod]
        public string InsertAndUpdateRepair(string text, int editId)
        {
            _cnn.Open();
            if (editId == 0)
            {
                var insertPersonel = new SqlCommand("insert into i_repairs (operation) values ('" + text + "')",_cnn);
                insertPersonel.ExecuteNonQuery();
                return "i";
            }
            var upOpreation = new SqlCommand("update i_repairs set operation='" + text + "' where id = " + editId + " ", _cnn);
            upOpreation.ExecuteNonQuery();
            _cnn.Close();
            return "e";
        }
        [WebMethod]
        public string InsertAndUpdatefaz(string text, int editId)
        {
            _cnn.Open();
            if (editId == 0)
            {
                var cmdinsertFaz = new SqlCommand("insert into i_faz (faz_name) values ('" + text + "')", _cnn);
                cmdinsertFaz.ExecuteNonQuery();
                return "i";
            }
            var cmdUpFAz = new SqlCommand("update i_faz set faz_name='" + text + "' where id=" + editId + " ", _cnn);
            cmdUpFAz.ExecuteNonQuery();
            _cnn.Close();
            return "e";
        }
        [WebMethod]
        public string InsertAndUpdateline(string text, int editId)
        {
            _cnn.Open();
            if (editId == 0)
            {
                var cmdinsertline = new SqlCommand("insert into i_lines (line_name) values ('" + text + "')", _cnn);
                cmdinsertline.ExecuteNonQuery();
                return "i";
            }
            var cmdUpline = new SqlCommand("update i_lines set line_name='" + text + "' where id=" + editId + " ", _cnn);
            cmdUpline.ExecuteNonQuery();
            _cnn.Close();
            return "e";
        }
        [WebMethod]
        public string MojoodiMachinePart(int machineid)
        {
            _cnn.Open();
            var list = new List<string[]>();
            var partlist = new List<string[]>();
           
            var getMojoodi = new SqlCommand("SELECT dbo.m_parts.PartId, sgdb.dbo.kalaMojodi.partname, sgdb.dbo.kalaMojodi.Mojodi " +
                                            "FROM dbo.m_machine INNER JOIN " +
                                            "dbo.m_parts ON dbo.m_machine.id = dbo.m_parts.Mid INNER JOIN " +
                                            "sgdb.dbo.kalaMojodi ON dbo.m_parts.PartId = sgdb.dbo.kalaMojodi.PartRef " +
                                            "WHERE(dbo.m_machine.id = " + machineid + ")", _cnn);
            var rd = getMojoodi.ExecuteReader();
            while (rd.Read())
            {
                partlist.Add(new []{rd["partname"].ToString() ,rd["PartId"].ToString(), rd["Mojodi"].ToString() });
            }
            list.AddRange(partlist);
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(list);
        }

        [WebMethod]
        public string MojoodiAnbar(int partid)
        {
            _partsConnection.Open();
            var list = new List<string[]>();
            var partlist = new List<string[]>();
            var getAnbar = new SqlCommand("SELECT [partcode],[partname],[Mojodi] FROM [sgdb].[dbo].[kalaMojodi] where PartRef = "+partid+" ",_partsConnection);
            var rd = getAnbar.ExecuteReader();
            while (rd.Read())
            {
                partlist.Add(new[] { rd["partname"].ToString(), rd["partcode"].ToString(), rd["Mojodi"].ToString() });
            }
            list.AddRange(partlist);
            _partsConnection.Close();
            return new JavaScriptSerializer().Serialize(list);
        }

        [WebMethod]
        public string CheckReminders()
        {
            _cnn.Open();
            ShamsiCalendar.ChangCulter(ShamsiCalendar.CulterType.Fa);
            var tarikh = DateTime.Now.ToString("yyyy/MM/dd");
            var check = new SqlCommand("if (select count(*) from daily_report where check_remind = 0 and date_remind like '%"+tarikh+"%') > 0 "+
                                       "begin select 1 update daily_report set check_remind = 1 where check_remind = 0 and date_remind like '%" + tarikh + "%' end select 0", _cnn);
            var count = Convert.ToInt32(check.ExecuteScalar());
            if (count > 0)
            {
                _cnn.Close();
                return "1";
            }
            _cnn.Close();
            return "0";
        }

        [WebMethod]
        public string MtbfReports(MtbfReports obj)
        {
            _cnn.Open();
            var insertData = new SqlCommand("INSERT INTO [dbo].[MT_report]([type],[name],[producer],[tarikh],[manager],[exp],[analyze])" +
                                            "VALUES("+obj.Type+",'"+obj.ReportName+"','"+obj.Producer+"','"+obj.Tarikh+"'" +
                                            ",'"+obj.Manager+"','"+obj.Exp+"','"+obj.Analyse+"')", _cnn);
            insertData.ExecuteNonQuery();
            _cnn.Close();
            return "";
        }

        [WebMethod]
        public string UpdateReport(MtbfReports obj)
        {
            _cnn.Open();
            var update = new SqlCommand("UPDATE [dbo].[MT_report] "+
                                        "SET[name] = '" + obj.ReportName + "'" +
                                        ",[producer] = '" + obj.Producer + "'" +
                                        ",[tarikh] = '" + obj.Tarikh + "'" +
                                        ",[manager] = '" + obj.Manager + "'" +
                                        ",[exp] = '" + obj.Exp + "'" +
                                        ",[analyze] = '" + obj.Analyse + "'" +
                                        "WHERE id = "+obj.Id+" ", _cnn);
            update.ExecuteNonQuery();
            _cnn.Close();
            return "";
        }
        [WebMethod]
        public string DeleteReport(int reportIdd)
        {
            _cnn.Open();
            var delete = new SqlCommand("delete from MT_report where id = "+ reportIdd + " ", _cnn);
            delete.ExecuteNonQuery();
            _cnn.Close();
            return "";
        }
        [WebMethod]
        public string GetFilteredReportTable(string dateS, string dateE, int type)
        {
            _cnn.Open();
            var rep = new List<MtbfReports>();
            var get = new SqlCommand("SELECT [id],[name],[producer],[tarikh],[manager],[exp],[analyze] FROM [dbo].[MT_report]" +
                                     " where tarikh between '"+dateS+"' and '"+dateE+"' and [type] = "+type+" ", _cnn);
            var r = get.ExecuteReader();
            while (r.Read())
            {
                rep.Add(new MtbfReports()
                {
                    Id = Convert.ToInt32(r["id"]),ReportName = r["name"].ToString(),Producer = r["producer"].ToString(),
                    Tarikh = r["tarikh"].ToString(),Manager = r["manager"].ToString(),Exp = r["exp"].ToString(),Analyse = r["analyze"].ToString()
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(rep);
        }

        [WebMethod]
        public string GetMttPrintData(int reportIdd)
        {
            _cnn.Open();
            var rep = new List<MtbfReports>();
            var get = new SqlCommand("SELECT [id],[type],[name],[producer],[tarikh],[manager],[exp],[analyze] FROM [dbo].[MT_report]" +
                                     " where id = " + reportIdd + " ", _cnn);
            var r = get.ExecuteReader();
            if (r.Read())
            {
                rep.Add(new MtbfReports()
                {
                    Id = Convert.ToInt32(r["id"]),
                    Type = Convert.ToInt32(r["type"]),
                    ReportName = r["name"].ToString(),
                    Producer = r["producer"].ToString(),
                    Tarikh = r["tarikh"].ToString(),
                    Manager = r["manager"].ToString(),
                    Exp = r["exp"].ToString(),
                    Analyse = r["analyze"].ToString()
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(rep);
        }

        [WebMethod]
        public string FilterGridCm(string s , string e)
        {
            _cnn.Open();
            var list = new List<string[]>();
            var listt = new List<string[]>();
            var filter = new SqlCommand("SELECT Forecast.tarikh, Part.partname,Part.Mojodi, dbo.i_units.unit_name, dbo.m_machine.name, dbo.m_machine.code " +
                                        ",cast(m_machine.loc as nvarchar(3)) as unitt " +
                                        "FROM dbo.m_machine INNER JOIN " +
                                        "dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code INNER JOIN " +
                                        "dbo.m_parts ON dbo.m_machine.id = dbo.m_parts.Mid INNER JOIN " +
                                        "dbo.p_forecast AS Forecast INNER JOIN " +
                                        "sgdb.dbo.kalaMojodi AS Part ON Forecast.PartId = Part.PartRef ON dbo.m_parts.id = Forecast.m_partId " +
                                        "where(Forecast.tarikh between '"+s+"' and '"+e+"') and Forecast.act = 0",_cnn);
            var r = filter.ExecuteReader();
            while (r.Read())
            {
                list.Add(new []{ r["unit_name"].ToString(), r["name"].ToString() , r["code"].ToString() , r["partname"].ToString() , r["tarikh"].ToString(),r["Mojodi"].ToString() });
            }
            listt.AddRange(list);
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(listt);
        }

        [WebMethod]
        public string GetPersonels(int task , int unit)
        {
            _cnn.Open();
            var persList =  new List<string[]>();
            var list = new List<string[]>();
            var p = new SqlCommand("select per,perid,unit,task,permit from(SELECT per_name as per,case when unit = 0 then 'تاسیسات' when unit = 1 then 'برق'  "+
                                   "end as unit, case when task = 0 then 'نیروی معمولی' when task = 1 then 'نیروی ماهر' when task = 2 then 'سرشیفت' when " +
                                   "task = 3 then 'سرپرست' when task = 4 then 'مدیر فنی' end as task, unit as vahed, task as semat,per_id as perid, case when permit = 1 " +
                                   "then 'فعال' else 'غیرفعال' end as permit FROM i_personel)i " +
                                   "where (vahed = "+unit+" or "+unit+" = -1) and (semat = "+task+" or "+task+" = -1) ", _cnn);
            var r = p.ExecuteReader();
            while (r.Read())
            {
                persList.Add(new []{r["per"].ToString() , r["perid"].ToString() , r["task"].ToString() , r["unit"].ToString(), r["permit"].ToString() });
            }
            list.AddRange(persList);
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(list);
        }

        [WebMethod]
        public string GetRequestedParts(int requestId)
        {
            _cnn.Open();
            var info = new PartRequest();
            var parts = new List<Parts>();
            var getinfo = new SqlCommand("SELECT [info],[date_reqbuy],[num_reqbuy] FROM [dbo].[r_partwait] where req_id="+requestId+" ",_cnn);
            var r = getinfo.ExecuteReader();
            if (r.Read())
            {
                info.Info = r["info"].ToString();
                info.BuyRequestDate = r["date_reqbuy"].ToString();
                info.BuyRequestNumber = r["num_reqbuy"].ToString();
            }
            _cnn.Close();
            _cnn.Open();
            var getparts = new SqlCommand("SELECT part.PartName as name, part.Serial as id FROM CMMS.dbo.r_reqwaitpart as main " +
                                          "inner join sgdb.inv.Part as part on main.part_id = part.Serial " +
                                          "inner join CMMS.dbo.r_partwait as req on main.id_wait = req.id " +
                                          "where req.req_id = "+requestId+" ",_cnn);
            var re = getparts.ExecuteReader();
            while (re.Read())
            {
                parts.Add(new Parts(){PartId = Convert.ToInt32(re["id"]), PartName = re["name"].ToString()});
            }
            _cnn.Close();
            var obj = new
            {
                info,parts
            };
            return new JavaScriptSerializer().Serialize(obj);
        } 

        [WebMethod]
        public string GetAffectedMachines(int machineCode)
        {
            var list = new List<Machines>();
            _cnn.Open();
            var selAffected = new SqlCommand("SELECT dbo.m_effect.sub_mid, m_machine_1.code, m_machine_1.name, "+
                                             "(SELECT id FROM dbo.m_machine AS m_machine_2 " +
                                             "WHERE(code = "+ machineCode + ")) AS main_mid " +
                                             "FROM dbo.m_machine INNER JOIN " +
                                             "dbo.m_effect ON dbo.m_machine.id = dbo.m_effect.main_mid INNER JOIN " +
                                             "dbo.m_machine AS m_machine_1 ON dbo.m_effect.sub_mid = m_machine_1.id " +
                                             "WHERE(dbo.m_effect.main_mid = (SELECT id " +
                                             "FROM dbo.m_machine AS m_machine_2 " +
                                             "WHERE(code = "+ machineCode + ")))", _cnn);
            var r = selAffected.ExecuteReader();
            while (r.Read())
            {
                list.Add(new Machines()
                {
                    MachineName = r["name"].ToString(),MachineId = r["main_mid"].ToString(),AfftectedMachineId = r["sub_mid"].ToString()
                });
            }
            _cnn.Close();
            return new JavaScriptSerializer().Serialize(list);
        }

        [WebMethod]
        public void AffectedMachinesSave(List<Machines> obj)
        {
            _cnn.Open();
            foreach (var i in obj)
            {
                var ins = new SqlCommand("INSERT INTO [dbo].[t_StopEffect]([reqid],[main_mid],[sub_mid],[stop_time])VALUES" +
                                         "("+i.RequestId+","+i.MachineId+","+i.AfftectedMachineId+",'"+i.StopTime+"')",_cnn);
                ins.ExecuteNonQuery();
            }
            _cnn.Close();
        }

        [WebMethod]
        public string GetCatalogFiles(string name ,string code ,int unit ,int mid)
        {
            _cnn.Open();
            var e = new List<CatalogFiles>();
            var selfiles = new SqlCommand("select id,name,code,address from catalog where " +
                                          "(mid = "+mid+" or "+mid+" = -1) AND " +
                                          "(name like '%"+name+"%' or '"+name+"' = '') AND " +
                                          "(code like '%"+code+"%' or '"+code+"' = '')", _cnn);
            var r = selfiles.ExecuteReader();
            while (r.Read())
            {
                e.Add(new CatalogFiles()
                {
                    Id = Convert.ToInt32(r["id"]),
                    Filename = r["name"].ToString(),
                    FileCode = r["code"].ToString(),
                    Address = r["address"].ToString()
                });
            }
            return new JavaScriptSerializer().Serialize(e);
        }

        [WebMethod]
        public void DeleteCatFile(int id)
        {
            _cnn.Open();
            var selfile = new SqlCommand("select address from catalog where id = "+id+" ",_cnn);
            var delfile = new SqlCommand("delete from catalog where id = " + id + " ", _cnn);
            var filePath = selfile.ExecuteScalar().ToString();
            if (!string.IsNullOrEmpty(filePath))
            {
                var path = Server.MapPath(filePath);
                if (File.Exists(path))
                {
                    File.Delete(path);
                }
            }
            delfile.ExecuteNonQuery();
        }
    }
}

