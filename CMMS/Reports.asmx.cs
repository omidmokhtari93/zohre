using System;
using System.Activities.Expressions;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

namespace CMMS
{
    /// <summary>
    /// Summary description for Reports
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class Reports : System.Web.Services.WebService
    {
        SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["CMMS"].ConnectionString);
        [WebMethod]
        public string Actrep(int line, int unit, string dateS,string dateE)
        {
            var infoAct=new List<string[]>();
            cnn.Open();
            var cmdActreply=new SqlCommand("SELECT        COUNT(r_action_1.act_id) AS total, dbo.i_repairs.operation, CAST(COUNT(r_action_1.act_id) * 100.0 / "+
                                            "  (SELECT        COUNT(dbo.r_action.id_rep) AS EX "+
                                            " FROM            dbo.r_action INNER JOIN "+
                                            "  dbo.r_reply ON dbo.r_action.id_rep = dbo.r_reply.id "+
                                            "  WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "')) AS numeric(12, 2)) AS persent " +
                                            " FROM dbo.i_repairs INNER JOIN "+
                                            " dbo.r_action AS r_action_1 ON dbo.i_repairs.id = r_action_1.act_id INNER JOIN "+
                                            " dbo.r_reply AS r_reply_1 ON r_action_1.id_rep = r_reply_1.id "+
                                            " WHERE(r_reply_1.start_repdate BETWEEN '"+dateS+"' AND '"+dateE+"') "+
                                            " GROUP BY r_action_1.act_id, dbo.i_repairs.operation",cnn);

            var cmdActreplyUnit=new SqlCommand("SELECT        COUNT(r_action_1.act_id) AS total, dbo.i_repairs.operation, CAST(COUNT(r_action_1.act_id) * 100.0 /" +
                                               " (SELECT        COUNT(dbo.r_action.id_rep) AS EX " +
                                               " FROM dbo.r_action INNER JOIN " +
                                               " dbo.r_reply ON dbo.r_action.id_rep = dbo.r_reply.id INNER JOIN " +
                                               " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                               " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                               " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.loc = " + unit+")) AS numeric(12, 2)) AS persent " +
                                               " FROM dbo.i_repairs INNER JOIN dbo.r_action AS r_action_1 ON dbo.i_repairs.id = r_action_1.act_id INNER JOIN " +
                                               " dbo.r_reply AS r_reply_1 ON r_action_1.id_rep = r_reply_1.id INNER JOIN " +
                                               " dbo.r_request AS r_request_1 ON r_reply_1.idreq = r_request_1.req_id INNER JOIN " +
                                               " dbo.m_machine AS m_machine_1 ON r_request_1.machine_code = m_machine_1.id " +
                                               " WHERE(r_reply_1.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine_1.loc = " + unit+") " +
                                               " GROUP BY r_action_1.act_id, dbo.i_repairs.operation",cnn);

            var cmdArtreplyLine= new SqlCommand("SELECT        COUNT(r_action_1.act_id) AS total, dbo.i_repairs.operation, CAST(COUNT(r_action_1.act_id) * 100.0 /" +
                                                " (SELECT        COUNT(dbo.r_action.id_rep) AS EX " +
                                                " FROM dbo.r_action INNER JOIN " +
                                                " dbo.r_reply ON dbo.r_action.id_rep = dbo.r_reply.id INNER JOIN " +
                                                " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                                " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                                " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.line = " + line + ")) AS numeric(12, 2)) AS persent " +
                                                " FROM dbo.i_repairs INNER JOIN dbo.r_action AS r_action_1 ON dbo.i_repairs.id = r_action_1.act_id INNER JOIN " +
                                                " dbo.r_reply AS r_reply_1 ON r_action_1.id_rep = r_reply_1.id INNER JOIN " +
                                                " dbo.r_request AS r_request_1 ON r_reply_1.idreq = r_request_1.req_id INNER JOIN " +
                                                " dbo.m_machine AS m_machine_1 ON r_request_1.machine_code = m_machine_1.id " +
                                                " WHERE(r_reply_1.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine_1.line = " + line + ") " +
                                                " GROUP BY r_action_1.act_id, dbo.i_repairs.operation", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdArtreplyLine.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdActreplyUnit.ExecuteReader();

            }
            else
            {
                rd = cmdActreply.ExecuteReader();
            }
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["operation"].ToString(), rd["total"].ToString()}
                };
                infoAct.AddRange(strList);
            }
            return new JavaScriptSerializer().Serialize(infoAct);
        }
        [WebMethod]
        public string Activemachin(int kind)
        {
            //kind 1 for ماشین آلات تولید 
            //kind 2 for تاسیسات و برق 
            //kind 3 for ساختمان 
            //kind 4 for حمل و نقل 
            var infoActiveMachin =new List<string[]>();
            cnn.Open();
            var cmdActiveMachin=new SqlCommand("SELECT CAST(COUNT(catState) * 100.0 /(SELECT COUNT(catState) AS kol "+
                                               " FROM dbo.m_machine "+
                                               " WHERE(catGroup = "+kind+ ")) AS numeric(12, 2)) AS persent, COUNT(catState) AS tedad," +
                                               " CASE WHEN catState = 1 THEN 'فعال' WHEN catState = 2 THEN 'معیوب' WHEN catState = 0 THEN 'غیر فعال' END AS name " +
                                               " FROM  dbo.m_machine AS m_machine_1"+
                                               " WHERE(catGroup = "+kind+")"+
                                               " GROUP BY catState",cnn);
            var rd = cmdActiveMachin.ExecuteReader();
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["name"].ToString(), rd["tedad"].ToString()}
                };
                infoActiveMachin.AddRange(strList);
            }
            return new JavaScriptSerializer().Serialize(infoActiveMachin);
        }
        [WebMethod]
        public string Maxsubsystem(int line,int unit,int count, string dateS, string dateE)
        {
            var infoMaxsubsystem = new ChartData();
            var list1 = new List<string>();
            var list2 = new List<decimal>();
            cnn.Open();
            var cmdMaxreq = new SqlCommand("SELECT TOP (" + count + ")  dbo.subsystem.name, COUNT(dbo.subsystem.code) AS count" +
                                           " FROM            dbo.m_subsystem INNER JOIN" +
                                           " dbo.subsystem ON dbo.m_subsystem.subId = dbo.subsystem.id INNER JOIN" +
                                           " dbo.r_reply ON dbo.m_subsystem.subId = dbo.r_reply.subsystem " +
                                           " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                           " GROUP BY dbo.subsystem.name ORDER BY count DESC", cnn);

            var cmdMaxrequnit=new SqlCommand(" SELECT  TOP (" + count + ") dbo.subsystem.name, COUNT(dbo.subsystem.code) AS count " +
                                             " FROM  dbo.m_subsystem INNER JOIN " +
                                             " dbo.subsystem ON dbo.m_subsystem.subId = dbo.subsystem.id INNER JOIN " +
                                             " dbo.r_reply ON dbo.m_subsystem.subId = dbo.r_reply.subsystem INNER JOIN " +
                                             " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                             " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                             " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.loc = "+unit+") " +
                                             " GROUP BY dbo.subsystem.name ORDER BY count DESC",cnn);

            var cmdMaxreqline= new SqlCommand(" SELECT  TOP (" + count + ") dbo.subsystem.name, COUNT(dbo.subsystem.code) AS count " +
                                              " FROM  dbo.m_subsystem INNER JOIN " +
                                              " dbo.subsystem ON dbo.m_subsystem.subId = dbo.subsystem.id INNER JOIN " +
                                              " dbo.r_reply ON dbo.m_subsystem.subId = dbo.r_reply.subsystem INNER JOIN " +
                                              " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                              " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                              " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.line = " + line + ") " +
                                              " GROUP BY dbo.subsystem.name ORDER BY count DESC", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdMaxreqline.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdMaxrequnit.ExecuteReader();

            }
            else
            {
                rd = cmdMaxreq.ExecuteReader();
            }
            while (rd.Read())
            {
                list1.Add(rd["name"].ToString());
                list2.Add(Convert.ToInt32(rd["count"]));
            }
            infoMaxsubsystem.Strings.AddRange(list1);
            infoMaxsubsystem.Integers.AddRange(list2);
            return new JavaScriptSerializer().Serialize(infoMaxsubsystem);
        }
        [WebMethod]
        public string MaxRequest(int count,int unit,string dateS, string dateE)
        {
            var infoMaxReq = new ChartData();
            var list1 = new List<string>();
            var list2 = new List<decimal>();
            cnn.Open();
            var cmdMaxreq = new SqlCommand("SELECT  TOP ("+count+") COUNT(dbo.m_machine.name) AS total, dbo.m_machine.code, dbo.m_machine.name "+
                                           " FROM  dbo.m_machine INNER JOIN "+
                                           " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN "+
                                           " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq "+
                                           " WHERE(dbo.r_request.date_req BETWEEN '"+dateS+"' AND '"+dateE+"') "+
                                           " GROUP BY dbo.m_machine.name, dbo.m_machine.code", cnn);

            var cmdMaxreqUnit= new SqlCommand("SELECT  TOP (" + count + ") COUNT(dbo.m_machine.name) AS total, dbo.m_machine.code, dbo.m_machine.name " +
                                              " FROM  dbo.m_machine INNER JOIN " +
                                              " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                              " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                              " WHERE(dbo.r_request.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND (m_machine.loc="+unit+") " +
                                              " GROUP BY dbo.m_machine.name, dbo.m_machine.code", cnn);
            SqlDataReader rd;
            if (unit != -1)
            {
                rd = cmdMaxreqUnit.ExecuteReader();
            }
            else 
            {
                rd = cmdMaxreq.ExecuteReader();
            }
            while (rd.Read())
            {
                list1.Add(rd["name"].ToString());
                list2.Add(Convert.ToInt32(rd["total"]));
            }
            infoMaxReq.Strings.AddRange(list1);
            infoMaxReq.Integers.AddRange(list2);
            return new JavaScriptSerializer().Serialize(infoMaxReq);
        }
        [WebMethod]
        public string TimeDelay(int line,int unit, string dateS, string dateE)//خرابی های پر هزینه 
        {
            var infoReqcost = new List<string[]>();
            cnn.Open();
            var cmdReqcost = new SqlCommand(" SELECT SUM(1 * DATEDIFF(minute, 0, dbo.r_reply.delay_time)) AS DelayTime, STRING_AGG(dbo.i_delay_reason.delay, ' ,') AS Dinfo, " +
                                            " dbo.r_reply.idreq, dbo.m_machine.name " +
                                            " FROM dbo.r_reply INNER JOIN " +
                                            " dbo.r_rdelay ON dbo.r_reply.id = dbo.r_rdelay.id_rep INNER JOIN " +
                                            " dbo.i_delay_reason ON dbo.r_rdelay.delay_id = dbo.i_delay_reason.id INNER JOIN " +
                                            " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                            " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                            " GROUP BY dbo.r_reply.idreq, dbo.m_machine.name", cnn);
            var cmdReqcostUnit = new SqlCommand(" SELECT SUM(1 * DATEDIFF(minute, 0, dbo.r_reply.delay_time)) AS DelayTime, STRING_AGG(dbo.i_delay_reason.delay, ' ,') AS Dinfo, " +
                                            " dbo.r_reply.idreq, dbo.m_machine.name " +
                                            " FROM dbo.r_reply INNER JOIN " +
                                            " dbo.r_rdelay ON dbo.r_reply.id = dbo.r_rdelay.id_rep INNER JOIN " +
                                            " dbo.i_delay_reason ON dbo.r_rdelay.delay_id = dbo.i_delay_reason.id INNER JOIN " +
                                            " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                            " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                            " where m_machine.loc = "+unit+" " +
                                            " GROUP BY dbo.r_reply.idreq, dbo.m_machine.name", cnn);
            var cmdReqcostline = new SqlCommand(" SELECT SUM(1 * DATEDIFF(minute, 0, dbo.r_reply.delay_time)) AS DelayTime, STRING_AGG(dbo.i_delay_reason.delay, ' ,') AS Dinfo, " +
                                            " dbo.r_reply.idreq, dbo.m_machine.name " +
                                            " FROM dbo.r_reply INNER JOIN " +
                                            " dbo.r_rdelay ON dbo.r_reply.id = dbo.r_rdelay.id_rep INNER JOIN " +
                                            " dbo.i_delay_reason ON dbo.r_rdelay.delay_id = dbo.i_delay_reason.id INNER JOIN " +
                                            " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                            " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                            " where m_machine.line = "+line+" " +
                                            " GROUP BY dbo.r_reply.idreq, dbo.m_machine.name", cnn);

            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdReqcostline.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdReqcostUnit.ExecuteReader();

            }
            else
            {
                rd = cmdReqcost.ExecuteReader();
            }
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["DelayTime"].ToString(),rd["Dinfo"].ToString(), rd["name"].ToString(),rd["idreq"].ToString() }
                };
                infoReqcost.AddRange(strList);
            }
            return new JavaScriptSerializer().Serialize(infoReqcost);
        }
        [WebMethod]
        public string RDelay(int line, int unit, string dateS, string dateE)
        {
            var infodelay = new ChartData();
            var list1 = new List<string>();
            var list2 = new List<decimal>();
            cnn.Open();
            var cmdDelay = new SqlCommand("SELECT dbo.i_delay_reason.delay, COUNT(dbo.i_delay_reason.id) AS total," +
                                          " CAST(COUNT(dbo.i_delay_reason.id) * 100.0 /(SELECT COUNT(dbo.r_rdelay.id_rep) AS EXPR1 "+
                                           " FROM dbo.r_rdelay INNER JOIN dbo.r_reply ON dbo.r_rdelay.id_rep = dbo.r_reply.id "+
                                           " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "')) AS numeric(12, 2)) AS persent " +
                                           " FROM dbo.i_delay_reason INNER JOIN "+
                                           " dbo.r_rdelay AS r_rdelay_1 ON dbo.i_delay_reason.id = r_rdelay_1.delay_id INNER JOIN "+
                                           " dbo.r_reply AS r_reply_1 ON r_rdelay_1.id_rep = r_reply_1.id "+
                                           " WHERE(r_reply_1.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                           " GROUP BY dbo.i_delay_reason.delay, dbo.i_delay_reason.id", cnn);

            var cmdDelayunit=new SqlCommand("SELECT dbo.i_delay_reason.delay, COUNT(dbo.i_delay_reason.id) AS total, CAST(COUNT(dbo.i_delay_reason.id) * 100.0 / " +
                                            " (SELECT        COUNT(dbo.r_rdelay.id_rep) AS EXPR1 " +
                                            " FROM            dbo.r_rdelay INNER JOIN " +
                                            " dbo.r_reply ON dbo.r_rdelay.id_rep = dbo.r_reply.id INNER JOIN " +
                                            " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                            " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                            " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.loc = "+unit+")) AS numeric(12, 2)) AS persent" +
                                            " FROM dbo.i_delay_reason INNER JOIN dbo.r_rdelay AS r_rdelay_1 ON dbo.i_delay_reason.id = r_rdelay_1.delay_id INNER JOIN " +
                                            " dbo.r_reply AS r_reply_1 ON r_rdelay_1.id_rep = r_reply_1.id INNER JOIN " +
                                            " dbo.r_request AS r_request_1 ON r_reply_1.idreq = r_request_1.req_id INNER JOIN " +
                                            " dbo.m_machine AS m_machine_1 ON r_request_1.machine_code = m_machine_1.id " +
                                            " WHERE(r_reply_1.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine_1.loc = "+unit+") " +
                                            " GROUP BY dbo.i_delay_reason.delay, dbo.i_delay_reason.id",cnn);

            var cmdDelayline = new SqlCommand("SELECT dbo.i_delay_reason.delay, COUNT(dbo.i_delay_reason.id) AS total, CAST(COUNT(dbo.i_delay_reason.id) * 100.0 / " +
                                              " (SELECT        COUNT(dbo.r_rdelay.id_rep) AS EXPR1 " +
                                              " FROM            dbo.r_rdelay INNER JOIN " +
                                              " dbo.r_reply ON dbo.r_rdelay.id_rep = dbo.r_reply.id INNER JOIN " +
                                              " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                              " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                              " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.line = " + line + ")) AS numeric(12, 2)) AS persent" +
                                              " FROM dbo.i_delay_reason INNER JOIN dbo.r_rdelay AS r_rdelay_1 ON dbo.i_delay_reason.id = r_rdelay_1.delay_id INNER JOIN " +
                                              " dbo.r_reply AS r_reply_1 ON r_rdelay_1.id_rep = r_reply_1.id INNER JOIN " +
                                              " dbo.r_request AS r_request_1 ON r_reply_1.idreq = r_request_1.req_id INNER JOIN " +
                                              " dbo.m_machine AS m_machine_1 ON r_request_1.machine_code = m_machine_1.id " +
                                              " WHERE(r_reply_1.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine_1.line = " + line + ") " +
                                              " GROUP BY dbo.i_delay_reason.delay, dbo.i_delay_reason.id", cnn);

            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdDelayline.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdDelayunit.ExecuteReader();

            }
            else
            {
                rd = cmdDelay.ExecuteReader();
            }
            while (rd.Read())
            {
                list1.Add(rd["delay"].ToString());
                list2.Add(Convert.ToInt32(rd["total"]));
            }
            infodelay.Strings.AddRange(list1);
            infodelay.Integers.AddRange(list2);
            return new JavaScriptSerializer().Serialize(infodelay);
        }
        [WebMethod]
        public string EmPmCm(int line,int unit,string dateS, string dateE)//نوع درخواست
        {
            var infoPm = new List<string[]>();
            cnn.Open();
            var cmdPm = new SqlCommand("SELECT CAST(COUNT(type_req) * 100.0 /(SELECT COUNT(type_req) AS kol FROM dbo.r_request "+
                                          " WHERE(date_req BETWEEN '" + dateS + "' AND '" + dateE + "')) AS numeric(12, 2)) AS perstate, COUNT(type_req) AS tedad, " +
                                          " CASE WHEN type_req = 1 THEN 'اضطراری' WHEN type_req = 2 THEN 'پیش بینانه' WHEN type_req = 3 THEN 'پیش گیرانه' END AS name "+
                                          " FROM dbo.r_request AS req WHERE(date_req BETWEEN '" + dateS + "' AND '" + dateE + "') GROUP BY type_req", cnn);

            var cmdPmunit=new SqlCommand(" SELECT  CAST(COUNT(req.type_req) * 100.0 / (SELECT   sum(kol) as T from(select COUNT(dbo.r_request.type_req) AS kol " +
                                         " FROM  dbo.r_request INNER JOIN dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                         " WHERE(r_request.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.loc = " + unit+") " +
                                         " GROUP BY dbo.m_machine.id) as T1) AS numeric(12, 2)) AS perstate, COUNT(req.type_req) AS tedad, " +
                                         " CASE WHEN type_req = 1 THEN 'اضطراری' WHEN type_req = 2 THEN 'پیش بینانه' WHEN type_req = 3 THEN 'پیش گیرانه' END AS name" +
                                         " FROM dbo.r_request AS req INNER JOIN " +
                                         " dbo.m_machine AS m_machine_1 ON req.machine_code = m_machine_1.id " +
                                         " WHERE(req.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine_1.loc = " + unit+") GROUP BY req.type_req",cnn);

            var cmdPmline = new SqlCommand(" SELECT  CAST(COUNT(req.type_req) * 100.0 / (SELECT   sum(kol) as T from(select COUNT(dbo.r_request.type_req) AS kol " +
                                           " FROM  dbo.r_request INNER JOIN dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                           " WHERE(r_request.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.line = " + line + ") " +
                                           " GROUP BY dbo.m_machine.id) as T1) AS numeric(12, 2)) AS perstate, COUNT(req.type_req) AS tedad, " +
                                           " CASE WHEN type_req = 1 THEN 'اضطراری' WHEN type_req = 2 THEN 'پیش بینانه' WHEN type_req = 3 THEN 'پیش گیرانه' END AS name" +
                                           " FROM dbo.r_request AS req INNER JOIN " +
                                           " dbo.m_machine AS m_machine_1 ON req.machine_code = m_machine_1.id " +
                                           " WHERE(req.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine_1.line = " + line + ") GROUP BY req.type_req", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdPmline.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdPmunit.ExecuteReader();

            }
            else
            {
                rd = cmdPm.ExecuteReader();
            }
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["name"].ToString(), rd["tedad"].ToString() }
                };
                infoPm.AddRange(strList);
            }
            return new JavaScriptSerializer().Serialize(infoPm);
        }
        [WebMethod]
        public string Failreason(int line, int unit, string dateS, string dateE)//دلایل خرابی
        {
            var infoFail = new ChartData();
            var list1 = new List<string>();
            var list2 = new List<decimal>();
           
            cnn.Open();
            var cmdfail = new SqlCommand("SELECT COUNT(dbo.i_fail_reason.id) AS total, dbo.i_fail_reason.fail "+
                                       " FROM dbo.i_fail_reason INNER JOIN "+
                                       " dbo.r_rfail ON dbo.i_fail_reason.id = dbo.r_rfail.fail_id INNER JOIN "+
                                       " dbo.r_reply ON dbo.r_rfail.id_rep = dbo.r_reply.id "+
                                       " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                       " GROUP BY dbo.i_fail_reason.id, dbo.i_fail_reason.fail", cnn);

            var cmdfailunit = new SqlCommand("SELECT COUNT(dbo.i_fail_reason.id) AS total, dbo.i_fail_reason.fail FROM dbo.i_fail_reason INNER JOIN " +
                                           " dbo.r_rfail ON dbo.i_fail_reason.id = dbo.r_rfail.fail_id INNER JOIN " +
                                           " dbo.r_reply ON dbo.r_rfail.id_rep = dbo.r_reply.id INNER JOIN " +
                                           " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                           " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                           " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.loc = "+unit+") " +
                                           " GROUP BY dbo.i_fail_reason.id, dbo.i_fail_reason.fail", cnn);

            var cmdfailline = new SqlCommand("SELECT COUNT(dbo.i_fail_reason.id) AS total, dbo.i_fail_reason.fail FROM dbo.i_fail_reason INNER JOIN " +
                                             " dbo.r_rfail ON dbo.i_fail_reason.id = dbo.r_rfail.fail_id INNER JOIN " +
                                             " dbo.r_reply ON dbo.r_rfail.id_rep = dbo.r_reply.id INNER JOIN " +
                                             " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                             " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                             " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.line = "+line+") " +
                                             " GROUP BY dbo.i_fail_reason.id, dbo.i_fail_reason.fail", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdfailline.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdfailunit.ExecuteReader();

            }
            else
            {
                rd = cmdfail.ExecuteReader();
            }
            while (rd.Read())
            {
                list1.Add(rd["fail"].ToString());
                list2.Add(Convert.ToInt32(rd["total"]));
            }
            infoFail.Strings.AddRange(list1);
            infoFail.Integers.AddRange(list2);
            
            
            return new JavaScriptSerializer().Serialize(infoFail);
        }
        [WebMethod]
        public string MachinType()//نوع ماشین آلات
        {
            var machineList = new List<string[]>();
            cnn.Open();
            var cmdMachine = new SqlCommand(" SELECT CAST(COUNT(catGroup) * 100.0 /(SELECT COUNT(catGroup) AS EXPR1 "+
                                         " FROM  dbo.m_machine) AS numeric(12, 2)) AS persent, COUNT(catGroup) AS total, "+
                                         " CASE WHEN catGroup = 1 THEN 'ماشین آلات تولید' WHEN catGroup = 2 THEN 'سیستم تاسیسات و برق' " +
                                         "WHEN catGroup = 3 THEN 'ساختمان' WHEN catGroup = 4 THEN 'حمل و نقل' END AS name "+
                                         " FROM dbo.m_machine AS m_machine_1 "+
                                         " GROUP BY catGroup", cnn);
            var rd = cmdMachine.ExecuteReader();
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["name"].ToString(), rd["total"].ToString() }
                };
                machineList.AddRange(strList);
            }
            return new JavaScriptSerializer().Serialize(machineList);
        }
        [WebMethod]
        public string MaxTools(int line,int unit,int count,string dateS, string dateE)//قطعات پر استفاده 
        {
            var infoTools = new ChartData();
            var list1 = new List<string>();
            var list2 = new List<decimal>();
            cnn.Open();
            var cmdTools = new SqlCommand("SELECT TOP ("+count+") Serial, PartName, SUM(count) AS tedad "+
                                         " FROM(SELECT help.PartName, dbo.r_tools.count, help.Serial "+
                                         " FROM dbo.r_tools INNER JOIN "+
                                         " sgdb.inv.Part AS help ON help.Serial = dbo.r_tools.tools_id INNER JOIN "+
                                         " dbo.r_reply ON dbo.r_tools.id_rep = dbo.r_reply.id "+
                                         " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                         " UNION ALL "+
                                         " SELECT help.PartName, dbo.s_subtools.count, help.Serial "+
                                         " FROM dbo.s_subtools INNER JOIN "+
                                         " sgdb.inv.Part AS help ON help.Serial = dbo.s_subtools.tools_id INNER JOIN "+
                                         " dbo.s_subhistory ON dbo.s_subtools.id_reptag = dbo.s_subhistory.id "+
                                         " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "')) AS tools " +
                                         " GROUP BY PartName, Serial "+
                                         " ORDER BY tedad DESC", cnn);

           var cmdToolsUnit=new SqlCommand(" SELECT TOP (" + count + ") Serial, PartName, SUM(count) AS tedad " +
                                        " FROM(SELECT help.PartName, dbo.r_tools.count, help.Serial " +
                                        " FROM dbo.r_tools INNER JOIN " +
                                        " sgdb.inv.Part AS help ON help.Serial = dbo.r_tools.tools_id INNER JOIN " +
                                        " dbo.r_reply ON dbo.r_tools.id_rep = dbo.r_reply.id INNER JOIN " +
                                        " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                        " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                        " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.loc = "+unit+") " +
                                        " UNION ALL " +
                                        " SELECT help.PartName, dbo.s_subtools.count, help.Serial " +
                                        " FROM dbo.s_subtools INNER JOIN " +
                                        " sgdb.inv.Part AS help ON help.Serial = dbo.s_subtools.tools_id INNER JOIN " +
                                        " dbo.s_subhistory ON dbo.s_subtools.id_reptag = dbo.s_subhistory.id " +
                                        " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.s_subhistory.new_unit = "+unit+")) AS T " +
                                        " GROUP BY PartName, Serial " +
                                        " ORDER BY tedad DESC",cnn);

            var cmdToolsLine = new SqlCommand(" SELECT TOP (10) Serial, PartName, SUM(count) AS tedad " +
                                              " FROM(SELECT help.PartName, dbo.r_tools.count, help.Serial " +
                                              " FROM dbo.r_tools INNER JOIN " +
                                              " sgdb.inv.Part AS help ON help.Serial = dbo.r_tools.tools_id INNER JOIN " +
                                              " dbo.r_reply ON dbo.r_tools.id_rep = dbo.r_reply.id INNER JOIN " +
                                              " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                              " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                              " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.line = "+line+") " +
                                              " UNION ALL " +
                                              " SELECT help.PartName, dbo.s_subtools.count, help.Serial " +
                                              " FROM dbo.s_subtools INNER JOIN " +
                                              " sgdb.inv.Part AS help ON help.Serial = dbo.s_subtools.tools_id INNER JOIN " +
                                              " dbo.s_subhistory ON dbo.s_subtools.id_reptag = dbo.s_subhistory.id " +
                                              " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.s_subhistory.new_line = "+line+")) AS T " +
                                              " GROUP BY PartName, Serial " +
                                              " ORDER BY tedad DESC", cnn);
           

            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdToolsLine.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdToolsUnit.ExecuteReader();

            }
            else
            {
                rd = cmdTools.ExecuteReader();
            }
            while (rd.Read())
            {
                list1.Add(rd["PartName"].ToString());
                list2.Add(Convert.ToInt32(rd["tedad"]));
            }
            infoTools.Strings.AddRange(list1);
            infoTools.Integers.AddRange(list2);
            return new JavaScriptSerializer().Serialize(infoTools);
        }
        [WebMethod]

        public string Personel(int kind,string dateS, string dateE)
        {
            var infoPersonel = new List<string[]>();
            cnn.Open();
            var cmdPersonel = new SqlCommand(" SELECT TOP (100) PERCENT per_name, per_id, CAST(SUM(min) / 60 AS nvarchar) + ':' + CAST({ fn MOD(SUM(min), 60) } AS nvarchar) AS totmin," +
                                             " SUM(min) / 60 AS Totalmin " +
                                             " FROM(SELECT dbo.i_personel.per_name, dbo.i_personel.per_id, -(1 * DATEDIFF(minute, dbo.s_subpersonel.time_work, 0)) AS min," +
                                             " dbo.s_subpersonel.time_work FROM dbo.i_personel INNER JOIN " +
                                             " dbo.s_subpersonel ON dbo.i_personel.id = dbo.s_subpersonel.per_id INNER JOIN " +
                                             " dbo.s_subhistory ON dbo.s_subpersonel.id_reptag = dbo.s_subhistory.id " +
                                             " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND (dbo.i_personel.unit = "+kind+")" +
                                             "            UNION ALL " +
                                             " SELECT i_personel_1.per_name, i_personel_1.per_id, -(1 * DATEDIFF(minute, dbo.r_personel.time_work, 0)) AS min, dbo.r_personel.time_work " +
                                             " FROM dbo.r_personel INNER JOIN " +
                                             " dbo.i_personel AS i_personel_1 ON dbo.r_personel.per_id = i_personel_1.id INNER JOIN " +
                                             " dbo.r_reply ON dbo.r_personel.id_rep = dbo.r_reply.id " +
                                             " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND (i_personel_1.unit = "+kind+")) AS T1 " +
                                             " GROUP BY per_name, per_id ORDER BY totmin", cnn);
            var rd = cmdPersonel.ExecuteReader();
            while (rd.Read())
            {
                infoPersonel.Add(new []{ rd["per_name"].ToString(), rd["totmin"].ToString()});
            }
            return new JavaScriptSerializer().Serialize(infoPersonel);
        }
        [WebMethod]
        public string EmPmtimePersonel(string dateS, string dateE)//گزارش نفر ساعت تعمیرات 
        {
            var infoTools = new ChartData();
            var list1 = new List<string>();
            var list2 = new List<decimal>();
            cnn.Open();
            var cmdEmPmtimePersonel = new SqlCommand(" SELECT SUM(- (1 * DATEDIFF(minute, dbo.r_personel.time_work, 0))) AS min, " +
                                          " CASE WHEN dbo.r_request.type_req = 1 THEN 'اضطراری' WHEN dbo.r_request.type_req = 2 THEN 'پیش بینانه'" +
                                          " WHEN dbo.r_request.type_req = 3 THEN 'پیش گیرانه' END AS TypeReq " +
                                          " FROM dbo.r_personel INNER JOIN " +
                                          " dbo.i_personel AS i_personel_1 ON dbo.r_personel.per_id = i_personel_1.id INNER JOIN " +
                                          " dbo.r_reply ON dbo.r_personel.id_rep = dbo.r_reply.id INNER JOIN " +
                                          " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id " +
                                          " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                          " GROUP BY dbo.r_request.type_req", cnn);

            var rd = cmdEmPmtimePersonel.ExecuteReader();
            while (rd.Read())
            {
                list1.Add(rd["TypeReq"].ToString());
                list2.Add(Convert.ToInt32(rd["min"]));
            }
            infoTools.Strings.AddRange(list1);
            infoTools.Integers.AddRange(list2);
            return new JavaScriptSerializer().Serialize(infoTools);
        }
        [WebMethod]
        public string RepState(string dateS, string dateE)
        {
            var infoRepstate = new List<string[]>();
            cnn.Open();
            var cmdRepstate = new SqlCommand("SELECT COUNT(rep_state) AS total, CAST(COUNT(rep_state) * 100.0 /(SELECT COUNT(rep_state) AS EXPR1 "+
                                             "FROM dbo.r_reply WHERE(start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "')) AS numeric(12, 2)) AS persent, " +
                                             "CASE WHEN rep_state = 1 THEN 'تعمیرات معمول بدون توقف دستگاه' WHEN rep_state = 2 THEN 'تعمیرات در حالت خواب دستگاه' WHEN rep_state = 3" +
                                             " THEN 'از کار افتادن خط تولید یا دستگاه در لحظه درخواست' WHEN rep_state = 4 THEN 'ادامه فعالیت دستگاه تا رسیدن قطعه یا تامین نیرو' "+
                                             "END AS name FROM dbo.r_reply AS r_reply_1 WHERE(start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                             "GROUP BY rep_state", cnn);
            var rd = cmdRepstate.ExecuteReader();
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["name"].ToString(), rd["total"].ToString() }
                };
                infoRepstate.AddRange(strList);
            }
            return new JavaScriptSerializer().Serialize(infoRepstate);
        }
        [WebMethod]
        public string Typefailreason(int line,int unit,string dateS, string dateE)//علت خرابی
        {
            var infoFail = new List<string[]>();
            cnn.Open();
            var cmdFail = new SqlCommand("SELECT CAST(COUNT(type_fail) * 100.0 / (SELECT COUNT(type_fail) AS T FROM dbo.r_request "+
                                         " WHERE(date_req BETWEEN '" + dateS + "' AND '" + dateE + "')) AS NUMERIC(12, 2)) AS persent, COUNT(type_fail) AS total, " +
                                         " CASE WHEN type_fail = 1 THEN 'مکانیکی' WHEN type_fail = 2 THEN 'تاسیساتی -الکتریکی' " +
                                         "WHEN type_fail = 3 THEN 'الکتریکی واحد برق' WHEN type_fail = 4 THEN 'متفرقه' END AS name "+
                                         " FROM dbo.r_request AS r_request_1 WHERE(date_req BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                         " GROUP BY type_fail", cnn);
            

            var cmdFailline = new SqlCommand(" SELECT  CAST(COUNT(r_request_1.type_fail) * 100.0 /(SELECT SUM(T) AS T FROM(SELECT COUNT(dbo.r_request.type_fail) AS T " +
                                             " FROM dbo.r_request INNER JOIN dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id" +
                                             " WHERE(dbo.r_request.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.line = " + line + ")" +
                                             " GROUP BY dbo.m_machine.id) AS derivedtbl_1) AS NUMERIC(12, 2)) AS persent, COUNT(r_request_1.type_fail) AS total," +
                                             " CASE WHEN type_fail = 1 THEN 'مکانیکی' WHEN type_fail = 2 THEN 'تاسیساتی -الکتریکی' WHEN type_fail = 3 THEN 'الکتریکی واحد برق' WHEN type_fail = 4 THEN 'متفرقه' END AS name" +
                                             " FROM dbo.r_request AS r_request_1 INNER JOIN" +
                                             " dbo.m_machine AS m_machine_1 ON r_request_1.machine_code = m_machine_1.id" +
                                             " WHERE(r_request_1.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine_1.line = " + line+") " +
                                             " GROUP BY r_request_1.type_fail", cnn);

            var cmdFailunit = new SqlCommand(" SELECT  CAST(COUNT(r_request_1.type_fail) * 100.0 /(SELECT SUM(T) AS T FROM(SELECT COUNT(dbo.r_request.type_fail) AS T " +
                                             " FROM dbo.r_request INNER JOIN dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id" +
                                             " WHERE(dbo.r_request.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.loc = " + unit + ")" +
                                             " GROUP BY dbo.m_machine.id) AS derivedtbl_1) AS NUMERIC(12, 2)) AS persent, COUNT(r_request_1.type_fail) AS total," +
                                             " CASE WHEN type_fail = 1 THEN 'مکانیکی' WHEN type_fail = 2 THEN 'تاسیساتی -الکتریکی' WHEN type_fail = 3 THEN 'الکتریکی واحد برق' WHEN type_fail = 4 THEN 'متفرقه' END AS name" +
                                             " FROM dbo.r_request AS r_request_1 INNER JOIN" +
                                             " dbo.m_machine AS m_machine_1 ON r_request_1.machine_code = m_machine_1.id" +
                                             " WHERE(r_request_1.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine_1.loc = " + unit + ") " +
                                             " GROUP BY r_request_1.type_fail", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd= cmdFailline.ExecuteReader();
                
            }
            else if(unit !=-1)
            {
                rd= cmdFailunit.ExecuteReader();
               
            }
            else
            {
                rd = cmdFail.ExecuteReader();
            }

            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["name"].ToString(), rd["total"].ToString() }
                };
                infoFail.AddRange(strList);
            }
            return new JavaScriptSerializer().Serialize(infoFail);
        }
        [WebMethod]
        public string TotalTimeRepStop(int line,int unit,string dateS, string dateE) //مجموع مدت زمان تعمیر و توقف در بازه زمان 
        {
            var infoTotal = new List<string[]>();
            cnn.Open();
            var cmdTotalTime = new SqlCommand("SELECT CAST(Tstop / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Tstop / 60, 60) }" +
                                              " AS nvarchar) AS Tstop, CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Trep / 60, 60) } AS nvarchar) AS Trepair " +
                                              " FROM(SELECT SUM(-(1 * DATEDIFF(second, stop_time_help, 0))) AS Tstop," +
                                              " SUM(-(1 * DATEDIFF(second, rep_time_help, 0))) AS Trep FROM dbo.r_reply " +
                                              " WHERE(start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "')) AS T1", cnn);

            var cmdTotalTimeunit=new SqlCommand("SELECT        CAST(Tstop / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Tstop / 60, 60) } AS nvarchar) AS Tstop," +
                                                " CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Trep / 60, 60) } AS nvarchar) AS Trepair " +
                                                " FROM(SELECT        SUM(-(1 * DATEDIFF(second, dbo.r_reply.stop_time_help, 0))) AS Tstop, SUM(-(1 * DATEDIFF(second, dbo.r_reply.rep_time_help, 0))) AS Trep " +
                                                "FROM dbo.r_reply INNER JOIN dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                                "dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                                "WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.loc = " + unit+")) AS T1",cnn);

            var cmdTotalTimeline = new SqlCommand("SELECT        CAST(Tstop / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Tstop / 60, 60) } AS nvarchar) AS Tstop," +
                                                  " CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Trep / 60, 60) } AS nvarchar) AS Trepair " +
                                                  " FROM(SELECT        SUM(-(1 * DATEDIFF(second, dbo.r_reply.stop_time_help, 0))) AS Tstop, SUM(-(1 * DATEDIFF(second, dbo.r_reply.rep_time_help, 0))) AS Trep " +
                                                  "FROM dbo.r_reply INNER JOIN dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                                  "dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                                  "WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.line = " + line + ")) AS T1", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdTotalTimeline.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdTotalTimeunit.ExecuteReader();

            }
            else
            {
                rd = cmdTotalTime.ExecuteReader();
            }
            while (rd.Read())
            {
                var strList = new List<string[]>{new[] { rd["Tstop"].ToString(),rd["Trepair"].ToString()}};
                infoTotal.AddRange(strList);
            }
            var obj = new {Total = infoTotal , flag = 0 };
            return new JavaScriptSerializer().Serialize(obj);
        }
        [WebMethod]
        public string MaxTimeRep_perMachine(int line, int unit, string dateS, string dateE, int count) //مدت زمان تعمیر ماشین -بیشترین مدت زمان تعمیر یک دستگاه
        {
            var infoperMachine = new List<string[]>();
            cnn.Open();
            var cmdMaxTimePerMachine = new SqlCommand("SELECT  TOP (" + count + ") name, code, CAST(Tstop / 60 / 60 AS nvarchar) + ':' + " +
                                                      "CAST({ fn MOD(Tstop / 60, 60) } AS nvarchar) AS Tstop," +
                                                      " CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Trep / 60, 60) } AS nvarchar) " +
                                                      " AS Trepair FROM(SELECT TOP(100) PERCENT dbo.m_machine.name," +
                                                      " SUM(-(1 * DATEDIFF(second, dbo.r_reply.stop_time_help, 0))) AS Tstop," +
                                                      " SUM(-(1 * DATEDIFF(second, dbo.r_reply.rep_time_help, 0))) AS Trep, " +
                                                      " dbo.m_machine.code " +
                                                      " FROM dbo.m_machine INNER JOIN " +
                                                      " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                                      " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                                      " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "')  " +
                                                      " GROUP BY dbo.m_machine.name, dbo.m_machine.code " +
                                                      " ORDER BY Trep DESC) AS T1 ORDER BY Trepair DESC", cnn);

            var cmdMaxTimePerMachineUnit = new SqlCommand("SELECT  TOP (" + count + ") name, code, CAST(Tstop / 60 / 60 AS nvarchar) + ':' + " +
                                                      "CAST({ fn MOD(Tstop / 60, 60) } AS nvarchar) AS Tstop," +
                                                      " CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Trep / 60, 60) } AS nvarchar) " +
                                                      " AS Trepair FROM(SELECT TOP(100) PERCENT dbo.m_machine.name," +
                                                      " SUM(-(1 * DATEDIFF(second, dbo.r_reply.stop_time_help, 0))) AS Tstop," +
                                                      " SUM(-(1 * DATEDIFF(second, dbo.r_reply.rep_time_help, 0))) AS Trep, " +
                                                      " dbo.m_machine.code " +
                                                      " FROM dbo.m_machine INNER JOIN " +
                                                      " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                                      " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                                      " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND m_machine.loc="+unit+"  " +
                                                      " GROUP BY dbo.m_machine.name, dbo.m_machine.code " +
                                                      " ORDER BY Trep DESC) AS T1 ORDER BY Trepair DESC", cnn);

            var cmdMaxTimePerMachineLine = new SqlCommand("SELECT  TOP (" + count + ") name, code, CAST(Tstop / 60 / 60 AS nvarchar) + ':' + " +
                                                          "CAST({ fn MOD(Tstop / 60, 60) } AS nvarchar) AS Tstop," +
                                                          " CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Trep / 60, 60) } AS nvarchar) " +
                                                          " AS Trepair FROM(SELECT TOP(100) PERCENT dbo.m_machine.name," +
                                                          " SUM(-(1 * DATEDIFF(second, dbo.r_reply.stop_time_help, 0))) AS Tstop," +
                                                          " SUM(-(1 * DATEDIFF(second, dbo.r_reply.rep_time_help, 0))) AS Trep, " +
                                                          " dbo.m_machine.code " +
                                                          " FROM dbo.m_machine INNER JOIN " +
                                                          " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                                          " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                                          " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND m_machine.line=" + line + "  " +
                                                          " GROUP BY dbo.m_machine.name, dbo.m_machine.code " +
                                                          " ORDER BY Trep DESC) AS T1 ORDER BY Trepair DESC", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdMaxTimePerMachineLine.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdMaxTimePerMachineUnit.ExecuteReader();

            }
            else
            {
                rd = cmdMaxTimePerMachine.ExecuteReader();
            }
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["name"].ToString(), rd["code"].ToString(), rd["Trepair"].ToString() }
                };
                infoperMachine.AddRange(strList);
            }
            var obj = new { Total = infoperMachine, flag = 1 };
            return new JavaScriptSerializer().Serialize(obj);
        }
        [WebMethod]
        public string MaxTimeStop_perMachine(int line,int unit,string dateS, string dateE, int count)//مدت زمان توقف ماشین -بیشترین مدت زمان توقف کلی یک دستگاه 
        {
            var infoperMachine = new List<string[]>();
            cnn.Open();
            var cmdMaxTimePerMachine = new SqlCommand("SELECT  TOP (" + count + ") name, code, CAST(Tstop / 60 / 60 AS nvarchar) + ':' + CAST" +
                                                      "({ fn MOD(Tstop / 60, 60) } AS nvarchar) AS Tstop," +
                                                      " CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Trep / 60, 60) } AS nvarchar) " +
                                                      " AS Trepair FROM(SELECT TOP(100) PERCENT dbo.m_machine.name," +
                                                      " SUM(-(1 * DATEDIFF(second, dbo.r_reply.stop_time_help, 0))) AS Tstop," +
                                                      " SUM(-(1 * DATEDIFF(second, dbo.r_reply.rep_time_help, 0))) AS Trep, " +
                                                      " dbo.m_machine.code FROM dbo.m_machine INNER JOIN " +
                                                      " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                                      " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                                      " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "')  " +
                                                      " GROUP BY dbo.m_machine.name, dbo.m_machine.code " +
                                                      " ORDER BY Tstop DESC) AS T1 ORDER BY Tstop DESC", cnn);

            var cmdMaxTimePerMachineUnit = new SqlCommand("SELECT  TOP (" + count + ") name, code, CAST(Tstop / 60 / 60 AS nvarchar) + ':' + CAST" +
                                                      "({ fn MOD(Tstop / 60, 60) } AS nvarchar) AS Tstop," +
                                                      " CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Trep / 60, 60) } AS nvarchar) " +
                                                      " AS Trepair FROM(SELECT TOP(100) PERCENT dbo.m_machine.name," +
                                                      " SUM(-(1 * DATEDIFF(second, dbo.r_reply.stop_time_help, 0))) AS Tstop," +
                                                      " SUM(-(1 * DATEDIFF(second, dbo.r_reply.rep_time_help, 0))) AS Trep, " +
                                                      " dbo.m_machine.code FROM dbo.m_machine INNER JOIN " +
                                                      " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                                      " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                                      " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') and m_machine.loc="+unit+"  " +
                                                      " GROUP BY dbo.m_machine.name, dbo.m_machine.code " +
                                                      " ORDER BY Tstop DESC) AS T1 ORDER BY Tstop DESC", cnn);

            var cmdMaxTimePerMachineLine = new SqlCommand("SELECT  TOP (" + count + ") name, code, CAST(Tstop / 60 / 60 AS nvarchar) + ':' + CAST" +
                                                      "({ fn MOD(Tstop / 60, 60) } AS nvarchar) AS Tstop," +
                                                      " CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Trep / 60, 60) } AS nvarchar) " +
                                                      " AS Trepair FROM(SELECT TOP(100) PERCENT dbo.m_machine.name," +
                                                      " SUM(-(1 * DATEDIFF(second, dbo.r_reply.stop_time_help, 0))) AS Tstop," +
                                                      " SUM(-(1 * DATEDIFF(second, dbo.r_reply.rep_time_help, 0))) AS Trep, " +
                                                      " dbo.m_machine.code FROM dbo.m_machine INNER JOIN " +
                                                      " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                                      " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                                      " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') and m_machine.line="+line+" " +
                                                      " GROUP BY dbo.m_machine.name, dbo.m_machine.code " +
                                                      " ORDER BY Tstop DESC) AS T1 ORDER BY Tstop DESC", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdMaxTimePerMachineLine.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdMaxTimePerMachineUnit.ExecuteReader();

            }
            else
            {
                rd = cmdMaxTimePerMachine.ExecuteReader();
            }
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["name"].ToString(),rd["code"].ToString(), rd["Tstop"].ToString() }
                };
                infoperMachine.AddRange(strList);
            }
            var obj = new { Total = infoperMachine, flag = 2 };
            return new JavaScriptSerializer().Serialize(obj);
        }
        [WebMethod]
        public string MaxTimeRep_Detail(int line,int unit,string dateS, string dateE, int count) //مدت زمان تعمیر بر بنای درخواست- گزارش بیشترین مدت زمان تعمیر 
        {
            var infoDetail = new List<string[]>();
            cnn.Open();
            var cmdMaxTimeDetail = new SqlCommand("SELECT name, req_id, code, CAST(Tstop / 60 / 60 AS nvarchar) + ':' + CAST" +
                                                  "({ fn MOD(Tstop / 60, 60) } AS nvarchar) AS Tstop," +
                                                  " CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Trep / 60, 60) } AS nvarchar) AS Trepair, TypeReq " +
                                                  " FROM(SELECT TOP(" + count + ") dbo.m_machine.name," +
                                                  " -(1 * DATEDIFF(second, dbo.r_reply.stop_time_help, 0)) AS Tstop," +
                                                  " -(1 * DATEDIFF(second, dbo.r_reply.rep_time_help, 0)) AS Trep, dbo.r_request.req_id,dbo.m_machine.code, " +
                                                  " CASE WHEN dbo.r_request.type_req = 1 THEN 'اضطراری' WHEN dbo.r_request.type_req = 2 THEN 'پیش بینانه'" +
                                                  " WHEN dbo.r_request.type_req = 3 THEN 'پیش گیرانه' END AS TypeReq " +
                                                  " FROM dbo.m_machine INNER JOIN " +
                                                  " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                                  " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                                  " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                                  " ORDER BY Trep DESC) AS T1 ORDER BY Trepair DESC", cnn);

            var cmdMaxTimeDetailunit = new SqlCommand("SELECT name, req_id, code, CAST(Tstop / 60 / 60 AS nvarchar) + ':' + CAST" +
                                                  "({ fn MOD(Tstop / 60, 60) } AS nvarchar) AS Tstop," +
                                                  " CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Trep / 60, 60) } AS nvarchar) AS Trepair, TypeReq " +
                                                  " FROM(SELECT TOP(" + count + ") dbo.m_machine.name," +
                                                  " -(1 * DATEDIFF(second, dbo.r_reply.stop_time_help, 0)) AS Tstop," +
                                                  " -(1 * DATEDIFF(second, dbo.r_reply.rep_time_help, 0)) AS Trep, dbo.r_request.req_id,dbo.m_machine.code, " +
                                                  " CASE WHEN dbo.r_request.type_req = 1 THEN 'اضطراری' WHEN dbo.r_request.type_req = 2 THEN 'پیش بینانه'" +
                                                  " WHEN dbo.r_request.type_req = 3 THEN 'پیش گیرانه' END AS TypeReq " +
                                                  " FROM dbo.m_machine INNER JOIN " +
                                                  " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                                  " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                                  " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND m_machine.unit="+unit+" " +
                                                  " ORDER BY Trep DESC) AS T1 ORDER BY Trepair DESC", cnn);

            var cmdMaxTimeDetailline = new SqlCommand("SELECT name, req_id, code, CAST(Tstop / 60 / 60 AS nvarchar) + ':' + CAST" +
                                                  "({ fn MOD(Tstop / 60, 60) } AS nvarchar) AS Tstop," +
                                                  " CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST({ fn MOD(Trep / 60, 60) } AS nvarchar) AS Trepair, TypeReq " +
                                                  " FROM(SELECT TOP(" + count + ") dbo.m_machine.name," +
                                                  " -(1 * DATEDIFF(second, dbo.r_reply.stop_time_help, 0)) AS Tstop," +
                                                  " -(1 * DATEDIFF(second, dbo.r_reply.rep_time_help, 0)) AS Trep, dbo.r_request.req_id,dbo.m_machine.code, " +
                                                  " CASE WHEN dbo.r_request.type_req = 1 THEN 'اضطراری' WHEN dbo.r_request.type_req = 2 THEN 'پیش بینانه'" +
                                                  " WHEN dbo.r_request.type_req = 3 THEN 'پیش گیرانه' END AS TypeReq " +
                                                  " FROM dbo.m_machine INNER JOIN " +
                                                  " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                                  " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                                  " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND m_machine.line="+line+" " +
                                                  " ORDER BY Trep DESC) AS T1 ORDER BY Trepair DESC", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdMaxTimeDetailline.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdMaxTimeDetailunit.ExecuteReader();

            }
            else
            {
                rd = cmdMaxTimeDetail.ExecuteReader();
            }
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["req_id"].ToString(),rd["name"].ToString(), rd["code"].ToString(), rd["Tstop"].ToString(), rd["Trepair"].ToString(), rd["TypeReq"].ToString() }
                };
                infoDetail.AddRange(strList);
            }
            var obj = new { Total = infoDetail, flag = 3 };
            return new JavaScriptSerializer().Serialize(obj);
        }
        [WebMethod]
        public string MaxTimeStop_Detail(int line,int unit,string dateS, string dateE, int count)//گزارش بیشترین توقف -مدت زمان توقف بر مبنای درخواست 
        {
            var infoDetail = new List<string[]>();
            cnn.Open();
            var cmdMaxTimeDetail = new SqlCommand("SELECT name, req_id, code, CAST(Tstop / 60 / 60 AS nvarchar) + ':' + CAST" +
                                                  "({ fn MOD(Tstop / 60, 60) } AS nvarchar) AS Tstop, CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST" +
                                                  "({ fn MOD(Trep / 60, 60) } AS nvarchar) AS Trepair, TypeReq " +
                                                  " FROM(SELECT TOP(" + count + ") dbo.m_machine.name," +
                                                  " -(1 * DATEDIFF(second, dbo.r_reply.stop_time_help, 0)) AS Tstop," +
                                                  " -(1 * DATEDIFF(second, dbo.r_reply.rep_time_help, 0)) AS Trep, dbo.r_request.req_id,  " +
                                                  " dbo.m_machine.code, " +
                                                  " CASE WHEN dbo.r_request.type_req = 1 THEN 'اضطراری' WHEN dbo.r_request.type_req = 2 " +
                                                  "THEN 'پیش بینانه' WHEN dbo.r_request.type_req = 3 THEN 'پیش گیرانه' END AS TypeReq " +
                                                  " FROM dbo.m_machine INNER JOIN " +
                                                  " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                                  " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                                  " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                                  " ORDER BY Tstop DESC) AS T1 ORDER BY Tstop DESC ", cnn);

            var cmdMaxTimeDetailunit = new SqlCommand("SELECT name, req_id, code, CAST(Tstop / 60 / 60 AS nvarchar) + ':' + CAST" +
                                                  "({ fn MOD(Tstop / 60, 60) } AS nvarchar) AS Tstop, CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST" +
                                                  "({ fn MOD(Trep / 60, 60) } AS nvarchar) AS Trepair, TypeReq " +
                                                  " FROM(SELECT TOP(" + count + ") dbo.m_machine.name," +
                                                  " -(1 * DATEDIFF(second, dbo.r_reply.stop_time_help, 0)) AS Tstop," +
                                                  " -(1 * DATEDIFF(second, dbo.r_reply.rep_time_help, 0)) AS Trep, dbo.r_request.req_id,  " +
                                                  " dbo.m_machine.code, " +
                                                  " CASE WHEN dbo.r_request.type_req = 1 THEN 'اضطراری' WHEN dbo.r_request.type_req = 2 " +
                                                  "THEN 'پیش بینانه' WHEN dbo.r_request.type_req = 3 THEN 'پیش گیرانه' END AS TypeReq " +
                                                  " FROM dbo.m_machine INNER JOIN " +
                                                  " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                                  " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                                  " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') and m_machine.loc="+unit+" " +
                                                  " ORDER BY Tstop DESC) AS T1 ORDER BY Tstop DESC ", cnn);

            var cmdMaxTimeDetailline = new SqlCommand("SELECT name, req_id, code, CAST(Tstop / 60 / 60 AS nvarchar) + ':' + CAST" +
                                                  "({ fn MOD(Tstop / 60, 60) } AS nvarchar) AS Tstop, CAST(Trep / 60 / 60 AS nvarchar) + ':' + CAST" +
                                                  "({ fn MOD(Trep / 60, 60) } AS nvarchar) AS Trepair, TypeReq " +
                                                  " FROM(SELECT TOP(" + count + ") dbo.m_machine.name," +
                                                  " -(1 * DATEDIFF(second, dbo.r_reply.stop_time_help, 0)) AS Tstop," +
                                                  " -(1 * DATEDIFF(second, dbo.r_reply.rep_time_help, 0)) AS Trep, dbo.r_request.req_id,  " +
                                                  " dbo.m_machine.code, " +
                                                  " CASE WHEN dbo.r_request.type_req = 1 THEN 'اضطراری' WHEN dbo.r_request.type_req = 2 " +
                                                  "THEN 'پیش بینانه' WHEN dbo.r_request.type_req = 3 THEN 'پیش گیرانه' END AS TypeReq " +
                                                  " FROM dbo.m_machine INNER JOIN " +
                                                  " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                                  " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                                  " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') and m_machine.line="+line+" " +
                                                  " ORDER BY Tstop DESC) AS T1 ORDER BY Tstop DESC ", cnn);

            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdMaxTimeDetailline.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdMaxTimeDetailunit.ExecuteReader();

            }
            else
            {
                rd = cmdMaxTimeDetail.ExecuteReader();
            }
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["req_id"].ToString(),rd["name"].ToString(), rd["code"].ToString(), rd["Tstop"].ToString(), rd["Trepair"].ToString(), rd["TypeReq"].ToString() }
                };
                infoDetail.AddRange(strList);
            }
            var obj = new { Total = infoDetail, flag = 4 };
            return new JavaScriptSerializer().Serialize(obj);
        }
        [WebMethod]
        public string RepairStopCost(int faz,int line, int unit, string dateS, string dateE)//هزینه توقفات تعمیرات
        {
            var infoStopCost = new List<string[]>();
            cnn.Open();
            var cmdUnit = new SqlCommand("SELECT (SUM(dbo.r_reply.elec_time) + SUM(dbo.r_reply.mech_time)) * (dbo.m_machine.stopcost / 60) AS TotalCost," +
                                              " SUM(dbo.r_reply.elec_time) * (dbo.m_machine.stopcost / 60) AS Ecost, SUM(dbo.r_reply.mech_time) " +
                                              " * (dbo.m_machine.stopcost / 60) AS Mcost, dbo.m_machine.name" +
                                              " FROM dbo.m_machine INNER JOIN " +
                                              " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                              " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                              " WHERE(dbo.m_machine.loc =" + unit + ") AND(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                              " GROUP BY dbo.m_machine.name, dbo.m_machine.stopcost", cnn);

            var cmdFaz = new SqlCommand("SELECT (SUM(dbo.r_reply.elec_time) + SUM(dbo.r_reply.mech_time)) * (dbo.m_machine.stopcost / 60) AS TotalCost," +
                                         " SUM(dbo.r_reply.elec_time) * (dbo.m_machine.stopcost / 60) AS Ecost, SUM(dbo.r_reply.mech_time) " +
                                         " * (dbo.m_machine.stopcost / 60) AS Mcost, dbo.m_machine.name" +
                                         " FROM dbo.m_machine INNER JOIN " +
                                         " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                         " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                         " WHERE(dbo.m_machine.faz =" + faz + ") AND(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                         " GROUP BY dbo.m_machine.name, dbo.m_machine.stopcost", cnn);

            var cmdLine = new SqlCommand("SELECT (SUM(dbo.r_reply.elec_time) + SUM(dbo.r_reply.mech_time)) * (dbo.m_machine.stopcost / 60) AS TotalCost," +
                                         " SUM(dbo.r_reply.elec_time) * (dbo.m_machine.stopcost / 60) AS Ecost, SUM(dbo.r_reply.mech_time) " +
                                         " * (dbo.m_machine.stopcost / 60) AS Mcost, dbo.m_machine.name" +
                                         " FROM dbo.m_machine INNER JOIN " +
                                         " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                         " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                         " WHERE(dbo.m_machine.line =" + line + ") AND(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                         " GROUP BY dbo.m_machine.name, dbo.m_machine.stopcost", cnn);

            var cmdtot = new SqlCommand("SELECT (SUM(dbo.r_reply.elec_time) + SUM(dbo.r_reply.mech_time)) * (dbo.m_machine.stopcost / 60) AS TotalCost," +
                                         " SUM(dbo.r_reply.elec_time) * (dbo.m_machine.stopcost / 60) AS Ecost, SUM(dbo.r_reply.mech_time) " +
                                         " * (dbo.m_machine.stopcost / 60) AS Mcost, dbo.m_machine.name" +
                                         " FROM dbo.m_machine INNER JOIN " +
                                         " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                         " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                         " WHERE (dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                         " GROUP BY dbo.m_machine.name, dbo.m_machine.stopcost", cnn);



            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdLine.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdUnit.ExecuteReader();

            }
            else if (faz != -1)
            {
                rd = cmdFaz.ExecuteReader();

            }
            else
            {
                rd = cmdtot.ExecuteReader();
            }
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["TotalCost"].ToString(), rd["Ecost"].ToString(), rd["Mcost"].ToString(), rd["name"].ToString() }
                };
                infoStopCost.AddRange(strList);
            }
            return new JavaScriptSerializer().Serialize(infoStopCost);
        }
        [WebMethod]
        public string ProductStopCost(int faz, int line, int unit, string dateS, string dateE)//هزینه توقفات منجر به توقف تولید
        {
            var infoStopCost = new List<string[]>();
            cnn.Open();
            var cmdUnit = new SqlCommand("SELECT SUM(dbo.t_StopEffect.stop_time) * (dbo.m_machine.stopcost / 60) AS StopCost, dbo.m_machine.name " +
                                         " FROM dbo.t_StopEffect INNER JOIN " +
                                         " dbo.m_machine ON dbo.t_StopEffect.sub_mid = dbo.m_machine.id INNER JOIN " +
                                         " dbo.r_request ON dbo.t_StopEffect.reqid = dbo.r_request.req_id INNER JOIN " +
                                         " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq "+
                                         " WHERE(dbo.m_machine.loc =" + unit + ") AND(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                         " GROUP BY dbo.m_machine.name, dbo.m_machine.stopcost", cnn);

            var cmdFaz = new SqlCommand("SELECT SUM(dbo.t_StopEffect.stop_time) * (dbo.m_machine.stopcost / 60) AS StopCost, dbo.m_machine.name " +
                                        " FROM dbo.t_StopEffect INNER JOIN " +
                                        " dbo.m_machine ON dbo.t_StopEffect.sub_mid = dbo.m_machine.id INNER JOIN " +
                                        " dbo.r_request ON dbo.t_StopEffect.reqid = dbo.r_request.req_id INNER JOIN " +
                                        " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                        " WHERE(dbo.m_machine.faz =" + faz + ") AND(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                        " GROUP BY dbo.m_machine.name, dbo.m_machine.stopcost", cnn);

            var cmdLine = new SqlCommand("SELECT SUM(dbo.t_StopEffect.stop_time) * (dbo.m_machine.stopcost / 60) AS StopCost, dbo.m_machine.name " +
                                         " FROM dbo.t_StopEffect INNER JOIN " +
                                         " dbo.m_machine ON dbo.t_StopEffect.sub_mid = dbo.m_machine.id INNER JOIN " +
                                         " dbo.r_request ON dbo.t_StopEffect.reqid = dbo.r_request.req_id INNER JOIN " +
                                         " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                         " WHERE(dbo.m_machine.line =" + line + ") AND(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                         " GROUP BY dbo.m_machine.name, dbo.m_machine.stopcost", cnn);

            var cmdtot = new SqlCommand("SELECT SUM(dbo.t_StopEffect.stop_time) * (dbo.m_machine.stopcost / 60) AS StopCost, dbo.m_machine.name " +
                                        " FROM dbo.t_StopEffect INNER JOIN " +
                                        " dbo.m_machine ON dbo.t_StopEffect.sub_mid = dbo.m_machine.id INNER JOIN " +
                                        " dbo.r_request ON dbo.t_StopEffect.reqid = dbo.r_request.req_id INNER JOIN " +
                                        " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                        " WHERE (dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                        " GROUP BY dbo.m_machine.name, dbo.m_machine.stopcost", cnn);



            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdLine.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdUnit.ExecuteReader();

            }
            else if (faz != -1)
            {
                rd = cmdFaz.ExecuteReader();

            }
            else
            {
                rd = cmdtot.ExecuteReader();
            }
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["StopCost"].ToString(),rd["name"].ToString() }
                };
                infoStopCost.AddRange(strList);
            }
            return new JavaScriptSerializer().Serialize(infoStopCost);
        }
        [WebMethod]
        public string ToolsCost(int line,int unit,string dateS, string dateE)//ریز هزینه قطعات
        {
            var infotools = new List<string[]>();
            cnn.Open();
            var cmdtoolscost=new SqlCommand("SELECT sgdb.dbo.Fee.perFee * SUM(i.count) AS Tot, sgdb.dbo.Fee.perFee, SUM(i.count) AS count," +
                                            " sgdb.dbo.Fee.partname FROM(SELECT dbo.r_tools.tools_id, SUM(dbo.r_tools.count) AS count "+
                                            " FROM dbo.r_reply INNER JOIN  dbo.r_tools ON dbo.r_reply.id = dbo.r_tools.id_rep "+
                                            " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                            " GROUP BY dbo.r_tools.tools_id  UNION ALL "+
                                            " SELECT dbo.s_subtools.tools_id, SUM(dbo.s_subtools.count) AS count "+
                                            " FROM dbo.s_subhistory INNER JOIN "+
                                            " dbo.s_subtools ON dbo.s_subhistory.id = dbo.s_subtools.id_reptag "+
                                            " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                            " GROUP BY dbo.s_subtools.tools_id) AS i INNER JOIN "+
                                            " sgdb.dbo.Fee ON i.tools_id = sgdb.dbo.Fee.Partref "+
                                            " GROUP BY i.tools_id, sgdb.dbo.Fee.partname, sgdb.dbo.Fee.perFee",cnn);

            var cmdtoolscostUnit = new SqlCommand("SELECT sgdb.dbo.Fee.perFee * SUM(i.count) AS Tot, sgdb.dbo.Fee.perFee, SUM(i.count) AS count," +
                                                  " sgdb.dbo.Fee.partname FROM(SELECT dbo.r_tools.tools_id, SUM(dbo.r_tools.count) AS count " +
                                                  " FROM dbo.r_reply INNER JOIN dbo.r_tools ON dbo.r_reply.id = dbo.r_tools.id_rep INNER JOIN " +
                                                  " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                                  " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                                  " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND (dbo.m_machine.loc = "+unit+") " +
                                                  " GROUP BY dbo.r_tools.tools_id  UNION ALL " +
                                                  " SELECT dbo.s_subtools.tools_id, SUM(dbo.s_subtools.count) AS count " +
                                                  " FROM dbo.s_subhistory INNER JOIN " +
                                                  " dbo.s_subtools ON dbo.s_subhistory.id = dbo.s_subtools.id_reptag " +
                                                  " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND (dbo.s_subhistory.new_unit = "+unit+")" +
                                                  " GROUP BY dbo.s_subtools.tools_id) AS i INNER JOIN " +
                                                  " sgdb.dbo.Fee ON i.tools_id = sgdb.dbo.Fee.Partref " +
                                                  " GROUP BY i.tools_id, sgdb.dbo.Fee.partname, sgdb.dbo.Fee.perFee", cnn);

            var cmdtoolscostLine = new SqlCommand("SELECT sgdb.dbo.Fee.perFee * SUM(i.count) AS Tot, sgdb.dbo.Fee.perFee, SUM(i.count) AS count," +
                                                  " sgdb.dbo.Fee.partname FROM(SELECT dbo.r_tools.tools_id, SUM(dbo.r_tools.count) AS count " +
                                                  " FROM dbo.r_reply INNER JOIN dbo.r_tools ON dbo.r_reply.id = dbo.r_tools.id_rep INNER JOIN " +
                                                  " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                                  " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                                  " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND (dbo.m_machine.line = " + line + ") " +
                                                  " GROUP BY dbo.r_tools.tools_id  UNION ALL " +
                                                  " SELECT dbo.s_subtools.tools_id, SUM(dbo.s_subtools.count) AS count " +
                                                  " FROM dbo.s_subhistory INNER JOIN " +
                                                  " dbo.s_subtools ON dbo.s_subhistory.id = dbo.s_subtools.id_reptag " +
                                                  " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND (dbo.s_subhistory.new_line = " + line + ")" +
                                                  " GROUP BY dbo.s_subtools.tools_id) AS i INNER JOIN " +
                                                  " sgdb.dbo.Fee ON i.tools_id = sgdb.dbo.Fee.Partref " +
                                                  " GROUP BY i.tools_id, sgdb.dbo.Fee.partname, sgdb.dbo.Fee.perFee", cnn);

            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdtoolscostLine.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdtoolscostUnit.ExecuteReader();

            }
            else
            {
                rd = cmdtoolscost.ExecuteReader();
            }
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["Tot"].ToString(), rd["perFee"].ToString(), rd["count"].ToString(), rd["partname"].ToString() }
                };
                infotools.AddRange(strList);
            }
            return new JavaScriptSerializer().Serialize(infotools);
        }
        [WebMethod]
        public string RequestCost( int count, string dateS, string dateE)//خرابی های پر هزینه 
        {
            var infoReqcost = new List<string[]>();
            cnn.Open();
            var cmdReqcost = new SqlCommand(" SELECT TOP ("+count+") SUM(i.Total) AS Tot, dbo.m_machine.name, i.idreq " +
                                            " FROM dbo.m_machine INNER JOIN " +
                                            " dbo.r_request AS r_request_2 ON dbo.m_machine.id = r_request_2.machine_code INNER JOIN " +
                                            " (SELECT TOP(5) SUM(Tot) AS Total, idreq " +
                                            " FROM(SELECT sgdb.dbo.Fee.perFee * SUM(i_1.count) AS Tot, i_1.idreq " +
                                            " FROM(SELECT dbo.r_tools.tools_id, SUM(dbo.r_tools.count) AS count, dbo.r_reply.idreq " +
                                            " FROM dbo.r_reply INNER JOIN " +
                                            " dbo.r_tools ON dbo.r_reply.id = dbo.r_tools.id_rep INNER JOIN " +
                                            " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                            " dbo.m_machine AS m_machine_2 ON dbo.r_request.machine_code = m_machine_2.id " +
                                            " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                            " GROUP BY dbo.r_tools.tools_id, dbo.r_reply.idreq) AS i_1 INNER JOIN " +
                                            " sgdb.dbo.Fee ON i_1.tools_id = sgdb.dbo.Fee.Partref " +
                                            " GROUP BY sgdb.dbo.Fee.perFee, i_1.idreq) AS Tmain " +
                                            " GROUP BY idreq UNION ALL " +
                                            " SELECT SUM(min * (salary / 30 / 440)) AS Price, idreq " +
                                            " FROM(SELECT dbo.i_personel.per_name, dbo.i_personel.per_id, r_reply_2.idreq, -(1 * DATEDIFF(minute, dbo.r_personel.time_work, 0)) AS min, CASE WHEN(task = 0) THEN " +
                                            " (SELECT worker FROM i_costs WHERE cost_year = " +
                                            " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 1 THEN " +
                                            " (SELECT expert FROM i_costs WHERE cost_year = " +
                                            " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 2 THEN " +
                                            " (SELECT headworker FROM i_costs WHERE cost_year = " +
                                            " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 3 THEN " +
                                            " (SELECT manager FROM i_costs WHERE cost_year = " +
                                            " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 4 THEN " +
                                            " (SELECT technical_manager FROM i_costs WHERE cost_year = " +
                                            " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) END AS salary, dbo.r_personel.time_work FROM dbo.i_personel INNER JOIN " +
                                            " dbo.r_personel ON dbo.i_personel.id = dbo.r_personel.per_id INNER JOIN " +
                                            " dbo.r_reply AS r_reply_2 ON dbo.r_personel.id_rep = r_reply_2.id " +
                                            " WHERE(r_reply_2.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.r_personel.per_id <> 5)) AS derivedtbl_1 " +
                                            " GROUP BY idreq UNION ALL " +
                                            " SELECT SUM(dbo.r_contract.cost) AS contract, r_reply_1.idreq " +
                                            " FROM dbo.i_contractor INNER JOIN " +
                                            " dbo.r_contract ON dbo.i_contractor.id = dbo.r_contract.contract_id INNER JOIN " +
                                            " dbo.r_reply AS r_reply_1 ON dbo.r_contract.id_rep = r_reply_1.id INNER JOIN " +
                                            " dbo.r_request AS r_request_1 ON r_reply_1.idreq = r_request_1.req_id INNER JOIN " +
                                            " dbo.m_machine AS m_machine_1 ON r_request_1.machine_code = m_machine_1.id " +
                                            " WHERE(r_reply_1.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                            " GROUP BY dbo.i_contractor.name, dbo.i_contractor.id, r_reply_1.idreq) AS i ON r_request_2.req_id = i.idreq " +
                                            " GROUP BY i.idreq, dbo.m_machine.name ORDER BY Tot DESC", cnn);

            var rd = cmdReqcost.ExecuteReader();
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["Tot"].ToString(), rd["name"].ToString(),rd["idreq"].ToString() }
                };
                infoReqcost.AddRange(strList);
            }
            return new JavaScriptSerializer().Serialize(infoReqcost);
        }
        [WebMethod]
        public string ContractorCost(int line,int unit,string dateS, string dateE)//هزینه پیمانکاران
        {
            var infocontcost = new List<string[]>();
            cnn.Open();
            var cmdContcost = new SqlCommand("select name,sum(cost) as cost from  " +
                                             "(SELECT dbo.s_subcontract.contract_id AS id, dbo.i_contractor.name, SUM(dbo.s_subcontract.cost) AS cost " +
                                             " FROM dbo.s_subcontract INNER JOIN " +
                                             " dbo.i_contractor ON dbo.s_subcontract.contract_id = dbo.i_contractor.id INNER JOIN " +
                                             " dbo.s_subhistory ON dbo.s_subcontract.id_reptag = dbo.s_subhistory.id " +
                                             " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                             " GROUP BY dbo.s_subcontract.contract_id, dbo.i_contractor.name union all " +
                                             " SELECT        dbo.i_contractor.id, dbo.i_contractor.name, SUM(dbo.r_contract.cost) AS cost " +
                                             " FROM          dbo.i_contractor INNER JOIN " +
                                             " dbo.r_contract ON dbo.i_contractor.id = dbo.r_contract.contract_id INNER JOIN " +
                                             " dbo.r_reply ON dbo.r_contract.id_rep = dbo.r_reply.id INNER JOIN " +
                                             " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                             " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                             " WHERE(dbo.r_reply.start_repdate BETWEEN '"+dateS+"' AND '"+dateE+"') " +
                                             " GROUP BY dbo.i_contractor.name, dbo.i_contractor.id) i group by id, name", cnn);

            var cmdContcostUnit = new SqlCommand("select name,sum(cost) as cost from  " +
                                             " (SELECT dbo.s_subcontract.contract_id AS id, dbo.i_contractor.name, SUM(dbo.s_subcontract.cost) AS cost " +
                                             " FROM dbo.s_subcontract INNER JOIN " +
                                             " dbo.i_contractor ON dbo.s_subcontract.contract_id = dbo.i_contractor.id INNER JOIN " +
                                             " dbo.s_subhistory ON dbo.s_subcontract.id_reptag = dbo.s_subhistory.id " +
                                             " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.s_subhistory.new_unit = " + unit + ") " +
                                             " GROUP BY dbo.s_subcontract.contract_id, dbo.i_contractor.name union all " +
                                             " SELECT        dbo.i_contractor.id, dbo.i_contractor.name, SUM(dbo.r_contract.cost) AS cost " +
                                             " FROM          dbo.i_contractor INNER JOIN " +
                                             " dbo.r_contract ON dbo.i_contractor.id = dbo.r_contract.contract_id INNER JOIN " +
                                             " dbo.r_reply ON dbo.r_contract.id_rep = dbo.r_reply.id INNER JOIN " +
                                             " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                             " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                             " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.loc = " + unit + ") " +
                                             " GROUP BY dbo.i_contractor.name, dbo.i_contractor.id) i group by id, name", cnn);

            var cmdContcostLine = new SqlCommand("select name,sum(cost) as cost from  " +
                                             " (SELECT dbo.s_subcontract.contract_id AS id, dbo.i_contractor.name, SUM(dbo.s_subcontract.cost) AS cost " +
                                             " FROM dbo.s_subcontract INNER JOIN " +
                                             " dbo.i_contractor ON dbo.s_subcontract.contract_id = dbo.i_contractor.id INNER JOIN " +
                                             " dbo.s_subhistory ON dbo.s_subcontract.id_reptag = dbo.s_subhistory.id " +
                                             " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.s_subhistory.new_line = " + line + ") " +
                                             " GROUP BY dbo.s_subcontract.contract_id, dbo.i_contractor.name union all " +
                                             " SELECT        dbo.i_contractor.id, dbo.i_contractor.name, SUM(dbo.r_contract.cost) AS cost " +
                                             " FROM          dbo.i_contractor INNER JOIN " +
                                             " dbo.r_contract ON dbo.i_contractor.id = dbo.r_contract.contract_id INNER JOIN " +
                                             " dbo.r_reply ON dbo.r_contract.id_rep = dbo.r_reply.id INNER JOIN " +
                                             " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                             " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                             " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.line = " + line + ") " +
                                             " GROUP BY dbo.i_contractor.name, dbo.i_contractor.id) i group by id, name", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdContcostLine.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdContcostUnit.ExecuteReader();
            }
            else
            {
                rd = cmdContcost.ExecuteReader();
            }

            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["cost"].ToString(), rd["name"].ToString() }
                };
                infocontcost.AddRange(strList);
            }
            return new JavaScriptSerializer().Serialize(infocontcost);
        }
       
        [WebMethod]
        public string PersonleCost(int line,int unit,string dateS, string dateE)// هزینه پرسنل
        {
            var infoPersonelcost = new List<string[]>();
            cnn.Open();
            var cmdPersonle = new SqlCommand("select per_name, per_id, sum(Price) as price from (SELECT per_name, per_id, SUM(min * (salary / 30 / 440)) AS Price" +
                                             " FROM(SELECT        dbo.i_personel.per_name, dbo.i_personel.per_id," +
                                             " -(1 * DATEDIFF(minute, dbo.r_personel.time_work, 0)) AS min, CASE WHEN(task = 0) THEN" +
                                             " (SELECT        worker" +
                                             " FROM            i_costs" +
                                             " WHERE        cost_year =" +
                                             " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 1 THEN" +
                                             " (SELECT        expert" +
                                             " FROM i_costs" +
                                             " WHERE        cost_year =" +
                                             " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 2 THEN" +
                                             " (SELECT        headworker" +
                                             " FROM            i_costs" +
                                             " WHERE        cost_year =" +
                                             " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 3 THEN" +
                                             " (SELECT        manager" +
                                             " FROM            i_costs" +
                                             " WHERE        cost_year =" +
                                             " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 4 THEN" +
                                             " (SELECT        technical_manager" +
                                             " FROM            i_costs" +
                                             " WHERE        cost_year =" +
                                             " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) END AS salary, dbo.r_personel.time_work" +
                                             " FROM            dbo.i_personel INNER JOIN" +
                                             " dbo.r_personel ON dbo.i_personel.id = dbo.r_personel.per_id INNER JOIN" +
                                             " dbo.r_reply ON dbo.r_personel.id_rep = dbo.r_reply.id" +
                                             " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "')) AS derivedtbl_1" +
                                             " GROUP BY per_name, per_id" +
                                             " union all " +
                                             " SELECT        per_name, per_id, SUM(min * (salary / 30 / 440)) AS Price " +
                                             " FROM(SELECT        dbo.i_personel.per_name, dbo.i_personel.per_id, -(1 * DATEDIFF(minute, dbo.s_subpersonel.time_work, 0)) AS min, CASE WHEN(task = 0) THEN" +
                                             " (SELECT        worker FROM  i_costs WHERE  cost_year = " +
                                             " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 1 THEN (SELECT expert FROM  i_costs WHERE cost_year = " +
                                             "(SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 2 THEN (SELECT headworker FROM   i_costs WHERE  cost_year = " +
                                             "(SELECT   SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 3 THEN (SELECT  manager FROM i_costs WHERE cost_year = " +
                                             "(SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 4 THEN (SELECT technical_manager FROM  i_costs WHERE cost_year = " +
                                             "(SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) END AS salary, dbo.s_subpersonel.time_work " +
                                             "FROM  dbo.i_personel INNER JOIN " +
                                             "dbo.s_subpersonel ON dbo.i_personel.id = dbo.s_subpersonel.per_id INNER JOIN " +
                                             "dbo.s_subhistory ON dbo.s_subpersonel.id_reptag = dbo.s_subhistory.id " +
                                             "WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "')) AS derivedtbl_1 " +
                                             "GROUP BY per_name, per_id) as Tmain group by per_id,per_name", cnn);

            var cmdPersonleUnit = new SqlCommand("select per_name, per_id, sum(Price) as price from (SELECT per_name, per_id, SUM(min * (salary / 30 / 440)) AS Price" +
                                                 " FROM(SELECT        dbo.i_personel.per_name, dbo.i_personel.per_id," +
                                                 " -(1 * DATEDIFF(minute, dbo.r_personel.time_work, 0)) AS min, CASE WHEN(task = 0) THEN" +
                                                 " (SELECT        worker" +
                                                 " FROM            i_costs" +
                                                 " WHERE        cost_year =" +
                                                 " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 1 THEN" +
                                                 " (SELECT        expert" +
                                                 " FROM i_costs" +
                                                 " WHERE        cost_year =" +
                                                 " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 2 THEN" +
                                                 " (SELECT        headworker" +
                                                 " FROM            i_costs" +
                                                 " WHERE        cost_year =" +
                                                 " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 3 THEN" +
                                                 " (SELECT        manager" +
                                                 " FROM            i_costs" +
                                                 " WHERE        cost_year =" +
                                                 " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 4 THEN" +
                                                 " (SELECT        technical_manager" +
                                                 " FROM            i_costs" +
                                                 " WHERE        cost_year =" +
                                                 " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) END AS salary, dbo.r_personel.time_work" +
                                                 "  FROM            dbo.i_personel INNER JOIN dbo.r_personel ON dbo.i_personel.id = dbo.r_personel.per_id INNER JOIN " +
                                                 " dbo.r_reply ON dbo.r_personel.id_rep = dbo.r_reply.id INNER JOIN" +
                                                 " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id " +
                                                 " INNER JOIN dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                                 " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') and m_machine.loc=" + unit + ") AS derivedtbl_1" +
                                                 " GROUP BY per_name, per_id" +
                                                 " union all " +
                                                 " SELECT        per_name, per_id, SUM(min * (salary / 30 / 440)) AS Price " +
                                                 " FROM(SELECT        dbo.i_personel.per_name, dbo.i_personel.per_id, -(1 * DATEDIFF(minute, dbo.s_subpersonel.time_work, 0)) AS min, CASE WHEN(task = 0) THEN" +
                                                 " (SELECT        worker FROM  i_costs WHERE  cost_year = " +
                                                 " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 1 THEN (SELECT expert FROM  i_costs WHERE cost_year = " +
                                                 "(SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 2 THEN (SELECT headworker FROM   i_costs WHERE  cost_year = " +
                                                 "(SELECT   SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 3 THEN (SELECT  manager FROM i_costs WHERE cost_year = " +
                                                 "(SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 4 THEN (SELECT technical_manager FROM  i_costs WHERE cost_year = " +
                                                 "(SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) END AS salary, dbo.s_subpersonel.time_work " +
                                                 "FROM  dbo.i_personel INNER JOIN " +
                                                 "dbo.s_subpersonel ON dbo.i_personel.id = dbo.s_subpersonel.per_id INNER JOIN " +
                                                 "dbo.s_subhistory ON dbo.s_subpersonel.id_reptag = dbo.s_subhistory.id " +
                                                 "WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND s_subhistory.new_unit="+unit+") AS derivedtbl_1 " +
                                                 "GROUP BY per_name, per_id) as Tmain group by per_id,per_name", cnn);


            var cmdPersonleLine = new SqlCommand(" select per_name, per_id, sum(Price) as price from (SELECT per_name, per_id, SUM(min * (salary / 30 / 440)) AS Price" +
                                                 " FROM(SELECT        dbo.i_personel.per_name, dbo.i_personel.per_id," +
                                                 " -(1 * DATEDIFF(minute, dbo.r_personel.time_work, 0)) AS min, CASE WHEN(task = 0) THEN" +
                                                 " (SELECT        worker" +
                                                 " FROM            i_costs" +
                                                 " WHERE        cost_year =" +
                                                 " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 1 THEN" +
                                                 " (SELECT        expert" +
                                                 " FROM i_costs" +
                                                 " WHERE        cost_year =" +
                                                 " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 2 THEN" +
                                                 " (SELECT        headworker" +
                                                 " FROM            i_costs" +
                                                 " WHERE        cost_year =" +
                                                 " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 3 THEN" +
                                                 " (SELECT        manager" +
                                                 " FROM            i_costs" +
                                                 " WHERE        cost_year =" +
                                                 " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 4 THEN" +
                                                 " (SELECT        technical_manager" +
                                                 " FROM            i_costs" +
                                                 " WHERE        cost_year =" +
                                                 " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) END AS salary, dbo.r_personel.time_work" +
                                                 " FROM            dbo.i_personel INNER JOIN dbo.r_personel ON dbo.i_personel.id = dbo.r_personel.per_id INNER JOIN " +
                                                 " dbo.r_reply ON dbo.r_personel.id_rep = dbo.r_reply.id INNER JOIN" +
                                                 " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id " +
                                                 " INNER JOIN dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                                 " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') and m_machine.line=" + line + ") AS derivedtbl_1" +
                                                 " GROUP BY per_name, per_id" +
                                                 " union all " +
                                                 " SELECT        per_name, per_id, SUM(min * (salary / 30 / 440)) AS Price " +
                                                 " FROM(SELECT        dbo.i_personel.per_name, dbo.i_personel.per_id, -(1 * DATEDIFF(minute, dbo.s_subpersonel.time_work, 0)) AS min," +
                                                 " CASE WHEN(task = 0) THEN" +
                                                 " (SELECT        worker FROM  i_costs WHERE  cost_year = " +
                                                 " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 1 THEN " +
                                                 " (SELECT expert FROM  i_costs WHERE cost_year = " +
                                                 " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 2 THEN " +
                                                 " (SELECT headworker FROM   i_costs WHERE  cost_year = " +
                                                 " (SELECT   SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 3 THEN " +
                                                 " (SELECT  manager FROM i_costs WHERE cost_year = " +
                                                 " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 4 THEN " +
                                                 " (SELECT technical_manager FROM  i_costs WHERE cost_year = " +
                                                 " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) END AS salary, dbo.s_subpersonel.time_work " +
                                                 " FROM  dbo.i_personel INNER JOIN " +
                                                 " dbo.s_subpersonel ON dbo.i_personel.id = dbo.s_subpersonel.per_id INNER JOIN " +
                                                 " dbo.s_subhistory ON dbo.s_subpersonel.id_reptag = dbo.s_subhistory.id " +
                                                 " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND s_subhistory.new_line=" + line + ") AS derivedtbl_1 " +
                                                 " GROUP BY per_name, per_id) as Tmain group by per_id,per_name", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdPersonleLine.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdPersonleUnit.ExecuteReader();

            }
            else
            {
                rd = cmdPersonle.ExecuteReader();
            }
            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["Price"].ToString(),rd["per_id"].ToString(), rd["per_name"].ToString() }
                };
                infoPersonelcost.AddRange(strList);
            }
            return new JavaScriptSerializer().Serialize(infoPersonelcost);
        }
      
        [WebMethod]
        public string TotalCost(int line,int unit,string dateS, string dateE)// هزینه کلی تعمیرات
        {
            var infoCost = new List<string[]>();
            cnn.Open();
            var cmdCosts = new SqlCommand("select CASE WHEN (sum(Tot)) IS NULL THEN 0 ELSE sum(Tot) END as Total,'هزینه قطعات' as kind from " +
                                          " (SELECT sgdb.dbo.Fee.perFee * SUM(i.count) AS Tot, sgdb.dbo.Fee.perFee, SUM(i.count) AS count," +
                                          " sgdb.dbo.Fee.partname FROM(SELECT dbo.r_tools.tools_id, SUM(dbo.r_tools.count) AS count" +
                                          " FROM dbo.r_reply INNER JOIN dbo.r_tools ON dbo.r_reply.id = dbo.r_tools.id_rep INNER JOIN " +
                                          " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                          " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                          " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                          " GROUP BY dbo.r_tools.tools_id  UNION ALL SELECT dbo.s_subtools.tools_id, SUM(dbo.s_subtools.count) AS count " +
                                          " FROM dbo.s_subhistory INNER JOIN " +
                                          " dbo.s_subtools ON dbo.s_subhistory.id = dbo.s_subtools.id_reptag " +
                                          " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                          " GROUP BY dbo.s_subtools.tools_id) AS i INNER JOIN sgdb.dbo.Fee ON i.tools_id = sgdb.dbo.Fee.Partref " +
                                          " GROUP BY i.tools_id, sgdb.dbo.Fee.partname, sgdb.dbo.Fee.perFee)T " +
                                          " union all " +
                                          " select CASE WHEN (sum(cost)) IS NULL THEN 0 ELSE sum(cost) END as  Total, 'هزینه پیمانکاران' as kind from( select name, sum(cost) as cost from " +
                                          " (SELECT dbo.s_subcontract.contract_id AS id, dbo.i_contractor.name, SUM(dbo.s_subcontract.cost) AS cost " +
                                          " FROM dbo.s_subcontract INNER JOIN " +
                                          " dbo.i_contractor ON dbo.s_subcontract.contract_id = dbo.i_contractor.id INNER JOIN " +
                                          " dbo.s_subhistory ON dbo.s_subcontract.id_reptag = dbo.s_subhistory.id " +
                                          " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "')  " +
                                          " GROUP BY dbo.s_subcontract.contract_id, dbo.i_contractor.name union all " +
                                          " SELECT        dbo.i_contractor.id, dbo.i_contractor.name, SUM(dbo.r_contract.cost) AS cost " +
                                          " FROM          dbo.i_contractor INNER JOIN " +
                                          " dbo.r_contract ON dbo.i_contractor.id = dbo.r_contract.contract_id INNER JOIN " +
                                          " dbo.r_reply ON dbo.r_contract.id_rep = dbo.r_reply.id INNER JOIN " +
                                          " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                          " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                          " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "')  " +
                                          " GROUP BY dbo.i_contractor.name, dbo.i_contractor.id) i group by id, name)C " +
                                          " union all " +
                                          " SELECT        CASE WHEN (sum(price)) IS NULL THEN 0 ELSE sum(price) END AS Total, 'هزینه پرسنل' as kind from( " +
                                          " select per_name, per_id, sum(Price) as price from(SELECT per_name, per_id, SUM(min * (salary / 30 / 440)) AS Price " +
                                          " FROM(SELECT        dbo.i_personel.per_name, dbo.i_personel.per_id, " +
                                          " -(1 * DATEDIFF(minute, dbo.r_personel.time_work, 0)) AS min, CASE WHEN(task = 0) THEN " +
                                          " (SELECT        worker " +
                                          " FROM            i_costs " +
                                          " WHERE        cost_year = " +
                                          " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 1 THEN " +
                                          " (SELECT        expert " +
                                          " FROM i_costs " +
                                          " WHERE        cost_year = " +
                                          " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 2 THEN (SELECT        headworker FROM            i_costs " +
                                          " WHERE        cost_year = (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 3 THEN " +
                                          " (SELECT manager FROM            i_costs WHERE        cost_year =" +
                                          " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 4 THEN " +
                                          " (SELECT        technical_manager " +
                                          " FROM            i_costs WHERE        cost_year = " +
                                          " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) END AS salary, dbo.r_personel.time_work " +
                                          " FROM            dbo.i_personel INNER JOIN dbo.r_personel ON dbo.i_personel.id = dbo.r_personel.per_id INNER JOIN " +
                                          " dbo.r_reply ON dbo.r_personel.id_rep = dbo.r_reply.id INNER JOIN " +
                                          " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id " +
                                          " INNER JOIN dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                          " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') ) AS derivedtbl_1 " +
                                          " GROUP BY per_name, per_id " +
                                          " union all " +
                                          " SELECT        per_name, per_id, SUM(min * (salary / 30 / 440)) AS Price " +
                                          " FROM(SELECT        dbo.i_personel.per_name, dbo.i_personel.per_id, -(1 * DATEDIFF(minute, dbo.s_subpersonel.time_work, 0)) AS min, CASE WHEN(task = 0) THEN " +
                                          " (SELECT        worker FROM  i_costs WHERE  cost_year = " +
                                          " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 1 THEN(SELECT expert FROM  i_costs WHERE cost_year = " +
                                          " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 2 THEN(SELECT headworker FROM   i_costs WHERE  cost_year = " +
                                          " (SELECT   SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 3 THEN(SELECT  manager FROM i_costs WHERE cost_year = " +
                                          " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 4 THEN(SELECT technical_manager FROM  i_costs WHERE cost_year = " +
                                          " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) END AS salary, dbo.s_subpersonel.time_work " +
                                          " FROM  dbo.i_personel INNER JOIN " +
                                          " dbo.s_subpersonel ON dbo.i_personel.id = dbo.s_subpersonel.per_id INNER JOIN " +
                                          " dbo.s_subhistory ON dbo.s_subpersonel.id_reptag = dbo.s_subhistory.id " +
                                          " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') ) AS derivedtbl_1 " +
                                          " GROUP BY per_name, per_id) as Tmain group by per_id,per_name)P ", cnn);

            var cmdCostsUnit = new SqlCommand("select CASE WHEN (sum(Tot)) IS NULL THEN 0 ELSE sum(Tot) END as Total,'هزینه قطعات' as kind from " +
                                              " (SELECT sgdb.dbo.Fee.perFee * SUM(i.count) AS Tot, sgdb.dbo.Fee.perFee, SUM(i.count) AS count," +
                                              " sgdb.dbo.Fee.partname FROM(SELECT dbo.r_tools.tools_id, SUM(dbo.r_tools.count) AS count" +
                                              " FROM dbo.r_reply INNER JOIN dbo.r_tools ON dbo.r_reply.id = dbo.r_tools.id_rep INNER JOIN " +
                                              " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                              " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                              " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.loc = " + unit + ") " +
                                              " GROUP BY dbo.r_tools.tools_id  UNION ALL SELECT dbo.s_subtools.tools_id, SUM(dbo.s_subtools.count) AS count " +
                                              " FROM dbo.s_subhistory INNER JOIN " +
                                              " dbo.s_subtools ON dbo.s_subhistory.id = dbo.s_subtools.id_reptag " +
                                              " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.s_subhistory.new_unit = " + unit + ") " +
                                              " GROUP BY dbo.s_subtools.tools_id) AS i INNER JOIN sgdb.dbo.Fee ON i.tools_id = sgdb.dbo.Fee.Partref " +
                                              " GROUP BY i.tools_id, sgdb.dbo.Fee.partname, sgdb.dbo.Fee.perFee)T " +
                                              " union all " +
                                              " select CASE WHEN (sum(cost)) IS NULL THEN 0 ELSE sum(cost) END as  Total, 'هزینه پیمانکاران' as kind from( select name, sum(cost) as cost from " +
                                              " (SELECT dbo.s_subcontract.contract_id AS id, dbo.i_contractor.name, SUM(dbo.s_subcontract.cost) AS cost " +
                                              " FROM dbo.s_subcontract INNER JOIN " +
                                              " dbo.i_contractor ON dbo.s_subcontract.contract_id = dbo.i_contractor.id INNER JOIN " +
                                              " dbo.s_subhistory ON dbo.s_subcontract.id_reptag = dbo.s_subhistory.id " +
                                              " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.s_subhistory.new_unit = " + unit + ") " +
                                              " GROUP BY dbo.s_subcontract.contract_id, dbo.i_contractor.name union all " +
                                              " SELECT        dbo.i_contractor.id, dbo.i_contractor.name, SUM(dbo.r_contract.cost) AS cost " +
                                              " FROM          dbo.i_contractor INNER JOIN " +
                                              " dbo.r_contract ON dbo.i_contractor.id = dbo.r_contract.contract_id INNER JOIN " +
                                              " dbo.r_reply ON dbo.r_contract.id_rep = dbo.r_reply.id INNER JOIN " +
                                              " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                              " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                              " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.loc = " + unit + ") " +
                                              " GROUP BY dbo.i_contractor.name, dbo.i_contractor.id) i group by id, name)C " +
                                              " union all " +
                                              " SELECT        CASE WHEN (sum(price)) IS NULL THEN 0 ELSE sum(price) END AS Total, 'هزینه پرسنل' as kind from( " +
                                              " select per_name, per_id, sum(Price) as price from(SELECT per_name, per_id, SUM(min * (salary / 30 / 440)) AS Price " +
                                              " FROM(SELECT        dbo.i_personel.per_name, dbo.i_personel.per_id, " +
                                              " -(1 * DATEDIFF(minute, dbo.r_personel.time_work, 0)) AS min, CASE WHEN(task = 0) THEN " +
                                              " (SELECT        worker " +
                                              " FROM            i_costs " +
                                              " WHERE        cost_year = " +
                                              " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 1 THEN " +
                                              " (SELECT        expert " +
                                              " FROM i_costs " +
                                              " WHERE        cost_year = " +
                                              " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 2 THEN (SELECT        headworker FROM            i_costs " +
                                              " WHERE        cost_year = (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 3 THEN " +
                                              " (SELECT manager FROM            i_costs WHERE        cost_year =" +
                                              " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 4 THEN " +
                                              " (SELECT        technical_manager " +
                                              " FROM            i_costs WHERE        cost_year = " +
                                              " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) END AS salary, dbo.r_personel.time_work " +
                                              " FROM            dbo.i_personel INNER JOIN dbo.r_personel ON dbo.i_personel.id = dbo.r_personel.per_id INNER JOIN " +
                                              " dbo.r_reply ON dbo.r_personel.id_rep = dbo.r_reply.id INNER JOIN " +
                                              " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id " +
                                              " INNER JOIN dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                              " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') and m_machine.loc = " + unit + ") AS derivedtbl_1 " +
                                              " GROUP BY per_name, per_id " +
                                              " union all " +
                                              " SELECT        per_name, per_id, SUM(min * (salary / 30 / 440)) AS Price " +
                                              " FROM(SELECT        dbo.i_personel.per_name, dbo.i_personel.per_id, -(1 * DATEDIFF(minute, dbo.s_subpersonel.time_work, 0)) AS min, CASE WHEN(task = 0) THEN " +
                                              " (SELECT        worker FROM  i_costs WHERE  cost_year = " +
                                              " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 1 THEN(SELECT expert FROM  i_costs WHERE cost_year = " +
                                              " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 2 THEN(SELECT headworker FROM   i_costs WHERE  cost_year = " +
                                              " (SELECT   SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 3 THEN(SELECT  manager FROM i_costs WHERE cost_year = " +
                                              " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 4 THEN(SELECT technical_manager FROM  i_costs WHERE cost_year = " +
                                              " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) END AS salary, dbo.s_subpersonel.time_work " +
                                              " FROM  dbo.i_personel INNER JOIN " +
                                              " dbo.s_subpersonel ON dbo.i_personel.id = dbo.s_subpersonel.per_id INNER JOIN " +
                                              " dbo.s_subhistory ON dbo.s_subpersonel.id_reptag = dbo.s_subhistory.id " +
                                              " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND s_subhistory.new_unit = " + unit + ") AS derivedtbl_1 " +
                                              " GROUP BY per_name, per_id) as Tmain group by per_id,per_name)P ", cnn);

            var cmdCostLine = new SqlCommand("select CASE WHEN (sum(Tot)) IS NULL THEN 0 ELSE sum(Tot) END as Total,'هزینه قطعات' as kind from " +
                                             " (SELECT sgdb.dbo.Fee.perFee * SUM(i.count) AS Tot, sgdb.dbo.Fee.perFee, SUM(i.count) AS count," +
                                             " sgdb.dbo.Fee.partname FROM(SELECT dbo.r_tools.tools_id, SUM(dbo.r_tools.count) AS count" +
                                             " FROM dbo.r_reply INNER JOIN dbo.r_tools ON dbo.r_reply.id = dbo.r_tools.id_rep INNER JOIN " +
                                             " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                             " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                             " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.line = " + line + ") " +
                                             " GROUP BY dbo.r_tools.tools_id  UNION ALL SELECT dbo.s_subtools.tools_id, SUM(dbo.s_subtools.count) AS count " +
                                             " FROM dbo.s_subhistory INNER JOIN " +
                                             " dbo.s_subtools ON dbo.s_subhistory.id = dbo.s_subtools.id_reptag " +
                                             " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.s_subhistory.new_line = " + line + ") " +
                                             " GROUP BY dbo.s_subtools.tools_id) AS i INNER JOIN sgdb.dbo.Fee ON i.tools_id = sgdb.dbo.Fee.Partref " +
                                             " GROUP BY i.tools_id, sgdb.dbo.Fee.partname, sgdb.dbo.Fee.perFee)T " +
                                             " union all " +
                                             " select CASE WHEN (sum(cost)) IS NULL THEN 0 ELSE sum(cost) END as  Total, 'هزینه پیمانکاران' as kind from( select name, sum(cost) as cost from " +
                                             " (SELECT dbo.s_subcontract.contract_id AS id, dbo.i_contractor.name, SUM(dbo.s_subcontract.cost) AS cost " +
                                             " FROM dbo.s_subcontract INNER JOIN " +
                                             " dbo.i_contractor ON dbo.s_subcontract.contract_id = dbo.i_contractor.id INNER JOIN " +
                                             " dbo.s_subhistory ON dbo.s_subcontract.id_reptag = dbo.s_subhistory.id " +
                                             " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.s_subhistory.new_line = " + line + ") " +
                                             " GROUP BY dbo.s_subcontract.contract_id, dbo.i_contractor.name union all " +
                                             " SELECT        dbo.i_contractor.id, dbo.i_contractor.name, SUM(dbo.r_contract.cost) AS cost " +
                                             " FROM          dbo.i_contractor INNER JOIN " +
                                             " dbo.r_contract ON dbo.i_contractor.id = dbo.r_contract.contract_id INNER JOIN " +
                                             " dbo.r_reply ON dbo.r_contract.id_rep = dbo.r_reply.id INNER JOIN " +
                                             " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id INNER JOIN " +
                                             " dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                             " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.line = " + line + ") " +
                                             " GROUP BY dbo.i_contractor.name, dbo.i_contractor.id) i group by id, name)C " +
                                             " union all " +
                                             " SELECT        CASE WHEN (sum(price)) IS NULL THEN 0 ELSE sum(price) END AS Total, 'هزینه پرسنل' as kind from( " +
                                             " select per_name, per_id, sum(Price) as price from(SELECT per_name, per_id, SUM(min * (salary / 30 / 440)) AS Price " +
                                             " FROM(SELECT        dbo.i_personel.per_name, dbo.i_personel.per_id, " +
                                             " -(1 * DATEDIFF(minute, dbo.r_personel.time_work, 0)) AS min, CASE WHEN(task = 0) THEN " +
                                             " (SELECT        worker " +
                                             " FROM            i_costs " +
                                             " WHERE        cost_year = " +
                                             " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 1 THEN " +
                                             " (SELECT        expert " +
                                             " FROM i_costs " +
                                             " WHERE        cost_year = " +
                                             " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 2 THEN (SELECT        headworker FROM            i_costs " +
                                             " WHERE        cost_year = (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 3 THEN " +
                                             " (SELECT manager FROM            i_costs WHERE        cost_year =" +
                                             " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 4 THEN " +
                                             " (SELECT        technical_manager " +
                                             " FROM            i_costs WHERE        cost_year = " +
                                             " (SELECT        SUBSTRING('" + dateS + "', 1, 4) AS Year)) END AS salary, dbo.r_personel.time_work " +
                                             " FROM            dbo.i_personel INNER JOIN dbo.r_personel ON dbo.i_personel.id = dbo.r_personel.per_id INNER JOIN " +
                                             " dbo.r_reply ON dbo.r_personel.id_rep = dbo.r_reply.id INNER JOIN " +
                                             " dbo.r_request ON dbo.r_reply.idreq = dbo.r_request.req_id " +
                                             " INNER JOIN dbo.m_machine ON dbo.r_request.machine_code = dbo.m_machine.id " +
                                             " WHERE(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') and m_machine.line = " + line + ") AS derivedtbl_1 " +
                                             " GROUP BY per_name, per_id " +
                                             " union all " +
                                             " SELECT        per_name, per_id, SUM(min * (salary / 30 / 440)) AS Price " +
                                             " FROM(SELECT        dbo.i_personel.per_name, dbo.i_personel.per_id, -(1 * DATEDIFF(minute, dbo.s_subpersonel.time_work, 0)) AS min, CASE WHEN(task = 0) THEN " +
                                             " (SELECT        worker FROM  i_costs WHERE  cost_year = " +
                                             " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 1 THEN(SELECT expert FROM  i_costs WHERE cost_year = " +
                                             " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 2 THEN(SELECT headworker FROM   i_costs WHERE  cost_year = " +
                                             " (SELECT   SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 3 THEN(SELECT  manager FROM i_costs WHERE cost_year = " +
                                             " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) WHEN task = 4 THEN(SELECT technical_manager FROM  i_costs WHERE cost_year = " +
                                             " (SELECT SUBSTRING('" + dateS + "', 1, 4) AS Year)) END AS salary, dbo.s_subpersonel.time_work " +
                                             " FROM  dbo.i_personel INNER JOIN " +
                                             " dbo.s_subpersonel ON dbo.i_personel.id = dbo.s_subpersonel.per_id INNER JOIN " +
                                             " dbo.s_subhistory ON dbo.s_subpersonel.id_reptag = dbo.s_subhistory.id " +
                                             " WHERE(dbo.s_subhistory.tarikh BETWEEN '" + dateS + "' AND '" + dateE + "') AND s_subhistory.new_line = " + line + ") AS derivedtbl_1 " +
                                             " GROUP BY per_name, per_id) as Tmain group by per_id,per_name)P ", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdCostLine.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdCostsUnit.ExecuteReader();

            }
            else
            {
                rd = cmdCosts.ExecuteReader();
            }

            while (rd.Read())
            {
                var strList = new List<string[]>
                {
                    new[] { rd["Total"].ToString(),rd["kind"].ToString() }
                };
                infoCost.AddRange(strList);
            }
            return new JavaScriptSerializer().Serialize(infoCost);
        }
        [WebMethod]
        public string Stopunitline_Report(string dateS, string dateE, int unit, int line)//  گزارش توقفات /بر مبنای خط و واحد
        {
            var obj = new MtMachines();
            cnn.Open();
            var cmdStopunit = new SqlCommand("SELECT        SUM(dbo.r_reply.elec_time) AS elec, SUM(dbo.r_reply.mech_time) AS mech, dbo.m_machine.name " +
                                         " FROM dbo.m_machine INNER JOIN " +
                                         " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                         " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                         " WHERE(dbo.m_machine.loc = "+unit+") AND(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                         " GROUP BY dbo.m_machine.name", cnn);

            var cmdStopLine = new SqlCommand("SELECT        SUM(dbo.r_reply.elec_time) AS elec, SUM(dbo.r_reply.mech_time) AS mech, dbo.i_lines.line_name as name" +
                                             " FROM dbo.m_machine INNER JOIN " +
                                             " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                             " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN " +
                                             " dbo.i_lines ON dbo.m_machine.line = dbo.i_lines.id " +
                                             " WHERE(dbo.m_machine.line = " + line + ") AND(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                             " GROUP BY dbo.i_lines.line_name", cnn);

            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdStopLine.ExecuteReader();

            }
            else
            {
                rd = cmdStopunit.ExecuteReader();

            }
            while (rd.Read())
            {
                obj.Machine.Add(rd["name"].ToString());
                obj.Mtt.Add(Convert.ToInt32(rd["elec"]));
                obj.MttH.Add(Convert.ToInt32(rd["mech"]));
            }
            return new JavaScriptSerializer().Serialize(obj);
        }
        [WebMethod]
        public string StopSub_Report(string dateS, string dateE, int unit, int line)//  گزارش توقفات تجهیزات/بر مبنای خط و واحد
        {
            var obj = new MtMachines();
            cnn.Open();
            var cmdStopunit = new SqlCommand("SELECT dbo.subsystem.name, dbo.r_reply.elec_time as elec, dbo.r_reply.mech_time as mech" +
                                             " FROM dbo.m_machine INNER JOIN " +
                                             " dbo.m_subsystem ON dbo.m_machine.id = dbo.m_subsystem.Mid INNER JOIN " +
                                             " dbo.subsystem ON dbo.m_subsystem.subId = dbo.subsystem.id INNER JOIN " +
                                             " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                             " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq AND dbo.subsystem.id = dbo.r_reply.subsystem " +
                                             " WHERE(dbo.m_machine.loc = " + unit + ") AND(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                             " GROUP BY dbo.subsystem.name, dbo.r_reply.elec_time, dbo.r_reply.mech_time", cnn);

            var cmdStopLine = new SqlCommand("SELECT dbo.subsystem.name, dbo.r_reply.elec_time as elec, dbo.r_reply.mech_time as mech " +
                                             " FROM dbo.m_machine INNER JOIN " +
                                             " dbo.m_subsystem ON dbo.m_machine.id = dbo.m_subsystem.Mid INNER JOIN " +
                                             " dbo.subsystem ON dbo.m_subsystem.subId = dbo.subsystem.id INNER JOIN " +
                                             " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                             " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq AND dbo.subsystem.id = dbo.r_reply.subsystem " +
                                             " WHERE(dbo.m_machine.line = " + line + ") AND(dbo.r_reply.start_repdate BETWEEN '" + dateS + "' AND '" + dateE + "') " +
                                             " GROUP BY dbo.subsystem.name, dbo.r_reply.elec_time, dbo.r_reply.mech_time", cnn);

            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdStopLine.ExecuteReader();

            }
            else
            {
                rd = cmdStopunit.ExecuteReader();

            }
            while (rd.Read())
            {
                obj.Machine.Add(rd["name"].ToString());
                obj.Mtt.Add(Convert.ToInt32(rd["elec"]));
                obj.MttH.Add(Convert.ToInt32(rd["mech"]));
            }
            return new JavaScriptSerializer().Serialize(obj);
        }
        [WebMethod]
        public string MTBF_Report(string dateS, string dateE,int unit,int line,int faz)// MTBF گزارش
        {
            var obj = new MtMachines();
            cnn.Open();
            var cmdMtbf = new SqlCommand("SELECT dbo.m_machine.name, dbo.m_machine.code, SUM(dbo.r_reply.mtbf) AS BF," +
                                         " COUNT(dbo.m_machine.code) AS Fail, SUM(dbo.r_reply.mtbf) / COUNT(dbo.m_machine.code) AS MTBF, dbo.m_machine.mtbfH" +
                                         " FROM dbo.m_machine INNER JOIN" +
                                         " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN" +
                                         " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN" +
                                         " dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code" +
                                         " WHERE(dbo.r_request.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine.loc = " + unit+")" +
                                         " GROUP BY dbo.m_machine.name, dbo.m_machine.code, dbo.m_machine.mtbfH", cnn);

            var cmdMtbfLine = new SqlCommand("SELECT dbo.m_machine.name, dbo.m_machine.code, SUM(dbo.r_reply.mtbf) AS BF," +
                                         " COUNT(dbo.m_machine.code) AS Fail, SUM(dbo.r_reply.mtbf) / COUNT(dbo.m_machine.code) AS MTBF, dbo.m_machine.mtbfH" +
                                         " FROM dbo.m_machine INNER JOIN" +
                                         " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN" +
                                         " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN" +
                                         " dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code" +
                                         " WHERE(dbo.r_request.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine.line = " + line + ")" +
                                         " GROUP BY dbo.m_machine.name, dbo.m_machine.code, dbo.m_machine.mtbfH", cnn);

            var cmdMtbffaz = new SqlCommand("SELECT dbo.m_machine.name, dbo.m_machine.code, SUM(dbo.r_reply.mtbf) AS BF," +
                                             " COUNT(dbo.m_machine.code) AS Fail, SUM(dbo.r_reply.mtbf) / COUNT(dbo.m_machine.code) AS MTBF, dbo.m_machine.mtbfH" +
                                             " FROM dbo.m_machine INNER JOIN" +
                                             " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN" +
                                             " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN" +
                                             " dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code" +
                                             " WHERE(dbo.r_request.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine.faz = " + faz + ")" +
                                             " GROUP BY dbo.m_machine.name, dbo.m_machine.code, dbo.m_machine.mtbfH", cnn);
            SqlDataReader rd;

            if (line != -1)
            {
                rd = cmdMtbfLine.ExecuteReader();

            }
            else if(unit != -1)
            {
                rd = cmdMtbf.ExecuteReader();

            }
            else 
            {
                rd = cmdMtbffaz.ExecuteReader();
            }
            while (rd.Read())
            {
                obj.Machine.Add(rd["name"].ToString());
                obj.Mtt.Add(Convert.ToInt32(rd["MTBF"]));
                obj.MttH.Add(Convert.ToInt32(rd["mtbfH"]));
            }
            return new JavaScriptSerializer().Serialize(obj);
        }
        [WebMethod]
        public string MTTR_Per_Repair(string dateS, string dateE, int unit,int line, int faz)// MTTRگزارش بر مبنی تعمیر  
        {
            var infoMttr = new MtMachines();
            cnn.Open();
            var cmdMttrR = new SqlCommand("SELECT        dbo.m_machine.name, dbo.m_machine.code, SUM(DATEDIFF(minute, 0, dbo.r_reply.rep_time_help)) AS TR, COUNT(dbo.m_machine.code) AS Trcount," +
                                          " SUM(DATEDIFF(minute, 0, dbo.r_reply.rep_time_help)) / 60 / COUNT(dbo.m_machine.code) AS MTTRrep, dbo.m_machine.mttrH" +
                                          " FROM dbo.m_machine INNER JOIN" +
                                          " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                          " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN" +
                                          " dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code" +
                                          " WHERE(dbo.r_request.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine.loc = " + unit + ")" +
                                          " GROUP BY dbo.m_machine.name, dbo.m_machine.code, dbo.m_machine.mttrH", cnn);

            var cmdMttrRLine = new SqlCommand("SELECT        dbo.m_machine.name, dbo.m_machine.code, SUM(DATEDIFF(minute, 0, dbo.r_reply.rep_time_help)) AS TR, COUNT(dbo.m_machine.code) AS Trcount," +
                                         " SUM(DATEDIFF(minute, 0, dbo.r_reply.rep_time_help)) / 60 / COUNT(dbo.m_machine.code) AS MTTRrep, dbo.m_machine.mttrH" +
                                         " FROM dbo.m_machine INNER JOIN" +
                                         " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                         " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN" +
                                         " dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code" +
                                         " WHERE(dbo.r_request.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine.line = " + line + ")" +
                                         " GROUP BY dbo.m_machine.name, dbo.m_machine.code, dbo.m_machine.mttrH", cnn);
            var cmdMttrRFaz = new SqlCommand("SELECT        dbo.m_machine.name, dbo.m_machine.code, SUM(DATEDIFF(minute, 0, dbo.r_reply.rep_time_help)) AS TR, COUNT(dbo.m_machine.code) AS Trcount," +
                                              " SUM(DATEDIFF(minute, 0, dbo.r_reply.rep_time_help)) / 60 / COUNT(dbo.m_machine.code) AS MTTRrep, dbo.m_machine.mttrH" +
                                              " FROM dbo.m_machine INNER JOIN" +
                                              " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                              " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN" +
                                              " dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code" +
                                              " WHERE(dbo.r_request.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine.faz = " + faz + ")" +
                                              " GROUP BY dbo.m_machine.name, dbo.m_machine.code, dbo.m_machine.mttrH", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdMttrRLine.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdMttrR.ExecuteReader();

            }
            else
            {
                rd = cmdMttrRFaz.ExecuteReader();
            }
            while (rd.Read())
            {
                infoMttr.Machine.Add(rd["name"].ToString());
                infoMttr.Mtt.Add(Convert.ToInt32(rd["mttrH"]));
                infoMttr.MttH.Add(Convert.ToInt32(rd["MTTRrep"]));
            }
            return new JavaScriptSerializer().Serialize(infoMttr);
        }
        [WebMethod]
        public string MTTR_Per_stop(string dateS, string dateE, int unit,int line ,int faz)// MTTRگزارش بر مبنی توقف  
        {
            var infoMttr = new MtMachines();
            cnn.Open();
            var cmdMttrS = new SqlCommand("SELECT dbo.m_machine.name, dbo.m_machine.code, SUM(DATEDIFF(minute, 0, dbo.r_reply.stop_time_help)) AS TR," +
                                         " COUNT(dbo.m_machine.code) AS Trcount," +
                                         " SUM(DATEDIFF(minute, 0, dbo.r_reply.stop_time_help)) / 60 / COUNT(dbo.m_machine.code) AS MTTR_Stop, dbo.m_machine.mttrH" +
                                         " FROM dbo.m_machine INNER JOIN" +
                                         " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                         " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN" +
                                         " dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code" +
                                         " WHERE(dbo.r_request.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine.loc = " + unit + ")" +
                                         " GROUP BY dbo.m_machine.name, dbo.m_machine.code, dbo.m_machine.mttrH", cnn);

            var cmdMttrSline = new SqlCommand("SELECT dbo.m_machine.name, dbo.m_machine.code, SUM(DATEDIFF(minute, 0, dbo.r_reply.stop_time_help)) AS TR," +
                                         " COUNT(dbo.m_machine.code) AS Trcount," +
                                         " SUM(DATEDIFF(minute, 0, dbo.r_reply.stop_time_help)) / 60 / COUNT(dbo.m_machine.code) AS MTTR_Stop, dbo.m_machine.mttrH" +
                                         " FROM dbo.m_machine INNER JOIN" +
                                         " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                         " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN" +
                                         " dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code" +
                                         " WHERE(dbo.r_request.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine.line = " + line + ")" +
                                         " GROUP BY dbo.m_machine.name, dbo.m_machine.code, dbo.m_machine.mttrH", cnn);
            var cmdMttrSFaz = new SqlCommand("SELECT dbo.m_machine.name, dbo.m_machine.code, SUM(DATEDIFF(minute, 0, dbo.r_reply.stop_time_help)) AS TR," +
                                              " COUNT(dbo.m_machine.code) AS Trcount," +
                                              " SUM(DATEDIFF(minute, 0, dbo.r_reply.stop_time_help)) / 60 / COUNT(dbo.m_machine.code) AS MTTR_Stop, dbo.m_machine.mttrH" +
                                              " FROM dbo.m_machine INNER JOIN" +
                                              " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN " +
                                              " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq INNER JOIN" +
                                              " dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code" +
                                              " WHERE(dbo.r_request.date_req BETWEEN '" + dateS + "' AND '" + dateE + "') AND(m_machine.faz = " + faz + ")" +
                                              " GROUP BY dbo.m_machine.name, dbo.m_machine.code, dbo.m_machine.mttrH", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdMttrSline.ExecuteReader();

            }
            else if (unit != -1)
            {
                rd = cmdMttrS.ExecuteReader();

            }
            else
            {
                rd = cmdMttrSFaz.ExecuteReader();
            }
            while (rd.Read())
            {
                infoMttr.Machine.Add(rd["name"].ToString());
                infoMttr.Mtt.Add(Convert.ToInt32(rd["mttrH"]));
                infoMttr.MttH.Add(Convert.ToInt32(rd["MTTR_Stop"]));
            }
            return new JavaScriptSerializer().Serialize(infoMttr);
        }
        //================================
        //==========برنامه کنترلی========
        [WebMethod]
        public string GetPmControlProgram(string s, string e, int mid , int opr)
        {
            var daily = Daily(mid , opr);
            var monthly = Month(s, e, mid , opr);
            var week = Week(s, e, mid , opr);
            var other = Other(s, e, mid , opr);
            var obj = new
            {
                daily,monthly,week,other
            };
            return new JavaScriptSerializer().Serialize(obj);
        }
        public List<PMcontrol> Daily( int machineid , int opr)
        {
            var lst = new List<PMcontrol>();
            cnn.Open();
            var cmdPm = new SqlCommand("SELECT TOP (100) PERCENT dbo.i_units.unit_code, dbo.i_units.unit_name," +
                                       " dbo.m_machine.name, dbo.m_machine.code, dbo.m_control.contName, dbo.p_pmcontrols.kind " +
                                       " FROM dbo.m_machine INNER JOIN" +
                                       " dbo.m_control ON dbo.m_machine.id = dbo.m_control.Mid INNER JOIN" +
                                       " dbo.p_pmcontrols ON dbo.m_control.id = dbo.p_pmcontrols.idmcontrol INNER JOIN" +
                                       " dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code" +
                                       " WHERE(dbo.p_pmcontrols.act = 0) AND(dbo.p_pmcontrols.kind = 0)" +
                                       " AND (dbo.m_machine.id=" + machineid + ") AND (m_control.opr = "+opr+")", cnn);
            var rd = cmdPm.ExecuteReader();
            while (rd.Read())
            {
                var obj = new PMcontrol
                {
                    Unit = rd["unit_name"].ToString(),
                    Machine = rd["name"].ToString(),
                    ControlName = rd["contName"].ToString()
                };
                lst.Add(obj);
            }
            cnn.Close();
            return lst;
        }
        public List<PMcontrol> Other(string S, string E, int machineid , int opr)
        {
            var lst = new List<PMcontrol>();
            var check = false;
            cnn.Open();
            var cmdPm = new SqlCommand("SELECT TOP (100) PERCENT dbo.i_units.unit_code, dbo.i_units.unit_name, dbo.m_machine.name," +
                                       " dbo.m_machine.id, dbo.m_control.contName, dbo.p_pmcontrols.tarikh, dbo.p_pmcontrols.act, dbo.p_pmcontrols.kind, " +
                                       "  dbo.p_pmcontrols.other FROM dbo.m_machine INNER JOIN " +
                                       "  dbo.m_control ON dbo.m_machine.id = dbo.m_control.Mid INNER JOIN " +
                                       "  dbo.p_pmcontrols ON dbo.m_control.id = dbo.p_pmcontrols.idmcontrol INNER JOIN " +
                                       " dbo.i_units  ON dbo.m_machine.loc = dbo.i_units.unit_code " +
                                       " WHERE(dbo.p_pmcontrols.tarikh < '" + E + "') AND(dbo.p_pmcontrols.act = 0) AND(dbo.p_pmcontrols.kind = 5) " +
                                       "AND (dbo.m_machine.id=" + machineid + ") AND (m_control.opr = " + opr + ") ORDER BY dbo.p_pmcontrols.tarikh ", cnn);
            var rd = cmdPm.ExecuteReader();
            while (rd.Read())
            {
                var obj = new PMcontrol
                {
                    Unit = rd["unit_name"].ToString(),
                    Machine = rd["name"].ToString(),
                    ControlName = rd["contName"].ToString()
                };
                var tarikh = rd["tarikh"].ToString();
                var step = Convert.ToInt32(rd["other"]);
                var dateS = ShamsiCalendar.Shamsi2Miladi(S);
                var dateE = ShamsiCalendar.Shamsi2Miladi(E);
                var date = ShamsiCalendar.Shamsi2Miladi(tarikh);
                while (true)
                {
                    
                    if (date <= dateE)
                    {
                        tarikh = ShamsiCalendar.Miladi2Shamsi(date);
                        if (date >= dateS)
                        {
                            obj.Date.Add(tarikh);
                            check = true;
                        }
                        date = date.AddDays(step);
                    }
                    else
                    {
                        if (check)
                        {
                            lst.Add(obj);
                        }
                        break;
                    }
                }
            }
            cnn.Close();
            return lst;
        }

        public List<PMcontrol> Week(string S, string E, int machineid , int opr)
        {
            var lst = new List<PMcontrol>();
            var check = false;
            cnn.Open();
            var cmdPm = new SqlCommand("SELECT TOP (100) PERCENT dbo.i_units.unit_code, dbo.i_units.unit_name, dbo.m_machine.name," +
                                       " dbo.m_machine.id, dbo.m_control.contName, dbo.p_pmcontrols.tarikh, dbo.p_pmcontrols.act, dbo.p_pmcontrols.kind, " +
                                       "  dbo.p_pmcontrols.other  FROM dbo.m_machine INNER JOIN dbo.m_control ON dbo.m_machine.id = dbo.m_control.Mid INNER JOIN " +
                                       "  dbo.p_pmcontrols ON dbo.m_control.id = dbo.p_pmcontrols.idmcontrol INNER JOIN " +
                                       " dbo.i_units  ON dbo.m_machine.loc = dbo.i_units.unit_code " +
                                       " WHERE(dbo.p_pmcontrols.tarikh < '" + E + "') AND(dbo.p_pmcontrols.act = 0) AND" +
                                       "(dbo.p_pmcontrols.kind = 6) AND (dbo.m_machine.id=" + machineid + ") AND (m_control.opr = " + opr + ") " +
                                       " ORDER BY dbo.p_pmcontrols.tarikh ", cnn);
            var rd = cmdPm.ExecuteReader();
            while (rd.Read())
            {
                var obj = new PMcontrol
                {
                    Unit = rd["unit_name"].ToString(),
                    ControlName = rd["contName"].ToString(),
                    Machine = rd["name"].ToString()
                };
                var tarikh = rd["tarikh"].ToString();
                var dateS = ShamsiCalendar.Shamsi2Miladi(S);
                var dateE = ShamsiCalendar.Shamsi2Miladi(E);
                var date = ShamsiCalendar.Shamsi2Miladi(tarikh);
                while (true)
                {
                    if (date <= dateE)
                    {
                        tarikh = ShamsiCalendar.Miladi2Shamsi(date);
                        if (date >= dateS)
                        {
                            obj.Date.Add(tarikh);
                            check = true;
                        }
                        date = date.AddDays(7);
                    }
                    else
                    {
                        if (check)
                        {
                            lst.Add(obj);
                        }
                        break;
                    }
                }
            }
            cnn.Close();
            return lst;
        }

        public List<PMcontrol> Month(string S, string E, int machineid , int opr)
        {
            var lst = new List<PMcontrol>();
            var check = false;
            cnn.Open();
            var cmdPm = new SqlCommand("SELECT TOP (100) PERCENT dbo.i_units.unit_code, dbo.i_units.unit_name, dbo.m_machine.name," +
                                       " dbo.m_machine.id, dbo.m_control.contName, dbo.p_pmcontrols.tarikh, dbo.p_pmcontrols.act, dbo.p_pmcontrols.kind, " +
                                       "  dbo.p_pmcontrols.other FROM dbo.m_machine INNER JOIN " +
                                       "  dbo.m_control ON dbo.m_machine.id = dbo.m_control.Mid INNER JOIN " +
                                       "  dbo.p_pmcontrols ON dbo.m_control.id = dbo.p_pmcontrols.idmcontrol INNER JOIN " +
                                       " dbo.i_units  ON dbo.m_machine.loc = dbo.i_units.unit_code " +
                                       " WHERE(dbo.p_pmcontrols.tarikh < '" + E + "') AND(dbo.p_pmcontrols.act = 0) AND" +
                                       " (dbo.p_pmcontrols.kind = 1 OR dbo.p_pmcontrols.kind = 2 OR dbo.p_pmcontrols.kind =3 OR dbo.p_pmcontrols.kind = 4)" +
                                       " AND (dbo.m_machine.id=" + machineid + ") AND (m_control.opr = " + opr + ") ORDER BY dbo.p_pmcontrols.tarikh ", cnn);
            var rd = cmdPm.ExecuteReader();
            while (rd.Read())
            {
                var obj = new PMcontrol
                {
                    Unit = rd["unit_name"].ToString(),
                    Machine = rd["name"].ToString(),
                    ControlName = rd["contName"].ToString()
                };
                var tarikh = rd["tarikh"].ToString();
                int pos = tarikh.LastIndexOf("/", StringComparison.Ordinal);
                string day = tarikh.Substring(pos + 1, tarikh.Length - (pos + 1));
                var step = Convert.ToInt32(rd["kind"]);
                var mo = 0;
                switch (step)
                {
                    case 1:
                        mo = 1; break;
                    case 2:
                        mo = 3; break;
                    case 3:
                        mo = 6; break;
                    case 4:
                        mo = 1; break;
                }
                var dateS = ShamsiCalendar.Shamsi2Miladi(S);
                var dateE = ShamsiCalendar.Shamsi2Miladi(E);
                var date = ShamsiCalendar.Shamsi2Miladi(tarikh);
                while (true)
                {
                    
                    if (date <= dateE)
                    {
                        tarikh = ShamsiCalendar.Miladi2Shamsi(date);
                        tarikh = tarikh.Substring(0, pos + 1) + day;
                        if (date >= dateS)
                        {
                            obj.Date.Add(tarikh);
                            
                            check = true;
                        }
                        date = step != 4 ? date.AddMonths(mo) : date.AddYears(mo);
                    }
                    else
                    {
                        if (check)
                        {
                            lst.Add(obj);
                        }
                        break;
                    }
                }
            }
            cnn.Close();
            return lst;
        }
        [WebMethod]
        public string StopProduct(int line, int unit,string dateS, string dateE)
        {
            var infoStopproduct = new ChartData();
            var list1 = new List<string>();
            var list2 = new List<decimal>();
            cnn.Open();
            var cmdPStop = new SqlCommand("SELECT dbo.m_machine.id, SUM(dbo.t_StopEffect.stop_time) AS StopTime, dbo.m_machine.name " +
                                           " FROM dbo.t_StopEffect INNER JOIN " +
                                           " dbo.m_machine ON dbo.t_StopEffect.sub_mid = dbo.m_machine.id INNER JOIN " +
                                           " dbo.r_request ON dbo.t_StopEffect.reqid = dbo.r_request.req_id INNER JOIN " +
                                           " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                           " WHERE(dbo.r_reply.start_repdate  BETWEEN '" + dateS + "' AND '" + dateE + "') "+
                                           " GROUP BY dbo.m_machine.id, dbo.m_machine.name", cnn);

            var cmdPStopUnit = new SqlCommand("SELECT dbo.m_machine.id, SUM(dbo.t_StopEffect.stop_time) AS StopTime, dbo.m_machine.name " +
                                               " FROM dbo.t_StopEffect INNER JOIN " +
                                               " dbo.m_machine ON dbo.t_StopEffect.sub_mid = dbo.m_machine.id INNER JOIN " +
                                               " dbo.r_request ON dbo.t_StopEffect.reqid = dbo.r_request.req_id INNER JOIN " +
                                               " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                               " WHERE(dbo.r_reply.start_repdate  BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.loc = " + unit + ") " +
                                               " GROUP BY dbo.m_machine.id, dbo.m_machine.name", cnn);

            var cmdPStopline = new SqlCommand("SELECT dbo.m_machine.id, SUM(dbo.t_StopEffect.stop_time) AS StopTime, dbo.m_machine.name " +
                                               " FROM dbo.t_StopEffect INNER JOIN " +
                                               " dbo.m_machine ON dbo.t_StopEffect.sub_mid = dbo.m_machine.id INNER JOIN " +
                                               " dbo.r_request ON dbo.t_StopEffect.reqid = dbo.r_request.req_id INNER JOIN " +
                                               " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq " +
                                               " WHERE(dbo.r_reply.start_repdate  BETWEEN '" + dateS + "' AND '" + dateE + "') AND(dbo.m_machine.line = " + line + ") " +
                                               " GROUP BY dbo.m_machine.id, dbo.m_machine.name", cnn);
            SqlDataReader rd;
            if (line != -1)
            {
                rd = cmdPStopline.ExecuteReader();

            }
            else if (line == -1 && unit != -1)
            {
                rd = cmdPStopUnit.ExecuteReader();

            }
            else
            {
                rd = cmdPStop.ExecuteReader();
            }
            while (rd.Read())
            {
                list1.Add(rd["name"].ToString());
                list2.Add(Convert.ToInt32(rd["StopTime"]));
            }
            infoStopproduct.Strings.AddRange(list1);
            infoStopproduct.Integers.AddRange(list2);
            return new JavaScriptSerializer().Serialize(infoStopproduct);
        }

        [WebMethod]
        public string FilterSubSystems(int loc)
        {
            cnn.Open();
            var e =  new List<SubSystems>();
            var sele = new SqlCommand("SELECT DISTINCT dbo.subsystem.name, dbo.subsystem.code FROM dbo.subsystem INNER JOIN "+
                                      "dbo.m_subsystem ON dbo.subsystem.id = dbo.m_subsystem.subId INNER JOIN " +
                                      "dbo.m_machine ON dbo.m_subsystem.Mid = dbo.m_machine.id WHERE(dbo.m_machine.loc = "+loc+" OR "+loc+" = 0)",cnn);
            var r = sele.ExecuteReader();
            while (r.Read())
            {
                e.Add(new SubSystems()
                {
                     SubSystemId = Convert.ToInt32(r["code"]), SubSystemName = r["name"].ToString()
                });
            }
            cnn.Close();
            return new JavaScriptSerializer().Serialize(e);
        }

        [WebMethod]
        public string FilterMachines(int loc)
        {
            cnn.Open();
            var e = new List<MachineMainInfo>();
            var sel = new SqlCommand("SELECT dbo.m_machine.name, dbo.m_machine.code, dbo.i_units.unit_name, " +
                                     "dbo.m_machine.imp, dbo.m_machine.creator, dbo.m_machine.maModel, dbo.m_machine.startDate " +
                                     "FROM dbo.m_machine INNER JOIN dbo.i_units ON dbo.m_machine.loc = dbo.i_units.unit_code " +
                                     "WHERE(dbo.m_machine.loc = " + loc + " OR " +loc+ " = 0) order by dbo.m_machine.code", cnn);
            var r = sel.ExecuteReader();
            while (r.Read())
            {
                e.Add(new MachineMainInfo()
                {
                    Name = r["name"].ToString(),Code = r["code"].ToString(),LocationName = r["unit_name"].ToString(),
                    Ahamiyat = r["imp"].ToString(),Creator = r["creator"].ToString(),Model = r["maModel"].ToString(),
                    Tarikh = r["startDate"].ToString()
                });
            }
            return new JavaScriptSerializer().Serialize(e);
        }
    }
}
