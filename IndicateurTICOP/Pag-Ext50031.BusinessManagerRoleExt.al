namespace TopEtanch.TopEtanch;

using Microsoft.Finance.RoleCenters;
using System.Security.User;

pageextension 70001 "Business Manager Role Ext" extends "Business Manager Role Center"
{
    layout
    {
        addfirst(rolecenter)
        {
            part("ManagerActivities"; "Manager Activities")
            {
                Caption = 'KPI management';
                ApplicationArea = all;
            }

        }


    }

}
