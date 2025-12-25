tableextension 50077 purchaseinvLineExt extends "Purch. Inv. Line"
{
    fields
    {

        field(50101; "Tariff No."; Code[20])
        {
            Caption = 'Nomencalture Produit';
            DataClassification = ToBeClassified;
            tablerelation = "Tariff Number";
        }
        field(50102; "Droit douane"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50103; TVA; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Country region origin code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No Origine';
        }
    }


}