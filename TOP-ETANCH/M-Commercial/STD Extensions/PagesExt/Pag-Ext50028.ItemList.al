namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;

pageextension 50028 ItemList extends "Item List"
{
    Layout
    {
        addafter("Vendor No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                visible = true;
                ApplicationArea = all;

            }

        }
        addafter(InventoryField)
        {
            field(Disponibilité; rec."CalcDisponibilitéWithResetFilters"('', ''))
            {
                visible = true;
                ApplicationArea = all;
                DecimalPlaces = 0 : 3;
            }
        }
        moveafter("No."; "Vendor Item No.")
        modify("Substitutes Exist")
        {
            Visible = false;
        }
        modify("Assembly BOM")
        {
            visible = false;
        }
        modify("Default Deferral Template Code")
        { Visible = false; }
        modify(Type)
        {
            visible = false;
        }
        modify("Vendor Item No.")
        {
            visible = true;
            // Caption= 'Code fournisseur';
            ApplicationArea = all;
        }
        modify("Cost is Adjusted")
        {
            Visible = false;
        }
    }
    actions
    {
        addfirst(Functions)
        {

            action(MAJ_DESCRIPTION)
            {
                ApplicationArea = all;
                Promoted = true;
                visible = true;
                trigger OnAction()
                var
                    Descriptionmodified: Text[100];
                    Descriptionmodifiedvendorno: text[250];
                    descOrigine: text[250];

                begin
                    if REc.Findfirst() then
                        repeat
                            Descriptionmodified := rec."Vendor Item No.";
                            rec.Validate("Vendor Item No.", Descriptionmodified.Replace('.', ','));
                            Descriptionmodifiedvendorno := rec.description;
                            rec.Validate(description, Descriptionmodifiedvendorno.Replace('.', ','));
                            descOrigine := rec."reference origine";
                            rec.Validate("reference origine", descOrigine.Replace('.', ','));


                            rec.Modify();
                        until rec.next = 0;

                end;

            }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin

    end;




}

