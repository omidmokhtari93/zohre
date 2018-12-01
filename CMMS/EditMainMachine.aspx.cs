using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class EditMainMachine : System.Web.UI.Page
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

        protected void gridMainMachines_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Ed")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                var dataKey = gridMainMachines.DataKeys[index];
                if (dataKey != null)
                {
                    int Mid = (int)dataKey["id"];
                    var hashedMid = Crypto.Crypt(Mid.ToString());
                    Response.Redirect("MachineBase.aspx?mid=" + hashedMid);
                }
            }
           
            if (e.CommandName == "del")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                var dataKey = gridMainMachines.DataKeys[index];
                if (dataKey != null)
                {
                    var mid = (int)dataKey["id"];
                    ViewState["machineId"] = mid;
                }
                var machineName = gridMainMachines.Rows[index].Cells[1].Text;
               
                lblMachineName.Text = machineName ;
                pnlDeleteMachine.Visible = true;
                pnlMachineInfo.Visible = false;
            }
        }

        protected void no_OnClick(object sender, EventArgs e)
        {
            pnlDeleteMachine.Visible = false;
            pnlMachineInfo.Visible = true;
        }

        protected void yes_OnClick(object sender, EventArgs e)
        {
            cnn.Open();
            var deletMAchine = new SqlCommand("DELETE FROM b_fuel where Mid =(select id from b_machine where id=" + ViewState["machineId"] + ") " +
                                              "DELETE FROM b_inst where Mid = (select id from b_machine where id = " + ViewState["machineId"] + ") " +
                                              "DELETE FROM b_subsystem where Mid = (select id from b_machine where id = " + ViewState["machineId"] + ") " +                                            
                                              "DELETE FROM b_control where Mid = (select id from m_machine where id = " + ViewState["machineId"] + ") " +                                            
                                              "DELETE FROM b_parts where Mid = (select id from m_machine where id = " + ViewState["machineId"] + ") " +                                           
                                              "Delete from b_machine where id = " + ViewState["machineId"] + "", cnn);
            deletMAchine.ExecuteNonQuery();
            gridMainMachines.DataBind();
            pnlMachineInfo.Visible = true;
            pnlDeleteMachine.Visible = false;
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "GreenAlert('no','.اطلاعات اولیه ماشین / دستگاه با موفقیت حذف شد');", true);
        }
    }
}