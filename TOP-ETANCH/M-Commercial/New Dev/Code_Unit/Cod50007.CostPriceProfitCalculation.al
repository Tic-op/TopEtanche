namespace Top.Top;
using Microsoft.Inventory.Costing;
using Microsoft.Pricing.PriceList;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Posting;

codeunit 50007 CostPriceProfitCalculation
{


    //[EventSubscriber(ObjectType::Codeunit,Codeunit::"Cost Calculation Management",)]

    //[EventSubscriber(ObjectType::Codeunit, Codeunit::ItemCostManagement,OnAfterUpdateUnitCost, '', false, false)]

    /* procedure UpdateSalesPrices()
    var 

      item: Record Item;
            // SalesPrice: Record "Sales Price";
            PricelistH: record "Price List Header";
            pricelisL: record "Price List Line";
            ParamMarge : record "Paramêtre marge" ;
        begin





        end; */


    //  [EventSubscriber(ObjectType::Table,database::Item,OnAfterModifyEvent, '', false, false)]
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::ItemCostManagement, OnAfterUpdateUnitCost, '', false, false)]
    procedure UpdateSalesPrices(var item: Record Item);
    var

        // SalesPrice: Record "Sales Price";
        PricelistH: record "Price List Header";
        pricelisL: record "Price List Line";
        ParamMarge: record "Paramêtre marge";
        PriceListtocancel: record "Price List Line";
    begin

        //if rec."Unit Cost" = xrec."Unit Cost" then exit ; 
        ParamMarge.setrange("Type articles", item."Item Category Code");
        if ParamMarge.findfirst() then
            repeat
                PricelistH.setrange("Source type", PricelistH."Source Type"::"Customer Price Group");
                PricelistH.setrange("Source No.", ParamMarge."Groupe prix client");
                if not PricelistH.findfirst then begin
                    PricelistH.reset();
                    PricelistH.init();
                    PricelistH.Code := 'Prix ' + ParamMarge."Groupe prix client";
                    PricelistH.Description := PricelistH.code;
                    PricelistH.validate("Source Type", PricelistH."Source Type"::"Customer Price Group");
                    PricelistH.validate("Source No.", ParamMarge."Groupe prix client");
                    // Message(ParamMarge."Groupe prix client"+'______'+PricelistH."Source No."+'___');
                    PricelistH.Validate("Starting Date", Today);
                    PricelistH."Allow Updating Defaults" := true;
                    PricelistH.validate(Status, PricelistH.Status::Active);
                    PricelistH.insert();
                    // PricelistH.validate(Status,PricelistH.Status::Active);
                    //PricelistH.Modify(); 
                    //  Commit();
                end;
                begin
                    pricelisL.init();
                    pricelisL.validate("Price List Code", PricelistH.Code);
                    pricelisL.validate("Source Type", pricelisL."Source Type"::"Customer Price Group");
                    pricelisL.validate("Source No.", PricelistH."Source No.");
                    pricelisL.validate("Product No.", item."No.");
                    pricelisL.validate("Starting Date", Today);
                    pricelisL."Minimum Quantity" := 1;
                    pricelisL.validate(status, Pricelisl.Status::Active);
                    pricelisL.validate("Unit Price", item."Unit Cost" * (1 + ParamMarge.Marge / 100));
                    pricelisL."Allow Line Disc." := true;


                    if pricelisL.insert(true) then begin
                        //  pricelisL.validate(Status,"Price Status"::Active);
                        // pricelisL.modify();

                        PriceListtocancel.setrange("Price List Code", pricelisL."Price List Code");
                        PriceListtocancel.setrange("Source Type", pricelisL."Source Type");
                        PriceListtocancel.setrange("Source No.", pricelisL."Source No.");
                        PriceListtocancel.setrange("Product No.", pricelisL."Product No.");
                        PriceListtocancel.setfilter("Line No.", '<> %1', pricelisL."Line No.");
                        if PriceListtocancel.FindFirst() then
                            repeat
                                PriceListtocancel.Status := PriceListtocancel.Status::Inactive;
                                PriceListtocancel."Ending Date" := today;

                                PriceListtocancel.Modify();
                            until PriceListtocancel.Next() = 0;

                        pricelisL.Verify();
                    end;
                end;
            until ParamMarge.next = 0;
    end;







}
