tableextension 50076 purchaseRcpLineExt extends "Purch. Rcpt. Line"
{
    fields
    {

        field(50101; "Tariff No."; Code[20])
        {
            Caption = 'Nomencalture Produit';
            DataClassification = ToBeClassified;
            TableRelation = "Tariff Number";
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
        field(50105; Montant; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Montant';
        }
    }
    /*trigger OnInsert()
    begin
        Rec.Montant := ("VAT Base Amount" * "VAT %" / 100) + "VAT Base Amount";
    end;*/


}