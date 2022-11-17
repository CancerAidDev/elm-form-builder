module Form.Validate.TagSpec exposing (suite)

import Expect
import Form.Field as Field
import Form.Field.Required as Required
import Form.Field.Width as Width
import Set
import Test


suite : Test.Test
suite =
    let
        field : Field.Field
        field =
            Field.ListStringField_ <|
                Field.TagField
                    { required = Required.Yes
                    , label = "Full Name"
                    , width = Width.HalfSize
                    , enabledBy = Nothing
                    , order = 1
                    , value = ""
                    , tags = Set.fromList [ "Sally", "Sophie", "Susan" ]
                    , disabled = False
                    , hidden = False
                    , unhiddenBy = Nothing
                    , placeholder = Nothing
                    }
    in
    Test.describe "Form.UpdateListStringValue Tests"
        [ Test.test "No change in list string value"
            (\_ ->
                Expect.equal
                    ( "name"
                    , Field.ListStringField_ <|
                        Field.TagField
                            { label = "Full Name"
                            , required = Required.Yes
                            , width = Width.HalfSize
                            , enabledBy = Nothing
                            , order = 1
                            , value = ""
                            , tags = Set.fromList [ "Sally", "Sophie", "Susan" ]
                            , disabled = False
                            , hidden = False
                            , unhiddenBy = Nothing
                            , placeholder = Nothing
                            }
                    )
                    ( "name", Field.updateListStringValue True "" [ "Sally", "Sophie", "Susan" ] field )
            )
        , Test.test "Add a name to the list"
            (\_ ->
                Expect.equal
                    ( "name"
                    , Field.ListStringField_ <|
                        Field.TagField
                            { label = "Full Name"
                            , required = Required.Yes
                            , width = Width.HalfSize
                            , enabledBy = Nothing
                            , order = 1
                            , value = ""
                            , tags = Set.fromList [ "Momo", "Sally", "Sophie", "Susan" ]
                            , disabled = False
                            , hidden = False
                            , unhiddenBy = Nothing
                            , placeholder = Nothing
                            }
                    )
                    ( "name", Field.updateListStringValue True "Momo" [ "Momo", "Sally", "Sophie", "Susan" ] field )
            )
        , Test.test "Remove name from the list"
            (\_ ->
                Expect.equal
                    ( "name"
                    , Field.ListStringField_ <|
                        Field.TagField
                            { label = "Full Name"
                            , required = Required.Yes
                            , width = Width.HalfSize
                            , enabledBy = Nothing
                            , order = 1
                            , value = ""
                            , tags = Set.fromList [ "Sally", "Susan" ]
                            , disabled = False
                            , hidden = False
                            , unhiddenBy = Nothing
                            , placeholder = Nothing
                            }
                    )
                    ( "name", Field.updateListStringValue False "Sophie" [ "Sally", "Susan" ] field )
            )
        ]
