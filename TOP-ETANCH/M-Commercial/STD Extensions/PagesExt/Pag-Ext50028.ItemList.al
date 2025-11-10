namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;

pageextension 50028 ItemList extends "Item List"
{ 
    Layout {
addafter("Vendor No.")
{
    field("Vendor Name";Rec."Vendor Name"){
        visible = true ; ApplicationArea= all ;

    }
    
}       
moveafter("Vendor Name";"Vendor Item No.")    
           modify ("Substitutes Exist") {
            Visible= false ;
           } 
         modify("Assembly BOM"){
            visible= false ;
         }
         modify ("Default Deferral Template Code")
         {Visible= false ;}
         modify(Type){
            visible=false;
         }
         modify("Vendor Item No."){
            visible= true;
            ApplicationArea = all ;
         }
    }
    actions{
        addfirst(Functions)
        {
            action(MAJ_VENDOR_NAME){ 
                ApplicationArea = all;
                Promoted = true ;
                 trigger OnAction()
                  var 
    vendor : Record Vendor ;
    
    begin 
    if REc.FindSet() then 
    vendor.SetLoadFields("No.",Name);
    repeat 
    if vendor.get(rec."Vendor No.")then begin  rec."Vendor Name" := vendor.name;
    rec.Modify();end
   
    until rec.next=0 ;

    end;

            }

          
        }
    }
 


 
}

