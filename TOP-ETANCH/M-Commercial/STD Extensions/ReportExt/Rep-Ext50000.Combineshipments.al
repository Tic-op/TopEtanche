namespace Top.Top;

using Microsoft.Sales.Document;

reportextension 50000 "Combine shipments" extends "Combine Shipments"
{
    dataset
    {
        modify(SalesOrderHeader)
        {
            //     RequestFilterFields = "Type de facturation";
            trigger OnAfterPreDataItem()
            var
            begin

                if PostInv then error('Afin de pouvoir valider les factures générées, veuillez contacter l''administrateur system');

            end;

        }


    }
    requestpage
    {
        layout
        {
            modify(PostInv)
            {
                Visible = false;
            }
        }
    }




}
