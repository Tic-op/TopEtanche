namespace Top.Top;
using Microsoft.Inventory.Item.Attribute;
using Microsoft.Inventory.Item;

codeunit 50008 "Attribut management"
{
   //  [EventSubscriber(ObjectType::Table,Database::"Item Attribute",OnAfterInsertEvent,'',false,false)]
     Procedure insertdefaultvalue(var Rec: Record "Item Attribute")
     var IAV : record "Item Attribute Value" ; 
     cu : codeunit "Item Attribute Management";
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
 //[EventSubscriber(ObjectType::Table,Database::"Item Attribute value",OnAfterInsertEvent,'',false,false)] 
 procedure testuniquenullvalue(var Rec: Record "Item Attribute Value") // useless now 01122
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
   
   [EventSubscriber(ObjectType::Table,Database::"Item Attribute Value Mapping",OnafterInsertEvent,'',false,false)] 

   Procedure affecterValeurattribue(var Rec: Record "Item Attribute Value Mapping")
   var  IAV : record "Item Attribute Value"; 
     
    
     begin
       IAV.get(rec."Item Attribute ID",rec."Item Attribute Value ID")  ;
        rec."Valeur attribut" := Iav.value;
    //   rec.Modify(true);
   
   end;
    [EventSubscriber(ObjectType::Table,Database::"Item Attribute Value Mapping",OnAfterValidateEvent,"Item Attribute Value ID",false,false)] 
         Procedure onaftermodify(var Rec: Record "Item Attribute Value Mapping")
         begin 
         affecterValeurattribue(rec) ;
         end;
  [EventSubscriber(ObjectType::Page,Page:: "Item Attribute Value List",OnBeforeItemAttributeValueMappingInsert,'',false,false)]

 //[EventSubscriber(ObjectType::codeunit,codeunit::"Item Attribute Management",OnBeforeItemAttributeValueMappingInsert,'',false,false)] 
  Procedure affectvaleurattribut(var ItemAttributeValueMapping: Record "Item Attribute Value Mapping"; ItemAttributeValue: Record "Item Attribute Value")
  //affectvaleurattribut(var ItemAttributeValueMapping: Record "Item Attribute Value Mapping";var TempItemAttributeValue: Record "Item Attribute Value" temporary)
   var 
   begin 
     ItemAttributeValueMapping."Valeur attribut" := ItemAttributeValue.Value ;

  end;  

[EventSubscriber(ObjectType::Page,Page:: "Item Attribute Value List",OnBeforeItemAttributeValueMappingModify,'',false,false)]

 Procedure affectvaleurattributmodif(var ItemAttributeValueMapping: Record "Item Attribute Value Mapping"; ItemAttributeValue: Record "Item Attribute Value")

 var 
   begin 
     ItemAttributeValueMapping."Valeur attribut" := ItemAttributeValue.Value ;

  end;  
   Procedure généraliserAttributPardefaut(var item :record item) //useless now 011225
   var 
   IaVm : record "Item Attribute Value Mapping" ;

   begin 
     Iavm.setrange("Table ID",27);
     iavm.setrange("No.",item."No.");
     if iavm.findfirst then 
     repeat "généraliservaleurpardefaut"(IaVm);
     until 
     iavm.next=0 ;




   end;
     Procedure généraliservaleurpardefaut(var Rec: Record "Item Attribute Value Mapping") //useless now 011225
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

            if IAVMAPPING.insert(true) then ;




       end;

     end;




     Procedure TrierParattribut(var Itemrec : Record item ; AttID : Integer) : Record Item temporary 
     var 
      itemtemp : Record item temporary ;
      IAVM : record "Item Attribute Value Mapping" ;
      itemreal : Record item ;
      Pagetrie : page "item list attribut sort" ;
      iav : record "Item Attribute Value" ;
      Ia : record "Item Attribute" ;
      ValeurnumVar : decimal ;
     

     
      begin 
           Ia.get(AttID);
         IAVM.setrange("Item Attribute ID",AttID);
         IAVM.SetRange("Table ID",27);
         Iavm.setfilter("No.",itemrec.GetFilter("No."));
        // message(Itemrec.GetFilter("No."));
         IAVM.SetCurrentKey("Valeur attribut");
        // Message(IAVM.count.ToText());
         if Iavm.findfirst() then 
         repeat 
          itemreal.get(IAVM."No.");
          itemtemp.Init();
          itemtemp:=itemreal ;
        /*   iav.get(iavm."Item Attribute ID",IAVM."Item Attribute Value ID");
          Iavm."Valeur attribut" := iav.Value ;
          Message(Iav.Value); */
          itemtemp."Valeur attribut":= Iavm."Valeur attribut" ;
          if (ia.Type = ia.type ::Decimal) or (ia.type = ia.type ::Integer) then begin 
            if Evaluate(ValeurnumVar,iavm."Valeur attribut") then 
             itemtemp."Valeur Attribut Numérique" :=ValeurnumVar;

          end ;
         
        

          //IAVM."Valeur attribut" ;
           //iavm.Modify();
          itemtemp.insert();
        
         until iavm.next=0 ;
        
         /*   Pagetrie.Setrecord(itemtemp);
         if (ia.Type = ia.type ::Decimal) or (ia.type = ia.type ::Integer) then  
         Pagetrie.Setnumerique(true);
         Pagetrie.setcaption(Ia.Name);
        
          Pagetrie.Run(); */
       // message(itemtemp.Count.ToText());
       Page.RunModal(50042,itemtemp); 
            
            


     end;


}
