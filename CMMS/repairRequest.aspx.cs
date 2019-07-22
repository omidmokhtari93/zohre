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

                    drUnits.SelectedValue = UserAccess.GetUnit().ToString();
                    drUnits.DataBind();
                    drUnits.Enabled = false;
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
                //ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "document.getElementById('CM').checked = true;", true);
                drTypeReq.SelectedValue = "3";
                drTypeReq.Focus();
            }
            if (!string.IsNullOrEmpty(id) && !string.IsNullOrEmpty(machineId) && !string.IsNullOrEmpty(unitCode))
            {
                //ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "document.getElementById('PM').checked = true;", true);
                drTypeReq.SelectedValue = "2";
                drTypeReq.Focus();
            }
            try
            {
                drUnits.SelectedValue = Crypto.Decrypt(unitCode);
                drUnits.DataBind();
                drMachines.DataSource = Sqlmachine;
                drMachines.DataValueField = "id";
                drMachines.DataTextField = "name";
                drMachines.DataBind();
                drMachines.SelectedValue = Crypto.Decrypt(machineId);
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "completeinputs();", true);

                cnn.Open();
                var sqlcode = new SqlCommand("select code from m_machine where id=" + Crypto.Decrypt(machineId) + "", cnn);
                txtmachin_code.Text = Convert.ToString(sqlcode.ExecuteScalar());   
            }
            catch
            {
                //ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "document.getElementById('EM').checked = true;", true);
                drTypeReq.SelectedValue = "1";
                drTypeReq.Focus();
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
            if (tools_value.Value == "")
                tools_value.Value = "0";
            var insertRequest = new SqlCommand("insert into r_request ([req_id],[unit_id],[machine_code],[subid],[type_fail]," +
                                               "[req_name],[type_req],[comment],[date_req],[time_req],[type_repair],[state],[faz],[line])" +
                                                "values("+txtreqid.Text+",'"+ drUnits.SelectedValue+"'," + machine_value.Value + "," +
                                               ""+tools_value.Value+"," + drkindFail.SelectedValue + ",'" + txtreq_name.Text + "'," +
                                               ""+drTypeReq.SelectedValue+",'"+txtcomment.Text+"','"+txtRequestDate.Value+"','"+txtRequestTime.Value+"',1,1,"+drFaz.SelectedValue+","+drLine.SelectedValue+")", cnn);
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
            
            txtmachin_code.Text = "";
            Pm();
            
        }

        protected void gridrequest_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ed")
            {
                
                txtmachin_code.Text = "";
                
                var index = int.Parse(e.CommandArgument.ToString());
                ViewState["id"] = gridrequest.DataKeys[index]["id"];
                cnn.Open();
                var getrequest =
                    new SqlCommand(
                        "SELECT [req_id],[unit_id],[machine_code],[subid],[type_fail],[req_name],[type_req],[comment]" +
                        ",[date_req],[time_req],[type_repair],[state],[faz],[line] FROM [dbo].[r_request] where id = " +
                        Convert.ToInt32(ViewState["id"]) + " " +
                        "select code from m_machine where id = (select machine_code from [dbo].[r_request] where id="+ Convert.ToInt32(ViewState["id"]) + ") ", cnn);
                
                var rd = getrequest.ExecuteReader();
                
                if (rd.Read())
                {
                    if (Convert.ToInt32(rd["state"].ToString()) == 1)
                    {
                        drUnits.SelectedValue = rd["unit_id"].ToString();
                        
                      
                        txtreqid.Text = rd["req_id"].ToString();

                        drMachines.DataSource = Sqlmachine;
                        drMachines.DataValueField = "id";
                        drMachines.DataTextField = "name";
                        drMachines.DataBind();
                        drMachines.SelectedValue = rd["machine_code"].ToString();

                        dr_tools.DataSource = Sqltools;
                        dr_tools.DataValueField = "subId";
                        dr_tools.DataTextField = "name";
                        dr_tools.DataBind();
                        dr_tools.SelectedValue = rd["subid"].ToString();

                        drkindFail.SelectedValue = rd["type_fail"].ToString();
                        drTypeReq.SelectedValue = rd["type_req"].ToString();
                        txtreq_name.Text = rd["req_name"].ToString();
                        txtcomment.Text = rd["comment"].ToString();
                        drLine.SelectedValue = rd["line"].ToString();
                        drFaz.SelectedValue = rd["faz"].ToString();
                        
                        txtRequestDate.Value = rd["date_req"].ToString();
                        txtRequestTime.Value = rd["time_req"].ToString();
                        
                        btninsert.Visible = false;
                        btncancel.Visible = true;
                        btnedit.Visible = true;
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Uperror();", true);
                    }
                }
                rd.NextResult();
                if (rd.Read())
                {
                    txtmachin_code.Text = Convert.ToString(rd["code"]);
                }
                cnn.Close();
                cnn.Open();
                
                
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
                                            "SET [unit_id] =  '"+ drUnits.SelectedValue+"' " +
                                             " ,[machine_code] = "+ drMachines.SelectedValue+" "+
                                             " ,[subid] = " + dr_tools.SelectedValue + " " +
                                             " ,[type_fail] = " +drkindFail.SelectedValue+" "+ 
                                             " ,[req_name] ='"+txtreq_name.Text+"' "+
                                             " ,[type_req] ="+ drTypeReq.SelectedValue + " "+
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
            
           
            txtmachin_code.Text = "";
            dr_tools.Items.Clear();
            dr_tools.Items.Insert(0, new ListItem("تجهیز را انتخاب نمایید", "-1"));
            txtRequestDate.Value = "";
            txtRequestTime.Value = "";
            GetReqNumber();

        }


    }
}