namespace Top.Top;

using Microsoft.Pricing.PriceList;
using Microsoft.Inventory.Item;

tableextension 50037 "Ligne prix vente" extends "Price List Line"
{
    fields
    {
        field(50201; "Prix marché"; decimal)
        {
            trigger OnValidate()
            begin
                CalcMarginFromPrice();
                ApplyPrice();
            end;

        }


        Field(50202; "Prix standard"; decimal)
        {
            trigger OnValidate()
            begin
                CalcMarginFromPrice();
                ApplyPrice();
            end;

        }

        Field(50203; MrgMarché; decimal)
        {
            DecimalPlaces = 0 : 0;
            trigger OnValidate()
            begin
                CalcPriceFromMargin();
                ApplyPrice();
            end;

        }
        Field(50204; MrgStd; decimal)
        {
            DecimalPlaces = 0 : 0;
            trigger OnValidate()
            begin
                CalcPriceFromMargin();
                ApplyPrice();
            end;

        }
        field(50210; "Estimated Cost"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Caption = 'Estimated Cost';
        }




    }


    procedure GetBaseCost(): Decimal
    var
        Item: Record Item;
    begin
        exit("Estimated Cost")
    end;

    procedure CalcPriceFromMargin()
    var
        Cost: Decimal;
    begin
        Cost := GetBaseCost();

        if Cost = 0 then
            exit;

        "Prix standard" := ROUND(Cost * (1 + MrgStd / 100), 0.001);
    end;

    procedure CalcMarginFromPrice()
    var
        Cost: Decimal;
    begin
        Cost := GetBaseCost();

        if Cost = 0 then
            exit;

        if "Prix marché" <> 0 then
            MrgMarché := (("Prix marché" - Cost) / Cost) * 100;

        if "Prix standard" <> 0 then
            MrgStd := (("Prix standard" - Cost) / Cost) * 100;
    end;

    procedure ApplyPrice()
    begin
        if "Prix marché" > "Prix standard" then
            "Unit Price" := "Prix marché"
        else
            "Unit Price" := "Prix standard";
    end;

}



/*  procedure SyncPriceAndMargin(CalcSource: Integer)
 var
     Item: Record Item;
 begin

     if not Item.get(rec."Asset No.") then
         exit;
     Rec."Unit Cost" := Item."Unit Cost";
     rec."Estimated Cost" := item."estimated cost";
     if Rec."Estimated Cost" = 0 then begin
         Rec.MrgMarché := 0;
         Rec.MrgStd := 0;
         exit;
     end;

     case CalcSource of
         1:
             begin
                 // Prix → % marge
                 if Rec."Prix marché" <> 0 then
                     Rec.MrgMarché :=
                         ((Rec."Prix marché" - Rec."Estimated Cost") / Rec."Estimated Cost") * 100
                 else
                     Rec.MrgMarché := 0;

                 if Rec."Prix standard" <> 0 then
                     Rec.MrgStd :=
                           ((Rec."Prix standard" - Rec."Estimated Cost") / Rec."Estimated Cost") * 100
                 else
                     Rec.MrgStd := 0;
             end;

         2:
             begin

                 if Rec.MrgMarché <> xRec.MrgMarché then
                     Rec.validate("Prix marché", ROUND(
                         Rec."Estimated Cost" * (1 + Rec.MrgMarché / 100), 0.001, '=')
                     );

                 if Rec.MrgStd <> xRec.MrgStd then
                     Rec.validate("Prix standard", ROUND(
                         Rec."Estimated Cost" * (1 + Rec.MrgStd / 100), 0.001, '='));

             end;

     end;
 end; 

*/
