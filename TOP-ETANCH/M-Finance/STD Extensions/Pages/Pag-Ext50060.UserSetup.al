namespace Top.Top;

using System.Security.User;

pageextension 50060 "User Setup" extends "User Setup"
{
    layout
    {
        addlast(Content)
        {
            field("Blockage Client"; Rec."Blockage Client")
            {
                ApplicationArea = All;
                Caption = 'Blockage Client';
            }
        }
    }
}
