table 50019 "Détails Article"
{
    Caption = 'Détails Article';
    DataClassification = ToBeClassified;
 
    fields
    {
        field(1; "Item No"; Code[20])
        {
            Caption = 'No. article';
            TableRelation = Item;
            ValidateTableRelation = false;
        }
        field(10; "Item Description"; Text[100])
        {
            Caption = 'Article Description';
        }
        field(12; "Qty"; Decimal)
        {
            Caption = 'Quantité';
        }
        field(4; "Document Type"; Option)
        {
            Caption = 'Type document';
            OptionMembers = "","Expédition","Facture","Devis","Facture validée","Commande Pré-BL","Facture Achat",,"Facture Achat Etranger";
        }
        field(5; "Document No"; Code[20])
        {
            Caption = 'No document';
 
        }
        field(11; "Document Line No"; integer)
        {
            AutoIncrement = true;
        }
 
        field(2; "Source No"; Code[20])
        {
            Caption = 'No source';
            TableRelation = if ("Document Type"= const("Expédition")) Customer else 
                                if ("Document Type"= const("Facture")) Customer else
                                if ("Document Type"= const("Devis")) Customer else
                                if ("Document Type"= const("Facture validée")) Customer else
                                if ("Document Type"= const("Commande Pré-BL")) Customer else
                                    if ("Document Type"= const("Facture Achat")) Vendor else
                                  if ("Document Type"= const("Facture Achat Etranger")) Vendor ;
  
                    
            // Customer;
            ValidateTableRelation = false;
            trigger onvalidate()
            var
                cust: record customer;
                vendor : record Vendor ;
            begin
                 if ("Document Type" = "Document Type"::"Facture Achat Etranger") or ("Document Type" ="Document Type"::"Facture Achat") then 
                       begin 
                         if Vendor.get("Source No") then 
                          "Source Name":=vendor.name;

                       end
                       else 
                       if "Document Type" <> 0 then
                       
                       begin 
               if Cust.get("Source No") then 

                "Source Name" := cust.Name;
                       end;
                
            end;
 
        }
        field(3; "Source Name"; Text[100])
        {
            Caption = 'Nom source';
        }
        field(6; "Date Document"; Date)
        {
            Caption = 'Date Document';
        }
        field(7; "Price HT"; Decimal)
        {
            Caption = 'Prix HT';
            DecimalPlaces = 0 : 3;
        }
        field(8; "Price TTC"; Decimal)
        {
            Caption = 'Prix TTC';
            DecimalPlaces = 0 : 3;
        }
        field(9; Remise; Decimal)
        {
            Caption = 'Remise';
            MinValue = 0;
            maxvalue = 100;
            DecimalPlaces = 0 : 2;
        }
    }
    keys
    {
        key(PK; "Item No", "Document Type", "Document No", "Document Line No")
        {
            Clustered = true;
        }
        key(key_date; "Date Document")
        { }
    }
 
 
}
 