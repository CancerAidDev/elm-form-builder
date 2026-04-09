module Form.Validate.Options exposing (optionsValidator, remoteOptionsValidator)

import Form.Field as Field
import Form.Field.Option as Option
import Form.Validate.Types as Types
import RemoteData


{-| Validator API for a value being in a list of options.
-}
optionsValidator : List Option.Option -> Types.Validator
optionsValidator options _ field =
    let
        value =
            Field.getStringValue_ field
    in
    if value == Field.nullableOptionValue then
        Ok field

    else if List.map .value options |> List.member value then
        Ok field

    else
        Err Types.InvalidOption


{-| Validator API for a value being in a list of remote (retrieved via network) options.
-}
remoteOptionsValidator : RemoteData.RemoteData err (List Option.Option) -> Types.Validator
remoteOptionsValidator remoteOptions locale field =
    if Field.getStringValue_ field == Field.nullableOptionValue then
        Ok field

    else
        RemoteData.map (\o -> optionsValidator o locale field) remoteOptions
            |> RemoteData.withDefault (Err Types.InvalidOption)
