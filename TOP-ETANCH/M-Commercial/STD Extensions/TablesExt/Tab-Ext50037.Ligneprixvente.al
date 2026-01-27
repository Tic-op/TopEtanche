namespace Top.Top;

using Microsoft.Pricing.PriceList;
using Microsoft.Inventory.Item;

tableextension 50037 "Ligne prix vente" extends "Price List Line"
{
    fields
    {
        field(50201; "Prix marché"; decimal)
        {
            trigger onvalidate()
            var
            begin
                if "Prix marché" > "Prix standard" then
                    validate("Unit Price", "Prix marché")
                else
                    Validate("Unit Price", "Prix standard");

                Verify();

                SyncPriceAndMargin(1);

            end;

        }


        Field(50202; "Prix standard"; decimal)
        {
            trigger onvalidate()
            var
            begin
                if "Prix marché" > "Prix standard" then
                    validate("Unit Price", "Prix marché")
                else
                    Validate("Unit Price", "Prix standard");
                Verify();

                SyncPriceAndMargin(1);

            end;

        }

        Field(50203; MrgMarché; decimal)
        {
            DecimalPlaces = 0 : 0;
            trigger onvalidate()
            var
            begin
                SyncPriceAndMargin(2);

            end;

        }
        Field(50204; MrgStd; decimal)
        {
            DecimalPlaces = 0 : 0;
            trigger onvalidate()
            var
            begin
                SyncPriceAndMargin(2);
            end;

        }



    }
    procedure SyncPriceAndMargin(CalcSource: Integer)
    var
        Item: Record Item;
    begin

        if not Item.get(rec."Asset No.") then
            exit;
        Rec."Unit Cost" := Item."Unit Cost";
        if Rec."Unit Cost" = 0 then begin
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
                            ((Rec."Prix marché" - Rec."Unit Cost") / Rec."Unit Cost") * 100
                    else
                        Rec.MrgMarché := 0;

                    if Rec."Prix standard" <> 0 then
                        Rec.MrgStd :=
                              ((Rec."Prix standard" - Rec."Unit Cost") / Rec."Unit Cost") * 100
                    else
                        Rec.MrgStd := 0;
                end;

            2:
                begin

                    if Rec.MrgMarché <> xRec.MrgMarché then
                        Rec.validate("Prix marché", ROUND(
                            Rec."Unit Cost" * (1 + Rec.MrgMarché / 100), 0.001, '=')
                        );

                    if Rec.MrgStd <> xRec.MrgStd then
                        Rec.validate("Prix standard", ROUND(
                            Rec."Unit Cost" * (1 + Rec.MrgStd / 100), 0.001, '='));

                end;

        end;
    end;

}
