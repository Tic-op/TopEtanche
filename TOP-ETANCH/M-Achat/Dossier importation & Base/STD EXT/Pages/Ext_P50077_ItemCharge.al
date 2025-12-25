pageextension 50077 ItemchargeExt extends "Item Charges"
{
    layout
    {
        addafter(Description)
        {
            field(Affectable; Rec.Affectable)
            {
                ApplicationArea = all;
            }
            field("Droit Douane"; Rec."Droit Douane") { ApplicationArea = all; }
            field(TVA; Rec.TVA) { ApplicationArea = all; }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}