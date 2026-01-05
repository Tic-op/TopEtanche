namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;

page 50044 "Recherche article"
{
    ApplicationArea = All;
    Caption = 'Recherche article';
    PageType = Worksheet;
    SourceTable = item;
    DeleteAllowed = false;
    InsertAllowed = false;
    RefreshOnActivate = false;
    UsageCategory = Administration;


    layout
    {
        area(Content)
        {
            group("Filtrer les résultats...")
            {
                group("Filtre article")
                {

                    field(FiltreDescription; FiltreDescription)
                    {
                        trigger OnValidate()
                        begin

                            if FiltreDescription <> '' then begin
                                // rec.Reset();
                                Rec.SetFilter("No.", '');

                                Rec.SetCurrentKey("Search Description");
                                Rec.SetFilter("Search Description", '*' + UpperCase(FiltreDescription) + '*')
                            end
                            else
                                Rec.SetRange("Search Description", '?');
                            CurrPage.Update(true);
                        end;
                    }
                    Field(FiltreReferenceFournisseur; FiltreReferenceFournisseur)
                    {
                        Trigger OnValidate()
                        begin
                            Rec.setfilter("Vendor Item No.", FiltreReferenceFournisseur);

                        end;
                    }

                    field(FiltreFournisseur; FiltreFournisseur) { }
                }
                group("Filtre catégories")
                {
                    field(famille; FiltreFamille)
                    {
                        TableRelation = "Item Category"."Code" where("Parent Category" = const(''), Level = const(Famille));
                        trigger onvalidate()
                        begin

                            rec.setrange("Famille Category", FiltreFamille);
                            CurrPage.update(true);
                        end;
                    }
                    field("catégorie"; FiltreCatégorie)
                    {
                        TableRelation = "Item Category"."Code" where(Level = const(Catégorie));
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            ItemCat: Record "Item Category";
                            PageLookup: Page "item Categories";
                        begin
                            ItemCat.SetRange("Parent Category", FiltreFamille);
                            PageLookup.SetTableView(Itemcat);
                            PageLookup.LookupMode := true;
                            PageLookup.Editable := false;
                            if PageLookup.RunModal() = Action::LookupOK then
                                PageLookup.GetRecord(ItemCat);

                            FiltreCatégorie := ItemCat.code;
                            //exit(true);
                        end;

                        trigger onvalidate()
                        begin

                            rec.setfilter("Catégorie Category", FiltreCatégorie);
                            CurrPage.update(true);
                        end;


                    }

                    field(Produit; FiltreProduit)
                    {
                        TableRelation = "Item Category"."Code" where(Level = const(Produit));
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            ItemCat: Record "Item Category";
                            PageLookup: Page "item Categories";
                        begin
                            ItemCat.SetRange("Parent Category", FiltreCatégorie);
                            PageLookup.SetTableView(Itemcat);
                            PageLookup.LookupMode := true;
                            PageLookup.Editable := false;
                            if PageLookup.RunModal() = Action::LookupOK then
                                PageLookup.GetRecord(ItemCat);

                            FiltreProduit := ItemCat.code;
                            //exit(true);
                        end;

                        trigger OnValidate()
                        begin

                            rec.setfilter("Produit Category", FiltreProduit);
                            CurrPage.update(true);
                        end;



                    }
                    field("Type"; FiltreType)
                    {
                        TableRelation = "Item Category"."Code" where(Level = const("type"));
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            ItemCat: Record "Item Category";
                            PageLookup: Page "item Categories";
                        begin
                            ItemCat.SetRange("Parent Category", FiltreProduit);
                            PageLookup.SetTableView(Itemcat);
                            PageLookup.LookupMode := true;
                            PageLookup.Editable := false;
                            if PageLookup.RunModal() = Action::LookupOK then
                                PageLookup.GetRecord(ItemCat);
                            FiltreType := ItemCat.code;
                            //exit(true);
                        end;

                        trigger onvalidate()
                        begin

                            rec.setfilter("Type Category", FiltreType);
                            CurrPage.update(true);
                        end;
                    }



                }

                //FiltreDescription, FiltreReferenceFournisseur , FiltreFournisseur ,FiltreFamille,FiltreCatégorie ,FiltreProduit,FiltreType

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
                Field(DispoGlobale; "disponibilité")
                {
                    Editable = false;
                    DecimalPlaces = 0 : 3;
                }
                Field(QtyToAdd; QtyToAdd) { DecimalPlaces = 0 : 3; }
                field("Vendor No."; Rec."Vendor No.") { Editable = false; }
                field("Vendor Name"; Rec."Vendor Name") { Editable = false; }
                field("Unit Price"; Rec."Unit Price") { Editable = false; DecimalPlaces = 0 : 3; }
                //field("Price Includes VAT"; Rec."Price Includes VAT") { Editable = false;}
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        disponibilité := rec."CalcDisponibilitéWithResetFilters"('', '');
        CalcQtyToAdd();
        //SetQtyToAddStyle();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        SalesLine, SalesLineToModify : Record "Sales Line";
        // PurchaseLine, PurchaseLineToModify : Record "Purchase Line";
        LineNo: Integer;

    begin


        // key to range with
        TempSelectedItems.SetFilter("Reorder Quantity", '>0');

        if TempSelectedItems.FindSet() then begin

            if SalesOrderNo <> '' then begin
                SalesLine.SetRange("Document Type", salesType);
                SalesLine.SetRange("Document No.", SalesOrderNo);
                if SalesLine.FindLast() then
                    LineNo := SalesLine."Line No." + 10000
                else
                    LineNo := 10000;
            end;



            repeat
                if SalesOrderNo <> '' then begin
                    // IF NOT CheckIfItemAlreadyExistsOnSalesLine() THEN 
                    begin
                        SalesLine.Init();
                        SalesLine.Validate("Document Type", salesType);
                        SalesLine.Validate("Document No.", SalesOrderNo);
                        SalesLine."Line No." := LineNo;
                        SalesLine.Type := SalesLine.Type::Item;
                        SalesLine.Validate("No.", TempSelectedItems."No.");
                        SalesLine.Validate(Quantity, TempSelectedItems."Reorder Quantity");
                        SalesLine.Insert();
                        LineNo += 10000;
                    end
                    /*   else begin
                          SalesLineToModify.SetRange("Document Type", salesType);
                          SalesLineToModify.SetRange("Document No.", SalesOrderNo);
                          SalesLineToModify.SetRange("No.", TempSelectedItems."No.");
                          if SalesLineToModify.FindFirst() then begin
                              SalesLineToModify.Validate(Quantity, TempSelectedItems."Reorder Quantity");
                              SalesLineToModify.Modify(true);
                          end;

                      end; */
                end;


            until TempSelectedItems.Next() = 0;
        end;

        CurrPage.Close();
    end;

    procedure initvar(TypeDoc: Enum "Sales Document Type"; noDoc: Code[20])
    var
        SL: Record "Sales Line";
        Items: Record Item;


    begin
        SalesHeader.get(TypeDoc, noDoc);
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

    local procedure UpdateQtyToAdd()
    begin

        if TempSelectedItems.get(Rec."No.") then begin
            TempSelectedItems."Reorder Quantity" := QtyToAdd;
            TempSelectedItems.Modify(true);

        end
        else begin
            TempSelectedItems.Init();
            TempSelectedItems.TransferFields(Rec);
            TempSelectedItems."Reorder Quantity" := QtyToAdd;
            TempSelectedItems.Insert(true);

        end;
    end;

    local procedure CalcQtyToAdd()
    begin
        QtyToAdd := 0;
        // QtyBuy := 0;
        if TempSelectedItems.get(Rec."No.") and (SalesOrderNo <> '') then begin

            QtyToAdd := TempSelectedItems."Reorder Quantity";
        end;
    end;


    procedure CheckIfItemAlreadyExistsOnSalesLine(): Boolean
    var
        SalesLine: Record "Sales Line";

    begin
        SalesLine.SetRange("Document Type", salesType);
        SalesLine.SetRange("Document No.", SalesOrderNo);
        SalesLine.SetRange("No.", TempSelectedItems."No.");
        exit(SalesLine.FindFirst());
    end;


    var
        FiltreDescription, FiltreReferenceFournisseur, FiltreFournisseur, FiltreFamille, FiltreCatégorie, FiltreProduit, FiltreType : Text[100];
        TempSelectedItems: Record Item temporary;
        SalesHeader: Record "Sales Header";
        salesType: Enum "Sales Document Type";
        SalesOrderNo: code[20];
        SalesVarinitialized: boolean; // TB Purpose //AM 031025
        QtyToAdd: decimal;
        disponibilité: decimal;
}
