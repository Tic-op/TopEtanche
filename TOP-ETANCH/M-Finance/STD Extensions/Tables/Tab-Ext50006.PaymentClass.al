namespace Top.Top;

using Microsoft.Bank.Payment;

tableextension 50006 "Payment Class" extends "Payment Class"
{
    fields
    {
        field(50000; "Max Valeur ligne"; Decimal)
        {
            Caption = 'Max Valeur ligne';
            DataClassification = ToBeClassified;
        }
          field(50002; "Sans Echéance"; Boolean) //CHB 30072025
        {

        }
    }
}
