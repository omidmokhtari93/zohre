using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using rijndael;
namespace CMMS
{
    public partial class primryCost : System.Web.UI.Page
    {
        SqlConnection cnn=new SqlConnection(ConfigurationManager.ConnectionStrings["CMMS"].ConnectionString);
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



        protected void btnSabt_Click(object sender, EventArgs e)
        {
            cnn.Open();
            var cmdinsertCosts = new SqlCommand("insert into i_costs (cost_year,worker,expert,headworker,manager,technical_manager)" +
                                                " values('" + drYear.SelectedValue + "'," + txtworker.Text + "," +
                                                txtexpert.Text + "," + txtheadworker.Text + "," + txtmanager.Text + ","+txttechnicalmanager.Text+")",cnn);
            cmdinsertCosts.ExecuteNonQuery();
            gridCost.DataBind();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
            txtworker.Text = "";
            txtexpert.Text = "";
            txtheadworker.Text = "";
            txtmanager.Text = "";
            txttechnicalmanager.Text = "";

        }

        protected void gridCost_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ed")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                ViewState["id"] = (int)gridCost.DataKeys[index]["id"];
                cnn.Open();
                var getCost = new SqlCommand("SELECT [id],[cost_year],[worker],[expert],[headworker],[manager],[technical_manager] FROM [dbo].[i_costs] where id = " + ViewState["id"] + " ", cnn);
                var rd = getCost.ExecuteReader();
                if (rd.Read())
                {
                    drYear.SelectedValue = rd["cost_year"].ToString();
                    txtworker.Text = rd["worker"].ToString();
                    txtexpert.Text = rd["expert"].ToString();
                    txtheadworker.Text = rd["expert"].ToString();
                    txtmanager.Text = rd["manager"].ToString();
                    txttechnicalmanager.Text = rd["technical_manager"].ToString();
                    btnSabt.Visible = false;
                    btnCancel.Visible = true;
                    btnEdit.Visible = true;
                }
            }
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            cnn.Open();
            var cmdUpcost=new SqlCommand("update i_costs set cost_year='"+drYear.SelectedValue+"',worker="+txtworker.Text+",expert="+txtexpert.Text+",headworker="+txtheadworker.Text+",manager="+txtmanager.Text+ ",technical_manager="+txttechnicalmanager.Text+" where id=" + ViewState["id"]+" ",cnn);
            cmdUpcost.ExecuteNonQuery();
            gridCost.DataBind();
            btnSabt.Visible = true;
            btnCancel.Visible = false;
            btnEdit.Visible = false;
            txtworker.Text = "";
            txtexpert.Text = "";
            txtheadworker.Text = "";
            txtmanager.Text = "";
            txttechnicalmanager.Text = "";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            btnEdit.Visible = false;
            btnCancel.Visible = false;
            btnSabt.Visible = true;
            txtworker.Text = "";
            txtexpert.Text = "";
            txtheadworker.Text = "";
            txtmanager.Text = "";
            txttechnicalmanager.Text = "";

        }
    }
}