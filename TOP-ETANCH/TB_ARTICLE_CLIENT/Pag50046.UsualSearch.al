namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Purchases.Document;
using Microsoft.Pricing.PriceList;
using Microsoft.Purchases.History;
using Microsoft.Sales.History;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;

page 50046 "Usual Search"
{
    ApplicationArea = All;
    Caption = 'Recherche multi-dimension';
    PageType = Worksheet;
    SourceTable = item;
    UsageCategory = Tasks;
    InsertAllowed = false;
    DeleteAllowed = false;
    // DelayedInsert = true; 
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group("Recherche")
            {

                Field(SearchFilter; SearchFilter)
                {
                    Caption = 'Filtre de recherche';
                    ApplicationArea = all;
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        if (XrecSearchFilter <> SearchFilter) AND (SearchFilter <> '') then begin
                            Inserer();
                            Generer();
                        end;
                        XrecSearchFilter := SearchFilter;
                    end;

                }
                field(Disp; OnlyAvailable)
                {
                    ApplicationArea = all;
                    QuickEntry = false;
                }
                field(Client; SalesHeader."Bill-to Customer No." + ' ' + SalesHeader."Bill-to Name")
                {
                    Enabled = false;
                    ApplicationArea = all;
                    QuickEntry = false;

                }
                /*  Field(VendorFilter; VendorFilter)
                 {
                     Caption = 'Filtre fournisseur';
                     ApplicationArea = all;
                     trigger OnValidate()
                     begin
                         if rec.count <> 0 then
                             rec.setfilter("Vendor Name", '*%1*', VendorFilter);
                     end;
                 } */
            }


            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        Itemcard: page "Item Card";

                    begin
                        Itemcard.SetRecord(Rec);
                        Itemcard.RunModal();
                    end;
                }
                field("Vendor Item No."; Rec."Vendor Item No.") { Editable = false; }
                field(Description; Rec.Description)
                {

                    ToolTip = 'Specifies a description of the item.';
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        if SalesVarinitialized then
                            rec.GetLastSales(SalesHeader."Sell-to Customer No.", SalesHeader."Sell-to Customer Name", 19);
                    end;
                }
                field("reference origine"; Rec."reference origine")
                {
                    editable = false;
                }
                Field("Disp. globale"; rec.Availability)
                {
                    Caption = 'Disp. globale';
                    Editable = false;
                    DecimalPlaces = 0 : 3;
                    BlankZero = true;
                    Style = AttentionAccent;
                }
                Field("Disp. magasin"; rec.AvailabilityByLocation)
                {
                    Caption = 'Disp. magasin';
                    Editable = false;
                    DecimalPlaces = 0 : 3;
                    BlankZero = true;
                    CaptionClass = 'Disp.  ' + SalesHeader."Location Code";
                    Style = Favorable;
                    Visible = LocationVisible;
                    ;
                }


                Field(QtyToAdd; rec."Reorder Quantity")
                {
                    Caption = 'Quantité';
                    DecimalPlaces = 0 : 3;
                    Style = Attention;
                }
                field("Budget Quantity"; Rec."Budget Quantity")
                {
                    Caption = 'Panier';
                    DecimalPlaces = 0 : 3;
                    Style = Ambiguous;
                    ApplicationArea = all;
                    Visible = panierVisible;

                }
                field(Tampon; rec.AvailabilityInTampon)
                {
                    Caption = 'Tampon';
                    Style = StrongAccent;
                    ApplicationArea = all;
                    Editable = false;
                    DecimalPlaces = 0 : 3;
                    BlankZero = true;
                }
                field("Achat en cours"; Rec."Qty. on Purch. Order")
                {
                    Caption = 'Achat en cours';
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 3;
                    BlankZero = true;

                    Editable = false;

                }

                field("Unit Price"; Rec."Unit Price")
                {
                    Editable = false;
                    DecimalPlaces = 3 : 3;
                    Style = Strong;

                }

                field("TTC"; ROUND(Rec."Unit Price" * 1.19, 0.001, '=')) { Editable = false; DecimalPlaces = 3 : 3; Style = StandardAccent; }

                field(Vendu; CountShipmentsByCustomerItem())
                {
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        ShowShipmentLinesByCustomerItem();
                    end;
                }
                field("Unit Cost"; Rec."Unit. cost simulation")
                {
                    Caption = 'Coût';
                    Editable = true;
                    trigger OnDrillDown()
                    begin
                        ShowReceiption();
                    end;

                    trigger OnValidate()
                    begin
                        if rec.Availability > 0 then
                            Error('La référence est disponible... Vous ne pouvez pas modifier le coût');
                    end;
                }
                field(Marge; rec."Marge sur achat")
                {

                }
                field("Vendor No."; Rec."Vendor No.") { Editable = false; }
                field("Vendor Name"; Rec."Vendor Name") { Editable = false; }


            }
            /*            part(Historique; HistVenteArticleSubform)
                        {
                            ApplicationArea = Basic, Suite;
                            Editable = false;
                            SubPageLink = "Item No" = field("No.");
                            UpdatePropagation = Both;
                            Caption = 'Historique';

                        }
                        */

        }


    }

    actions
    {
        area(Processing)
        {

            action(Générer)
            {
                ShortcutKey = F7;
                trigger onaction()
                var

                begin
                    Inserer();
                    Generer();

                end;
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Inserer();
    end;

    trigger OnAfterGetCurrRecord()
    var
        Customer: Record Customer;
        Item: Record Item;
    begin
        Customer.setrange("No.", SalesHeader."Sell-to Customer No.");
        //    CurrPage.Historique.Page.SetCustomer(Customer);
        Item.SetRange("No.", Rec."No.");
        //  CurrPage.Historique.Page.Setitem(Item);



    end;




    procedure initvar(TypeDoc: Enum "Sales Document Type"; noDoc: Code[20])
    var
        SL: Record "Sales Line";
        Items: Record Item;


    begin
        SalesHeader.get(TypeDoc, noDoc);
        if (TypeDoc = TypeDoc::Order) or (TypeDoc = TypeDoc::Invoice) then
            LocationVisible := SalesHeader."Location Code" <> '';
        if SalesHeader.Status <> SalesHeader.Status::Open
        then
            Error('Le document doit être ouvert!');
        SalesOrderNo := noDoc;
        salesType := TypeDoc;

        panierVisible :=
                 (SalesHeader."Document Type" = SalesHeader."Document Type"::Quote)
or
         (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)
         OR (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice);




        /*  SL.SetRange("Document Type", salesType);
         SL.SetRange("Document No.", SalesOrderNo);
         SL.SetRange(Type, SL.Type::Item);
         SL.SetFilter("No.", '<>%1', '');
         SL.SetFilter(Quantity, '<>%1', 0);
         if SL.FindFirst() then
             repeat
                 Items.SetRange("No.", SL."No.");
                 Items.FindFirst();
                 TempSelectedItems.Init();
                 TempSelectedItems := Items;
                 TempSelectedItems."Reorder Quantity" := SL.Quantity;
                 if TempSelectedItems.insert(true) then;


             until SL.Next() = 0; */
        SalesVarinitialized := true;




    end;

    procedure initvarPurch(TypeDoc: Enum "Purchase Document Type"; noDoc: Code[20])
    var
        PL: Record "Purchase Line";
        Items: Record Item;


    begin
        SalesHeader.get(TypeDoc, noDoc);
        if SalesHeader.Status <> SalesHeader.Status::Open
        then
            Error('Le document doit être ouvert!');
        SalesOrderNo := noDoc;
        salesType := TypeDoc;


        /*  SL.SetRange("Document Type", salesType);
         SL.SetRange("Document No.", SalesOrderNo);
         SL.SetRange(Type, SL.Type::Item);
         SL.SetFilter("No.", '<>%1', '');
         SL.SetFilter(Quantity, '<>%1', 0);
         if SL.FindFirst() then
             repeat
                 Items.SetRange("No.", SL."No.");
                 Items.FindFirst();
                 TempSelectedItems.Init();
                 TempSelectedItems := Items;
                 TempSelectedItems."Reorder Quantity" := SL.Quantity;
                 if TempSelectedItems.insert(true) then;


             until SL.Next() = 0; */
        SalesVarinitialized := true;




    end;



    Procedure Inserer()
    var
        SalesL: record "Sales Line";
        BO, CurrDoc : record "Sales Header";
    begin
        Rec.SetFilter("Reorder Quantity", '>%1', 0);

        if rec.FindSet() then
            repeat
                SalesL.Reset();
                SalesL.Init();
                SalesL."Document Type" := SalesHeader."Document Type";
                SalesL."Document No." := SalesHeader."No.";
                SalesL."Line No." := SalesL.GetLastLineNo() + 10000;
                SalesL.validate(Type, "Sales Line Type"::Item);

                SalesL.validate("No.", Rec."No.");

                if rec."Reorder Quantity" <= rec.AvailabilityByLocation then
                    SalesL.Validate(Quantity, Rec."Reorder Quantity")
                else begin
                    SalesL.validate("Location Code", '');
                    SalesL.Validate(Quantity, Rec."Reorder Quantity")
                end;
                //SalesL.Quantity := rec."Reorder Quantity";
                //  SalesL."Qty. to Ship" := rec."Reorder Quantity";

                if SalesL.insert() then begin
                    rec."Reorder Quantity" := 0;
                end;
                SalesL.Validate("Unit Price", rec."Unit Price");
                SalesL.Modify();

            until rec.next = 0;



        rec.Reset();

        if not panierVisible then begin
            rec.Reset();
            exit;
        end;
        //  Rec.SetCurrentKey("Budget Quantity");
        rec.setfilter("Budget Quantity", '>%1', 0);

        if rec.FindSet() then
            repeat
                CurrDoc.setrange("Document Type", salesType);
                CurrDoc.SetRange("No.", SalesOrderNo);
                CurrDoc.FindSet();
                BO.init;
                BO := CurrDoc;
                BO."Document Type" := SalesHeader."Document Type"::"Blanket Order";
                // BO.Validate("Posting Date", Today);
                if BO.insert then BO.Validate("Posting Date", Today);



                SalesL.Init();
                SalesL."Document Type" := SalesHeader."Document Type"::"Blanket Order";
                SalesL."Document No." := SalesHeader."No.";
                SalesL."Line No." := SalesL.GetLastLineNo() + 10000;
                SalesL.validate(Type, "Sales Line Type"::Item);

                SalesL.validate("No.", Rec."No.");
                SalesL.Validate(Quantity, Rec."Budget Quantity");

                if SalesL.insert() then begin
                    rec."Budget Quantity" := 0;
                    SalesL.Validate("Unit Price", rec."Unit Price");
                    SalesL.Modify();
                end

            until rec.next = 0;


        rec.Reset();


    end;

    Procedure Generer()
    var
        itemrec: record Item;
        FiltreRecherche: Code[1000];
        Customer: Record Customer;
        FiltrerecharcheClean: Code[1000];
        ProgressDlg: Dialog;
        TotalCount: Integer;
        CurrentCount: Integer;
        PriceHeader: Record "Price List Header";
        PriceLine: Record "Price List Line";

    begin

        if SearchFilter = '' then
            Error('Pas de critères de recherche ...');


        /*   FiltreRecherche := UpperCase('*' + FiltreDescription + '*' + FiltreReferenceFournisseur + '*' + FiltreReferenceOrigine + '*' + '|' +
                            '*' + FiltreDescription + '*' + FiltreReferenceOrigine + '*' + FiltreReferenceFournisseur + '*' + '|' +
                           '*' + FiltreReferenceFournisseur + '*' + FiltreReferenceOrigine + '*' + FiltreDescription + '*' + '|' +
                          '*' + FiltreReferenceFournisseur + '*' + FiltreDescription + '*' + FiltreReferenceOrigine + '*' + '|' +
                          '*' + FiltreReferenceOrigine + '*' + FiltreDescription + '*' + FiltreReferenceFournisseur + '*' + '|' +
                            '*' + FiltreReferenceOrigine + '*' + FiltreReferenceFournisseur + '*' + FiltreDescription + '*'); */

        rec.DeleteAll(false);
        itemrec.SetCurrentKey("Usual search");
        FiltreRecherche := BuildFilter(SearchFilter);
        FiltrerecharcheClean := SupprimerRedondancesCaractere(FiltreRecherche, '*');
        // message(FiltreRecherche);
        //Message(SearchFilter);
        //Message(FiltrerecharcheClean);
        Itemrec.setfilter("Usual search", '*' + FiltrerecharcheClean + '*');

        TotalCount := ItemRec.Count();
        CurrentCount := 0;

        ProgressDlg.Open(
          'Traitement des articles...\#1#############\'
        + 'Avancement : #2###### %\'
        + 'Article : #3############');

        /*   if VendorFilter <> '' then
              rec.setfilter("Vendor Name", '*%1*', VendorFilter); */
        if ItemRec.FindSet() then
            repeat
                CurrentCount += 1;

                // Mise à jour du progress
                ProgressDlg.Update(1, CurrentCount);
                ProgressDlg.Update(2, Round((CurrentCount * 100) / TotalCount, 1));
                ProgressDlg.Update(3, ItemRec."No.");

                Rec := ItemRec;

                Customer.Get(SalesHeader."Sell-to Customer No.");

                Rec."Unit Price" := ItemRec."Unit Price";
                if Customer."Customer Price Group" <> '' then begin
                    PriceLine.SetCurrentKey("Source Type", "Source No.", "Asset Type", "Asset No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                    PriceLine.SetRange("Source Type", PriceLine."Source Type"::"Customer Price Group");
                    PriceLine.SetRange("Source No.", Customer."Customer Price Group");
                    PriceLine.SetRange("Product No.", rec."No.");
                    PriceLine.SetRange(status, PriceLine.Status::Active);
                    PriceLine.SetFilter("Minimum Quantity", '<=%1', 1);///???
                    if PriceLine.FindSet() then
                        Rec."Unit Price" := PriceLine."Unit Price";
                end;


                if ItemRec."Unit Cost" <> 0 then
                    Rec."Marge sur achat" :=
                        ((Rec."Unit Price" / ItemRec."Unit Cost") - 1) * 100;


                Rec."Unit. cost simulation" := ItemRec."Unit Cost";
                rec.Availability := rec."CalcDisponibilitéWithResetFilters"('', '');
                rec.AvailabilityByLocation := rec."CalcDisponibilitéWithResetFilters"(SalesHeader."Location Code", '');
                Rec.AvailabilityInTampon := rec."CalcDisponibilitéWithResetFilters"('LIV', '');
                If not OnlyAvailable then
                    Rec.Insert()
                else
                    if (rec.Availability > 0) then
                        Rec.Insert();

            until ItemRec.Next() = 0;
        if Rec.FindFirst() then;
        ProgressDlg.Close();


    end;

    procedure SupprimerRedondancesCaractere(Texte: Text; Car: Char): Text
    var
        i: Integer;
        Resultat: Text;
        CarPrecedent: Char;
    begin
        if Texte = '' then
            exit('');

        Resultat := '';
        CarPrecedent := 0;

        for i := 1 to StrLen(Texte) do begin
            if (Texte[i] = Car) and (CarPrecedent = Car) then
                continue;

            Resultat += Texte[i];
            CarPrecedent := Texte[i];
        end;

        exit(Resultat);
    end;


    procedure BuildFilter(InputText: Text): Text
    var
        Tokens: List of [Text];
        Permutations: List of [Text];
        ResultFilter: Text;
        Token: Text;
    begin
        // Découpage UNIQUEMENT sur *
        foreach Token in InputText.Split('*') do begin
            /*    Token := DelChr(Token, '<>', ' ');
               if Token <> '' then */
            Tokens.Add(Token);
        end;

        if Tokens.Count = 0 then
            exit('');

        if Tokens.Count > 4 then
            Error('Max 4 bloques de recherche');
        GeneratePermutations(Tokens, 1, Permutations);

        foreach Token in Permutations do begin
            if ResultFilter <> '' then
                ResultFilter += '|';

            ResultFilter += '*' + Token + '*';
        end;

        exit(UpperCase(ResultFilter));
    end;


    /* local procedure EscapeFilterValue(Value: Text): Text
    begin
        Value := ConvertStr(Value, '\', '\\');
        Value := ConvertStr(Value, '*', '\*');
        Value := ConvertStr(Value, '|', '\|');
        Value := ConvertStr(Value, '&', '\&');
        exit(Value);
    end; */

    local procedure ShowReceiption()
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.Reset();

        PurchRcptLine.SetRange(Type, PurchRcptLine.Type::Item);
        PurchRcptLine.SetRange("No.", rec."No.");
        Page.Run(Page::"Posted Purchase Receipt Lines", PurchRcptLine);
    end;



    procedure CountShipmentsByCustomerItem(): Integer
    var
        ShipLine: Record "Sales Shipment Line";
    begin
        ShipLine.SetCurrentKey("No.", "Posting Date");
        ShipLine.SetRange("No.", rec."No.");
        ShipLine.SetCurrentKey("Bill-to Customer No.");
        ShipLine.SetRange("Bill-to Customer No.", SalesHeader."Bill-to Customer No.");
        ShipLine.SetCurrentKey("Bill-to Customer No.");

        exit(ShipLine.count);
    end;

    procedure ShowShipmentLinesByCustomerItem()
    var
        ShipLine: Record "Sales Shipment Line";
    begin
        ShipLine.SetCurrentKey("No.", "Posting Date");
        ShipLine.SetRange("No.", rec."No.");
        ShipLine.SetCurrentKey("Bill-to Customer No.");
        ShipLine.SetRange("Bill-to Customer No.", SalesHeader."Bill-to Customer No.");
        ShipLine.SetRange(Type, ShipLine.Type::Item);

        Page.Run(Page::"Posted Sales Shipment Lines", ShipLine);
    end;


    local procedure GeneratePermutations(
     var Tokens: List of [Text];
     StartIndex: Integer;
     var Result: List of [Text])
    var
        i: Integer;
    begin
        if StartIndex = Tokens.Count then begin
            Result.Add(JoinTokens(Tokens));
            exit;
        end;



        for i := StartIndex to Tokens.Count do begin
            Swap(Tokens, StartIndex, i);
            GeneratePermutations(Tokens, StartIndex + 1, Result);
            Swap(Tokens, StartIndex, i);
        end;
    end;

    local procedure Swap(var Tokens: List of [Text]; Index1: Integer; Index2: Integer)
    var
        Temp1, Temp2 : Text;
    begin
        Temp1 := Tokens.Get(Index1);
        Temp2 := Tokens.Get(Index2);

        Tokens.Set(Index1, Temp2);
        Tokens.Set(Index2, Temp1);
    end;

    local procedure JoinTokens(Tokens: List of [Text]): Text
    var
        Result: Text;
        Token: Text;
    begin
        foreach Token in Tokens do
            Result += '*' + Token + '*';
        exit(Result);
    end;




    var
        // TempSelectedItems: Record Item temporary;
        SalesHeader: Record "Sales Header";
        salesType: Enum "Sales Document Type";
        SalesOrderNo, CustNo : code[20];
        SalesVarinitialized: boolean; // TB Purpose //AM 031025
        panierVisible: Boolean;
        QtyToAdd: decimal;
        FiltreDescription, FiltreReferenceFournisseur, FiltreReferenceOrigine : Text[100];
        SearchFilter, XrecSearchFilter : Code[50];
        OnlyAvailable, LocationVisible : Boolean;

    //VendorFilter: text[100];
}
