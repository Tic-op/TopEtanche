namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.History;
using Microsoft.Inventory.Ledger;
using Microsoft.Foundation.Company;

report 50001 "Synthèse Importation"
{
    Caption = 'Synthèse Importation';


    RDLCLayout = 'Synthèse Importation.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(DI; "Import Folder")
        {
            column(No; "No.")
            {
            }
            column(VendorNo; "Vendor No.")
            {
            }
            column(VendorName; "Vendor Name")
            {
            }
            column(CreationDate; "Creation Date")
            {
            }
            column(ClosedDate; "Closed Date")
            {
            }
            column(Status; Status)
            {
            }
            column(Ndclaration; "N° déclaration")
            {
            }
            column(picture; companyInfo.Picture)
            {
            }

            dataitem(recLpurchRCPLine; "Purch. Rcpt. Line")
            {
                column(No_; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_Cost; "Unit Cost") { }
                column(CoutRevient; CoutRevient) { }
                column(Unit_Cost__LCY_; "Unit Cost (LCY)") { }
                column(NGP; "Tariff No." + '/' + "Country region origin code") { }


                dataitem(VE; "Value Entry")
                {
                    DataItemTableView = sorting("Item Ledger Entry No.", "Entry Type");
                    //  DataItemLink = "Item Ledger Entry No." = field("Item Rcpt. Entry No.");

                    column(Item_Charge_No_; Charge + '/' + "Document No.") { }
                    column(CoutTotal; "Cost Amount (Actual)" + "Cost Amount (expected)") { }
                    column(Cost_per_Unit; UnitCost) { }

                    trigger OnPreDataItem()
                    var
                        ILE: Record "Item Ledger Entry";

                    begin
                        ile.SetCurrentKey("Document No.", "Document Type", "Document Line No.");
                        ILE.SetFilter("Document No.", recLpurchRCPLine."Document No.");
                        ILE.SetRange("Document Line No.", recLpurchRCPLine."Line No.");
                        ILE.FindFirst();

                        VE.setrange("Item Ledger Entry No.", ILE."Entry No.");



                    end;

                    trigger OnAfterGetRecord()
                    var
                        recValueEntry: record "Value Entry";
                    begin
                        if "Item Charge No." = '' then
                            charge := 'ACHAT'
                        else
                            charge := "Item Charge No.";
                        recValueEntry.SetCurrentKey("Item Ledger Entry No.", "Valuation Date", "Posting Date");
                        recValueEntry.SetRange("Item Ledger Entry No.", "Item Ledger Entry No.");
                        recValueEntry.SetRange("Item Charge No.", "Item Charge No.");
                        if "Item Charge No." <> '' then
                            recValueEntry.CalcSums("Cost per Unit")
                        else
                            recValueEntry.FindLast();

                        UnitCost := recValueEntry."Cost per Unit";
                        //  Message('%1', UnitCost);
                    end;
                }

                trigger OnPreDataItem()
                var
                    recLpurchRcpHeader: Record "Purch. Rcpt. Header";
                begin
                    recLpurchRcpHeader.SetRange("DI No.", DI."No.");
                    recLpurchRcpHeader.FindFirst();
                    recLpurchRCPLine.SETRANGE(recLpurchRCPLine."Document No.", recLpurchRcpHeader."No.");
                    recLpurchRCPLine.SETRANGE(recLpurchRCPLine.Type, recLpurchRCPLine.Type::Item);

                end;


                trigger OnAfterGetRecord()
                var
                    ILE: Record "Item Ledger Entry";
                begin
                    ILE.SetCurrentKey("Document No.", "Document Type", "Document Line No.");
                    ILE.SetRange("Document No.", recLpurchRCPLine."Document No.");
                    ILE.SetRange("Document Line No.", recLpurchRCPLine."Line No.");

                    ILE.SetAutoCalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                    ILE.FindFirst();

                    CoutRevient := (ILE."Cost Amount (Actual)" + ILE."Cost Amount (Expected)") / ILE."Quantity";


                end;


            }
            trigger OnAfterGetRecord()
            begin

                companyInfo.GET;
                companyInfo.CalcFields(Picture);
            end;
        }


    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(OptionCost; OptionCost) { ApplicationArea = all; }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        charge: code[25];
        OptionCost: Option Unitaire,Total;
        companyInfo: Record "Company Information";
        UnitCost, CoutRevient : Decimal;
}
