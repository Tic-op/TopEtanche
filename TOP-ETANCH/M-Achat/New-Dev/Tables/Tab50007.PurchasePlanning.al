table 50007 "PurchasePlanning"
{
    DataClassification = ToBeClassified;
    Caption = 'Planification des réceptions';

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
            Caption = 'Fournisseur';
        }

        field(2; "Expected Date"; Date)
        {
            DataClassification = SystemMetadata;
            Caption = 'Date prévue de réception';
        }

        field(3; "Approved by Vendor"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Validé par le fournisseur';
        }

        field(4; "Real Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date réelle';
        }

        field(5; "Comment"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Remarque';
        }
    }

    keys
    {
        key(PK; "Vendor No.", "Expected Date")
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    begin
        if xRec."Approved by Vendor" = "Approved by Vendor" then begin
            if "Approved by Vendor" then
                Error('Une fois validée, la ligne ne peut plus être modifiée.');
        end;
    end;

    trigger OnDelete()
    begin
        if "Approved by Vendor" then
            Error('Suppression non autorisée : ligne validée par le fournisseur.');
    end;

    trigger OnRename()
    begin
        if "Approved by Vendor" then
            Error('Renommage non autorisé : ligne validée par le fournisseur.');
    end;

    procedure CalculerMontants(var MontantCommande: Decimal; var MontantReceptionne: Decimal; var MontantDOPRestante: Decimal)
    var
        PurchaseLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        QuantiteRestante: Decimal;
        CoutUnitaire: Decimal;
        Remise: Decimal;
    begin
        MontantCommande := 0;
        MontantReceptionne := 0;
        MontantDOPRestante := 0;

        // Montant des Commandes (Order)
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange("Buy-from Vendor No.", "Vendor No.");
        PurchaseLine.SetRange("Expected Receipt Date", "Expected Date");
        if PurchaseLine.findfirst() then
            repeat
                MontantCommande += PurchaseLine.Amount;
            until PurchaseLine.Next() = 0;

        // Montant des Réceptions
        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Buy-from Vendor No.", "Vendor No.");
        PurchRcptLine.SetRange("Expected Receipt Date", "Expected Date");
        if PurchRcptLine.FindSet() then
            repeat
                CoutUnitaire := PurchRcptLine."Direct Unit Cost";
                Remise := PurchRcptLine."Line Discount %" / 100;
                MontantReceptionne += PurchRcptLine.Quantity * CoutUnitaire * (1 - Remise);
            until PurchRcptLine.Next() = 0;

        // DOP restantes
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Quote);
        PurchaseLine.SetRange("Buy-from Vendor No.", "Vendor No.");
        PurchaseLine.SetRange("Expected Receipt Date", "Expected Date");
        PurchaseLine.SetRange("Confirmé par fournisseur", true);
        PurchaseLine.SetAutoCalcFields("DOP sur Commande", "DOP sur Réception");

        if PurchaseLine.FindSet() then
            repeat
                QuantiteRestante := PurchaseLine.Quantity - (PurchaseLine."DOP sur Commande" + PurchaseLine."DOP sur Réception");
                if QuantiteRestante > 0 then begin
                    CoutUnitaire := PurchaseLine."Unit Cost";
                    Remise := PurchaseLine."Line Discount %" / 100;
                    MontantDOPRestante += QuantiteRestante * CoutUnitaire * (1 - Remise);
                end;
            until PurchaseLine.Next() = 0;
    end;


}
