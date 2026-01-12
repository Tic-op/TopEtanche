namespace Top.Top;

using Microsoft.Pricing.PriceList;
using Microsoft.Sales.Pricing;

pageextension 50082 "Price list Subform" extends "Price List Lines"
{
    layout
    {
        addafter("Unit Price")
        {
            field("Prix marché"; rec."Prix marché")
            {
                AccessByPermission = tabledata "Sales Price Access" = R;
                ApplicationArea = All;
                Editable = AmountEditable;
                Enabled = PriceMandatory;
                Visible = PriceVisible;
                StyleExpr = PriceStyle;
            }


            Field("Prix standard"; rec."Prix standard")
            {
                AccessByPermission = tabledata "Sales Price Access" = R;
                ApplicationArea = All;
                Editable = AmountEditable;
                Enabled = PriceMandatory;
                Visible = PriceVisible;
                StyleExpr = PriceStyle;

            }
        }
    }
}
