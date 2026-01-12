namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Purchases.History;
using Microsoft.Sales.History;

page 50053 "Usual Search Item"
{
    ApplicationArea = All;
    Caption = 'Usual Search Item';
    PageType = Worksheet;
    SourceTable = Item;

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
                            //  Inserer();
                            Generer();
                        end;
                        XrecSearchFilter := SearchFilter;
                    end;

                }

                /*    field(Client; SalesHeader."Bill-to Customer No." + ' ' + SalesHeader."Bill-to Name")
                   {
                       Enabled = false;
                       ApplicationArea = all;
                       QuickEntry = false;

                   } */
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
                        /* if SalesVarinitialized then
                            rec.GetLastSales(SalesHeader."Sell-to Customer No.", SalesHeader."Sell-to Customer Name", 19); */
                    end;
                }
                field("reference origine"; Rec."reference origine")
                {
                    editable = false;
                }
                Field(Disponibilité; rec.Availability)
                {
                    Caption = 'Disponibilité';
                    Editable = false;
                    DecimalPlaces = 0 : 3;
                    BlankZero = true;
                    Style = Favorable;
                }

                field("Unit Cost"; Rec."Unit. cost simulation")
                {
                    Caption = 'Coût';
                    Editable = true;
                    visible = false;
                    trigger OnDrillDown()
                    begin
                        ShowReceiption();
                    end;


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

                //field(Marge; rec."Marge sur achat"){}
                field("Vendor No."; Rec."Vendor No.") { Editable = false; }
                field("Vendor Name"; Rec."Vendor Name") { Editable = false; }


            }
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
                    //  Inserer();
                    Generer();

                end;
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        //  Inserer();
    end;

    Trigger OnOpenPage()

    var
        item: Record item;
        i: integer;
    begin
        // item.SetCurrentKey("Usual search");
        //   item.setrange("Usual search", '');
        i := 0;

        item.findfirst();
        repeat
            if (item."Usual search" = '')
             //OR
             // (item."Usual search" <> item.Description + ' ' + item."Vendor Item No." + ' ' + item."reference Origine")
             then begin
                item."Usual search" := item.Description + ' ' + item."Vendor Item No." + ' ' + item."reference Origine";
                item.Modify();
                i := i + 1;
            end;
        until (item.Next() = 0);

        //  Message('End');

    end;


    /*   procedure initvar(TypeDoc: Enum "Sales Document Type"; noDoc: Code[20])
      var
          SL: Record "Sales Line";
          Items: Record Item;


      begin
          SalesHeader.get(TypeDoc, noDoc);
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




          SalesVarinitialized := true;




      end;
   */





    Procedure Generer()
    var
        itemrec: record Item;
        FiltreRecherche: Code[1000];
        // Customer: Record Customer;
        FiltrerecharcheClean: Code[1000];
        ProgressDlg: Dialog;
        TotalCount: Integer;
        CurrentCount: Integer;


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

                /*     Customer.Get(SalesHeader."Sell-to Customer No.");

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
                    end; */

                /* 
                                if ItemRec."Unit Cost" <> 0 then
                                    Rec."Marge sur achat" :=
                                        ((Rec."Unit Price" / ItemRec."Unit Cost") - 1) * 100;
                                Rec."Unit. cost simulation" := ItemRec."Unit Cost"; */
                rec.Availability := rec."CalcDisponibilitéWithResetFilters"('', '');

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
        // ShipLine.SetCurrentKey("Bill-to Customer No.");
        //ShipLine.SetRange("Bill-to Customer No.", SalesHeader."Bill-to Customer No.");
        //ShipLine.SetCurrentKey("Bill-to Customer No.");

        exit(ShipLine.count);
    end;

    procedure ShowShipmentLinesByCustomerItem()
    var
        ShipLine: Record "Sales Shipment Line";
    begin
        ShipLine.SetCurrentKey("No.", "Posting Date");
        ShipLine.SetRange("No.", rec."No.");
        // ShipLine.SetCurrentKey("Bill-to Customer No.");
        // ShipLine.SetRange("Bill-to Customer No.", SalesHeader."Bill-to Customer No.");
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
        // SalesHeader: Record "Sales Header";


        QtyToAdd: decimal;
        FiltreDescription, FiltreReferenceFournisseur, FiltreReferenceOrigine : Text[100];
        SearchFilter, XrecSearchFilter : Code[50];
        //TransferH: record "Transfer Header";
        TransferHNo: Code[20];

    //VendorFilter: text[100];
}
