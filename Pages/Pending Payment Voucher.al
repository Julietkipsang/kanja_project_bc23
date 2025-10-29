page 50052 "pending Payment Voucher List"
{
    // version TL2.0

    CardPageID = "Payment Voucher";
    PageType = List;
    SourceTable = "Payment/Receipt Voucher";
    SourceTableView = WHERE(Status = FILTER("Pending Approval"),
                            "Line type" = CONST(Payment));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Paying Code."; rec."Paying Code.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Description';
                }
                field("Payment Date"; rec."Payment Date")
                {
                    ApplicationArea = All;
                }
                field(Type; rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = All;
                }
                field("Paying Bank"; rec."Paying Bank")
                {
                    ApplicationArea = All;
                }
                field("Paying/Receiving Bank Name"; Rec."Paying/Receiving Bank Name")
                {
                    ApplicationArea = All;
                    Caption = 'Paying Bank Name';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
    }
}

