namespace Top.Top;

using Microsoft.Pricing.PriceList;

page 50029 PriceListSubform
{
    ApplicationArea = All;
    Caption = 'PriceListSubform';
    PageType = ListPart;
    SourceTable = "Price List Line";
    SourceTableView = where("Asset Type"= const(Item),Status= const ("Price Status"::Active));
    ModifyAllowed= false ; 
    InsertAllowed = false ;
    DeleteAllowed = false ;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {  /*  field("Source Type";Rec."Source Type")
            {}
                field("Asset Type"; Rec."Asset Type")
                {
                    ToolTip = 'Specifies the type of the product.';
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ToolTip = 'Specifies the identifier of the product. If no product is selected, the price and discount values will apply to all products of the selected product type for which those values are not specified. For example, if you choose Item as the product type but do not specify a specific item, the price will apply to all items for which a price is not specified.';
                }
                field("Product No."; Rec."Product No.")
                {
                    ToolTip = 'Specifies the identifier of the product. If no product is selected, the price and discount values will apply to all products of the selected product type for which those values are not specified. For example, if you choose Item as the product type but do not specify a specific item, the price will apply to all items for which a price is not specified.';
                } */
               /*  field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies whether the price list line is in Draft status and can be edited, Inactive and cannot be edited or used, or Active and used for price calculations.';
                } */
               /* field("Line Amount"; Rec."Line Amount")
               {
                   ToolTip = 'Specifies the value of the Line Amount field.', Comment = '%';
               } */
                field("Unit Price";Rec."Unit Price")
                {

                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                { }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ToolTip = 'Specifies the line discount percentage for the product.';
                }
                /*   field("Price Includes VAT";Rec."Price Includes VAT")
                  {

                  }  */
                /*  field("VAT Bus. Posting Gr. (Price)";Rec."VAT Bus. Posting Gr. (Price)")
                 {

                 } */
            }
        }
    }
}
