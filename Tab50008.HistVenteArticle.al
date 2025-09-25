table 50008 HistVenteArticle
{
    Caption = 'HistVenteArticle';
   // TableType = Temporary ;
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Item No"; Code[20])
        {
            Caption = 'No. article';
        }
        field(4; "Document Type"; Option)
        {
            Caption = 'Type document';
            OptionMembers = "","Expédition","Facture","Devis","Facture validée","Commande Pré-BL";
        }
        field(5; "Document No"; Code[20])
        {
            Caption = 'No document';
            TableRelation = if ("Document Type" = const(Expédition)) "Sales Shipment Header"."No." where("No." = field("Document No")) else
            if ("Document Type" = const("Facture validée")) "Sales Invoice Header"."No." where("No." = field("Document No")) else
            if ("Document Type" = const(Devis)) "Sales Header Archive" where("Document Type" = const("Sales Document Type"::Quote), "No." = field("Document No"))
            else if ("Document Type" = const(Facture)) "Sales Header" where("Document Type" = const("Sales Document Type"::invoice), "No." = field("Document No"))
            else if ("Document Type" = const("Commande Pré-BL")) "Sales Header" where("Document Type" = const("Sales Document Type"::Order), "No." = field("Document No"), "Shipping No." = filter(<> ''));
            ValidateTableRelation = false ;}

        field(2; "Customer No"; Code[20])
        {
            Caption = 'No client';
            TableRelation = Customer;

        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Nom client';
        }
        field(6; "Date Document"; Date)
        {
            Caption = 'Date Document';
        }
        field(7; "Price HT"; Decimal)
        {
            Caption = 'Prix HT';
            DecimalPlaces = 0:3 ;
        }
        field(8; "Price TTC"; Decimal)
        {
            Caption = 'Prix TTC';
            DecimalPlaces = 0:3 ;
        }
        field(9; Remise; Decimal)
        {
            Caption = 'Remise';
            MinValue = 0 ;
            maxvalue = 100 ;
            DecimalPlaces = 0:2;
        }
    }
    keys
    {
        key(PK; "Item No","Document Type","Customer No")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        cust: Record customer;
    begin
        if "Customer Name" = '' then begin

            Cust.SetLoadFields("No.", Name);
            Cust.get("Customer No");
            "Customer Name" := cust.Name;
        end

    end;

}
