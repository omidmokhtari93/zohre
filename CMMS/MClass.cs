using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.Remoting.Contexts;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Security;

namespace CMMS
{
    public class MachineMainInfo
    {
        public string Name { get; set; }
        
        public string Code { get; set; }
        public string Ahamiyat { get; set; }
        public string Creator { get; set; }
        public string InsDate { get; set; }
        public string Model { get; set; }
        public string Tarikh { get; set; }
        public string Location { get; set; }
        public string LocationName { get; set; }
        public int Line { get; set; }
        public string LineName { get; set; }
        public int Faz { get; set; }
        public string FazName { get; set; }
        public int StopCostPerHour { get; set; }
        public string Power { get; set; }
        public int CatGroup { get; set; }
        public string CatState { get; set; }
        public int VaziatTajhiz { get; set; }
        public int MtbfH { get; set; }
        public int MtbfD { get; set; }
        public int MttrH { get; set; }
        public int MttrD { get; set; }
        public string SellInfo { get; set; }
        public string SuppInfo { get; set; }
        public string Keycomment { get; set; }
    }

    public class KeyItems
    {
        public string Keyname { get; set; }
        public string Kw { get; set; }
        public string Rpm { get; set; }
        public string Country { get; set; }
        public string Volt { get; set; }
        public string Flow { get; set; }
        public string CommentKey { get; set; }
    }
    public class MasrafiMain
    {
        public string Length { get; set; }
        public string Width { get; set; }
        public string Height { get; set; }
        public string Weight { get; set; }
        public int BarghChecked { get; set; }
        public string Masraf { get; set; }
        public string Voltage { get; set; }
        public string Phase { get; set; }
        public string Cycle { get; set; }
        public int GasChecked { get; set; }
        public string GasPressure { get; set; }
        public int AirChecked { get; set; }
        public string AirPressure { get; set; }
        public int FuelChecked { get; set; }
        public string FuelType { get; set; }
        public string FuelMasraf { get; set; }

    }

    public class Controls
    {
        public int Idcontrol { get; set; }
        public string Control { get; set; }
        public int Time { get; set; }
        public int Day { get; set; }
        public int MDservice { get; set; }
        public int Operation { get; set; }
        public string PmDate { get; set; }
        public string Comment { get; set; }
    }
    public class SubSystems
    {
        public string SubSystemName { get; set; }
        public int SubSystemId { get; set; }
        public string SubSystemCode { get; set; }
        public string SubSystemMachine { get; set; }
        public string FazName { get; set; }
        public string LineName { get; set; }
    }

    public class Parts
    {
        public int Id { get; set; }
        public int PartId { get; set; }
        public string PartName { get; set; }
        public string Measurement { get; set; }
        public int MeasurId { get; set; }
        public string UsePerYear { get; set; }
        public string Min { get; set; }
        public string Max { get; set; }
        public string ChangePeriod { get; set; }
        public string Comment { get; set; }

    }

    public class Instructions
    {
        public string Dastoor { get; set; }
        public string Tarikh { get; set; }
        public string MachineType { get; set; }
        public string AP1 { get; set; }
        public string AP2 { get; set; }
        public string AP3 { get; set; }
        public string VP1 { get; set; }
        public string VP2 { get; set; }
        public string VP3 { get; set; }
        public string PF { get; set; }
    }

    public class ContractorInfo
    {
        public string Name { get; set; }
        public string Mail { get; set; }
        public string Address { get; set; }
        public string Phone { get; set; }
        public string Mobile { get; set; }
        public string Fax { get; set; }
        public int Permit { get; set; }
        public string Comment { get; set; }
    }

    public class Crypto
    {
        public static string Crypt(string text)
        {
            return Convert.ToBase64String(Encoding.Unicode.GetBytes(text));
        }

        public static string Decrypt(string text)
        {
            return Encoding.Unicode.GetString(Convert.FromBase64String(text));
        }
    }

    public class ToolsTableItems
    {
        public string ToolId { get; set; }
        public string ToolName { get; set; }
        public string ToolCode { get; set; }
    }
    public class PartsFilter
    {
        public string PartName { get; set; }
        public int PartId { get; set; }
    }
    public class RequestDetails
    {
        public string RequestNumber { get; set; }
        public string MachineName { get; set; }
        public string MachineCode { get; set; }
        public string SubName { get; set; }
        public int SubId { get; set; }
        public string NameRequest { get; set; }
        public string UnitName { get; set; }
        public string FailType { get; set; }
        public string RequestType { get; set; }
        public string Time { get; set; }
        public string RequestTime { get; set; }
        public string RequestDate { get; set; }
        public string Comment { get; set; }
    }

    public class Units
    {
        public string UnitName { get; set; }
        public string UnitCode { get; set; }
    }
    public class Machines
    {
        public string MachineId { get; set; }
        public string MachineName { get; set; }
        public string MachineCode { get; set; }
        public string MachineLocation { get; set; }
        public string AfftectedMachineId { get; set; }
        public string StopTime { get; set; }
        public int RequestId { get; set; }
    }

    public class Line
    {
        public string LineId { get; set; }
        public string LineName { get; set; }

    }

    public class RepairRecords
    {
        public List<RecordInfoRepairRecords> RecordInfo { get; set; }
        public List<PartsRepairRecords> Parts { get; set; }
        public List<RepairerOfRepairRedords> Repairers { get; set; }
        public List<ContractorsOfRepairRecords> Contractors { get; set; }
    }

    public class RecordInfoRepairRecords
    {
        public int TagId { get; set; }
        public int RepairNumber { get; set; }
        public string Tarikh { get; set; }
        public string RepairExplain { get; set; }
        public int RecentlyUnit { get; set; }
        public int RecentlyLine { get; set; }
        public int NewUnit { get; set; }
        public int NewLine { get; set; }
        public string Comment { get; set; }
        public int Cr { get; set; }
    }
    public class PartsRepairRecords
    {
        public int Part { get; set; }
        public string PartName { get; set; }
        public int Count { get; set; }
        public string Measur { get; set; }
        public Boolean Rptools { get; set; }
        public string Rptooltip { get; set; }

    }

    public class RepairerOfRepairRedords
    {
        public int Repairer { get; set; }
        public string PersonelName { get; set; }
        public string RepairTime { get; set; }
        
    }

    public class ContractorsOfRepairRecords
    {
        public int Contractor { get; set; }
        public string ContractorName { get; set; }
        public string Cost { get; set; }
    }

    public class ReplyData
    {
        public List<ReplyInfo> ReplyInfo { get; set; }
        public List<FailReason> FailReason { get; set; }
        public List<DelayReason> DelayReason { get; set; }
        public List<Action> Action { get; set; }
        public List<PartChanges> PartChange { get; set; }
        public List<PartsRepairRecords> Parts { get; set; }
        public List<RepairerOfRepairRedords> Personel { get; set; }
        public List<ContractorsOfRepairRecords> Contractors { get; set; }
    }

    public class PartChanges
    {
        public int Machine { get; set; }
        public string MachineName { get; set; }
        public int Sub { get; set; }
        public string SubName { get; set; }
        public int Part { get; set; }
        public string PartName { get; set; }
    }
    public class FailReason
    {
        public int FailReasonId { get; set; }
        public string FailReasonName { get; set; }
    }

    public class DelayReason
    {
        public int DelayReasonId { get; set; }
        public string DelayReasonName { get; set; }
    }

    public class Action
    {
        public int ActionId { get; set; }
        public string ActionName { get; set; }
    }
    public class ReplyInfo
    {
        public int RequestId { get; set; }
        public int State { get; set; }
        public string StateName { get; set; }
        public string Comment { get; set; }
        public string StartDate { get; set; }
        public string StartTime { get; set; }
        public string EndDate { get; set; }
        public string EndTime { get; set; }
        public string RequestTime { get; set; }
        public string RequestDate { get; set; }
        public string RepairTime { get; set; }
        public string StopTime { get; set; }
        public int SubSystem { get; set; }
        public string SubsystemName { get; set; }
        public string Mechtime { get; set; }
        public string Electime { get; set; }

    }
    public class ControlsList
    {
        public string ControlName { get; set; }
        public List<string> Dates { get; set; }
        public ControlsList()
        {
            Dates = new List<string>();
        }
    }

    public class DailyReport
    {
        public string Id { get; set; }
        public string Date { get; set; }
        public string ReportProducer { get; set; }
        public string ReportExplain { get; set; }
        public string ReportTips { get; set; }
        public string RemindTime { get; set; }
        public string Subject { get; set; }
    }
    public class ChartData
    {
        public List<string> Strings { get; set; }
        public List<decimal> Integers { get; set; }

        public ChartData()
        {
            Strings = new List<string>();
            Integers = new List<decimal>();
        }
    }

    public class MtMachines
    {
        public List<string> Machine { get; set; }
        public List<int> Mtt { get; set; }
        public List<int> MttH { get; set; }
        public List<string> Fazname { get; set; }
        public List<string> Linename { get; set; }

        public MtMachines()
        {
            Machine = new List<string>();
            Mtt = new List<int>();
            MttH = new List<int>();
            Fazname= new List<string>();
            Linename=new List<string>();
        }

        
    }
    public class RepairRequest
    {
        public int Id { get; set; }
        public string RequestId { get; set; }
        public string UnitName { get; set; }
        public string Requester { get; set; }
        public string FailType { get; set; }
        public string RequestType { get; set; }
        public string Code { get; set; }
        public string Time { get; set; }
    }

    public class RepairRecord
    {
        public int RequestId { get; set; }
        public string MachineName { get; set; }
        public string Code { get; set; }
        public string RepairDate { get; set; }
        public string StopTime { get; set; }
        public string RepairTime { get; set; }
    }

    public class MtbfReports
    {
        public int Id { get; set; }
        public int Type { get; set; }
        public string Tarikh { get; set; }
        public string ReportName { get; set; }
        public string Producer { get; set; }
        public string Manager { get; set; }
        public string Exp { get; set; }
        public string Analyse { get; set; }
    }
    public class UserAccess
    {
        public static int CheckAccess()
        {
            try
            {
                var identity = (FormsIdentity)HttpContext.Current.User.Identity;
                var userData = identity.Ticket.UserData.Split(",".ToCharArray());
                return Convert.ToInt32(userData[1]);
            }
            catch (Exception)
            {
                return -1;
            }

        }

        public static int GetUnit()
        {
            try
            {
                var identity = (FormsIdentity)HttpContext.Current.User.Identity;
                var userData = identity.Ticket.UserData.Split(",".ToCharArray());
                return Convert.ToInt32(userData[2]);
            }
            catch (Exception)
            {
                return -1;
            }
        }
       
    }
    public class PMcontrol
    {
        public string Unit { get; set; }
        public string Machine { get; set; }
        public List<string> Date { get; set; }

        public string ControlName { get; set; }

        public PMcontrol()
        {
            Date = new List<string>();
        }
    }

    public class PartRequest
    {
        public int RequestId { get; set; }
        public int State { get; set; }
        public string Info { get; set; }
        public int PartId { get; set; }
        public string BuyRequestDate { get; set; }
        public string BuyRequestNumber { get; set; }
    }

    public class ForeCastList
    {
        public int ForeCastId { get; set; }
        public string PartName { get; set; }
        public int PartId { get; set; }
        public int MachineId { get; set; }
        public string ReplyDate { get; set; }
        public string CmDate { get; set; }
    }

    public class PartForeCastChange
    {
        public List<string> FailReasonList { get; set; }
        public int ForeCastId { get; set; }
        public string Info { get; set; }
        public int MachineId { get; set; }
        public int PartId { get; set; }
        public string ReplyDate { get; set; }
        public string Tarikh { get; set; }
        public string MainDate { get; set; }

    }

    public class CatalogFiles
    {
        public int Id { get; set; }
        public int MachineId { get; set; }
        public string Filename { get; set; }
        public string FileCode { get; set; }
        public string Address { get; set; }
    }
}