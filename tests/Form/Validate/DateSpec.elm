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
            [ HelperSpec.simpleFieldTest (FieldType.DateType FieldType.datePast)
                (HelperSpec.dateField FieldType.datePast)
                { valid = [ { value = "2022-05-30", name = "Simple date" } ]
                , invalid = [ { value = "asdf", error = Types.InvalidDate, name = "Text as date" } ]
                , locale = Locale.enAU
                }
            , HelperSpec.simpleFieldTest (FieldType.DateType FieldType.dateOfBirth)
                (HelperSpec.dateField FieldType.dateOfBirth)
                { valid = [ { value = "2022-05-30", name = "Simple date" } ]
                , invalid = [ { value = "asdf", error = Types.InvalidDate, name = "Text as date" } ]
                , locale = Locale.enAU
                }
            , HelperSpec.simpleFieldTest (FieldType.DateType FieldType.dateFuture)
                (HelperSpec.dateField FieldType.dateFuture)
                { valid = [ { value = "2025-05-30", name = "Simple date" } ]
                , invalid = [ { value = "asdf", error = Types.InvalidDate, name = "Text as date" } ]
                , locale = Locale.enAU
                }
            , HelperSpec.simpleFieldTest (FieldType.DateType FieldType.dateDefault)
                (HelperSpec.dateField FieldType.dateDefault)
                { valid = [ { value = "2022-05-30", name = "Simple date" } ]
                , invalid = [ { value = "asdf", error = Types.InvalidDate, name = "Text as date" } ]
                , locale = Locale.enAU
                }
            ]
        ]
