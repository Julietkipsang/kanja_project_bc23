page 50082 "settlementChargesList"
{
    // version TL2.0

    //AutoSplitKey = true;
    // Caption = 'Flat Charges Subform';
    PageType = List;
    SourceTable = Settlement;
    //SourceTableView = sorting("Minimum Amount") where("Calculation Method" = filter("Based Flat Amount"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(settlementTypes; Rec.settlementTypes)
                {
                    Editable = false;

                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Minimum Amount"; Rec."Minimum Amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ApplicationArea = All;
                }
                // field("MPESA Charges"; Rec."MPESA Charges")
                // {

                // }
                // field(KanjaCharges; Rec.KanjaCharges)
                // {

                // }

                field("Total Charge Amount"; Rec."Total Charge Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                }

            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
    end;

    trigger OnOpenPage()
    begin

    end;

    var



}
