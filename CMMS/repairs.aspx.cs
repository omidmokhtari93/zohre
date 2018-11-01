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
    public partial class repairs : System.Web.UI.Page
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
            if (string.IsNullOrEmpty(txtoprepair.Text))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            cnn.Open();
            var insertPersonel = new SqlCommand("insert into i_repairs (operation) values ('" + txtoprepair.Text + "')",
                cnn);
            insertPersonel.ExecuteNonQuery();
            gridrepairs.DataBind();
            txtoprepair.Text = "";

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
        }

        protected void gridrepairs_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ed")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                ViewState["id"] = gridrepairs.DataKeys[index]["id"];
                cnn.Open();
                var getOp = new SqlCommand(
                    "SELECT [operation] FROM [dbo].[i_repairs] where id = " + Convert.ToInt32(ViewState["id"]) + " ",
                    cnn);
                var rd = getOp.ExecuteReader();
                if (rd.Read())
                {
                    txtoprepair.Text = rd["operation"].ToString();
                }
            }
            btninsert.Visible = false;
            btnedit.Visible = true;
            btncancel.Visible = true;
        }

        protected void btnedit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtoprepair.Text))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            cnn.Open();
            var UpOpreation=new SqlCommand("update i_repairs set operation='"+txtoprepair.Text+ "' where id = " + ViewState["id"] + " ", cnn);
            UpOpreation.ExecuteNonQuery();
            gridrepairs.DataBind();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
            txtoprepair.Text = "";
            btninsert.Visible = true;
            btnedit.Visible = false;
            btncancel.Visible = false;
        }

        protected void btncancel_Click(object sender, EventArgs e)
        {
            txtoprepair.Text = "";
            btninsert.Visible = true;
            btnedit.Visible = false;
            btncancel.Visible = false;
        }
    }
}