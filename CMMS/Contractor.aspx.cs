using System;
using System.CodeDom;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class Contractor : System.Web.UI.Page
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
            if (string.IsNullOrEmpty(txtcontractor.Text) || string.IsNullOrEmpty(txtphone.Text)|| string.IsNullOrEmpty(txtaddress.Text))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }

            cnn.Open();
            var insertContractor = new SqlCommand("insert into i_contractor (name,webmail,address,phone,tell,fax,permit,comment)values('" + txtcontractor.Text + "','" + txtemail.Text + "','" + txtaddress.Text + "','" + txtphone.Text + "','"+txttell.Text+"','"+txtfax.Text+"',"+userState.Value+",'"+txtcomment.Text+"')", cnn);
            insertContractor.ExecuteNonQuery();
            gridcontrac.DataBind();

            txtcontractor.Text = "";
            txtaddress.Text = "";
            txtemail.Text = "";
            txtfax.Text = "";
            txttell.Text = "";
            txtphone.Text = "";
            txtcomment.Text = "";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
        }

        protected void gridcontrac_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ed")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                ViewState["id"] = gridcontrac.DataKeys[index]["id"];
                cnn.Open();
                var getUser = new SqlCommand("SELECT [name],[webmail],[address],[phone],[tell],[fax],[permit],[comment] FROM [dbo].[i_contractor] where id = " + Convert.ToInt32(ViewState["id"]) + " ", cnn);
                var rd = getUser.ExecuteReader();
                if (rd.Read())
                {
                    txtcontractor.Text = rd["name"].ToString();
                    txtemail.Text = rd["webmail"].ToString();
                    txtaddress.Text = rd["address"].ToString();
                    txtfax.Text = rd["fax"].ToString();
                    txtphone.Text = rd["phone"].ToString();
                    txttell.Text = rd["tell"].ToString();
                    userState.Value = rd["permit"].ToString();
                    txtcomment.Text = rd["comment"].ToString();
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "setRadio();", true);
                    btninsert.Visible = false;
                    btncancel.Visible = true;
                    btnedit.Visible = true;
                }
            }
            if (e.CommandName == "Print")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                var cid = gridcontrac.DataKeys[index]["id"];
                Response.Write("<script>window.open ('ContractorPrint.aspx?cid=" + cid + "','_blank');</script>");
            }
            
        }

        protected void btnedit_Click(object sender, EventArgs e)
        {
            
            if (string.IsNullOrEmpty(txtcontractor.Text) || string.IsNullOrEmpty(txtphone.Text) || string.IsNullOrEmpty(txtaddress.Text))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }

            cnn.Open();
            int permitt;
            if (userState.Value == "0")
            {
                permitt = 0;
            }
            else
            {
                permitt = 1;
            }
            var upContract = new SqlCommand("UPDATE [dbo].[i_contractor] " +
                                            "SET[name] = '" + txtcontractor.Text + "' ," +
                                             " [webmail]='"+txtemail.Text+"',[address]='"+txtaddress.Text+"'," +
                                            "[phone]='"+txtphone.Text+"',[tell]='"+txttell.Text+"'," +
                                            "[fax]='"+txtfax.Text+"',[permit]="+permitt+",comment='"+txtcomment.Text+"' "+
                                            "WHERE id = " + ViewState["id"] + " ", cnn);
            upContract.ExecuteNonQuery();
            gridcontrac.DataBind();

            btninsert.Visible = true;
            btncancel.Visible = false;
            btnedit.Visible = false;
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
            txtcontractor.Text = "";
            txtaddress.Text = "";
            txtemail.Text = "";
            txtfax.Text = "";
            txttell.Text = "";
            txtphone.Text = "";
            txtcomment.Text = "";


        }

        protected void btncancel_Click(object sender, EventArgs e)
        {
            btninsert.Visible = true;
            btncancel.Visible = false;
            btnedit.Visible = false;
            txtcontractor.Text = "";
            txtaddress.Text = "";
            txtemail.Text = "";
            txtfax.Text = "";
            txttell.Text = "";
            txtphone.Text = "";
            txtcomment.Text = "";


        }
    }
    
}