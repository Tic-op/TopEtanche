namespace BSPCloud.BSPCloud;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;

codeunit 50017 "Planning managment"
{
      procedure CalculVMJ(Myitem : Record "My Item" temporary ;Datefirst: Date; Datelast: Date): decimal
    var
        item: record item;
        ILE: record "Item Ledger Entry";
        /* Datefirst: Date;
        Datelast: Date; */
        VMJ: decimal;
        int: integer;
    begin
         ILE.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
        ILE.setrange("Item No.", Myitem."Item No."); 
        ILE.setrange("Entry Type", "Item Ledger Entry Type"::Sale);
        ILE.setrange("Posting Date", Datefirst, Datelast);
       
        if Ile.findfirst() then begin
            // Datefirst := ILE."Posting Date";
            // ILE.FindLast();
            // Datelast := ILE."Posting Date";
            ILE.CalcSums(Quantity);
            VMJ :=  -ILE.Quantity / (Datelast - Datefirst + 1);
            exit(VMJ);
        end
        else
            exit(0);
    end;
    procedure CalculVMJEffective(Myitem : Record "My Item" temporary; DateDebut: Date; DateFin: Date)  CMJ: decimal;

    var
        NJ: Decimal;
        NJR: Decimal;
        QtéVendue: Decimal;
        DDV: date;
        ILE: record "Item Ledger Entry";
        D0: date;
        Item: record item;
        ItemSold: record item;
        // CalendarMgmt: Codeunit "Calendar Management";
        NJ_Repos: integer;
       
        // cal: record "Base Calendar";
        // baseCal: Record "Customized Calendar Change";
        //location: record Location;

    begin
        NJ := 0;   // Dispo
        NJR := 0; // Rupture
        QtéVendue := 0;
        DDV := 0D;
        if DateDebut = 0D then exit(0);

        ILE.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
        
        ILE.SETFILTER("Item No.", Myitem."Item No.");
        ILE.SetRange("Entry Type", ILE."Entry Type"::Sale);
        ILE.SETCURRENTKEY("Item No.", "Posting Date");
        ILE.SETRANGE("Posting Date", DateDebut, DateFin);
        ILE.CalcSums(Quantity) ;
        QtéVendue -= ILE.Quantity;

      //  if "Item No." = '2630002752' then 
        //Message('%1',QtéVendue);

        ILE.SetRange(Positive,false);
        if ILE.FindLast() then //Eviter les cas de retour ou avoir ou annulation de BL
        DDV := ILE."Posting Date"; 
    
        ItemSold.GET(Myitem."Item No.");

         D0 := DateDebut;
        REPEAT
            ItemSold.SETRANGE("Date Filter", D0); 
            ItemSold.Calcfields("Sold (Qty.)");
  //                  if "Item No." = '2630002752' then 
//Message(ItemSold.getfilters);
if ItemSold."Sold (Qty.)" > 0 then   begin
 NJ  += 1 ;
  //  Message('sold %1  NJ %2',ItemSold."Sold (Qty.)",NJ);

end

 else begin
            Item.GET(Myitem."Item No.");
            Item.SETRANGE("Date Filter", 0D, D0);
            Item.CALCFIELDS("Net Change");
            IF  Item."Net Change" > 0 then 
             NJ  += 1
 end;     
            D0 := CALCDATE('<1D>', D0);  
         UNTIL D0 = DateFin;

      //  if "Item No." = '2630002752' then 
         IF (NJ) <> 0 THEN
            CMJ := QtéVendue / NJ;


        exit(CMJ);

    end;




  local   procedure CalculEcoulement(Myitem : Record "My Item" temporary ;Datefirst: Date; Datelast: Date; Methode_calculVMJ: option "","VMJ Effective","VMJ sur période"): decimal
      begin
       // if BoolCalcul = false then exit(0);
       // item.get("Item No.");
        //item."Location Filter" := '';

       


        if Methode_calculVMJ = 0 then exit(0);
        if Methode_calculVMJ = Methode_calculVMJ::"VMJ sur période" then begin
            if Myitem."VMJ / Période" <> 0 then begin
                exit((Myitem."Quantité en stock" -Myitem."Qté sur commande vente") / Myitem."VMJ / Période");
            end
            else
                exit(0);
        end
        else begin
            if Myitem."VMJ / Stock" <> 0 then begin
                exit((Myitem."Quantité en stock" - Myitem."Qté sur commande vente") / Myitem."VMJ / Stock");
            end
            else
                exit(0);
        end;




    end;


     procedure CalcRecommandation(Myitem : Record "My Item" temporary ;Datefirst: Date; Datelast: Date; Methode_calculVMJ: option "","VMJ Effective","VMJ sur période"): decimal;
    var
        Recommandation: decimal;
        CD: DateFormula;
        item : Record item ;

    begin 
        //item.get("Item No.");
       // Myitem. CalcFields(Inventory);
        if Myitem."Couverture demandée" = 0 then exit(0);
        if Methode_calculVMJ = 0 then exit(0);

        if Methode_calculVMJ = Methode_calculVMJ::"VMJ sur période" then begin
            if Myitem."VMJ / Période" <> 0 then
                Recommandation := Round((((Myitem."Couverture demandée") - Myitem.Ecoulement) *Myitem."VMJ / Période"  - Myitem."Qté sur commande achat"), 1, '>');


            if Recommandation > 0 then begin
                Myitem."Qté à commander" := Recommandation;
               // Rec.Modify(false);

                exit(Recommandation)
            end
            else begin
                Myitem."Qté à commander" := -1;
                //Rec.Modify(false);


                exit(-1)
            end;

        end
        else begin
            if Myitem."VMJ / Stock" <> 0 then
                Recommandation := Round((((Myitem."Couverture demandée") -Myitem.Ecoulement) * Myitem."VMJ / Stock" - Myitem."Qté sur commande vente"), 1, '>');


            if Recommandation > 0 then begin
                Myitem."Qté à commander" := Recommandation;
           //     Rec.Modify(false);

                exit(Recommandation)
            end else begin
                Myitem."Qté à commander" := -1;
               // Rec.Modify(false);


                exit(-1)
            end;

        end;




    end;
procedure ExecuteEcoulement(Var Myitem : Record "My Item" temporary) 
var begin 
   Myitem."VMJ / Période" := CalculVMJ(Myitem,Myitem.datedebut, Myitem.datefin );
                     Myitem."VMJ / Stock" := CalculVMJEffective(Myitem,Myitem.datedebut, Myitem.datefin);//// Lenteur importante !!! 
                     Myitem.Ecoulement :=CalculEcoulement(Myitem,Myitem.datedebut, Myitem.datefin, Myitem."Mode de calcul VMJ");
                     Myitem."Qté à commander" := CalcRecommandation(Myitem,Myitem.datedebut, Myitem.datefin, Myitem."Mode de calcul VMJ");
                    Myitem.Modify();

end;

   procedure updateMethodeCalcul(Var Myitem : Record "My Item" temporary; Methode_calculVMJ: option " ","VMJ stock disponible","VMJ sur période")
  begin 
  Myitem.Validate("Mode de calcul VMJ",Methode_calculVMJ);
        //  Myitem.modify();
    end;

    procedure getItemNoFilterFromDerniereDateSortie(DerniereDateSortie: Date): Text
    var
        ILE, ILE1 : record "Item Ledger Entry";
        FiltreItemNO: text;

    begin
        FiltreItemNO := '';
        ILE.SetCurrentKey("Item No.", "Posting Date");
        ILE.setrange("Posting Date", DerniereDateSortie);
        ILE.setrange("Entry Type", "Item Ledger Entry Type"::Sale);
        ILE.setrange(Positive, false);
        ILE.findfirst();
        repeat
            //ILE1.reset;

            ILE1.SetCurrentKey("Item No.", "Posting Date");
            ILE1.SetRange("Item No.", ILE."Item No.");
            ILE1.setrange("Entry Type", "Item Ledger Entry Type"::Sale);
            ILE1.setrange(Positive, false);
            ILE1.FindLast();
            if ILE1."Posting Date" = DerniereDateSortie then begin
                if FiltreItemNO = '' then
                    FiltreItemNO := ILE1."Item No."
                else
                    FiltreItemNO := FiltreItemNO + '|' + ILE1."Item No.";
            end



        until ILE.next = 0;
        //  Message(FiltreItemNO);
        Exit(FiltreItemNO);


    end;


}
