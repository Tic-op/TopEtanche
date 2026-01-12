namespace Top.Top;

using Microsoft.Pricing.PriceList;

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
            end;

        }
    }
}
