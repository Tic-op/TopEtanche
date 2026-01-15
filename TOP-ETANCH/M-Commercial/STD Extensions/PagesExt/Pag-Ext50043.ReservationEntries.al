namespace TopEtanch.TopEtanch;


using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;
using Microsoft.CRM.Setup;

pageextension 50043 "Reservation Entries" extends "Reservation Entries"
{
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {



        addafter("Quantity (Base)")
        {


            field("Lot No"; Rec."Lot No.")
            {
                visible = true;
                ApplicationArea = all;
            }
            field("Expiration Date"; Rec."Expiration Date")
            {
                visible = true;
                ApplicationArea = all;
            }


        }
        addafter("Item No.")
        {
            field(designation; desi)
            {
                visible = true;
                ApplicationArea = all;
            }
        }


    }
    var
        desi: Text[100];

    trigger OnAfterGetRecord()
    var
        item: Record Item;

    begin
        if item.get(REC."Item No.") then
            desi := item.Description;

    end;


}
