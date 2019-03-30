using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class otherRepairRequest : System.Web.UI.Page
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
                getrecnumber();
            }
        }

        private void getrecnumber()
        {
            cnn.Open();
            var cmdreqid =
                new SqlCommand(
                    "SELECT case when COUNT(req_id)=0 then 1000 else MAX(req_id)+1 end as id FROM [dbo].[r_request]", cnn);
            txtreqid.Text = Convert.ToString(cmdreqid.ExecuteScalar());
            cnn.Close();
        }

        protected void btninsert_OnClick(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtreq_name.Text))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            cnn.Open();
            var insertRequest = new SqlCommand("insert into r_request ([req_id],[unit_id],[other_machine],[type_fail],[req_name],[type_req]," +
                                               "[comment],[date_req],[time_req],[type_repair],[state])" +
                                               "values("+txtreqid.Text+",'" + drunit.SelectedValue + "','"+txtrepair.Text+"'," +
                                               "" + typefail.Value + ",'" + txtreq_name.Text + "'," + typereq.Value + "," +
                                               "'" + txtcomment.Text + "','" + txtRequestDate.Value + "','" + txtRequestTime.Value + "',0,1)", cnn);
            insertRequest.ExecuteNonQuery();
            gridrequest.DataBind();
            txtreq_name.Text = "";
            txtcomment.Text = "";
            txtRequestDate.Value = "";
            txtRequestTime.Value = "";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
            cnn.Close();
            getrecnumber();
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
                                           "SET [unit_id] =  " + drunit.SelectedValue + " " +
                                           " ,[other_machine] = '" + txtrepair.Text + "' " +
                                           " ,[type_fail] = " + Convert.ToInt32(typefail.Value) + " " +
                                           " ,[req_name] ='" + txtreq_name.Text + "' " +
                                           " ,[type_req] =" + Convert.ToInt32(typereq.Value) + " " +
                                           " ,[comment] ='" + txtcomment.Text + "' " +
                                           " ,[date_req] = '" + txtRequestDate.Value + "' " +
                                           " ,[time_req] = '" + txtRequestTime.Value + "' " +
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
            txtrepair.Text = "";
            txtreq_name.Text = "";
            txtRequestDate.Value = "";
            txtRequestTime.Value = "";
            drunit.SelectedValue = "-1";
         
           
            getrecnumber();
        }

        protected void btncancel_OnClick(object sender, EventArgs e)
        {
            btninsert.Visible = true;
            btnedit.Visible = false;
            btncancel.Visible = false;
            txtcomment.Text = "";
            txtrepair.Text = "";
            txtRequestDate.Value = "";
            txtRequestTime.Value = "";
            txtreq_name.Text = "";
            drunit.SelectedValue = "-1";
            getrecnumber();
        }

        protected void gridrequest_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ed")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                ViewState["id"] = gridrequest.DataKeys[index]["id"];
                cnn.Open();
                var getrequest =
                    new SqlCommand(
                        "SELECT [req_id],[unit_id],[other_machine],[type_fail],[req_name],[type_req],[comment],[date_req],[time_req],[type_repair],[state] FROM [dbo].[r_request] where id = " +
                        Convert.ToInt32(ViewState["id"]) + " ", cnn);
                var rd = getrequest.ExecuteReader();
                if (rd.Read())
                {
                    if (Convert.ToInt32(rd["state"].ToString()) == 1)
                    {
                        txtreqid.Text = rd["req_id"].ToString();
                        drunit.SelectedValue = rd["unit_id"].ToString();
                        txtrepair.Text = rd["other_machine"].ToString();
                        typefail.Value = rd["type_fail"].ToString();
                        typereq.Value = rd["type_req"].ToString();
                        txtreq_name.Text = rd["req_name"].ToString();
                        txtcomment.Text = rd["comment"].ToString();
                        txtRequestDate.Value = rd["date_req"].ToString();
                        txtRequestTime.Value = rd["time_req"].ToString();
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script",
                            "setRadioFail();setRadioreq();", true);
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
    }
}