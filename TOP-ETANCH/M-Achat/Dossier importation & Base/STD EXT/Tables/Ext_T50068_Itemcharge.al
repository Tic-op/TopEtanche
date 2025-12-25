tableextension 50068 itemchargeExt extends "Item Charge"
{
    fields
    {
        field(50000; Affectable; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = true;
        }
        field(50001; "Droit Douane"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Droit Douane" then tva := false;
            end;

        }
        field(50003; TVA; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if tva then "Droit Douane" := false;
            end;
        }
    }


}