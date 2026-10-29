report 50123 "GST Sales Credit Note"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = "Sales Credit Note";

    dataset
    {
        dataitem(Header; "Sales Cr.Memo Header")
        {
            column(CompanyInfo; CompanyInfo.Picture) { }
            column(CompanyGSTNo; CompanyInfo."GST Registration No.") { }
            column(CompanyName; CompanyName) { }

            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(CompanyContact; CompanyInfo."Phone No.") { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(Location_State_Code; "Location State Code") { }

            column(State; State) { }
            //column()
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyCity; CompanyInfo.City) { }
            column(CompanyPostCode; CompanyInfo."Post Code") { }
            column(Customer_GST_Reg__No_; "Customer GST Reg. No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Document_Date; "Document Date") { }
            column(No_; "No.") { }
            column(Applies_to_Doc__No_; "Applies-to Doc. No.") { }
            column(Location_GST_Reg__No_; "Location GST Reg. No.") { }
            // details of receiver
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Sell_to_Address; "Sell-to Address") { }
            column(Sell_to_City; "Sell-to City") { }
            column(Sell_to_Post_Code; "Sell-to Post Code") { }
            column(GST_Bill_to_State_Code; "GST Bill-to State Code") { }

            // shipping
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_Code; "Ship-to Code") { }
            column(Ship_to_GST_Reg__No_; "Ship-to GST Reg. No.") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            column(GST_Ship_to_State_Code; "GST Ship-to State Code") { }

            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                column(Item_Code; "No.") { }
                column(Description; Description) { }
                column(Description_2; "Description 2") { }
                column(Document_No_; "Document No.") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(UOM; "Unit of Measure") { }
                column(Quantity; Quantity) { }
                column(Amount; Amount) { }
                column(Unit_Price; "Unit Price") { }

                column(Taxable_Value; "Line Amount") { }
                column(CGSTamt; CGSTamt) { }
                column(CGSTRate; CGSTRate) { }
                column(SGSTamt; SGSTamt) { }
                column(SGSTRate; SGSTRate) { }
                column(IGSTamt; IGSTamt) { }
                column(IGSTRate; IGSTRate) { }
                //

                // using trigger to get details of gsts
                trigger OnAfterGetRecord()
                var
                    DetailedGStEntry: Record "Detailed GST Ledger Entry";
                begin
                    ClearGSTLineVariables();
                    // CGST
                    DetailedGStEntry.SetRange("Document No.", "Sales Cr.Memo Line"."Document No.");
                    DetailedGStEntry.SetRange("Document Line No.", "Sales Cr.Memo Line"."Line No.");
                    DetailedGStEntry.SetRange("GST Component Code", 'CGST');
                    if DetailedGStEntry.FindFirst() then begin
                        CGSTRate := DetailedGStEntry."GST %";
                        CGSTamt := Abs(DetailedGStEntry."GST Amount");
                    end;
                    // SGSt
                    DetailedGStEntry.SetRange("GST Component Code", 'SGST');
                    if DetailedGStEntry.FindFirst() then begin
                        SGSTRate := DetailedGStEntry."GST %";
                        SGSTamt := Abs(DetailedGStEntry."GST Amount");
                    end;

                    // for IGST
                    DetailedGStEntry.SetRange("GST Component Code", 'IGST');
                    if DetailedGStEntry.FindFirst() then begin
                        IGSTRate := DetailedGStEntry."GST %";
                        IGSTamt := Abs(DetailedGStEntry."GST Amount");
                    end;
                end;

            }

        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Document_No; Document_No)
                    {
                        ApplicationArea = all;
                        Caption = 'Document No';
                        TableRelation = "Sales Cr.Memo Header";
                    }
                }
            }
        }


    }

    rendering
    {
        layout("Sales Credit Note")
        {
            Type = RDLC;
            LayoutFile = 'sales-credit-test.rdl';
        }
    }
    trigger OnInitReport()
    begin
        if CompanyInfo.get() then
            CompanyInfo.CalcFields(Picture);
    end;


    var
        CompanyInfo: Record "Company Information";
        CGSTRate: Decimal;
        CGSTamt: Decimal;
        SGSTRate: Decimal;
        SGSTamt: Decimal;
        IGSTRate: Decimal;
        IGSTamt: Decimal;
        Document_No: Code[50];

    local procedure ClearGSTLineVariables()
    begin
        CGSTamt := 0;
        CGSTRate := 0;
        SGSTamt := 0;
        SGSTRate := 0;
        IGSTRate := 0;
        IGSTamt := 0;
    end;
}
