namespace Top.Top;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;

page 50047 "Customer VAT Suspension List"
{
    ApplicationArea = All;
    Caption = 'Customer VAT Suspension List';
    PageType = List;
    SourceTable = "Customer VAT Suspension";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Client field.', Comment = '%';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Date début field.', Comment = '%';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the Date fin field.', Comment = '%';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the TVA field.', Comment = '%';
                }
                field("Bus. Posting Group"; Rec."Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Groupe CA field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                // KPI de surveillance : Problème hors suspension

                field(NonSuspendedQuotes; NonSuspendedQuotes)
                {
                    Caption = 'Devis';
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;
                    BlankZero = true;
                    Style = Unfavorable;

                    trigger OnDrillDown()
                    begin
                        DrillDownSalesHeaderDoc("Sales Document Type"::Quote);
                    end;
                }

                field(NonSuspendedOrders; NonSuspendedOrders)
                {
                    Caption = 'Commande';
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;
                    BlankZero = true;
                    Style = Unfavorable;

                    trigger OnDrillDown()
                    begin
                        DrillDownSalesHeaderDoc("Sales Document Type"::Order);
                    end;
                }

                field(NonSuspendedShipments; NonSuspendedShipments)
                {
                    Caption = 'BL';
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;
                    BlankZero = true;
                    Style = Unfavorable;

                    trigger OnDrillDown()
                    begin
                        DrillDownShipments();
                    end;
                }

                field(NonSuspendedInvoices; NonSuspendedInvoices)
                {
                    Caption = 'Facture';
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;
                    BlankZero = true;
                    Style = Unfavorable;

                    trigger OnDrillDown()
                    begin
                        DrillDownSalesHeaderDoc("Sales Document Type"::Invoice);//from sales header
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalculateCounters();
    end;

    local procedure CalculateCounters()
    begin
        //T36
        NonSuspendedQuotes := CountSalesHeader("Sales Document Type"::Quote);
        NonSuspendedOrders := CountSalesHeader("Sales Document Type"::Order);
        NonSuspendedInvoices := CountSalesHeader("Sales Document Type"::Invoice);
        //

        NonSuspendedShipments := CountShipments();


    end;

    local procedure CountSalesHeader(DocType: Enum "Sales Document Type"): Integer
    var
        SalesHeader: Record "Sales Header";
    begin

        if (Today <= Rec."End Date") AND (Today >= Rec."Start Date") then begin
            SalesHeader.Reset();
            SalesHeader.SetRange("Document Type", DocType);
            SalesHeader.SetCurrentKey("Sell-to Customer No.", "External Document No.");
            SalesHeader.SetRange("Sell-to Customer No.", Rec."Customer No.");
            if DocType = DocType::Quote then
                SalesHeader.SetRange("Document Date", Rec."Start Date", Rec."End Date")
            else
                SalesHeader.SetRange("Posting Date", Rec."Start Date", Rec."End Date");
            SalesHeader.SetFilter("VAT Bus. Posting Group", '<>%1', rec."VAT Bus. Posting Group");
            SalesHeader.SetFilter("Gen. Bus. Posting Group", '<>%1', rec."Bus. Posting Group");
            exit(SalesHeader.Count());
        end;
    end;


    local procedure CountShipments(): Integer
    var
        ShipmentHeader: Record "Sales Shipment Header";
    begin

        if (Today <= Rec."End Date") AND (Today >= Rec."Start Date") then begin

            ShipmentHeader.Reset();
            ShipmentHeader.SetCurrentKey("Sell-to Customer No.");
            ShipmentHeader.SetRange("Sell-to Customer No.", Rec."Customer No.");
            ShipmentHeader.SetCurrentKey("Posting Date");
            ShipmentHeader.SetRange("Posting Date", Rec."Start Date", Rec."End Date");
            ShipmentHeader.SetFilter("VAT Bus. Posting Group", '<>%1', rec."VAT Bus. Posting Group");
            ShipmentHeader.SetFilter("Gen. Bus. Posting Group", '<>%1', rec."Bus. Posting Group");
            exit(ShipmentHeader.Count());
        end;
    end;



    local procedure DrillDownSalesHeaderDoc(DocType: Enum "Sales Document Type")
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", DocType);
        SalesHeader.SetCurrentKey("Sell-to Customer No.", "External Document No.");
        SalesHeader.SetRange("Sell-to Customer No.", Rec."Customer No.");
        if DocType = DocType::Quote then
            SalesHeader.SetRange("Document Date", Rec."Start Date", Rec."End Date")
        else
            SalesHeader.SetRange("Posting Date", Rec."Start Date", Rec."End Date");
        SalesHeader.SetFilter(
            "VAT Bus. Posting Group",
            '<>%1',
            Rec."VAT Bus. Posting Group");

        if SalesHeader.IsEmpty then
            exit;
        if DocType = DocType::Quote then
            Page.Run(Page::"Sales Quotes", SalesHeader);
        if DocType = DocType::Order then
            Page.Run(Page::"Sales Order List", SalesHeader);
        if DocType = DocType::Invoice then
            Page.Run(Page::"Sales Invoice List", SalesHeader);


    end;


    local procedure DrillDownShipments()
    var
        ShipmentHeader: Record "Sales Shipment Header";
    begin
        ShipmentHeader.Reset();

        ShipmentHeader.SetCurrentKey("Sell-to Customer No.");
        ShipmentHeader.SetRange("Sell-to Customer No.", Rec."Customer No.");
        ShipmentHeader.SetCurrentKey("Posting Date");
        ShipmentHeader.SetRange("Posting Date", Rec."Start Date", Rec."End Date");
        ShipmentHeader.SetFilter("VAT Bus. Posting Group", '<>%1', rec."VAT Bus. Posting Group");
        ShipmentHeader.SetFilter("Gen. Bus. Posting Group", '<>%1', rec."Bus. Posting Group");

        Page.Run(Page::"Posted Sales Shipments", ShipmentHeader);
    end;

    var
        NonSuspendedQuotes: Integer;
        NonSuspendedOrders: Integer;
        NonSuspendedShipments: Integer;
        NonSuspendedInvoices: Integer;

}