using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using rijndael;

namespace CMMS
{
    public partial class editMachine : System.Web.UI.Page
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

        protected void gridMachines_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Ed")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                int Mid = (int)gridMachines.DataKeys[index]["id"];
                var hashedMid = Crypto.Crypt(Mid.ToString());
                Response.Redirect("newMachine.aspx?mid=" + hashedMid);
            }
//            if (e.CommandName == "Print")
//            {
//                var index = int.Parse(e.CommandArgument.ToString());
//                var mid = (int)gridMachines.DataKeys[index]["id"];
//                var hashedMid = Crypto.Crypt(mid.ToString());
//                Response.Write("<script>window.open ('MachinePrint.aspx?mid=" + hashedMid + "','_blank');</script>");
//            }
            if (e.CommandName == "del")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                var mid = (int)gridMachines.DataKeys[index]["id"];
                ViewState["machineId"] = mid;
                var machineName = gridMachines.Rows[index].Cells[1].Text;
                var machineCode = gridMachines.Rows[index].Cells[2].Text;
                lblMachineName.Text = machineName + " به شماره فنی " + machineCode;
                pnlDeleteMachine.Visible = true;
                pnlMachineInfo.Visible = false;
            }
        }

        protected void btnSearch_OnClick(object sender, EventArgs e)
        {
            var sub1 = txtSearch.Value.Replace("ک", "ك").Replace("ی", "ي");
            var sub2 = txtSearch.Value.Replace("ك", "ک").Replace("ي", "ی").Replace("ﯼ", "ی").Replace("ى", "ی").Replace("ة", "ه");
            SqlMachine.FilterExpression = " name like '%" + txtSearch.Value + "%' OR name like '%" + sub1 + "%' OR name like '%" + sub2 + "%'";
            SqlMachine.DataBind();
            gridMachines.DataBind();
        }

        protected void drUnits_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            if (drUnits.SelectedValue == "0")
            {
                SqlMachine.FilterExpression = "";
                SqlMachine.DataBind();
                gridMachines.DataBind();
                return;
            }
            SqlMachine.FilterExpression = " location in (" + drUnits.SelectedValue + ") ";
            SqlMachine.DataBind();
            gridMachines.DataBind();
        }

        protected void btnSearchCode_OnClick(object sender, EventArgs e)
        {
            SqlMachine.FilterExpression = " vcode like '%" + txtCodeSearch.Value+"%' ";
            SqlMachine.DataBind();
            gridMachines.DataBind();
        }

        protected void no_OnClick(object sender, EventArgs e)
        {
            pnlDeleteMachine.Visible = false;
            pnlMachineInfo.Visible = true;
        }

        protected void yes_OnClick(object sender, EventArgs e)
        {
            cnn.Open();
            var deletMAchine = new SqlCommand("DELETE FROM m_fuel where Mid =(select id from m_machine where id="+ ViewState["machineId"] + ") "+
                                              "DELETE FROM m_inst where Mid = (select id from m_machine where id = "+ ViewState["machineId"] + ") " +
                                              "DELETE FROM m_subsystem where Mid = (select id from m_machine where id = "+ ViewState["machineId"] + ") " +
                                              "DELETE FROM m_energy where Mid = (select id from m_machine where id = "+ ViewState["machineId"] + ") " +
                                              "DELETE FROM p_pmcontrols where idmcontrol in (SELECT dbo.m_control.id " +
                                              "FROM dbo.m_machine INNER JOIN " +
                                              "dbo.m_control ON dbo.m_machine.id = dbo.m_control.Mid " +
                                              "WHERE(dbo.m_machine.id = "+ ViewState["machineId"] + ")) " +
                                              "DELETE FROM m_control where Mid = (select id from m_machine where id = "+ ViewState["machineId"] + ") " +
                                              "DELETE FROM p_forecast where m_partId in (SELECT dbo.m_parts.id AS id " +
                                              "FROM dbo.m_machine INNER JOIN " +
                                              "dbo.m_parts ON dbo.m_machine.id = dbo.m_parts.Mid " +
                                              "WHERE(dbo.m_machine.id = "+ ViewState["machineId"] + ")) " +
                                              "DELETE FROM m_parts where Mid = (select id from m_machine where id = "+ ViewState["machineId"] + ") " +
                                              "DELETE FROM r_action where id_rep in(SELECT dbo.r_reply.id " +
                                              "FROM dbo.m_machine INNER JOIN " +
                                              "dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                              "dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                              "WHERE(dbo.m_machine.id = "+ ViewState["machineId"] + "))  " +
                                              "DELETE FROM r_contract where id_rep in(SELECT dbo.r_reply.id " +
                                              "FROM dbo.m_machine INNER JOIN " +
                                              "dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                              "dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                              "WHERE(dbo.m_machine.id = "+ ViewState["machineId"] + "))  " +
                                              "DELETE FROM r_personel where id_rep in(SELECT dbo.r_reply.id " +
                                              "FROM dbo.m_machine INNER JOIN " +
                                              "dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                              "dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                              "WHERE(dbo.m_machine.id = "+ ViewState["machineId"] + "))  " +
                                              "DELETE FROM r_rdelay where id_rep in(SELECT dbo.r_reply.id " +
                                              "FROM dbo.m_machine INNER JOIN " +
                                              "dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                              "dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                              "WHERE(dbo.m_machine.id = "+ ViewState["machineId"] + "))  " +
                                              "DELETE FROM r_rfail where id_rep in(SELECT dbo.r_reply.id " +
                                              "FROM dbo.m_machine INNER JOIN " +
                                              "dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                              "dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                              "WHERE(dbo.m_machine.id = "+ ViewState["machineId"] + "))  " +
                                              "DELETE FROM r_tools where id_rep in(SELECT dbo.r_reply.id " +
                                              "FROM dbo.m_machine INNER JOIN " +
                                              "dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                              "dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                              "WHERE(dbo.m_machine.id = "+ ViewState["machineId"] + "))  " +
                                              "DELETE FROM r_reply WHERE idreq in(SELECT dbo.r_request.req_id " +
                                              "FROM dbo.m_machine INNER JOIN " +
                                              "dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code " +
                                              "WHERE(dbo.m_machine.id = "+ ViewState["machineId"] + ")) " +
                                              "DELETE FROM r_request WHERE machine_code in(select id from m_machine where id = "+ ViewState["machineId"] + ") " +
                                              "delete from m_machine where id = "+ ViewState["machineId"] + "", cnn);
            deletMAchine.ExecuteNonQuery();
            gridMachines.DataBind();
            pnlMachineInfo.Visible = true;
            pnlDeleteMachine.Visible = false;
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "GreenAlert('no','.ماشین / دستگاه با موفقیت حذف شد');", true);
        }
    }
}