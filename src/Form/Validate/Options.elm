module Form.Validate.Options exposing (optionsValidator, remoteOptionsValidator)

import Form.Field as Field
import Form.Field.Option as Option
import Form.Validate.Types as Types
import Json.Decode exposing (field)
import RemoteData


{-| Validator API for a value being in a list of options.
-}
optionsValidator : Maybe Bool -> List Option.Option -> Types.Validator
optionsValidator hasEmptyOptions options _ field =
    if hasEmptyOptions == Just False then
        Ok field

    else
        let
            value =
                Field.getStringValue_ field
        in
        if List.map .value options |> List.member value then
            Ok field

        else
            Err Types.InvalidOption


{-| Validator API for a value being in a list of remote (retrieved via network) options.
-}
remoteOptionsValidator : RemoteData.RemoteData err (List Option.Option) -> Types.Validator
remoteOptionsValidator remoteOptions locale field =
    RemoteData.map (\o -> optionsValidator (Just True) o locale field) remoteOptions
        |> RemoteData.withDefault (Err Types.InvalidOption)
