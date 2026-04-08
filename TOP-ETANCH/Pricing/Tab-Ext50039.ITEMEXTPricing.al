namespace TopEstimatedPricing.TopEstimatedPricing;

using Microsoft.Inventory.Item;

tableextension 50039 ITEMEXTPricing extends Item
{
    fields
    {

        field(50201; "Prix marché"; decimal)
        {
            DecimalPlaces = 3 : 3;

            trigger OnValidate()
            begin
                CalcMarginFromPrice();
                ApplyPrice();
            end;

        }


        Field(50202; "Prix standard"; decimal)
        {

            DecimalPlaces = 3 : 3;
            trigger OnValidate()
            begin
                CalcMarginFromPrice();
                ApplyPrice();
            end;

        }

        Field(50203; MrgMarché; decimal)
        {
            DecimalPlaces = 0 : 2;
            trigger OnValidate()
            begin
                CalcPriceFromMargin();
                ApplyPrice();
            end;

        }
        Field(50204; MrgStd; decimal)
        {
            DecimalPlaces = 0 : 2;
            trigger OnValidate()
            begin
                CalcPriceFromMargin();
                ApplyPrice();
            end;

        }
        Field(50205; "estimated cost"; decimal)
        {
            DecimalPlaces = 0 : 3;
            trigger OnValidate()
            var
                PricingMgt: Codeunit PricingMNG;
            begin
                /*  if "estimated cost" < "Unit Cost" then
                     "estimated cost" := "Unit Cost"; */
                CalcPriceFromMargin();
                ApplyPrice();
                // Commit();
                if Rec."estimated cost" <> xRec."estimated cost" then
                    PricingMgt.UpdateAllPriceLinesFromItem(rec);
            end;

            trigger OnLookup()
            var
                CU: codeunit PricingMNG;
            begin
                CU.RecalculateEstimatedCost("No.");
            end;
        }
        /*   field(50206; "Last Estimated Cost Source"; Option)
          {
              OptionMembers = Import,Local,Manual,System;
              OptionCaption = 'Import,Local,Manuel,System';
          } */
    }
    procedure GetBaseCost(): Decimal
    begin
        if ("estimated cost" = 0) and ("Unit Cost" = 0) then // Version 1
            exit(0);

        if ("estimated cost" > "Unit Cost") then
            exit("estimated cost")
        else
            exit("Unit Cost");
        /*    if "estimated cost" > 0 then  //Version 2
              exit("estimated cost") 
          else
              exit("Unit Cost"); */
    end;

    procedure CalcPriceFromMargin()
    var
        Cost: Decimal;
    begin
        Cost := GetBaseCost();

        "Prix standard" := ROUND(Cost * (1 + MrgStd / 100), 0.001);
        //  "Prix marché" := ROUND(Cost * (1 + MrgMarché / 100), 0.001);
    end;

    procedure CalcMarginFromPrice()
    var
        Cost: Decimal;
    begin
        Cost := GetBaseCost();

        if Cost <> 0 then begin
            if "Prix marché" <> 0 then
                MrgMarché := (("Prix marché" - Cost) / Cost) * 100;

            if "Prix standard" <> 0 then
                MrgStd := (("Prix standard" - Cost) / Cost) * 100;
        end;
    end;

    procedure ApplyPrice()
    begin
        if "Prix marché" > "Prix standard" then
            "Unit Price" := "Prix marché"
        else
            "Unit Price" := "Prix standard";
    end;
}
