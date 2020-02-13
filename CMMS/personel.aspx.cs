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
    public partial class personel : System.Web.UI.Page
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
        }

        protected void btninsert_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtname.Text) || string.IsNullOrEmpty(txtper.Text))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            cnn.Open();
            var insertPersonel = new SqlCommand("insert into i_personel (per_id,per_name,unit,task,permit,profession)" +
                                                "values('" + txtper.Text + "','" + txtname.Text + "'," + userState.Value + "" +
                                                "," + drsemat.SelectedValue + "," + userActive.Value + " , " + drProf.SelectedValue + ")", cnn);
            insertPersonel.ExecuteNonQuery();
            gridpersonel.DataBind();
            txtname.Text = "";
            txtper.Text = "";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
        }

        protected void gridpersonel_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            var index = int.Parse(e.CommandArgument.ToString());
            ViewState["id"] = gridpersonel.DataKeys[index]["id"];

            if (e.CommandName == "ed")
            {
                cnn.Open();
                var getUser =
                    new SqlCommand(
                        "SELECT [per_id],[per_name],[unit],[task],[permit],[profession] FROM [dbo].[i_personel] where id = " +
                        Convert.ToInt32(ViewState["id"]) + " ", cnn);
                var rd = getUser.ExecuteReader();
                if (!rd.Read()) return;
                txtname.Text = rd["per_name"].ToString();
                txtper.Text = rd["per_id"].ToString();
                userState.Value = rd["unit"].ToString();
                userActive.Value = rd["permit"].ToString();
                drsemat.SelectedValue = rd["task"].ToString();
                drProf.SelectedValue = rd["profession"].ToString();
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "setRadio();setactRadio();",
                    true);

                btninsert.Visible = false;
                btncancel.Visible = true;
                btnedit.Visible = true;
                cnn.Close();
            }
            else if (e.CommandName == "del")
            {
                cnn.Open();
                var getUser =
                    new SqlCommand(
                        "SELECT per_id FROM r_personel where per_id = " + Convert.ToInt32(ViewState["id"]) + " ", cnn);
                var rd = getUser.ExecuteReader();
                if (!rd.Read())
                {
                    cnn.Close();
                    cnn.Open();
                    var delcommand = new SqlCommand("delete from i_personel where id= " + Convert.ToInt32(ViewState["id"]) + "", cnn);
                    delcommand.ExecuteNonQuery();
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
                    cnn.Close();
                    gridpersonel.DataBind();

                }
                else
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "DelErr();", true);
                }
            }
            else
            {
                return;
            }

        }

        protected void btnedit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtname.Text) || string.IsNullOrEmpty(txtper.Text))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            cnn.Open();
            var unitt = userState.Value == "0" ? 0 : 1;
            var act = userActive.Value == "0" ? 0 : 1;
            var upPersonel = new SqlCommand("UPDATE [dbo].[i_personel] " +
                                        "SET[per_name] = '" + txtname.Text + "' " +
                                        ",[per_id] = '" + txtper.Text + "' " +
                                        ",[unit] =" + unitt + " " +
                                        ",[task] = " + drsemat.SelectedValue + " " +
                                        ",[permit]= " + act + " " +
                                        ",[profession] = " + drProf.SelectedValue + " " +
                                        "WHERE id = " + ViewState["id"] + " ", cnn);
            upPersonel.ExecuteNonQuery();
            gridpersonel.DataBind();

            btninsert.Visible = true;
            btncancel.Visible = false;
            btnedit.Visible = false;
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
            txtname.Text = "";
            txtper.Text = "";
        }

        protected void btncancel_Click(object sender, EventArgs e)
        {
            btninsert.Visible = true;
            btncancel.Visible = false;
            btnedit.Visible = false;
            txtname.Text = "";
            txtper.Text = "";
        }

        protected void drtaskFilter_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            FilterPersonel();
        }

        protected void drunitFilter_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            FilterPersonel();
        }

        private void FilterPersonel()
        {
            var task = Convert.ToInt32(drtaskFilter.SelectedValue);
            var unit = Convert.ToInt32(drunitFilter.SelectedValue);
            var prof = Convert.ToInt32(drProfFilter.SelectedValue);
            sqlpersonel.FilterExpression = " (vahed = " + unit + " or " + unit + " = -1) " +
                                           "and (semat = " + task + " or " + task + " = -1) " +
                                           "and (filterprof = " + prof + " or " + prof + " = -1)";
            gridpersonel.DataBind();
        }
        protected void btnPrintPersonel_OnClick(object sender, EventArgs e)
        {
            var task = drtaskFilter.SelectedValue;
            var unit = drunitFilter.SelectedValue;
            var prof = drProfFilter.SelectedValue;
            Response.Write("<script>window.open('PersonelPrint.aspx?task=" + task + "&unit=" + unit + "&prof=" + prof + "','_blank');</script>");
        }


        protected void drProfFilter_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            FilterPersonel();
        }
    }
}