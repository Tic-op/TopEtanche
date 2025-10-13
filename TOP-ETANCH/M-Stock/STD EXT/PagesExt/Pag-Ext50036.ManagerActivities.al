namespace Top.Top;

using Microsoft.Finance.RoleCenters;

pageextension 50036 "Manager Activities" extends "Business Manager Role Center"

{
    layout
    {
        addafter(Control139)
        {    group(KPI)
        {
              part("Manager Activities"; "KPI Préparation")
            {
                Caption = 'KPI Préparations';
                ApplicationArea = all;
            }
        }
          

        }
    }
}
