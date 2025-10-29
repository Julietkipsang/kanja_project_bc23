page 50091 "Approved Float Entries List"
{
    PageType = List;
    CardPageId = "Float Management Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Float Management";
    Editable = false;
    SourceTableView = sorting("Receipt No") order(descending) where(Status = filter("Approved"), Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Receipt No"; Rec."Receipt No")
                {
                    ApplicationArea = All;

                }
                field("Associated Bank Account"; Rec."Associated Bank Account")
                {
                    ApplicationArea = All;

                }
                field("Transaction Description"; Rec."Transaction Description")
                {
                    ApplicationArea = All;

                }

                field("Received Amount"; Rec."Received Amount")
                {
                    ApplicationArea = All;

                }
                field("Sacco No"; Rec."Sacco No")
                {
                    ApplicationArea = All;


                }
                field("Sacco Code"; Rec."Sacco Code")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field("Sacco Name"; Rec."Sacco Name")
                {

                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;

                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Editable = false;

                }


            }

        }

    }
    actions
    {

    }



}