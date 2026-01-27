namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Pricing.PriceList;

page 50056 "Item Sales Price FactBox"
{
    PageType = CardPart;
    SourceTable = Item;
    Caption = 'Item Prices';

    layout
    {
        area(content)
        {
            group(Prices)
            {
                field("Prix standard"; rec."Prix standard")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Attention;
                }
                field("Prix marché"; rec."Prix marché")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Gros Price"; GrosPrice)
                {
                    Caption = 'Prix Gros';
                    ApplicationArea = All;
                    Editable = false;
                    Style = strong;
                    trigger OnDrillDown()
                    var
                        PG: Page "Price List Line Review";
                        LP: record "Price List Line";
                    begin
                        LP.SetCurrentKey("Asset Type", "Asset No.", "Source Type", "Source No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                        LP.SetAscending("Starting Date", false);
                        LP.SetRange("Source Type", LP."Source Type"::"Customer Price Group");
                        LP.SetRange("Source No.", 'GROS');
                        /*  PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
                         PriceListLine.SetRange("Asset No.",); */
                        LP.setrange("Product No.", rec."No.");
                        LP.SetRange(Status, LP.Status::Active);
                        PG.SetTableView(LP);
                        PG.Editable(false);
                        Pg.Run;



                    end;
                }
                /*  field("Auto Price"; AutoPrice)
                 {
                     Caption = 'Prix Auto';
                     ApplicationArea = All;
                     Editable = false;
                     Style = Ambiguous;
                     visible =false ;
                     trigger OnDrillDown()
                     var
                         PG: Page "Price List Line Review";
                         LP: record "Price List Line";
                     begin
                         LP.SetCurrentKey("Asset Type", "Asset No.", "Source Type", "Source No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                         LP.SetAscending("Starting Date", false);
                         LP.SetRange("Source Type", LP."Source Type"::"Customer Price Group");
                         LP.SetRange("Source No.", 'AUTO');

                         LP.setrange("Product No.", rec."No.");
                         LP.SetRange(Status, LP.Status::Active);
                         PG.SetTableView(LP);
                         PG.Editable(false);
                         Pg.Run;



                     end;
                 } */


            }

        }


    }

    var
        //   AutoPrice: Decimal;
        Lastpurchase: decimal;
        GrosPrice: Decimal;

    trigger OnAfterGetRecord()
    begin
        //  AutoPrice := GetSalesPrice('AUTO');
        GrosPrice := GetSalesPrice('GROS');
    end;

    local procedure GetSalesPrice(PriceGroup: Code[10]): Decimal
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
    // local procedure LastPurchasePrice()
}
