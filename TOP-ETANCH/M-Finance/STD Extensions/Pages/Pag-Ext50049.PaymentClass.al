namespace Top.Top;

using Microsoft.Bank.Payment;

pageextension 50049 "Payment Class" extends "Payment Class"
{
    layout
    {

        addafter(Name)
        {
            field("Type caisse"; Rec."Type caisse")
            {
                ApplicationArea = all;

            }

        }

        addafter("Line No. Series")
        {
            field("Max Valeur ligne"; rec."Max Valeur ligne")
            {
                ApplicationArea = all;
                Caption = 'Max Valeur ligne';
            }

        }
        addafter(Suggestions)
        {
            field("Sans Echéance"; rec."Sans Echéance")
            {
                ApplicationArea = all;
                Caption = 'Sans Echéance';
            }

        }
    }
}
