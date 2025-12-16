namespace Top.Top;

using Microsoft.Bank.Payment;
using Microsoft.Bank.BankAccount;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;

tableextension 50035 "Payment Line" extends "Payment Line"
{
    fields
    {
        field(50000; "Designation"; Text[250])
        {
            Caption = 'Designation';
            DataClassification = ToBeClassified;


        }


        modify(Amount)
        {
            trigger OnAfterValidate()
            var
                PaymentClass: Record "Payment Class";
            begin
                IF ("Account Type" = "Account Type"::Customer) AND (Amount > 0) THEN
                    VALIDATE(Amount, -abs(Amount));

                if PaymentClass.get("Payment Class") then begin
                    if (Abs(Amount) > abs(PaymentClass."Max Valeur ligne")) and
                    (PaymentClass."Max Valeur ligne" <> 0) then
                        Error('Dans le %1 il est impossible de passer %2. La valeur maximale permise est %3',
                        PaymentClass.Code, abs(Amount), PaymentClass."Max Valeur ligne");
                end;
                //     IF ("Code RS" <> xRec."Code RS") then
                //       Error('Merci de supprimer le code RS avant de modifier le montant');
            end;
        }

        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
                frs: Record Vendor;
                Bq: Record "Bank Account";
                PH: Record "Payment Header";

            begin
                if "Account No." = '' then
                    exit;
                Designation := '';

                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    Customer.get("Account No.");
                    Designation := Customer.Name;
                END;
                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    frs.get("Account No.");
                    Designation := frs.Name;
                end;
                IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                    Bq.get("Account No.");
                    Designation := Bq.Name;
                END;

                PH.get("No.");
                if (PH."Account Type" = "Account Type"::"Bank Account") and (PH."Account No." <> '') then
                    "Banque Entête" := PH."Account No.";
            end;
        }

        modify("Drawee Reference")
        {
            trigger OnAfterValidate()
            begin
                "External Document No." := "Drawee Reference";
            end;
        }

        field(60019; "Engagement financier"; Option)
        {
            Caption = 'Engagement financier';
            OptionMembers = " ","Effet à payer","Chèque à payer","Espèce ou virement à payer";
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Payment Status"."Engagement financier" where("Payment Class" = field("Payment Class"), "Line" = field("Status No.")));

        }
        field(60020; "Risque"; Option)
        {
            Caption = 'Risque';
            OptionMembers = " ",CPF,FACTORING,EPF,EEN,BQ;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Payment Status".Risque where("Payment Class" = field("Payment Class"), "Line" = field("Status No.")));

        }
        field(50001; "Montant base RS"; Decimal)
        {
            Caption = 'Montant base RS';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50002; "Code RS"; Code[20])
        {
            Caption = 'Code RS';
            DataClassification = ToBeClassified;
            TableRelation = "Retenue à la source";
            trigger OnValidate()
            begin

                if "Status No." <> 0 Then
                    Error('Ce champs ne peut pas être modifié');

                if "Montant RS" <> 0 then
                    Error('RS déjà calculée. Merci de suprrimer toute la ligne !');

                CalculRS();
                if (xRec."Code RS" <> rec."Code RS") then
                    CalculRS();

            end;
        }
        field(50003; "Montant RS"; Decimal)
        {
            Caption = 'Montant RS';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "RS VAT Amount"; Decimal)
        {
            Caption = 'RS VAT Amount';
            DataClassification = ToBeClassified;

            Editable = false;
        }
        field(50005; "Montant RS VAT Amount"; Decimal)
        {
            Caption = 'Montant RS VAT Amount';
            DataClassification = ToBeClassified;
            Editable = false;


        }
        Field(50102; "Banque Entête"; code[25])

        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
            Editable = false;

        }
        Field(50103; "TVA RS Pub"; Decimal)

        {
            DataClassification = ToBeClassified;


        }
    }
    procedure CalculRS()
    var
        RS: Record "Retenue à la source";
    begin
        //Récupérer la rs saisie + vérifier que % <> 0 + Vérifier que il y a un GL account 
        if "Code RS" <> '' then begin
            RS.get("Code RS");
            IF RS."Compte GL" = '' Then
                Error('Pas de compte comptable dans la retenue %1', "Code RS");
            IF RS.Taux <= 0 Then
                Error('Taux non valide dans la retenue %1', "Code RS");

            IF "Montant base RS" <> 0 then
                "Montant RS" := ROUND("Montant base RS" * RS.Taux / 100, 0.001, '=')
            else begin
                "Montant base RS" := amount;
                "Montant RS" := ROUND("Montant base RS" * RS.Taux / 100, 0.001, '=');
                Validate(amount, "Montant base RS" - "Montant RS");
            end;
        end
        else if "Montant base RS" <> 0 then begin // initier Amount
            Validate(amount, "Montant base RS");
            "Montant base RS" := 0;
            "Montant RS" := 0;
        end;


    end;
}
