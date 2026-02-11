tableextension 50076 purchaseRcpLineExt extends "Purch. Rcpt. Line"
{
    fields
    {


        field(50050; "Prix Std"; Decimal)
        {
            Caption = 'Prix Std';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                MargeStd;
            end;

        }
        field(50051; "Prix Gros"; Decimal)
        {
            Caption = 'Prix Gros';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                MargeGros;

            end;

        }
        field(50052; "Prix Auto"; decimal)
        {
            Caption = 'Prix Auto';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                MargeAuto;

            end;

        }
        field(50053; PRCost; decimal)
        {

        }
        field(50054; PMPCost; decimal)
        {

        }
        field(50055; CalcBase; Option)
        {
            Caption = 'Base';
            OptionMembers = PR,PMP;
            OptionCaption = 'PR,PMP';
            trigger OnValidate()
            begin
                // validate(TheoreticalSalesPrice, 0);
            end;

        }
        field(50056; OtherUnitCost; decimal)
        {


        }
        field(50057; "% Marge théorique"; decimal)
        {
            Editable = false;
        }
        field(50058; "% Marge Auto"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            begin
                MargeAuto;
            end;
        }
        field(50059; "% Marge Gros"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            begin
                MargeGros;
            end;
        }
        field(50060; "% Marge Std"; Decimal)
        {
            trigger OnValidate()
            begin
                MargeStd;
            end;
        }
        field(50061; "Price confirmation Date"; DateTime)
        {
        }
        field(50062; "P. Marché"; Decimal)
        {
            Editable = false;

        }

        field(50063; "P. Marché Gros"; Decimal)
        {
            Editable = false;


        }

        field(50064; "Ecart Marché"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(50065; "Ecart Marché Gros"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 0;
        }

        field(50066; "% Ecart Marché"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(50067; "% Ecart Marché Gros"; Decimal)
        {
            Editable = false;
        }
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
        /*   Field(50301; "Vendor Shipment No."; Code[35])
          {
              Caption = 'No BL fournisseur';
              CalcFormula = lookup("Purchase Header"."Vendor Shipment No." where("Document Type" = const("Purchase Document Type"::Order), "No." = field("Order No.")));
              FieldClass = FlowField;
          } */
    }
    /*trigger OnInsert()
    begin
        Rec.Montant := ("VAT Base Amount" * "VAT %" / 100) + "VAT Base Amount";
    end;*/
    local procedure MargeStd()
    begin
        if CalcBase = CalcBase::PR then
            "Prix Std" := ROUND(PRCost * (1 + "% Marge Std" / 100), 0.001, '=')
        else
            "Prix Std" := ROUND(PMPCost * (1 + "% Marge Std" / 100), 0.001, '=');


    end;

    local procedure MargeGros()
    begin
        if CalcBase = CalcBase::PR then
            "Prix Gros" := ROUND(PRCost * (1 + "% Marge Gros" / 100), 0.001, '=')
        else
            "Prix Gros" := ROUND(PMPcost * (1 + "% Marge Gros" / 100), 0.001, '=')
    end;

    local procedure MargeAuto()
    begin
        if CalcBase = CalcBase::PR then
            "Prix Auto" := ROUND(PRCost * (1 + "% Marge Auto" / 100), 0.001, '=')
        else
            "Prix Auto" := ROUND(PMPCost * (1 + "% Marge Auto" / 100), 0.001, '=')

    end;

    Procedure Getprixmarchéarticle(): decimal
    var
        item: record Item;
    begin
        if rec.type <> rec.type::Item then
            exit(0)
        else begin
            item.get(rec."No.");
            exit(item."Prix marché");
        end;

    end;


    Procedure Getprixmarchégros(): Decimal
    var
        LP: record "Price List Line";
        pdf: page 50;
    begin

        if rec.type <> rec.type::Item then
            exit(0)
        else begin
            LP.SetCurrentKey("Asset Type", "Asset No.", "Source Type", "Source No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            LP.SetAscending("Starting Date", false);
            LP.SetRange("Source Type", LP."Source Type"::"Customer Price Group");
            LP.SetRange("Source No.", 'GROS');
            /*  PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
             PriceListLine.SetRange("Asset No.",); */
            LP.setrange("Product No.", "No.");


            if LP.findlast() then
                exit(LP."Prix marché")
            else
                exit(0)


        end;


    end;

    procedure GetSalesPrice(PriceGroup: Code[10]): Decimal
    var
        PriceListLine: Record "Price List Line";
        Today: Date;
    begin
        Today := WorkDate();

        PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::"Customer Price Group");
        PriceListLine.SetRange("Source No.", PriceGroup);
        /*  PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
         PriceListLine.SetRange("Asset No.",); */
        PriceListLine.setrange("Product No.", rec."No.");
        PriceListLine.SetRange(Status, PriceListLine.Status::Active);
        PriceListLine.SetFilter("Starting Date", '..%1', Today);
        PriceListLine.SetFilter("Ending Date", '%1|>=%1', 0D, Today);

        if PriceListLine.FindFirst() then
            exit(PriceListLine."Unit Price");

        exit(0);
    end;




}