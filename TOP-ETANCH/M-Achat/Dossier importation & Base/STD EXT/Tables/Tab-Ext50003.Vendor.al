namespace Ticop.Ticop;

using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Item;

tableextension 50113 Vendor_Ext extends Vendor
{
    fields
    {
        field(50000; "Item Count"; Integer)
        {
            Caption = 'Item Count';
            FieldClass = FlowField;
            CalcFormula = COUNT(Item where("Vendor No." = field("No.")));
            Editable = false;
        }
        field(50101; "Stamp"; Boolean)
        {
            Caption = 'Timbre';
            InitValue = true;

        }
        field(50102; "Equipement"; Boolean)
        {
            Caption = 'Equipement';
            DataClassification = ToBeClassified;

        }
    }
}
