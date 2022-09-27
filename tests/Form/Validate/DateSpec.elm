module Form.Validate.DateSpec exposing (suite)

import Form.Field.FieldType as FieldType
import Form.Locale as Locale
import Form.Validate.HelperSpec as HelperSpec
import Form.Validate.Types as Types
import Test


suite : Test.Test
suite =
    Test.describe "Form.Validate.Date"
        [ Test.describe "validate"
            [ HelperSpec.simpleFieldTest (FieldType.DateType FieldType.DatePast)
                (HelperSpec.dateField FieldType.DatePast)
                { valid = [ { value = "2022-05-30", name = "Simple date" } ]
                , invalid = [ { value = "asdf", error = Types.InvalidDate, name = "Text as date" } ]
                , locale = Locale.enAU
                }
            , HelperSpec.simpleFieldTest (FieldType.DateType FieldType.DateOfBirth)
                (HelperSpec.dateField FieldType.DateOfBirth)
                { valid = [ { value = "2022-05-30", name = "Simple date" } ]
                , invalid = [ { value = "asdf", error = Types.InvalidDate, name = "Text as date" } ]
                , locale = Locale.enAU
                }
            ]
        ]
