namespace Top.Top;
using Microsoft.Inventory.Item.Attribute;
using Microsoft.Inventory.Item;

codeunit 50008 "Attribut management"
{
     [EventSubscriber(ObjectType::Table,Database::"Item Attribute",OnAfterInsertEvent,'',false,false)]
     Procedure insertdefaultvalue(var Rec: Record "Item Attribute")
     var IAV : record "Item Attribute Value" ; 
     begin 
        IAv.setrange("Attribute ID",rec.ID);
        iav.setrange("Null Value",true);
        if iav.count >0 then 
        exit ;
        iav.reset ;

        IAV.init() ;
        IAV."Attribute ID" := rec.ID ;
        IAV.id:= 0 ;
        case rec.Type of 
        rec.type::Decimal : begin 
              IAv.Value := '0' ;
              Iav."Numeric Value" := 0 ; 
               end;             
        rec.Type ::Integer : 
         begin 
              IAv.Value := '0' ;
              Iav."Numeric Value" := 0 ;
              
                 end;   

        rec.Type ::Option : begin 
             iav.value := '_';


        end;
        rec.type::Text :
         iav.value := '_' ;
        
        end;
         IAV."Null Value":=true; 
        iAV.Insert(true);
        

     end;
 [EventSubscriber(ObjectType::Table,Database::"Item Attribute value",OnAfterInsertEvent,'',false,false)] 
 procedure testuniquenullvalue(var Rec: Record "Item Attribute Value")
 var iav ,iavdefault : record "Item Attribute Value" ;
      ia : record "Item Attribute" ;
      
 begin 
    
     iav.setrange("Attribute ID",rec."Attribute ID");
     iav.setfilter(ID,'<> %1',rec.ID);
     iav.setrange("Null Value",true);

     if iav.FindSet() then 
      if rec."Null Value" then 
        error('Multiples valeurs nulles au niveau des valeurs attribut article')
     else begin 
          ia.get(rec."Attribute ID");
           insertdefaultvalue(ia);
     end;
         
     


 end;
    // Procedure généraliser
     [EventSubscriber(ObjectType::Table,Database::"Item Attribute Value Mapping",OnAfterInsertEvent,'',false,false)] 
     Procedure généraliservaleurpardefaut(var Rec: Record "Item Attribute Value Mapping")
     var IAV : record "Item Attribute Value" ;
     IAVMAPPING : record "Item Attribute Value Mapping" ;
     item : record Item ;
    
     begin 
       if rec."Table ID" = 27 then 
       begin 
            item.get(rec."No.");
            IAVMAPPING.init();
            IAVMAPPING."Table ID" := 5722 ;
            IAVMAPPING."No." := item."Item Category Code" ;
            IAVMAPPING."Item Attribute ID":= rec."Item Attribute ID"; 
            IAV.setrange("Attribute ID",rec."Item Attribute ID");
            IAv.setrange("Null Value") ;
            if iav.FindFirst()
             then 
            IAVMAPPING."Item Attribute Value ID" := iav.ID ;

            if IAVMAPPING.insert then ;




       end;

     end;




     Procedure TrierParattribut(var Itemrec : Record item ; AttID : Integer) : Record Item temporary 
     var 
      itemtemp : Record item temporary ;
      IAVM : record "Item Attribute Value Mapping" ;
      itemreal : Record item ;
      Pagetrie : page "item list attribut sort" ;
     

     
      begin 
         IAVM.setrange("Item Attribute ID",AttID);
         IAVM.SetRange("Table ID",27);
         Iavm.setfilter("No.",itemrec.GetFilter("No."));
         IAVM.SetCurrentKey("Valeur attribut");
         if Iavm.findfirst() then 
         repeat 
          itemreal.get(IAVM."No.");
          itemtemp:=itemreal ;
       itemtemp."Valeur attribut":= IAVM."Valeur attribut" ;
       itemtemp.insert();

         until iavm.next=0 ;
         message(itemtemp.Count.ToText());
        Page.RunModal(50042,itemtemp)
            
            


     end;


}
