using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;

namespace CMMS
{
    public partial class repairRequest : System.Web.UI.Page
    {
        SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["CMMS"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            switch (UserAccess.CheckAccess())
            {
                case 0:
                    break;
                case 2:

                    drunit.SelectedValue = UserAccess.GetUnit().ToString();
                    drunit.DataBind();
                    drunit.Enabled = false;
                    break;
                default:
                    Response.Redirect("login.aspx");
                    break;

            }
            Page.MaintainScrollPositionOnPostBack = true;
            if (!Page.IsPostBack)
            {
                GetReqNumber();
                CheckQueryString();
            }
        }

        private void CheckQueryString()
        {
            var machineId = Request.Params.Get("mid");
            var unitCode = Request.Params.Get("ucode");
            var id = Request.Params.Get("id");
            if (string.IsNullOrEmpty(id) && string.IsNullOrEmpty(machineId) && string.IsNullOrEmpty(unitCode))
            {
                return;
            }
            if (string.IsNullOrEmpty(id) && !string.IsNullOrEmpty(machineId) && !string.IsNullOrEmpty(unitCode))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "document.getElementById('CM').checked = true;", true);
            }
            if (!string.IsNullOrEmpty(id) && !string.IsNullOrEmpty(machineId) && !string.IsNullOrEmpty(unitCode))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "document.getElementById('PM').checked = true;", true);
            }
            try
            {
                drunit.SelectedValue = Crypto.Decrypt(unitCode);
                drunit.DataBind();
                dr_machine.SelectedValue = Crypto.Decrypt(machineId);
                dr_machine.DataBind();
                dr_tools.DataBind();
                cnn.Open();
                var sqlcode = new SqlCommand("select code from m_machine where id=" + Crypto.Decrypt(machineId) + "", cnn);
                txtmachin_code.Text = Convert.ToString(sqlcode.ExecuteScalar());   
            }
            catch
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "document.getElementById('EM').checked = true;", true);
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "cancel();", true);
            }
        }
        private void GetReqNumber()
        {
            cnn.Open();
            var cmdreqid =
                new SqlCommand("SELECT case when COUNT(req_id)= 0 then  1000  else MAX(req_id)+1 end as id FROM [dbo].[r_request]", cnn);
            txtreqid.Text = Convert.ToString(cmdreqid.ExecuteScalar());
            
            cnn.Close();
        }

        private void MachineCode()
        {
            cnn.Close();
            cnn.Open();
            var sqlcode = new SqlCommand("select code,line,faz from m_machine where id=" + dr_machine.SelectedValue + "", cnn);
            var rd = sqlcode.ExecuteReader();
            if (rd.Read())
            {
                txtmachin_code.Text = rd["code"].ToString();
                drLine.SelectedValue = rd["line"].ToString();
                drFaz.SelectedValue = rd["faz"].ToString();
                drLine.DataBind();
                drFaz.DataBind();

            }
            
        }
        public void UPinsertPm(string id, int mconntrol, string tarikh, int kind, string week, string other)
        {
            cnn.Open();

            var cmdcommandCm = new SqlCommand("update dbo.p_pmcontrols set act=1 where id=" + id + " " +
                                              "insert into p_pmcontrols (idmcontrol,tarikh,act,kind,week,other) VALUES(" + mconntrol + ",'" + tarikh + "',0," + kind + "," + week + "," + other + " )", cnn);
            cmdcommandCm.ExecuteNonQuery();
            cnn.Close();
        }
        private void Pm()
        {
            var pmid= Request.Params.Get("id");
            if (string.IsNullOrEmpty(pmid))
            {
                return;
            }
            pmid = Crypto.Decrypt(pmid);
            cnn.Open();//set previous record
            var cmdUPPM=new SqlCommand("update p_pmcontrols set act=1 where id="+ pmid + " ", cnn);
            cmdUPPM.ExecuteNonQuery();
            cnn.Close();
            cnn.Open();//insert new pm 
            var cmdPM=new SqlCommand("select [idmcontrol],[act],[tarikh],[kind],[week],[other] from [p_pmcontrols] where id="+ pmid + "", cnn);
            var rd = cmdPM.ExecuteReader();
            if (rd.Read())
            {
               
                var tarikh = rd["tarikh"].ToString();
                var kind = Convert.ToInt32(rd["kind"]);
                var mcontrolid = Convert.ToInt32(rd["idmcontrol"]);
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
                            UPinsertPm(pmid, mcontrolid, tarikh, kind, "NULL", "NULL");
                        
                        break;
                    }
                    case 1://month
                    {
                        int pos = tarikh.LastIndexOf("/");
                        string day = tarikh.Substring(pos + 1, tarikh.Length - (pos + 1));
                        var Date = ShamsiCalendar.Shamsi2Miladi(tarikh);
                        Date = Date.AddMonths(1);

                        tarikh = ShamsiCalendar.Miladi2Shamsi(Date);
                        pos = tarikh.LastIndexOf("/");
                        //if (Convert.ToInt32(day) < 10)
                        //    day = "0" + day;
                        tarikh = tarikh.Substring(0, pos + 1) + day;
                        cnn.Close();
                            UPinsertPm(pmid, mcontrolid, tarikh, kind, "NULL", "NULL");
                        
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
                            UPinsertPm(pmid, mcontrolid, tarikh, kind, "NULL", "NULL");
                        
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
                        //if (Convert.ToInt32(day) < 10)
                        //    day = "0" + day;
                        tarikh = tarikh.Substring(0, pos + 1) + day;
                        cnn.Close();
                            UPinsertPm(pmid, mcontrolid, tarikh, kind, "NULL", "NULL");
                        
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
                            UPinsertPm(pmid, mcontrolid, tarikh, kind, "NULL", "NULL");
                        
                        break;

                    }
                    case 5://other
                    {
                        var Date = ShamsiCalendar.Shamsi2Miladi(tarikh);
                        var other = Convert.ToInt32(rd["other"]);
                        Date = Date.AddDays(other);
                        tarikh = ShamsiCalendar.Miladi2Shamsi(Date);
                        cnn.Close();
                            UPinsertPm(pmid, mcontrolid, tarikh, kind, "NULL", other.ToString());
                        
                        break;

                    }
                    case 6://week
                    {
                        var Date = ShamsiCalendar.Shamsi2Miladi(tarikh);
                        var week = Convert.ToInt32(rd["week"]);
                        Date = Date.AddDays(7);
                        tarikh = ShamsiCalendar.Miladi2Shamsi(Date);
                        cnn.Close();
                            UPinsertPm(pmid, mcontrolid, tarikh, kind, week.ToString(), "NULL");
                        
                        break;
                    }

                }


            }
            cnn.Close();
        }
        protected void btninsert_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtreq_name.Text) )
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            cnn.Open();
            var insertRequest = new SqlCommand("insert into r_request ([req_id],[unit_id],[machine_code],[subid],[type_fail]," +
                                               "[req_name],[type_req],[comment],[date_req],[time_req],[type_repair],[state],[faz],[line])" +
                                                "values("+txtreqid.Text+",'"+drunit.SelectedValue+"'," + dr_machine.SelectedValue + "," +
                                               ""+dr_tools.SelectedValue+"," + typefail.Value + ",'" + txtreq_name.Text + "'," +
                                               ""+typereq.Value+",'"+txtcomment.Text+"','"+txtRequestDate.Value+"','"+txtRequestTime.Value+"',1,1,"+drFaz.SelectedValue+","+drLine.SelectedValue+")", cnn);
            insertRequest.ExecuteNonQuery();
            gridrequest.DataBind();
            txtreq_name.Text = "";
            txtcomment.Text = "";
            txtmachin_code.Text = "";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
            cnn.Close();
            GetReqNumber();
            txtRequestDate.Value = "";
            txtRequestTime.Value = "";
            dr_machine.Items.Clear();
            dr_machine.Items.Insert(0, new ListItem("دستگاه را انتخاب نمایید", "-1"));
            txtmachin_code.Text = "";
            dr_tools.Items.Clear();
            dr_tools.Items.Insert(0, new ListItem("تجهیز را انتخاب نمایید", "-1"));

            //drLine.Items.Clear();
            //drLine.Items.Insert(0, new ListItem("انتخاب نمایید", "0"));

            //drFaz.Items.Clear();
            //drFaz.Items.Insert(0,new ListItem("انتخاب نمایید", "0"));
            Pm();
            
        }

        protected void gridrequest_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ed")
            {
                dr_machine.Items.Clear();
                dr_machine.Items.Insert(0, new ListItem("دستگاه را انتخاب نمایید", "-1"));
                txtmachin_code.Text = "";
                dr_tools.Items.Clear();
                dr_tools.Items.Insert(0, new ListItem("تجهیز را انتخاب نمایید", "-1"));
                var index = int.Parse(e.CommandArgument.ToString());
                ViewState["id"] = gridrequest.DataKeys[index]["id"];
                cnn.Open();
                var getrequest =
                    new SqlCommand(
                        "SELECT [req_id],[unit_id],[machine_code],[subid],[type_fail],[req_name],[type_req],[comment]" +
                        ",[date_req],[time_req],[type_repair],[state],[faz],[line] FROM [dbo].[r_request] where id = " +
                        Convert.ToInt32(ViewState["id"]) + " ", cnn);
                
                var rd = getrequest.ExecuteReader();
                
                if (rd.Read())
                {
                    if (Convert.ToInt32(rd["state"].ToString()) == 1)
                    {
                        drunit.SelectedValue = rd["unit_id"].ToString();
                        sqlmachin.DataBind();
                        dr_machine.DataBind();
                        txtreqid.Text = rd["req_id"].ToString();
                        dr_machine.SelectedValue = rd["machine_code"].ToString();
                        sqlsubsys.DataBind();
                        dr_tools.DataBind();
                        dr_tools.SelectedValue = rd["subid"].ToString();
                        typefail.Value = rd["type_fail"].ToString();
                        typereq.Value = rd["type_req"].ToString();
                        txtreq_name.Text = rd["req_name"].ToString();
                        txtcomment.Text = rd["comment"].ToString();
                        drLine.SelectedValue = rd["line"].ToString();
                        drFaz.SelectedValue = rd["faz"].ToString();
                        drLine.DataBind();
                        drFaz.DataBind();
                        txtRequestDate.Value = rd["date_req"].ToString();
                        txtRequestTime.Value = rd["time_req"].ToString();
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script",
                            "setRadioFail();setRadioreq();", true);
                        MachineCode();//for fill txtmachinecode
                        btninsert.Visible = false;
                        btncancel.Visible = true;
                        btnedit.Visible = true;
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Uperror();", true);
                    }
                }
                cnn.Close();
            }
           
        }

        protected void btnedit_OnClick(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtreq_name.Text))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            cnn.Open();
            var upRequest = new SqlCommand("UPDATE [dbo].[r_request] " +
                                            "SET [unit_id] =  '"+drunit.SelectedValue+"' " +
                                             " ,[machine_code] = "+dr_machine.SelectedValue+" "+
                                             " ,[subid] = " + dr_tools.SelectedValue + " " +
                                             " ,[type_fail] = " +Convert.ToInt32(typefail.Value)+" "+ 
                                             " ,[req_name] ='"+txtreq_name.Text+"' "+
                                             " ,[type_req] ="+ Convert.ToInt32(typereq.Value) + " "+
                                             " ,[comment] ='"+txtcomment.Text+"' "+
                                             " ,[date_req] = '"+txtRequestDate.Value+"' "+
                                             " ,[time_req] = '"+txtRequestTime.Value+"' "+
                                             ",[line]="+drLine.SelectedValue+" "+
                                              ",[faz]=" + drFaz.SelectedValue + " " +
                                             " WHERE id = " + ViewState["id"] + " ", cnn);
            upRequest.ExecuteNonQuery();
            cnn.Close();
            gridrequest.DataBind();
            cnn.Close();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
            btninsert.Visible = true;
            btnedit.Visible = false;
            btncancel.Visible = false;
            txtcomment.Text = "";
            txtmachin_code.Text = "";
            txtreq_name.Text = "";
            drunit.SelectedValue = "-1";
            dr_tools.SelectedValue = "-1";
            dr_machine.SelectedValue = "-1";
            txtRequestDate.Value = "";
            txtRequestTime.Value = "";
            GetReqNumber();
        }

        protected void btncansel_OnClick(object sender, EventArgs e)
        {
            btninsert.Visible = true;
            btnedit.Visible = false;
            btncancel.Visible = false;
            txtcomment.Text = "";
            txtreq_name.Text = "";
            drunit.SelectedValue = "-1";
            dr_machine.Items.Clear();
            dr_machine.Items.Insert(0, new ListItem("دستگاه را انتخاب نمایید", "-1"));
            txtmachin_code.Text = "";
            dr_tools.Items.Clear();
            dr_tools.Items.Insert(0, new ListItem("تجهیز را انتخاب نمایید", "-1"));
            txtRequestDate.Value = "";
            txtRequestTime.Value = "";
            GetReqNumber();

        }
        
        protected void dr_machine_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            MachineCode();
            dr_tools.Items.Clear();
            dr_tools.Items.Insert(0, new ListItem("تجهیز را انتخاب نمایید", "-1"));
            dr_tools.DataBind();
        }

        protected void drunit_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            dr_machine.Items.Clear();
            dr_machine.Items.Insert(0,new ListItem("دستگاه را انتخاب نمایید","-1"));
            txtmachin_code.Text = "";
            dr_tools.Items.Clear();
            dr_tools.Items.Insert(0, new ListItem("تجهیز را انتخاب نمایید", "-1"));
            
        }
    }
}