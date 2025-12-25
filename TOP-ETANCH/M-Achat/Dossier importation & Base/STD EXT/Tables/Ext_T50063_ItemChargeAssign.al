tableextension 50063 ItemchargeAssigPurch extends "Item Charge Assignment (Purch)"
{
    fields
    {
        field(50001; "DI No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No DI';
        }
        field(50002; "Droit Douane"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
    }

}