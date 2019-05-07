using System;
using System.CodeDom;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;

namespace CMMS
{
    public partial class welcome : System.Web.UI.Page
    {
        SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["CMMS"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            switch (UserAccess.CheckAccess())
            {
                case 0:
                    break;
                default:
                    Response.Redirect("login.aspx");
                    break;

            }
            TodayDateTime.Value = ShamsiCalendar.ShamsiDateTime();
        }

        protected void drServicePeriod_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            if (drServicePeriod.SelectedValue == "-1")
            {
                SqlDailyPM.FilterExpression = "";
                SqlDailyPM.DataBind();
                gridDailyPM.DataBind();
                return;
            }
            SqlDailyPM.FilterExpression = "searchPriod = " + drServicePeriod.SelectedValue + "";
            SqlDailyPM.DataBind();
            gridDailyPM.DataBind();
        }

        protected void btnSearchMachine_OnClick(object sender, EventArgs e)
        {
            var sub1 = txtMachineName.Value.Replace("ک", "ك").Replace("ی", "ي");
            var sub2 = txtMachineName.Value.Replace("ك", "ک").Replace("ي", "ی").Replace("ﯼ", "ی").Replace("ى", "ی").Replace("ة", "ه");
            SqlDailyPM.FilterExpression = " name like '%" + txtMachineName.Value + "%' OR name like '%" + sub1 + "%' OR name like '%" + sub2 + "%'";
            SqlDailyPM.DataBind();
            gridDailyPM.DataBind();
        }

        protected void drUnits_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            if (drUnits.SelectedValue == "-1")
            {
                SqlDailyPM.FilterExpression = "";
                SqlDailyPM.DataBind();
                gridDailyPM.DataBind();
                return;
            }
            SqlDailyPM.FilterExpression = "loc = '" + drUnits.SelectedValue + "'";
            SqlDailyPM.DataBind();
            gridDailyPM.DataBind();
        }

        public void UPinsertCM(string id, int mconntrol, string tarikh, int kind, string week, string other)
        {
            cnn.Open();

            var cmdcommandCM = new SqlCommand("update dbo.p_pmcontrols set act=1 where id=" + id + " " +
                                                 "insert into p_pmcontrols (idmcontrol,tarikh,act,kind,week,other) VALUES(" + mconntrol + ",'" + tarikh + "',0,"+kind+","+week+","+other+" )", cnn);
            cmdcommandCM.ExecuteNonQuery();
            cnn.Close();
        }

        private void TimeService(int rowIndex)
        {
            var row1 = gridDailyPM.Rows[rowIndex];
            var ts = row1.Cells[0].FindControl("txtTimeServcie") as TextBox;
            var id = gridDailyPM.DataKeys[rowIndex]["id"];
            if (string.IsNullOrEmpty(ts.Text)) return;
            cnn.Open();
            var updateTimeService = new SqlCommand("update p_pmcontrols set timeservice  = " + ts.Text + " where id = " + id + " ", cnn);
            updateTimeService.ExecuteNonQuery();
            cnn.Close();
        }

        protected void gridDailyPM_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            
            var index = 0;
            if (e.CommandName == "done")
            {
                index = int.Parse(e.CommandArgument.ToString());
                TimeService(index);
                ViewState["id"] = gridDailyPM.DataKeys[index]["id"];
                cnn.Open();
                var getPM = new SqlCommand(
                    "SELECT TOP (100) PERCENT dbo.m_control.Mid, dbo.m_machine.name, dbo.m_machine.code, dbo.m_control.contName, CAST(dbo.m_control.period AS nvarchar(2)) AS searchPriod, " +
                    " CAST(dbo.m_machine.loc AS nvarchar(3)) AS loc, " +
                    " dbo.p_pmcontrols.act, dbo.p_pmcontrols.tarikh, dbo.i_units.unit_name, " +
                    " dbo.p_pmcontrols.kind, dbo.p_pmcontrols.id, dbo.p_pmcontrols.week, dbo.p_pmcontrols.other,dbo.m_control.id AS McontrolId " +
                    " FROM            dbo.m_machine INNER JOIN " +
                    " dbo.m_control ON dbo.m_machine.id = dbo.m_control.Mid INNER JOIN " +
                    " dbo.p_pmcontrols ON dbo.m_control.id = dbo.p_pmcontrols.idmcontrol INNER JOIN " +
                    " dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code " +
                    " WHERE(dbo.p_pmcontrols.tarikh <= '" + TodayDateTime.Value +
                    "') AND(dbo.p_pmcontrols.act = 0) AND (dbo.p_pmcontrols.id=" + ViewState["id"] + ") " +
                    " ", cnn);
                var rd = getPM.ExecuteReader();
                if (rd.Read())
                {
                    var tarikh = rd["tarikh"].ToString();
                    var kind = Convert.ToInt32(rd["kind"]);
                    var mcontrolid = Convert.ToInt32(rd["McontrolId"]);
                   // var week = Convert.ToInt32(rd["week"]);
                   // var other = Convert.ToInt32(rd["other"]);
                    switch (kind)
                    {
                        case 0://daily
                        {
                            var Date = ShamsiCalendar.Shamsi2Miladi(tarikh);
                            Date = Date.AddDays(1);
                           
                            tarikh = ShamsiCalendar.Miladi2Shamsi(Date); 
                            cnn.Close();
                            UPinsertCM(ViewState["id"].ToString(),mcontrolid,tarikh,kind,"NULL","NULL");
                            gridDailyPM.DataBind();
                            break;
                        }
                        case 1://month
                        {
                            int pos = tarikh.LastIndexOf("/");
                            string day = tarikh.Substring(pos+1, tarikh.Length - (pos+1));
                            string Mhelp = tarikh.Substring(pos - 2, 2);
                            
                            var Date = ShamsiCalendar.Shamsi2Miladi(tarikh);
                            if ((Convert.ToInt32(Mhelp) < 7) && (Convert.ToInt32(day)==1))
                            {
                                Date = Date.AddMonths(2);
                            }
                            else
                            {
                                Date = Date.AddMonths(1);
                                }
                                
                          
                            tarikh = ShamsiCalendar.Miladi2Shamsi(Date); 
                                pos = tarikh.LastIndexOf("/");
                            //if (Convert.ToInt32(day) < 10)
                            //    day = "0" + day;
                            tarikh = tarikh.Substring(0, pos+1) + day;
                            cnn.Close();
                            UPinsertCM(ViewState["id"].ToString(), mcontrolid, tarikh, kind, "NULL", "NULL");
                            gridDailyPM.DataBind();
                            break;
                        }
                        case 2://3month
                        {
                            int pos = tarikh.LastIndexOf("/");
                            string day = tarikh.Substring(pos + 1, tarikh.Length - (pos + 1));
                            var Date = ShamsiCalendar.Shamsi2Miladi(tarikh);
                            Date = Date.AddMonths(3);

                            tarikh = ShamsiCalendar.Miladi2Shamsi(Date);
                            pos = tarikh.LastIndexOf("/");
                            //if (Convert.ToInt32(day) < 10)
                            //    day = "0" + day;
                            tarikh = tarikh.Substring(0, pos + 1) + day;
                            cnn.Close();
                            UPinsertCM(ViewState["id"].ToString(), mcontrolid, tarikh, kind, "NULL", "NULL");
                            gridDailyPM.DataBind();
                            break;

                            }
                        case 3://6month
                        {
                            int pos = tarikh.LastIndexOf("/");
                            string day = tarikh.Substring(pos + 1, tarikh.Length - (pos + 1));
                            var Date = ShamsiCalendar.Shamsi2Miladi(tarikh);
                            Date = Date.AddMonths(6);

                            tarikh = ShamsiCalendar.Miladi2Shamsi(Date);
                            pos = tarikh.LastIndexOf("/");
                           
                            tarikh = tarikh.Substring(0, pos + 1) + day;
                            cnn.Close();
                            UPinsertCM(ViewState["id"].ToString(), mcontrolid, tarikh, kind, "NULL", "NULL");
                            gridDailyPM.DataBind();
                            break;

                            }
                        case 4://year
                        {
                            int pos = tarikh.LastIndexOf("/");
                            string day = tarikh.Substring(pos + 1, tarikh.Length - (pos + 1));
                            var Date = ShamsiCalendar.Shamsi2Miladi(tarikh);
                            Date = Date.AddYears(1);

                            tarikh = ShamsiCalendar.Miladi2Shamsi(Date);
                            pos = tarikh.LastIndexOf("/");
                            //if (Convert.ToInt32(day) < 10)
                            //    day = "0" + day;
                            tarikh = tarikh.Substring(0, pos + 1) + day;
                            cnn.Close();
                            UPinsertCM(ViewState["id"].ToString(), mcontrolid, tarikh, kind, "NULL", "NULL");
                            gridDailyPM.DataBind();
                            break;

                            }
                        case 5://other
                        {
                                var Date = ShamsiCalendar.Shamsi2Miladi(tarikh);
                                var other = Convert.ToInt32(rd["other"]);
                                Date = Date.AddDays(other);                               
                                tarikh = ShamsiCalendar.Miladi2Shamsi(Date);
                                cnn.Close();
                                UPinsertCM(ViewState["id"].ToString(), mcontrolid, tarikh, kind, "NULL", other.ToString());
                                gridDailyPM.DataBind();
                                break;
                                
                        }
                        case 6://week
                        {
                            var Date = ShamsiCalendar.Shamsi2Miladi(tarikh);
                            var week = Convert.ToInt32(rd["week"]);
                            Date = Date.AddDays(7);
                            tarikh = ShamsiCalendar.Miladi2Shamsi(Date);
                            cnn.Close();
                            UPinsertCM(ViewState["id"].ToString(), mcontrolid, tarikh, kind, week.ToString(), "NULL");
                            gridDailyPM.DataBind();
                            break;
                        }

                    }
                }
            }
            if (e.CommandName == "repair")
            {     
                index = Convert.ToInt32(e.CommandArgument);
                var machineId = gridDailyPM.DataKeys[index]["Mid"];
                var unitCode = gridDailyPM.DataKeys[index]["loc"];
                var pmid= gridDailyPM.DataKeys[index]["id"];
                Response.Redirect("repairRequest.aspx?mid="+Crypto.Crypt(machineId.ToString())+"&ucode="+Crypto.Crypt(unitCode.ToString())+"&id="+Crypto.Crypt(pmid.ToString()));
            }
        }

        protected void btnChangeDate_OnServerClick(object sender, EventArgs e)
        {
            var Newtarikh = txtChangeDate.Value;
            var id = PMid.Value;
            cnn.Open();
            var changePM = new SqlCommand(
                "SELECT TOP (100) PERCENT dbo.m_control.Mid, dbo.m_machine.name, dbo.m_machine.code, dbo.m_control.contName, CAST(dbo.m_control.period AS nvarchar(2)) AS searchPriod, " +
                " CAST(dbo.m_machine.loc AS nvarchar(3)) AS loc, " +
                " dbo.p_pmcontrols.act, dbo.p_pmcontrols.tarikh, dbo.i_units.unit_name, " +
                " dbo.p_pmcontrols.kind, dbo.p_pmcontrols.id, dbo.p_pmcontrols.week, dbo.p_pmcontrols.other,dbo.m_control.id AS McontrolId " +
                " FROM            dbo.m_machine INNER JOIN " +
                " dbo.m_control ON dbo.m_machine.id = dbo.m_control.Mid INNER JOIN " +
                " dbo.p_pmcontrols ON dbo.m_control.id = dbo.p_pmcontrols.idmcontrol INNER JOIN " +
                " dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code " +
                " WHERE(dbo.p_pmcontrols.tarikh <= '" + TodayDateTime.Value +
                "') AND(dbo.p_pmcontrols.act = 0) AND (dbo.p_pmcontrols.id=" + id + ")", cnn);
            var rd = changePM.ExecuteReader();
            if (rd.Read())
            {
                var tarikh = rd["tarikh"].ToString();
                var kind = Convert.ToInt32(rd["kind"]);
                var mcontrolid = Convert.ToInt32(rd["McontrolId"]);
                
                // var week = Convert.ToInt32(rd["week"]);
                // var other = Convert.ToInt32(rd["other"]);
                switch (kind)
                {
                    case 0: //daily
                    {
                        cnn.Close();
                        UPinsertCM(id, mcontrolid, Newtarikh, kind, "NULL", "NULL");
                        gridDailyPM.DataBind();
                        break;
                        }
                    case 1: //month
                    case 2: //3month
                    case 3: //6month
                    case 4: //year
                    {
                        int pos = tarikh.LastIndexOf("/", StringComparison.Ordinal);
                        string day = tarikh.Substring(pos + 1, tarikh.Length - (pos + 1));

                        pos = Newtarikh.LastIndexOf("/", StringComparison.Ordinal);

                        Newtarikh = Newtarikh.Substring(0, pos + 1) + day;
                        cnn.Close();
                        UPinsertCM(id, mcontrolid, Newtarikh, kind, "NULL", "NULL");
                        gridDailyPM.DataBind();
                        break;
                    }
                    case 5: //other   
                    {
                        var other = Convert.ToInt32(rd["other"]);
                        cnn.Close();
                        UPinsertCM(id, mcontrolid, Newtarikh, kind, "NULL", other.ToString());
                        gridDailyPM.DataBind();
                        break;
                    }
                    case 6: //week
                   {
                        var week = Convert.ToInt32(rd["week"]);
                        Newtarikh = ShamsiCalendar.Changedayofweek(Newtarikh, week);
                        cnn.Close();
                        UPinsertCM(id, mcontrolid, Newtarikh, kind, week.ToString(), "NULL");
                        gridDailyPM.DataBind();
                        break;
                    }

                }
            }

        }
    }
}