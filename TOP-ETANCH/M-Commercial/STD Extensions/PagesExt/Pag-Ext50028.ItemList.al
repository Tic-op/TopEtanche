namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Document;
using Microsoft.Pricing.PriceList;
using Microsoft.Sales.Customer;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;
using Microsoft.Inventory.Ledger;

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
                visible = false;
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
        addlast(Statistics)
        {
            Action(Recherche_Ticop)

            {
                ShortcutKey = 'Alt+W';
                ApplicationArea = all;
                Image = AddWatch;
                trigger OnAction()
                var
                    RS: Page "Usual Search item";


                begin

                    //RS.Run();
                    rs.RunModal();

                    // Page.RunModal(50029);
                    CurrPage.Update();



                end;
            }
            action(ValidateCombineShipmentAll)
            {
                Caption = 'Valider Combine Shipment (Tous)';
                ApplicationArea = All;

                trigger OnAction()
                var
                    Customer: Record Customer;
                    SH: record "Sales Header";
                    PriceLine, Pricelistlinetodelete : record "Price List Line";
                    Item, itemtodelete : Record Item;
                    PM, PMTodelete : record "Paramêtre marge";
                    MyitemTodelete: record "My Item";
                    Totalitemcount, itemcount : integer;
                    rcptline: record "Purch. Rcpt. Line";
                    PurchRcptLine: Record "Purch. Rcpt. Line";
                    Purchline: record "Purchase Line";
                    Txt: text;
                    Countitem: integer;
                    ILE: record "Item Ledger Entry";
                    SL: Record "Sales Line";
                begin




                    begin
                        /*   txt := '';
                          Purchline.setrange("Document Type", "Purchase Document Type"::Order);
                          Purchline.findset();

                          repeat

                          begin
                              PurchRcptLine.reset;
                              PurchRcptLine.SetCurrentKey("Document No.", "No.", "Planned Receipt Date");
                              PurchRcptLine.SetRange("Order No.", Purchline."Document No.");
                              PurchRcptLine.SetRange("Order Line No.", Purchline."Line No.");
                              PurchRcptLine.SetFilter(Quantity, '<>%1', 0);
                              PurchRcptLine.CalcSums(Quantity);
                              if PurchRcptLine.Quantity > Purchline."Quantity Received" then
                                  txt := txt + '|' + Purchline."Document No." + '|' + Purchline."Line No.".ToText();
                              // PAGE.RunModal(0, PurchRcptLine);
                          end;

                          until Purchline.next = 0;

                          message(txt);
   */

                    end;



                    begin
                        Countitem := 0;
                        Item.setfilter("Description 2", '*TOBEDELETED*');

                        Item.findset();
                        repeat
                            ILE.setrange("Item No.", item."No.");
                            SL.SetRange("No.", item."No.");
                            Purchline.setrange("No.", item."No.");

                            if (ILE.Count = 0) and (SL.count = 0) and (Purchline.count = 0) then begin
                                if item.delete(true)
                                then
                                    Countitem += 1;
                            end;


                        until Item.Next() = 0;
                        message('%1 articles Supprimés', Countitem);
                        // Item.DeleteAll(false);
                    end;


                    /*  Item.findset;
                     repeat
                         Item.Validate("Prix marché", Item."Prix marché");
                         Item.Validate("Prix standard", Item."Prix standard");
                         Item.Modify();
                     until Item.next = 0;

                     Customer.modifyall("Combine Shipments", true);

                     Message('Validation terminée pour tous les clients.');
                     //     SH.setrange("Combine Shipments", false);
                     SH.findset(true);
                     repeat
                         if SH.Status = Sh.Status::Released then begin
                             Sh.SetStatus(0);
                             SH."Combine Shipments" := True;
                             Sh.SetStatus(1);
                             sh.Modify();
                         end
                         else begin
                             SH."Combine Shipments" := True;
                             sh.Modify();
                         end
                     until SH.Next() = 0; */

                    //Commit();
                    //Message('Ok'); */


                    /*       PriceLine.SETRANGE("Price List Code", 'PRIX GROS');
                          PriceLine.Setfilter("Asset No.", '<>%1', '');
                          PriceLine.setfilter(Status, '<>%1', PriceLine.Status::Inactive);

                          PriceLine.findset(true);
                          repeat
                              PriceLine.validate("Prix marché", PriceLine."Prix marché");
                              PriceLine.validate("Prix standard", PriceLine."Prix standard");

                              PriceLine.modify(true);

                          until PriceLine.next = 0; */
                    /*    PM.findset();
                       repeat
                           if item.get(Pm."Type articles") then begin
                               PriceLine.setrange("Price List Code", 'PRIX GROS');
                               PriceLine.Setrange("Asset No.", PM."Type articles");
                               PriceLine.setfilter(Status, '<>%1', PriceLine.status::Inactive);
                               if PriceLine.Findset(true) then
                                   repeat
                                       PriceLine.Status := PriceLine.status::Draft;
                                       PriceLine.Validate(MrgStd, PM.Marge);
                                       PriceLine.Status := PriceLine.status::Active;
                                       PriceLine.Modify(true);
                                   until PriceLine.next = 0;



                           end
                       until PM.next = 0; */

                    /* Priceline.setrange("Prix marché", 0, 0.001); // 260126
                    Priceline.findset();
                    Priceline.ModifyAll("Prix marché", 0);
                    Commit;
                    itemcount := 0;
                    MyitemTodelete.DeleteAll(); */
                    /* MyitemTodelete.setrange("User ID", 'Ticop');
                    Totalitemcount := MyitemTodelete.count;
                    MyitemTodelete.findset();
                    repeat
                        itemtodelete.get(MyitemTodelete."Item No.");
                        if itemtodelete.delete(true)
                        then
                            itemcount += 1;

                    until MyitemTodelete.next = 0;

                    message(item.count.ToText() + '/' + Totalitemcount.ToText() + 'supprimés'); */

                    // PM.Reset();
                    //   PMTodelete.DeleteAll();  

                end;
            }

        }
    }
    trigger OnAfterGetRecord()
    var
    begin

    end;




}

