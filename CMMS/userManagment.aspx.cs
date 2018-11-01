using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using rijndael;

namespace CMMS
{
    public partial class userManagment : System.Web.UI.Page
    {
        SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["CMMS"].ConnectionString);
        string initVector = "F4568dgbdfgtt444";
        string key = "rdf48JH4";
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


        protected void btnSabt_OnClick(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtName.Text) || string.IsNullOrEmpty(txtUserName.Text) || string.IsNullOrEmpty(txtTell.Text)
                || string.IsNullOrEmpty(txtPassword.Text) || string.IsNullOrEmpty(txtPasswordRep.Text) || drUnitname.SelectedValue == "-1" || txtPassword.Text != txtPasswordRep.Text)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            var re = new RijndaelEnhanced(key, initVector);
            String EnPass = re.Encrypt(txtPassword.Text);
            cnn.Open();
            var insertUser = new SqlCommand("insert into users ([name],[username],[password],[usrlevel],[permit],[tell],[email],[unit]) values" +
                                            "('"+txtName.Text+"','"+txtUserName.Text+"','"+ EnPass + "',"+draccessLevel.SelectedValue+","+userState.Value+"," +
                                            " '"+txtTell.Text+"' , '"+txtEmail.Text+"' , "+drUnitname.SelectedValue+")",cnn);
            insertUser.ExecuteNonQuery();
            EmptyControls();
            gridUsers.DataBind();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
        }

        protected void gridUsers_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            foreach (GridViewRow row in gridUsers.Rows)
            {
                row.Cells[2].Text = "****";
            }
        }

        protected void gridUsers_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ed")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                ViewState["uid"] = (int) gridUsers.DataKeys[index]["uid"];
                cnn.Open();
                var getUser = new SqlCommand("SELECT [name],[username],[password],[usrlevel],[permit],[tell],[email],[unit] FROM [dbo].[users] where id = "+ViewState["uid"]+" ",cnn);
                var rd = getUser.ExecuteReader();
                if (rd.Read())
                {
                    txtName.Text = rd["name"].ToString();
                    txtUserName.Text = rd["username"].ToString();
                    var  re = new RijndaelEnhanced(key,initVector);
                    txtPassword.Text = re.Decrypt(rd["password"].ToString());
                    txtPasswordRep.Text = txtPassword.Text;
                    txtEmail.Text = rd["email"].ToString();
                    txtTell.Text = rd["tell"].ToString();
                    drUnitname.SelectedValue = rd["unit"].ToString();
                    draccessLevel.SelectedValue = rd["usrlevel"].ToString();
                    userState.Value = rd["permit"].ToString();
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "setRadio();", true);
                    btnSabt.Visible = false;
                    btnCancel.Visible = true;
                    btnEdit.Visible = true;
                }
            }

           
        }

        protected void btnCancel_OnClick(object sender, EventArgs e)
        {
            btnEdit.Visible = false;
            btnCancel.Visible = false;
            btnSabt.Visible = true;
            EmptyControls();
        }

        protected void btnEdit_OnClick(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtName.Text) || string.IsNullOrEmpty(txtUserName.Text) || string.IsNullOrEmpty(txtTell.Text)
                || string.IsNullOrEmpty(txtPassword.Text) || string.IsNullOrEmpty(txtPasswordRep.Text) || drUnitname.SelectedValue == "-1" || txtPassword.Text != txtPasswordRep.Text)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            var re = new RijndaelEnhanced(key, initVector);
            String EnPass = re.Encrypt(txtPassword.Text);
            cnn.Open();
            var upUser = new SqlCommand("UPDATE [dbo].[users] "+
                                        "SET[name] = '"+txtName.Text+"' " +
                                        ",[username] = '"+txtUserName.Text+"' " +
                                        ",[password] = '"+EnPass+"' " +
                                        ",[usrlevel] = "+draccessLevel.SelectedValue+" " +
                                        ",[permit] = "+userState.Value+" " +
                                        ",[tell] = '"+txtTell.Text+"' " +
                                        ",[email] = '"+txtEmail.Text+"' " +
                                        ",[unit] = "+drUnitname.SelectedValue+" " +
                                        "WHERE id = "+ViewState["uid"]+" " , cnn);
            upUser.ExecuteNonQuery();
            gridUsers.DataBind();
            EmptyControls();
            btnSabt.Visible = true;
            btnCancel.Visible = false;
            btnEdit.Visible = false;
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
        }

        private void EmptyControls()
        {
            txtUserName.Text = "";
            txtPassword.Text = "";
            txtPasswordRep.Text = "";
            txtEmail.Text = "";
            txtTell.Text = "";
            txtName.Text = "";
            drUnitname.SelectedValue = "-1";
            draccessLevel.SelectedValue = "2";
        }

        
    }
}