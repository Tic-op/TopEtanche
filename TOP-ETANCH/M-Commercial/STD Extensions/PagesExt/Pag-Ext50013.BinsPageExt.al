namespace TopEtanch.TopEtanch;

using Microsoft.Warehouse.Structure;

pageextension 50013 BinsPageExt extends Bins
{
    layout
    {
        addafter("Bin Type Code")
        {
            field("Niveau emplacement"; Rec."Niveau emplacement")
            {
                ApplicationArea = all;
                trigger OnValidate()
                var
                    TempRec: Record "Bin";
                begin
                    Rec."Date de mise à jour" := CurrentDateTime();
                end;

            }
            field("Date de mise à jour"; Rec."Date de mise à jour")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
}
