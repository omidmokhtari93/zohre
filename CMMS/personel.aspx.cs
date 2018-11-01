﻿using System;
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
            var insertPersonel = new SqlCommand("insert into i_personel (per_id,per_name,unit,task,permit)values('" + txtper.Text + "','" + txtname.Text + "'," + userState.Value + ","+drsemat.SelectedValue+","+userActive.Value+")", cnn);
            insertPersonel.ExecuteNonQuery();
            gridpersonel.DataBind();
            txtname.Text = "";
            txtper.Text = "";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
        }

        protected void gridpersonel_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ed")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                ViewState["id"] = gridpersonel.DataKeys[index]["id"];
                cnn.Open();
                var getUser = new SqlCommand("SELECT [per_id],[per_name],[unit],[task],[permit] FROM [dbo].[i_personel] where id = " + Convert.ToInt32(ViewState["id"]) + " ", cnn);
                var rd = getUser.ExecuteReader();
                if (rd.Read())
                {
                    txtname.Text = rd["per_name"].ToString();
                    txtper.Text = rd["per_id"].ToString();
                    
                    
                    userState.Value = rd["unit"].ToString();
                    userActive.Value = rd["permit"].ToString();
                    drsemat.SelectedValue = rd["task"].ToString();
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "setRadio();setactRadio();", true);
                    btninsert.Visible = false;
                    btncancel.Visible = true;
                    btnedit.Visible = true;
                }
            }

            
        }

       

        protected void btnedit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtname.Text) || string.IsNullOrEmpty(txtper.Text) )
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            
            cnn.Open();
            int unitt;
            int act;
            if (userState.Value == "0")
            {
                unitt = 0;
            }
            else
            {
                unitt = 1;
            }
            if (userActive.Value == "0")
            {
                act = 0;
            }
            else
            {
                act = 1;
            }
            var upPersonel = new SqlCommand("UPDATE [dbo].[i_personel] " +
                                        "SET[per_name] = '" + txtname.Text + "' " +
                                        ",[per_id] = '" + txtper.Text + "' " +
                                        ",[unit] =" + unitt + " " +
                                        ",[task] = " + drsemat.SelectedValue + " " +
                                        ",[permit]= "+act+" " +
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
            if (drtaskFilter.SelectedValue == "-1")
            {
                sqlpersonel.FilterExpression = "";
                gridpersonel.DataBind();
                return;
            }
            sqlpersonel.FilterExpression = "semat = "+drtaskFilter.SelectedValue+" ";
            gridpersonel.DataBind();
        }

        protected void drunitFilter_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            if (drunitFilter.SelectedValue == "-1")
            {
                sqlpersonel.FilterExpression = "";
                gridpersonel.DataBind();
                return;
            }
            sqlpersonel.FilterExpression = "vahed = "+drunitFilter.SelectedValue+" ";
            gridpersonel.DataBind();
        }
    }
}